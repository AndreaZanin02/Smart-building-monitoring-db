/*
CONSIGLI INTERVENTO: Consigli di intervento per accelerometro e giroscopio
*/

DROP PROCEDURE IF EXISTS consigli_intervento_struttura;
DELIMITER $$
CREATE PROCEDURE consigli_intervento_struttura(IN _Edificio INT, OUT messaggio VARCHAR(1000)) 
BEGIN	
	DECLARE sogliamedia DOUBLE DEFAULT 0;
    DECLARE misuramedia DOUBLE DEFAULT 0;
    
	WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
    ),
    sensori_target AS (
		SELECT S.IdSensore, S.SogliaSicurezza
        FROM Sensore S
        WHERE S.Vano IN (SELECT *
						 FROM vani_target
                         )
			AND S.TipoSensore = 'Accelerometro' OR S.TipoSensore = 'Giroscopio'
    )
	SELECT AVG(ST.SogliaSicurezza) AS MediaSoglia, AVG((M.AsseX + M.AsseY + M.AsseZ)/3) AS MediaMisurazioni INTO sogliamedia, misuramedia
	FROM sensori_target ST
			INNER JOIN
			Misure M ON M.Sensore = ST.IdSensore
			INNER JOIN
			ElencoAlert EA ON EA.Sensore = M.Sensore AND EA.Timestamp = M.Timestamp
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK;
    
	IF misuramedia >= (sogliamedia*2) THEN
		SET messaggio = ("L'edificio necessita di una ristrutturazione completa");
    END IF;
    
    IF misuramedia > sogliamedia AND misuramedia < (sogliamedia*2) THEN
		WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
    ),
    sensori_target AS (
		SELECT S.IdSensore, S.Vano, S.ElementoStrutturale
        FROM Sensore S
        WHERE S.Vano IN (SELECT *
						 FROM vani_target
                         )
			AND S.TipoSensore = 'Accelerometro' OR S.TipoSensore = 'Giroscopio'
    )
	SELECT ST.Vano, ST.ElementoStrutturale, 'Consigliata una ristrutturazione di questa parte dell edificio' AS Consiglio
	FROM sensori_target ST
			INNER JOIN
			Misure M ON M.Sensore = ST.IdSensore
			INNER JOIN
			ElencoAlert EA ON EA.Sensore = M.Sensore AND EA.Timestamp = M.Timestamp
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK;
    END IF;
END $$
DELIMITER ;

/*
	Consigli di intervento per sensore pioggia
*/
DROP PROCEDURE IF EXISTS consigli_intervento_pioggia;
DELIMITER $$
CREATE PROCEDURE consigli_intervento_pioggia(IN _Edificio INT)
BEGIN 
    DECLARE MediaMisurazioni_ DOUBLE DEFAULT 0;
	DECLARE MediaSoglieSicurezza_ DOUBLE DEFAULT 0;
    
	WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
    ),
    sensori_target AS (
		SELECT S.Vano, S.IdSensore, S.ElementoStrutturale, S.SogliaSicurezza
        FROM Sensore S
        WHERE S.Vano IN (SELECT *
						 FROM vani_target
                         )
			AND S.TipoSensore = 'SensorePioggia'
    )
	SELECT DISTINCT AVG(M.AsseY) AS MediaMisurazioni, AVG(ST.SogliaSicurezza) AS MediaSoglieSicurezza INTO MediaMisurazioni_, MediaSoglieSicurezza_
	FROM sensori_target ST
		INNER JOIN
		Misure M ON ST.IdSensore = M.Sensore
		INNER JOIN
		ElencoAlert EA ON EA.Sensore = M.Sensore AND EA.Timestamp = M.Timestamp
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK;
   
   IF MediaMisurazioni_ > MediaSoglieSicurezza_ * 1.5 THEN
   SELECT 'Necessaria una ristrutturazione del piano terra e di eventuali piani sotterranei.' AS ConsiglioIntervento;
   ELSE
   SELECT 'Non è necessaria nessun tipo di ristrutturazione.' AS ConsiglioIntervento;
   END IF;
