/*
Una procedura di back-end deve consentire la generazione
di un report che classifichi i punti monitorati dell’edificio, individuando così quelli
che potrebbero cagionare più danni, dipendentemente dallo scostamento dai valori
di soglia
*/

DROP PROCEDURE IF EXISTS classifica_punti_monitorati_edificio;
DELIMITER $$
CREATE PROCEDURE classifica_punti_monitorati_edificio(IN _Edificio INT) 
BEGIN
	WITH sensori AS (
		SELECT V.IdVano, S.IdSensore, S.TipoSensore, S.SogliaSicurezza, S.ElementoStrutturale
        FROM Vano V
			 INNER JOIN
             Sensore S ON V.IdVano = S.Vano
		WHERE V.Edificio = _Edificio
			AND S.TipoSensore IN ('Giroscopio', 'Accelerometro')
	),
    misurazioni AS (
		SELECT S.IdVano, S.IdSensore, S.TipoSensore, S.SogliaSicurezza, S.ElementoStrutturale, (M.AsseX + M.AsseY + M.AsseZ)/3 AS MediaSensore
        FROM sensori S
			 INNER JOIN
             Misure M ON S.IdSensore = M.Sensore
		WHERE CURRENT_DATE - INTERVAL 1 WEEK < M.Timestamp
    ),
    differenza_soglia AS(
		SELECT M.IdVano, M.ElementoStrutturale, M.IdSensore, M.TipoSensore, AVG(M.MediaSensore) - M.SogliaSicurezza AS DistaccoSoglia
		FROM misurazioni M
		GROUP BY M.IdVano, M.ElementoStrutturale, M.IdSensore, M.TipoSensore
        ORDER BY DistaccoSoglia DESC
    )
    SELECT DS.IdVano AS Vano, DS.ElementoStrutturale, DS.IdSensore AS Sensore, DS.TipoSensore, IF (DS.DistaccoSoglia < 0,'Nessun pericolo', DS.DistaccoSoglia) AS ScostamentoDallaSogliaSicurezza
	FROM differenza_soglia DS
    ORDER BY ScostamentoDallaSogliaSicurezza DESC;
END $$
DELIMITER ;

/*
Sulla base dei valori misurati da tutti i sensori, l’edificio si trova in uno stato.
Lo stato dell’edificio non dipende esclusivamente dai valori misurati dai sensori
durante l’ultima registrazione, ma anche dall’evoluzione che ha caratterizzato i valori
misurati dai sensori.
*/
DROP PROCEDURE IF EXISTS stato_edificio;
DELIMITER $$
CREATE PROCEDURE stato_edificio(IN _edificio INT, OUT stato VARCHAR(100), OUT messaggio VARCHAR(1000))
BEGIN
DECLARE finito INT DEFAULT 0;
DECLARE valore_attuale DOUBLE DEFAULT 0;
DECLARE valore_lead DOUBLE DEFAULT 0;
DECLARE salta_tipo_sensore INT DEFAULT 0;
DECLARE c_giroscopio INT DEFAULT 0;
DECLARE c_accelerometro INT DEFAULT 0;
DECLARE c_posizione INT DEFAULT 0;
DECLARE c_umidita INT DEFAULT 0;
DECLARE tipo_attuale VARCHAR(16) DEFAULT ' ';
DECLARE tipo_lead VARCHAR(16) DEFAULT ' ';
DECLARE situazione_complessiva INT DEFAULT 0;

