/* 
Controllo coefficienti di rischio
*/

DROP PROCEDURE IF EXISTS coefficienti_rischio;
DELIMITER $$
CREATE PROCEDURE coefficienti_rischio()
BEGIN
    WITH ValoriRecenti AS(
		SELECT C.AreaGeografica, C.TipoRischio, C.Valore
        FROM Coefficienti C
        WHERE C.Data >= ALL (
								SELECT C1.Data
                                FROM Coefficienti C1
                                WHERE C1.TipoRischio = C.TipoRischio
									AND C1.AreaGeografica = C.AreaGeografica
							)
    )
    SELECT VR.AreaGeografica
    FROM ValoriRecenti VR
    GROUP BY VR.AreaGeografica
    HAVING AVG(VR.Valore) <= ALL (
									SELECT AVG(VR1.Valore)
									FROM ValoriRecenti VR1
									GROUP BY VR1.AreaGeografica
								 );
END $$
DELIMITER ;

/*
Controllo dello stato dei sensori
*/

DROP PROCEDURE IF EXISTS alert_sensori;
DELIMITER $$
CREATE PROCEDURE alert_sensori (IN _IdVano INT)
BEGIN
	SELECT S.IdSensore, S.TipoSensore, E.Timestamp, M.AsseX, M.AsseY, M.AsseZ
    FROM Sensore S
		 INNER JOIN
         ElencoAlert E ON S.IdSensore = E.Sensore
         INNER JOIN
         Misure M ON M.Sensore = S.IdSensore AND M.Timestamp = E.Timestamp
	WHERE S.Vano = _IdVano;
END	$$
DELIMITER ;

/*
Utilizzo di un materiale
*/

DROP PROCEDURE IF EXISTS utilizzo_materiale;
DELIMITER $$
CREATE PROCEDURE utilizzo_materiale(IN _PartitaIVA INT, IN _CodLotto INT)
BEGIN
	IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) = 'Materiale Generico' THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VGenerico VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
    
    IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) = 'Asse di Legno' THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VAsseLegno VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
    
    IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) = 'Pietra' THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VPietra VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
    
    IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) = 'Piastrella' THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VPiastrella VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
    
    IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) = 'Intonaco' THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VIntonaco VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
    
    IF (
			SELECT M.TipoMateriale
            FROM Materiale M
            WHERE M.CodLotto = _CodLotto
				AND M.PartitaIVA = _PartitaIVA
		) IN ('Mattone') THEN 
        SELECT VG.Vano, VG.ElementoStrutturale
        FROM VMattone VG
        WHERE VG.CodLotto = _CodLotto
				AND VG.PartitaIVA = _PartitaIVA;
	END IF;
END $$
DELIMITER ;

/*
Elenco lavoratori e relativo lavoro svolto in una data
*/

DROP PROCEDURE IF EXISTS lavoratori_lavoro;
DELIMITER $$
CREATE PROCEDURE lavoratori_lavoro (IN _Data DATE)
BEGIN
	WITH matricole AS (
		SELECT A.Lavoratore, A.Lavoro
        FROM OrariLavoro OL
			 INNER JOIN
             Afferiscono A ON OL.Lavoro = A.Lavoro
		WHERE OL.Data = _Data
	)
    SELECT M.Lavoratore, L.IdLavoro, PE.Edificio
    FROM matricole M
		 INNER JOIN
         Lavoro L ON M.Lavoro = L.IdLavoro
         INNER JOIN
         StadioAvanzamento SA ON L.StadioAvanzamento = SA.IdFase
         INNER JOIN
         ProgettoEdilizio PE ON SA.ProgettoEdilizio = PE.IdProgetto;
END $$
DELIMITER ;

/*
Stadio di avanzamento più in ritardo
*/

DROP PROCEDURE IF EXISTS stadioavanzamento_ritardo;
DELIMITER $$
CREATE PROCEDURE stadioavanzamento_ritardo()
BEGIN		
	SELECT SA.IdFase AS StadioDiAvanzamento, L.IdLavoro AS Lavoro, L.CapoCantiere, DATEDIFF(CURRENT_DATE, SA.StimaDataFine) AS GiorniDiRitardo
    FROM StadioAvanzamento SA
		 INNER JOIN
         Lavoro L ON SA.IdFase = L.StadioAvanzamento
    WHERE SA.DataCompletamento IS NULL
		AND SA.StimaDataFine < CURRENT_DATE
		AND (DATEDIFF(CURRENT_DATE, SA.StimaDataFine)) >= ALL (	 
																	SELECT DATEDIFF(CURRENT_DATE, SA1.StimaDataFine)
																	FROM StadioAvanzamento SA1
																	WHERE SA1.DataCompletamento IS NULL
																		AND SA1.StimaDataFine < CURRENT_DATE 
																)
		AND L.DataFine IS NULL;
END $$
DELIMITER ;

/*
Inserimento in Afferiscono (i controlli che l'inserimento possa essere fatto vengono svolti automaticamente dai trigger)
*/	

DROP PROCEDURE IF EXISTS inserimento_afferiscono;
DELIMITER $$
CREATE PROCEDURE inserimento_afferiscono (IN _Lavoratore VARCHAR(16), IN _Lavoro INT, IN _Compenso INT)
BEGIN
	INSERT INTO Afferiscono (Lavoratore, Lavoro, Compenso) 
	VALUES (_Lavoratore, _Lavoro, _Compenso);
END $$
DELIMITER ;

/*
Quantità rimasta in magazzino (attributo ridondante)
*/

DROP PROCEDURE IF EXISTS quantita_rimasta;
DELIMITER $$
CREATE PROCEDURE quantita_rimasta (IN _PartitaIVA INT, IN _CodLotto INT)
BEGIN
	SELECT M.QuantitaRimasta
    FROM Materiale M
    WHERE M.CodLotto = _CodLotto
			AND M.PartitaIVA = _PartitaIVA;
END $$
DELIMITER ;

/*
Costo totale dei soli materiale utiizzati per un progetto edilizio (attributo ridondante)
*/

DROP PROCEDURE IF EXISTS costo_totale_materiali;
DELIMITER $$
CREATE PROCEDURE costo_totale_materiali (IN _ProgettoEdilizio INT) 
BEGIN
	SELECT PE.CostoMateriali
    FROM ProgettoEdilizio PE
    WHERE PE.IdProgetto = _ProgettoEdilizio;
END $$
DELIMITER ;