END $$
DELIMITER ;

/*
consigli umidità
*/
DROP PROCEDURE IF EXISTS consiglio_intervento_umidita;
DELIMITER $$
CREATE PROCEDURE consiglio_intervento_umidita(IN _Edificio INT) 
BEGIN
	WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
	),
    sensori_target AS (
		SELECT S.Vano, S.IdSensore, S.SogliaSicurezza
        FROM Sensore S
        WHERE S.Vano IN (
							SELECT *
                            FROM vani_target
						)
			AND S.TipoSensore = 'SensoreUmidita'
	)
    SELECT DISTINCT ST.Vano, "Installare un deumidificatore" AS Consiglio
    FROM sensori_target ST
		 INNER JOIN
         Misure M ON ST.IdSensore = M.Sensore
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK
		AND M.AsseY > ST.SogliaSicurezza;
END $$
DELIMITER ;

/*
consigli temperatura
*/
DROP PROCEDURE IF EXISTS consiglio_intervento_temperatura;
DELIMITER $$
CREATE PROCEDURE consiglio_intervento_temperatura(IN _Edificio INT) 
BEGIN
	WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
	),
    sensori_target AS (
		SELECT S.Vano, S.IdSensore, S.SogliaSicurezza
        FROM Sensore S
        WHERE S.Vano IN (
							SELECT *
                            FROM vani_target
						)
			AND S.TipoSensore = 'SensoreTemperatura'
	)
    SELECT ST.Vano, "Installare un climatizzatore" AS Consiglio
    FROM sensori_target ST
		 INNER JOIN
         Misure M ON ST.IdSensore = M.Sensore
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK
		AND M.AsseY > ST.SogliaSicurezza
    GROUP BY ST.Vano
    HAVING COUNT(*) >= 5;
END $$
DELIMITER ;