DECLARE cursore CURSOR FOR
		WITH Vani_edificio AS(
				SELECT V.IdVano
				FROM Vano V
				WHERE V.Edificio = _edificio
		), 
		Sensori_target AS(
				SELECT S.IdSensore, S.TipoSensore
				FROM sensore S
				WHERE S.Vano IN (
									SELECT *
									FROM Vani_edificio
								) 
				AND S.TipoSensore IN ('Giroscopio', 'Accelerometro', 'SensoreUmidita', 'SensorePosizione') 
		)
		SELECT ST.TipoSensore, IF(ST.TipoSensore = 'Giroscopio' OR ST.TipoSensore = 'Accelerometro', (M.AsseX + M.AsseY + M.AsseZ)/3, IF(ST.TipoSensore = 'SensoreUmidita', IF(M.AsseX >= M.AsseY, M.AsseX, AsseY), M.AsseX)) AS Valore
		FROM Sensori_target ST 
             INNER JOIN
             Misure M ON ST.IdSensore = M.Sensore
             INNER JOIN
             ElencoAlert EA ON M.Sensore = EA.Sensore AND M.Timestamp = EA.Timestamp
		WHERE EA.Timestamp >= CURRENT_DATE - INTERVAL 1 MONTH
		ORDER BY ST.TipoSensore, EA.Timestamp DESC;

DECLARE CONTINUE HANDLER FOR NOT FOUND
		set finito = 1;

OPEN cursore;

Preleva: LOOP
		FETCH cursore INTO tipo_attuale, valore_attuale;

		IF finito = 1 THEN
				LEAVE preleva;
		END IF;

		IF salta_tipo_sensore = 1 THEN
				IF tipo_attuale <> tipo_lead THEN
						SET salta_tipo_sensore = 0;
				ELSE
						ITERATE preleva;
				END IF;
		END IF;

		IF tipo_attuale <> tipo_lead THEN
				SET tipo_lead = tipo_attuale;
				SET valore_lead = valore_attuale;
				ITERATE preleva;
		END IF;

		IF tipo_attuale = 'Giroscopio' AND valore_attuale <= valore_lead THEN
				SET c_giroscopio = c_giroscopio + 1;
				SET valore_lead = valore_attuale;
		END IF;
		IF tipo_attuale = 'Accelerometro' AND valore_attuale <= valore_lead THEN
				SET c_accelerometro = c_accelerometro + 1;
				SET valore_lead = valore_attuale;
		END IF;
		IF tipo_attuale = 'SensoreUmidita' AND valore_attuale <= valore_lead THEN
				SET c_umidita = c_umidita + 1;
				SET valore_lead = valore_attuale;
		END IF;
		IF tipo_attuale = 'SensorePosizione' AND valore_attuale <= valore_lead THEN
					SET c_posizione = c_posizione + 1;
					SET valore_lead = valore_attuale;
		END IF;

		IF valore_attuale > valore_lead THEN
				SET salta_tipo_sensore = 1;
		END IF;

END LOOP preleva;
CLOSE cursore;