/*
	Consigli di intervento per sensore posizione
*/
DROP PROCEDURE IF EXISTS consigli_intervento_crepe;
DELIMITER $$
CREATE PROCEDURE consigli_intervento_crepe(IN _Edificio INT)
BEGIN 
	DECLARE vano_ INT DEFAULT 0;
    DECLARE elementostrutturale_ VARCHAR(10) DEFAULT '';
    DECLARE sensore_ INT DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    DECLARE costo DOUBLE DEFAULT 0;
    
    DECLARE cursore CURSOR FOR
	WITH vani_target AS(
		SELECT V.IdVano
        FROM Vano V
        WHERE V.Edificio = _Edificio
    ),
    sensori_target AS (
		SELECT S.Vano, S.IdSensore, S.ElementoStrutturale, S.SogliaSicurezza
        FROM Sensore S
        WHERE S.Vano IN (SELECT *
						 FROM vani_target
                         )
			AND S.TipoSensore = 'SensorePosizione'
    )
	SELECT DISTINCT ST.Vano, ST.ElementoStrutturale, ST.IdSensore
	FROM sensori_target ST
		INNER JOIN
		Misure M ON ST.IdSensore = M.Sensore
		INNER JOIN
		ElencoAlert EA ON EA.Sensore = M.Sensore AND EA.Timestamp = M.Timestamp
	WHERE M.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK
	AND M.AsseX > (ST.SogliaSicurezza * 2);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS tabella_costo(
        Sensore INT NOT NULL,
        Vano INT NOT NULL,
        ElementoStrutturale VARCHAR(16) NOT NULL,
        CostoUnitario DOUBLE DEFAULT 0,
        ConsiglioIntervento VARCHAR(100) DEFAULT 'Consigliata una ristrutturazione completa dell elemento strutturale',
        PRIMARY KEY (Sensore)
    );
    
	TRUNCATE TABLE tabella_costo;
    
    OPEN cursore;
    ciclo: LOOP
		FETCH cursore INTO vano_, elementostrutturale_, sensore_;
        IF finito = 1 THEN
			LEAVE ciclo;
        END IF;
        IF EXISTS (
					SELECT 1
                    FROM VMattone VM
                    WHERE VM.Vano = vano_
						AND VM.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(M.CostoUnitario)
                                    FROM Materiale M
										 INNER JOIN
                                         VMattone VM ON M.PartitaIVA = VM.PartitaIVA AND M.CodLotto = VM.CodLotto
									WHERE VM.Vano = vano_
										AND VM.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        
        IF EXISTS (
					SELECT 1
                    FROM VIntonaco VI
                    WHERE VI.Vano = vano_
						AND VI.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(I.CostoUnitario)
                                    FROM Materiale I
										 INNER JOIN
                                         VIntonaco VI ON I.PartitaIVA = VI.PartitaIVA AND I.CodLotto = VI.CodLotto
									WHERE VI.Vano = vano_
										AND VI.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        
        IF EXISTS (
					SELECT 1
                    FROM VPiastrella VP
                    WHERE VP.Vano = vano_
						AND VP.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(P.CostoUnitario)
                                    FROM Materiale P
										 INNER JOIN
                                         VPiastrella VP ON P.PartitaIVA = VP.PartitaIVA AND P.CodLotto = VP.CodLotto
									WHERE VP.Vano = vano_
										AND VP.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        
        IF EXISTS (
					SELECT 1
                    FROM VPietra VP
                    WHERE VP.Vano = vano_
						AND VP.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(P.CostoUnitario)
                                    FROM Materiale P
										 INNER JOIN
                                         VPietra VP ON P.PartitaIVA = VP.PartitaIVA AND P.CodLotto = VP.CodLotto
									WHERE VP.Vano = vano_
										AND VP.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        
        IF EXISTS (
					SELECT 1
                    FROM VAsseLegno VA
                    WHERE VA.Vano = vano_
						AND VA.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(AL.CostoUnitario)
                                    FROM Materiale AL
										 INNER JOIN
                                         VAsseLegno VAL ON AL.PartitaIVA = VAL.PartitaIVA AND AL.CodLotto = VAL.CodLotto
									WHERE VAL.Vano = vano_
										AND VAL.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        
        IF EXISTS (
					SELECT 1
                    FROM VGenerico VG
                    WHERE VG.Vano = vano_
						AND VG.ElementoStrutturale = elementostrutturale_
				  ) THEN
			SET costo = costo + (
									SELECT AVG(G.CostoUnitario)
                                    FROM Materiale G
										 INNER JOIN
                                         VGenerico VG ON G.PartitaIVA = VG.PartitaIVA AND G.CodLotto = VG.CodLotto
									WHERE VG.Vano = vano_
										AND VG.ElementoStrutturale = elementostrutturale_
								);
        END IF;
        INSERT INTO tabella_costo (Sensore, Vano, ElementoStrutturale, CostoUnitario)
        VALUES (sensore_, vano_, elementostrutturale_, costo);
    END LOOP;
    CLOSE cursore;
	SELECT *
    FROM tabella_costo;
END $$
DELIMITER ;

/*
consigli TOTALI
*/
DROP PROCEDURE IF EXISTS consigli_totali;
DELIMITER $$
CREATE PROCEDURE consigli_totali(IN _Edificio INT) 
BEGIN
	DECLARE ConsiglioInterventoEdificio VARCHAR(1000) DEFAULT '';
	CALL consigli_intervento_struttura(_Edificio, ConsiglioInterventoEdificio);
    SELECT ConsiglioInterventoEdificio;
    CALL consigli_intervento_pioggia(_Edificio);
    CALL consiglio_intervento_umidita(_Edificio);
    CALL consiglio_intervento_temperatura (_Edificio);
    CALL consigli_intervento_crepe(_Edificio);
END $$
DELIMITER ;

/*
STIMA DANNI EDIFICIO: funzionalità che stimi i potenziali danni alle parti di un edificio, sfruttando i dati misurati dai sensori e i danni
arrecati all’edificio provocati da precedenti sollecitazioni sismiche reali.
*/

DROP PROCEDURE IF EXISTS stima_danni_edificio;
DELIMITER $$
CREATE PROCEDURE stima_danni_edificio(IN _Edificio INT, IN _TipoEventoCalamitoso VARCHAR(100))
BEGIN
    DECLARE data_ultimo_evento TIMESTAMP;
    DECLARE livello_gravita INT DEFAULT 0;
    DECLARE coefficiente INT DEFAULT 0;
    
	SET data_ultimo_evento = (
								SELECT EC.DataAccadimento
                                FROM EventoCalamitoso EC
                                WHERE EC.Tipo = _TipoEventoCalamitoso
									AND EC.AreaGeografica = (
																SELECT E.AreaGeografica
                                                                FROM Edificio E
                                                                WHERE E.IdEdificio = _Edificio
															)
									AND NOT EXISTS (
														SELECT 1
                                                        FROM EventoCalamitoso EC2
                                                        WHERE EC2.Tipo = _TipoEventoCalamitoso
															AND EC2.DataAccadimento > EC.DataAccadimento
                                                            AND EC2.AreaGeografica = EC.AreaGeografica
													)
							);
                            
	WITH vani_target AS (
		SELECT V.Idvano
        FROM Vano V
			 INNER JOIN
             Edificio E ON V.Edificio = E.IdEdificio
        WHERE E.AreaGeografica = (
									SELECT E.AreaGeografica
									FROM Edificio E
									WHERE E.IdEdificio = _Edificio
								)
				AND E.Zona = (
								SELECT E1.Zona
								FROM Edificio E1
								WHERE E1.IdEdificio = _Edificio
							)
    ),
    misurazioni_target AS (
			SELECT VT.IdVano, S.IdSensore, S.SogliaSicurezza, IF(S.TipoSensore = 'Giroscopio' OR S.TipoSensore = 'Accelerometro', (M.AsseX + M.AsseY + M.AsseZ)/3, IF(S.TipoSensore = 'SensoreTemperatura' OR S.TipoSensore = 'SensoreUmidita',(AsseX + AsseY)/2, AsseX)) AS Valore
            FROM vani_target VT
				 INNER JOIN
                 Sensore S ON VT.IdVano = S.Vano
                 INNER JOIN
                 Misure M ON S.IdSensore = M.Sensore
                 INNER JOIN
                 ElencoAlert EA ON M.Sensore = EA.Sensore AND M.Timestamp = EA.Timestamp
			WHERE M.Timestamp BETWEEN data_ultimo_evento - INTERVAL 10 MINUTE AND data_ultimo_evento + INTERVAL 60 MINUTE
	),
    doppio_della_soglia AS(
		SELECT COUNT(*) / ( SELECT IF (COUNT(DISTINCT E.IdEdificio) = 0, 1, COUNT(DISTINCT E.IdEdificio))
							FROM Edificio E
									INNER JOIN
									ProgettoEdilizio PE ON E.IdEdificio = PE.Edificio
							WHERE E.AreaGeografica = (
															SELECT E.AreaGeografica
															FROM Edificio E
															WHERE E.IdEdificio = _Edificio
													  )
								AND E.Zona = (
												SELECT E1.Zona
                                                FROM Edificio E1
                                                WHERE E1.IdEdificio = _Edificio
											 )    
								AND PE.Esiste = 0
								AND PE.DataFine < data_ultimo_evento
							) as MediaAlert
        FROM misurazioni_target MT
        WHERE MT.Valore > (MT.SogliaSicurezza * 2)
    )
    
	SELECT IF(DDS.MediaAlert >= 10, 4, IF(DDS.MediaAlert BETWEEN 7 AND 9, 3, IF(DDS.MediaAlert BETWEEN 4 AND 6,2,IF(DDS.MediaAlert BETWEEN 1 AND 3, 1, 0)))) AS LivelloGravita INTO livello_gravita
	FROM doppio_della_soglia DDS;
    
    CALL stato_edificio(_Edificio, @StatoEdificio, @Messaggio);
    
    SET coefficiente = livello_gravita * IF(@StatoEdificio = "L'Edificio è in ottimo stato!", 1, IF(@StatoEdificio = "L'Edificio è in discreto stato!",2,3));
    
    WITH vani_target AS (
		SELECT V.Idvano
        FROM Vano V 
        WHERE V.Edificio = _Edificio
    ),
    misurazioni_target AS (
			SELECT VT.IdVano, S.IdSensore, S.ElementoStrutturale, S.SogliaSicurezza, AVG(IF(S.TipoSensore = 'Giroscopio' OR S.TipoSensore = 'Accelerometro', (M.AsseX + M.AsseY + M.AsseZ)/3, IF(S.TipoSensore = 'SensoreTemperatura' OR S.TipoSensore = 'SensoreUmidita',(AsseX + AsseY)/2, AsseX)) + coefficiente) AS Valore
            FROM vani_target VT
				 INNER JOIN
                 Sensore S ON VT.IdVano = S.Vano
                 INNER JOIN
                 Misure M ON S.IdSensore = M.Sensore
                 INNER JOIN
                 ElencoAlert EA ON M.Sensore = EA.Sensore AND M.Timestamp = EA.Timestamp
			WHERE CURRENT_DATE - INTERVAL 1 WEEK < M.Timestamp
            GROUP BY VT.IdVano, S.IdSensore, S.ElementoStrutturale, S.TipoSensore, S.SogliaSicurezza
	)
    SELECT MT.IdVano, MT.Elementostrutturale, MT.IdSensore as SensoreAnalizzato, IF(MT.Valore < MT.SogliaSicurezza * 4, "Possibile danno lieve a questa parte dell'edificio", "Possibile danno critico a questa parte dell'edificio") AS StimaDanni
    FROM misurazioni_target MT
    WHERE MT.Valore > MT.SogliaSicurezza;    
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS stima_danni_edificio_con_livello_gravita;
DELIMITER $$
CREATE PROCEDURE stima_danni_edificio_con_livello_gravita(IN _Edificio INT, IN livello_gravita INT)
BEGIN
    DECLARE coefficiente INT DEFAULT 0;

    CALL stato_edificio(_Edificio, @StatoEdificio, @Messaggio);
    
    SET coefficiente = livello_gravita * IF(@StatoEdificio = "L'Edificio è in ottimo stato!", 1, IF(@StatoEdificio = "L'Edificio è in discreto stato!",2,3));
    
    WITH vani_target AS (
		SELECT V.Idvano
        FROM Vano V 
        WHERE V.Edificio = _Edificio
    ),
    misurazioni_target AS (
			SELECT VT.IdVano, S.IdSensore, S.ElementoStrutturale, S.SogliaSicurezza, AVG(IF(S.TipoSensore = 'Giroscopio' OR S.TipoSensore = 'Accelerometro', (M.AsseX + M.AsseY + M.AsseZ)/3, IF(S.TipoSensore = 'SensoreTemperatura' OR S.TipoSensore = 'SensoreUmidita',(AsseX + AsseY)/2, AsseX)) + coefficiente) AS Valore
            FROM vani_target VT
				 INNER JOIN
                 Sensore S ON VT.IdVano = S.Vano
                 INNER JOIN
                 Misure M ON S.IdSensore = M.Sensore
                 INNER JOIN
                 ElencoAlert EA ON M.Sensore = EA.Sensore AND M.Timestamp = EA.Timestamp
			WHERE CURRENT_DATE - INTERVAL 1 WEEK < M.Timestamp
            GROUP BY VT.IdVano, S.IdSensore, S.ElementoStrutturale, S.TipoSensore, S.SogliaSicurezza
	)
    SELECT MT.IdVano, MT.Elementostrutturale, MT.IdSensore as SensoreAnalizzato, IF(MT.Valore < MT.SogliaSicurezza * 4, "Possibile danno lieve a questa parte dell'edificio", "Possibile danno critico a questa parte dell'edificio") AS StimaDanni
    FROM misurazioni_target MT
    WHERE MT.Valore > MT.SogliaSicurezza;
    
END $$
DELIMITER ;