CREATE TEMPORARY TABLE IF NOT EXISTS risultati(
		Tipo_sensore VARCHAR(16) NOT NULL, 
		Misurazioni_in_crescita INT NOT NULL, 
		PRIMARY Key (Tipo_sensore) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

TRUNCATE TABLE risultati;

IF c_accelerometro <> 0 THEN SET c_accelerometro = c_accelerometro + 1; END IF;
IF c_giroscopio <> 0 THEN SET c_giroscopio = c_giroscopio + 1; END IF;
IF c_umidita <> 0 THEN SET c_umidita= c_umidita + 1; END IF;
IF c_posizione <> 0 THEN SET c_posizione = c_posizione + 1; END IF;

INSERT INTO risultati (Tipo_sensore, Misurazioni_in_crescita) 
VALUES ('Accelerometro', c_accelerometro), 
									('Giroscopio', c_giroscopio), 
									('SensoreUmidita', c_umidita), 
									('SensorePosizione', c_posizione);

SELECT *
FROM risultati;

SET situazione_complessiva = c_umidita + c_accelerometro + c_giroscopio + c_posizione;
IF situazione_complessiva < 4 THEN
		SET stato = "L'Edificio è in ottimo stato!";
END IF;
IF situazione_complessiva BETWEEN 4 AND 7 THEN
		SET stato = "L'Edificio è in discreto stato!";
END IF;
IF situazione_complessiva > 7 THEN
		SET stato = "L'Edificio è in pessimo stato!";
END IF;

set messaggio='';

IF c_accelerometro > 2 THEN
		SET messaggio = CONCAT(messaggio, " A seguito di numerose segnalazioni di forti vibrazioni, è consigliabile verificare l'integrità delle fondamenta dello stabile.");
END IF;
IF c_giroscopio > 2 THEN
		SET messaggio = CONCAT(messaggio, " I giroscopi applicati all'edificio evidenziano una costante, e sempre più grave, inclinazione. E' fondamentale un'ispezione delle fondamenta del palazzo per evitare cedimenti improvvisi della struttura.");
END IF;
IF c_umidita > 2 THEN
		SET messaggio = CONCAT(messaggio, " Si suggerisce una sanificazione da muffe, che potrebbero essere proliferate a causa di alte percentuali di umidita.");
END IF;
IF c_posizione > 2 THEN
		SET messaggio = CONCAT(messaggio, " Nelle pareti dell'edificio si stanno allargando numerose crepe, è quindi richiesto un controllo specialistico per la prevenzione di crolli.");
END IF;

END $$
DELIMITER ;

/*
procedura lato server che stima il livello di gravità nei vari punti dell’area geografica colpita, 
sulla base di un semplice modello che usa i dati dei sensori posizionati sugli edifici.
*/

DROP PROCEDURE IF EXISTS livello_gravita;
DELIMITER $$

CREATE PROCEDURE livello_gravita(IN _Data TIMESTAMP, IN _AreaGeografica VARCHAR(100))
BEGIN
                        
	WITH edifici_target AS (
		SELECT E.IdEdificio, E.Zona
        FROM AreaGeografica AG
			 INNER JOIN
             Edificio E ON AG.NomeLuogo = E.AreaGeografica
		WHERE AG.NomeLuogo = _AreaGeografica
	),
    vani_target AS (
		SELECT ET.IdEdificio, ET.Zona, V.Idvano
        FROM edifici_target ET
			 INNER JOIN
             Vano V ON ET.IdEdificio = V.Edificio
    ),
    misurazioni_target AS (
			SELECT VT.IdEdificio, VT.Zona, VT.IdVano, S.IdSensore, S.SogliaSicurezza, IF(S.TipoSensore = 'Giroscopio' OR S.TipoSensore = 'Accelerometro', (M.AsseX + M.AsseY + M.AsseZ)/3, IF(S.TipoSensore = 'SensoreTemperatura' OR S.TipoSensore = 'SensoreUmidita',(AsseX + AsseY)/2, AsseX)) AS Valore
            FROM vani_target VT
				 INNER JOIN
                 Sensore S ON VT.IdVano = S.Vano
                 INNER JOIN
                 Misure M ON S.IdSensore = M.Sensore
                 INNER JOIN
                 ElencoAlert EA ON M.Sensore = EA.Sensore AND M.Timestamp = EA.Timestamp
			WHERE M.Timestamp BETWEEN _Data - INTERVAL 10 MINUTE AND _Data + INTERVAL 60 MINUTE
	),
    doppio_della_soglia AS(
		SELECT MT.Zona, COUNT(*) / (
										SELECT IF(COUNT(DISTINCT E.IdEdificio)=0, 1, COUNT(DISTINCT E.IdEdificio))
										FROM Edificio E
											 INNER JOIN
											 ProgettoEdilizio PE ON E.IdEdificio = PE.Edificio
										WHERE E.AreaGeografica = _AreaGeografica
											AND E.Zona = MT.Zona
											AND PE.Esiste = 0 
											AND PE.DataFine < _Data
								   )AS MediaAlert
        FROM misurazioni_target MT
        WHERE MT.Valore > (MT.SogliaSicurezza * 2)
        GROUP BY MT.Zona
    )
	SELECT DDS.Zona, IF(DDS.MediaAlert >= 10, 5, IF(DDS.MediaAlert BETWEEN 7 AND 9, 4, IF(DDS.MediaAlert BETWEEN 4 AND 6,3,IF(DDS.MediaAlert BETWEEN 1 AND 3, 2, 1)))) AS LivelloGravita
	FROM doppio_della_soglia DDS;
END $$
DELIMITER ;