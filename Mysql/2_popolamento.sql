INSERT INTO AreaGeografica (NomeLuogo)
VALUES ('Toscana'), ('Liguria'), ('Abruzzo'), ('Lombardia'), ('Piemonte'), ('Lazio'), ('Calabria');

INSERT INTO Coefficienti (TipoRischio, Data, Valore, AreaGeografica) 
VALUES ('Sismico', '2022-10-01', 150, 'Toscana'),
	   ('Idrogeologico', '2022-10-01', 50, 'Toscana'),
       ('Sismico', '2022-09-01', 100, 'Toscana'),
	   ('Idrogeologico', '2022-09-01', 75, 'Toscana'),
       ('Sismico', '2022-05-01', 180, 'Toscana'),
	   ('Idrogeologico', '2022-05-01', 75, 'Toscana'),
       ('Sismico', '2022-01-01', 200, 'Toscana'),
	   ('Idrogeologico', '2022-01-01', 175, 'Toscana'),
       ('Sismico', '2022-10-01', 75, 'Liguria'),
	   ('Idrogeologico', '2022-10-01', 20, 'Liguria'),
       ('Sismico', '2022-09-01', 125, 'Liguria'),
	   ('Idrogeologico', '2022-09-01', 150, 'Liguria'),
       ('Sismico', '2022-05-01', 120, 'Liguria'),
	   ('Idrogeologico', '2022-05-01', 250, 'Liguria'),
       ('Sismico', '2022-01-01', 45, 'Liguria'),
	   ('Idrogeologico', '2022-01-01', 200, 'Liguria'),
       ('Sismico', '2022-11-08', 250, 'Calabria'),
	   ('Idrogeologico', '2022-11-08', 50, 'Calabria'),
       ('Sismico', '2022-11-05', 500, 'Calabria'),
	   ('Idrogeologico', '2022-11-05', 75, 'Calabria'),
       ('Sismico', '2022-11-17', 180, 'Calabria'),
	   ('Idrogeologico', '2022-11-17', 750, 'Calabria'),
       ('Sismico', '2022-11-18', 400, 'Calabria'),
	   ('Idrogeologico', '2022-11-18', 175, 'Calabria');
       
INSERT INTO EventoCalamitoso (Tipo, DataAccadimento, Latitudine, Longitudine, AreaGeografica)
VALUES ('Sismico', '2022-11-08 18:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Idrogeologico', '2022-11-08 15:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Sismico', '2022-11-05 18:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Idrogeologico', '2022-11-05 15:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Sismico', '2022-11-17 18:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Idrogeologico', '2022-11-17 15:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Sismico', '2022-11-18 18:00:00', 38.1116, 15.6621, 'Calabria'),
	   ('Idrogeologico', '2022-11-18 15:00:00', 38.1116, 15.6621, 'Calabria'),
       ('Sismico', '2022-11-16 13:00:00', 11.4166, 15.6621, 'Toscana');

INSERT INTO Edificio (IdEdificio, Tipologia, Zona, AreaGeografica)
VALUES (1,'Condominio','nord','Toscana'),
	   (2,'Condominio','sud','Calabria');

INSERT INTO Piano (NumPiano, Pianta, Edificio)
VALUES (0,'Rettangolo',1),
	   (1, 'Rettangolo', 1),
       (0,'Quadrato', 2),
	   (1,'Quadrato', 2),
       (2,'Quadrato', 2),
       (3,'Quadrato', 2);
   
INSERT INTO Vano (IdVano, Forma, LarghezzaMax, AltezzaMax, LunghezzaMax, Piano, Edificio)     
VALUES (1, 'Rettangolo', 5000, 1500, 2000, 0, 1), 
	   (2, 'Quadrato', 7000, 3000, 7000, 0, 1),
       (3, 'Rettangolo', 3000, 3000, 2000, 0, 1),
       (4, 'Quadrato', 5000, 3000, 5000, 0, 1),
       (5, 'Quadrato', 5000, 3000, 5000, 0, 1),
       
	   (6, 'Quadrato', 3000, 3000, 4000, 1, 1),
       (7, 'Rettangolo', 4000, 3000, 2000, 1, 1),
       (8, 'Rettangolo', 3000, 3000, 2000, 1, 1),
       (9, 'Quadrato', 5000, 3000, 5000, 1, 1),
       (10, 'Quadrato', 5000, 3000, 5000, 1, 1),
       
       (11, 'Quadrato', 7000, 3000, 7000, 0, 2),
	   (12, 'Rettangolo', 4000, 3000, 9000, 0, 2),
       
       (13, 'Rettangolo', 3000, 3000, 5500, 1, 2),
       (14, 'Quadrato', 6600, 3000, 6600, 1, 2),
       (15, 'Quadrato', 5000, 3000, 5000, 1, 2),
       
	   (16, 'Quadrato', 4000, 3000, 4000, 2, 2),
       (17, 'Rettangolo', 4000, 3000, 2000, 2, 2),
       (18, 'Quadrato', 3000, 3000, 3000, 2, 2),
       (19, 'Rettangolo', 5000, 3000, 1000, 2, 2),
       
       (20, 'Rettangolo', 8000, 3000, 5000, 3, 2);
       
INSERT INTO Funzione (Tipologia)
VALUES ('Terrazza'), ('Soggiorno'), ('Cucina'), ('Bagno'), ('CameraDaLetto');

INSERT INTO Adibito (Vano, Funzione)
VALUES (1,'Terrazza'),
	   (2,'Soggiorno'),
       (2,'Cucina'),
       (3,'Bagno'),
       (4,'CameraDaLetto'),
       (5,'CameraDaLetto'),
       (6,'Soggiorno'),
       (7,'Cucina'),
       (8,'Bagno'),
       (9,'CameraDaLetto'),
       (10,'CameraDaLetto'),
       (11,'Terrazza'),
	   (12,'Soggiorno'),
       (12,'Cucina'),
       (13,'Bagno'),
       (14,'CameraDaLetto'),
       (15,'CameraDaLetto'),
       (16,'Soggiorno'),
       (17,'Cucina'),
       (18,'Bagno'),
       (19,'CameraDaLetto'),
       (20,'CameraDaLetto');
       
INSERT INTO Parete (ElementoStrutturale, Vano)
VALUES ('nord', 1),
	   ('sud', 1),
       ('est', 1),
       ('ovest', 1),
       ('soffitto', 1),
       ('pavimento', 1),
       
	   ('nord', 2),
	   ('sud', 2),
       ('est', 2),
       ('ovest', 2),
       ('soffitto', 2),
       ('pavimento', 2),
       
       ('nord', 3),
	   ('sud', 3),
       ('est', 3),
       ('ovest', 3),
       ('soffitto', 3),
       ('pavimento', 3),
       
       ('nord', 11),
	   ('sud', 11),
       ('est', 11),
       ('ovest', 11),
       ('soffitto', 11),
       ('pavimento', 11),
       
	   ('nord', 12),
	   ('sud', 12),
       ('est', 12),
       ('ovest', 12),
       ('soffitto', 12),
       ('pavimento', 12),
       
       ('nord', 13),
	   ('sud', 13),
       ('est', 13),
       ('ovest', 13),
       ('soffitto', 13),
       ('pavimento', 13),
       
       ('nord', 4),
	   ('sud', 4),
       ('est', 4),
       ('ovest', 4),
       ('soffitto', 4),
       ('pavimento', 4),
       
	   ('nord', 5),
	   ('sud', 5),
       ('est', 5),
       ('ovest', 5),
       ('soffitto', 5),
       ('pavimento', 5),
       
       ('nord', 6),
	   ('sud', 6),
       ('est', 6),
       ('ovest', 6),
       ('soffitto', 6),
       ('pavimento', 6),
       
       ('nord', 7),
	   ('sud', 7),
       ('est', 7),
       ('ovest', 7),
       ('soffitto', 7),
       ('pavimento', 7),
       
	   ('nord', 8),
	   ('sud', 8),
       ('est', 8),
       ('ovest', 8),
       ('soffitto', 8),
       ('pavimento', 8),
       
       ('nord', 9),
	   ('sud', 9),
       ('est', 9),
       ('ovest', 9),
       ('soffitto', 9),
       ('pavimento', 9),
       
       ('nord', 10),
	   ('sud', 10),
       ('est', 10),
       ('ovest', 10),
       ('soffitto', 10),
       ('pavimento', 10);

INSERT INTO Sensore (IdSensore, ElementoStrutturale, TipoSensore, SogliaSicurezza, Vano)
VALUES (1,'nord','SensorePioggia', 50, 1),
	   (2, 'soffitto', 'SensorePosizione', 50, 2),
       (3, 'ovest', 'Giroscopio', 7, 2),
       (4, 'est', 'SensoreTemperatura', 25, 2),
       (5, 'soffitto', 'SensoreUmidita', 15, 2),
       (6, 'soffitto', 'SensoreUmidita', 15, 5),
       (7, 'soffitto', 'Accelerometro', 5, 6),
       (8, 'soffitto', 'Giroscopio', 7, 7),
       (9, 'soffitto', 'SensoreUmidita', 10, 8),
       (10, 'soffitto', 'SensoreTemperatura', 30, 10),
       (11,'sud','Giroscopio', 60, 11), 
	   (12, 'soffitto', 'Accelerometro', 50, 12), 
       (13, 'est', 'Giroscopio', 60, 12), 
       (14, 'nord', 'SensorePosizione', 25, 13), 
       (15, 'soffitto', 'SensorePosizione', 25, 13),
       (16, 'soffitto', 'SensoreUmidita', 50, 13),
       (17, 'sud', 'Accelerometro', 50, 14),
       (18, 'ovest', 'Giroscopio', 60, 14),
       (19, 'soffitto', 'SensoreUmidita', 50, 18),
       (20, 'pavimento', 'Giroscopio', 60, 20);

INSERT INTO Misure (Timestamp, AsseX, AsseY, AsseZ, Sensore) 
VALUES ('2022-11-08 20:13:13', 0, 0, 0, 1),
	   ('2022-11-09 15:25:45', 20, 0, 0, 1),
       ('2022-11-10 07:00:00', 0, 0, 0, 1),
       ('2022-11-16 13:15:00', 70, 0, 0, 1),
       ('2022-11-17 09:30:30', 40, 0, 0, 1),
       ('2022-11-17 00:00:00', 20, 0, 0, 1),
       ('2022-11-08 20:20:13', 101, 0, 0, 1),
	   ('2022-11-09 15:38:45', 20, 0, 0, 1),
       ('2022-11-10 07:55:00', 220, 0, 0, 1),
       ('2022-11-16 13:40:00', 70, 0, 0, 1),
       ('2022-11-17 09:35:30', 101, 0, 0, 1),
       ('2022-11-17 00:10:00', 50, 0, 0, 1),
       ('2022-11-17 18:30:00', 120, 0, 0, 1),
       ('2022-11-17 15:10:00', 80, 0, 0, 1),
       ('2022-11-15 10:10:00', 90, 0, 0, 1),
       
       ('2022-11-08 20:13:13', 10, 0, 0, 2),
	   ('2022-11-10 15:25:45', 20, 0, 0, 2),
       ('2022-11-11 07:00:00', 0, 0, 0, 2),
       ('2022-11-16 13:15:00', 30, 0, 0, 2),
       ('2022-11-17 09:30:30', 80, 0, 0, 2),
       ('2022-11-18 00:00:00', 70, 0, 0, 2),
       ('2022-11-17 15:00:00', 100, 0, 0, 2),
       ('2022-11-18 18:00:00', 120, 0, 0, 2),
       ('2022-11-18 18:15:00', 130, 0, 0, 2),
       
       ('2022-11-08 20:13:13', 8, 2, 10, 3),
	   ('2022-11-09 15:25:45', 0, 0, 0, 3),
       ('2022-11-12 07:00:00', 0, 0, 0, 3),
       ('2022-11-17 13:15:01', 5, 1, 4, 3),
       ('2022-11-17 09:30:30', 10, 5, 5, 3),
       ('2022-11-17 00:00:00', 3, 2, 1, 3),
       ('2022-11-17 18:00:00', 30, 200, 10, 3),
       ('2022-11-18 15:00:00', 30, 200, 1, 3),
       
       ('2022-11-08 20:13:13', 20, 20, 0, 4),
	   ('2022-11-09 15:24:45', 27, 25, 0, 4),
       ('2022-11-11 07:04:00', 22, 22, 0, 4),
       ('2022-11-17 13:15:40', 36, 30, 0, 4),
       ('2022-11-17 09:34:30', 26, 26, 0, 4),
       ('2022-11-18 00:40:00', 25, 27, 0, 4),
       ('2022-11-16 20:15:13', 26, 27, 0, 4),
	   ('2022-11-16 15:35:45', 27, 25, 0, 4),
       ('2022-11-17 07:03:00', 29, 28, 0, 4),
       ('2022-11-17 13:15:00', 36, 30, 0, 4),
       ('2022-11-17 09:20:30', 29, 25, 0, 4),
       ('2022-11-18 00:03:00', 25, 27, 0, 4),
       ('2022-11-17 15:03:00', 250, 27, 0, 4),
       
       ('2022-11-11 20:13:13', 4, 2, 0, 5),
	   ('2022-11-13 15:25:45', 8, 2, 0, 5),
       ('2022-11-17 07:00:00', 9, 6, 0, 5),
       ('2022-11-17 13:15:00', 8, 5, 0, 5),
       ('2022-11-18 09:30:30', 16, 18, 0, 5),
       ('2022-11-18 00:00:00', 6, 4, 0, 5),
       ('2022-11-17 18:00:00', 60, 40, 100, 5),
       
       ('2022-11-10 20:13:13', 6, 5, 4, 7),
	   ('2022-11-11 15:25:45', 3, 2, 1, 7),
       ('2022-11-17 07:00:00', 9, 7, 5, 7),
       ('2022-11-18 13:15:00', 8, 9, 4, 7),
       ('2022-11-18 09:30:30', 1, 9, 3, 7),
       ('2022-11-16 00:00:00', 5, 7, 4, 7),
       ('2022-11-17 18:00:00', 50, 70, 40, 7),
       
       ('2022-11-1 20:13:13', 20, 25, 30, 11),
	   ('2022-11-5 15:05:45', 100, 300, 540, 11),
       ('2022-11-5 17:59:00', 70, 85, 70, 11),
       ('2022-11-8 15:00:01', 120, 140, 150, 11),
       ('2022-11-8 15:03:30', 700, 140, 80, 11),
       ('2022-11-8 18:04:00', 55, 80, 90, 11),
       ('2022-11-17 18:01:13', 110, 200, 70, 11),
	   ('2022-11-17 18:04:45', 20, 10, 100, 11),
       ('2022-11-17 18:09:10', 550, 80, 0, 11),
       ('2022-11-18 14:59:00', 70, 90, 60, 11),
       ('2022-11-18 15:00:30', 90, 90, 90, 11),
       ('2022-11-18 17:55:00', 210, 200, 100, 11),
       
       ('2022-11-1 20:13:34', 20, 25, 30, 12),
	   ('2022-11-5 15:05:45', 100, 300, 540, 12),
       ('2022-11-5 17:59:10', 70, 85, 70, 12),
       ('2022-11-8 15:00:10', 120, 140, 150, 12),
       ('2022-11-8 15:03:50', 700, 140, 80, 12),
       ('2022-11-8 18:04:32', 55, 30, 40, 12),
       ('2022-11-17 18:01:12', 190, 200, 70, 12),
	   ('2022-11-17 18:04:12', 20, 10, 100, 12),
       ('2022-11-17 18:09:32', 550, 80, 0, 12),
       ('2022-11-18 14:59:12', 20, 40, 60, 12),
       ('2022-11-18 15:00:32', 90, 30, 90, 12),
       ('2022-11-18 17:55:24', 730, 160, 20, 12),
       
       ('2022-11-1 20:13:34',60, 25, 10, 13),
	   ('2022-11-5 15:06:45', 90, 40, 100, 13),
       ('2022-11-5 17:59:50', 98, 100, 70, 13),
       ('2022-11-8 15:01:10', 120, 140, 150, 13),
       ('2022-11-8 15:04:50', 200, 140, 109, 13),
       ('2022-11-8 18:06:32', 700, 50, 40, 13),
       ('2022-11-17 18:08:12', 39, 70, 50, 13),
	   ('2022-11-17 18:12:12', 90, 10, 100, 13),
       ('2022-11-17 18:18:32', 550, 80, 0, 13),
       ('2022-11-18 14:59:47', 20, 40, 60, 13),
       ('2022-11-18 15:01:32', 90, 30, 90, 13),
       ('2022-11-18 17:56:24', 730, 160, 20, 13),
       
       ('2022-11-5 15:06:45', 20, 0, 0, 14),
	   ('2022-11-5 17:59:50', 30, 0, 0, 14),
       ('2022-11-8 15:01:10', 61, 0, 0, 14),
       ('2022-11-8 15:04:50', 36, 0, 0, 14),
       ('2022-11-8 18:06:32', 57, 0, 0, 14),
       ('2022-11-17 18:08:12', 89, 0, 0, 14),
       ('2022-11-17 18:12:12', 70, 0, 0, 14),
	   ('2022-11-18 14:59:47', 27, 0, 0, 14),
       ('2022-11-22 07:00:00', 0, 0, 0, 14),
       ('2022-11-18 17:56:24', 59, 0, 0, 14),
       ('2022-11-21 09:30:30', 30, 0, 0, 14),
       ('2022-11-21 00:00:00', 37, 0, 0, 14),
       ('2022-11-17 15:06:45', 200, 0, 0, 14),
	   ('2022-11-18 17:59:50', 30, 0, 0, 14),
       ('2022-11-17 15:11:10', 61, 0, 0, 14),
       ('2022-11-18 15:08:50', 36, 0, 0, 14),
       ('2022-11-18 18:46:32', 57, 0, 0, 14),
       
       ('2022-11-5 15:26:45', 20, 0, 0, 15),
	   ('2022-11-5 17:59:54', 30, 0, 0, 15),
       ('2022-11-8 15:11:10', 61, 0, 0, 15),
       ('2022-11-8 15:07:50', 36, 0, 0, 15),
       ('2022-11-8 18:00:32', 57, 0, 0, 15),
       ('2022-11-17 18:06:12', 89, 0, 0, 15),
       ('2022-11-17 18:07:12', 70, 0, 0, 15),
	   ('2022-11-18 14:59:37', 27, 0, 0, 15),
       ('2022-11-22 07:00:00', 0, 0, 0, 15),
       ('2022-11-18 17:59:24', 59, 0, 0, 15),
       ('2022-11-21 09:30:30', 30, 0, 0, 15),
       ('2022-11-17 15:26:45', 20, 0, 0, 15),
	   ('2022-11-18 17:59:54', 30, 0, 0, 15),
       ('2022-11-18 15:11:10', 61, 0, 0, 15),
       ('2022-11-21 00:00:00', 37, 0, 0, 15);

INSERT INTO ProgettoEdilizio (IdProgetto, Esiste, CostoMateriali, DataInizio, StimaDataFine, DataApprovazione, DataPresentazione, DataFine, Edificio)
VALUES (1, 1, 0, '2022-10-22', '2022-12-31', '2022-10-10', '2022-10-05', NULL, 1),
	   (2, 1, 0, '2022-11-10', '2022-12-31', '2022-10-10', '2022-10-05', NULL, 2);

INSERT INTO StadioAvanzamento (IdFase, DataCompletamento, DataInizio, StimaDataFine, ProgettoEdilizio)
VALUES (1, NULL, '2022-10-22', '2022-11-15', 1),
	   (2, NULL, '2022-11-16', '2022-12-31', 1),
       (3, NULL, '2022-10-22', '2022-10-28', 1),
       (4, '2022-11-11', '2022-11-10', '2022-11-11', 2),
	   (5, NULL, '2022-11-10', '2022-11-12', 2),
       (6, NULL, '2022-11-10', '2022-11-13', 2);
      
INSERT INTO CapoCantiere (CodFiscale, Nome, Cognome, PagaOraria, MaxOperai) 
VALUES ('RSSMRA95A01G702J', 'Mario', 'Rossi', 15, 30),
	   ('FRITMS95A01G702J', 'Thomas', 'Fiori', 10, 5);
 
INSERT INTO Lavoro (IdLavoro, Tipologia, DataInizio, Vano, DataFine, StadioAvanzamento, CapoCantiere, Costo)
VALUES (1, 'Ristrutturazione', '2022-10-22', 2, '2022-11-05', 1, 'RSSMRA95A01G702J', 0),
	   (2, 'Ristrutturazione', '2022-11-16', 3, '2022-12-10', 2, 'RSSMRA95A01G702J', 0),
       (3, 'Ristrutturazione', '2022-10-22', 2, NULL, 3, 'RSSMRA95A01G702J', 0),
       (4, 'Ristrutturazione', '2022-11-10', 11, '2022-11-11', 4, 'FRITMS95A01G702J', 0),
	   (5, 'Ristrutturazione', '2022-11-11', 12, NULL, 5, 'RSSMRA95A01G702J', 0),
       (6, 'Ristrutturazione', '2022-11-12', 13, NULL, 6, 'RSSMRA95A01G702J', 0),
       (7, 'Ristrutturazione', '2022-10-22', 2, '2022-11-04', 1, 'FRITMS95A01G702J', 0),
	   (8, 'Ristrutturazione', '2022-11-16', 3, '2022-12-09', 2, 'FRITMS95A01G702J', 0),
       (9, 'Ristrutturazione', '2022-10-22', 2, NULL, 3, 'RSSMRA95A01G702J', 0),
       (10, 'Ristrutturazione', '2022-11-11', 11, '2022-11-11', 4, 'FRITMS95A01G702J', 0),
	   (11, 'Ristrutturazione', '2022-11-11', 12, NULL, 5, 'FRITMS95A01G702J', 0),
       (12, 'Ristrutturazione', '2022-11-12', 13, NULL, 6, 'RSSMRA95A01G702J', 0);

INSERT INTO Materiale (PartitaIVA, CodLotto, DataAcquisto, TipoCosto, QuantitaComprata, QuantitaRimasta, CostoUnitario, TipoMateriale)
VALUES (19757, 9154258, '2022-10-15', 'metro-quadrato', 300, 20, 30, 'Mattone'),
	   (21436, 6520148, '2022-10-10', 'metro-quadrato', 200, 20, 15, 'Intonaco'),
       (14756, 1024578, '2022-10-14', 'metro-quadrato', 500, 20, 18, 'Piastrella'),
       (20001, 4646646, '2022-11-15', 'metro-quadrato', 100, 20, 30, 'Pietra'), 
	   (21001, 2817638, '2022-11-10', 'metro-quadrato', 200, 20, 15, 'Asse di Legno'), 
       (22001, 2974521, '2022-11-14', 'metro-quadrato', 100, 20, 18, 'Materiale Generico'),
       (19757, 1111111, '2022-10-15', 'metro-quadrato', 200, 20, 30, 'Mattone'),
	   (21436, 2222222, '2022-10-10', 'metro-quadrato', 100, 20, 15, 'Intonaco'),
       (14756, 3333333, '2022-10-14', 'metro-quadrato', 200, 20, 10, 'Piastrella'),
       (20001, 4444444, '2022-11-15', 'metro-quadrato', 200, 20, 40, 'Pietra'), 
	   (21001, 5555555, '2022-11-10', 'metro-quadrato', 500, 20, 15, 'Asse di Legno'), 
       (22001, 6666666, '2022-11-14', 'metro-quadrato', 200, 20, 50, 'Materiale Generico'); 
       
INSERT INTO Utilizzo (Lavoro, PartitaIVA, CodLotto, QuantitaUsata) 
VALUES (1, 19757, 9154258, 20),
	   (1, 21436, 6520148, 10),
       (1, 14756, 1024578, 20),
       (2, 19757, 9154258, 30),
	   (2, 21436, 6520148, 40),
       (2, 14756, 1024578, 30),
       (5, 20001, 4646646, 40),
	   (5, 21001, 2817638, 40),
       (4, 20001, 4646646, 40),
       (4, 19757, 1111111, 40),
	   (6, 21436, 2222222, 40),
       (6, 19757, 1111111, 40),
       (7, 21436, 2222222, 20),
	   (7, 14756, 3333333, 10),
       (8, 14756, 3333333, 20),
       (9, 20001, 4444444, 30),
	   (10, 21001, 5555555, 40),
       (11, 22001, 6666666, 30),
       (12, 20001, 4444444, 40);

INSERT INTO Mattone (PartitaIVA, CodLotto, X, Y, Z, Forma, Tipo)
VALUES (19757, 9154258, 300, 200, 100, 'Parallelepipedo', 'Calcestruzzo'),
	   (19757, 1111111, 300, 200, 200, 'Parallelepipedo', 'Laterizio');

INSERT INTO Alveolatura (MaterialeIsolante, Forma)
VALUES ('Laterizio', 'Rettangolare');

INSERT INTO Caratterizzato (PartitaIVA, CodLotto, MaterialeIsolante, FormaAlveolatura)
VALUES (19757, 9154258, 'Laterizio', 'Rettangolare');
    
INSERT INTO Intonaco (PartitaIVA, CodLotto, Tipo, Colore)
VALUES (21436, 6520148, 'Calce', 'Verde'),
	   (21436, 2222222, 'Calce', 'Bianco');

INSERT INTO Piastrella (PartitaIVA, CodLotto, Tipo, DimensioneLato, Forma, Disegno)
VALUES (14756, 1024578, 'Ceramica', 200, 'Quadrata', 'Fiori'),
	   (14756, 3333333, 'Ceramica', 300, 'Quadrata', NULL);
    
INSERT INTO VMattone (PartitaIVA, CodLotto, ElementoStrutturale, Vano) 
VALUES (19757, 9154258, 'nord', 2),
	   (19757, 9154258, 'sud', 3),
	   (19757, 9154258, 'nord', 1),
       (19757, 1111111, 'nord', 4),
	   (19757, 1111111, 'sud', 3),
	   (19757, 9154258, 'nord', 5),
       (19757, 1111111, 'nord', 2),
	   (19757, 1111111, 'sud', 6),
	   (19757, 9154258, 'Ovest', 1);

INSERT INTO Vintonaco (PartitaIVA, CodLotto, ElementoStrutturale, Vano, Spessore, NumStrato) 
VALUES (21436, 6520148, 'nord', 2, 2, 1),
	   (21436, 2222222, 'sud', 3, 2, 1),
       (21436, 6520148, 'nord', 4, 2, 1),
	   (21436, 2222222, 'nord', 3, 2, 1),
       (21436, 6520148, 'nord', 7, 2, 1),
	   (21436, 2222222, 'sud', 8, 2, 1),
       (21436, 6520148, 'nord', 9, 2, 1),
	   (21436, 2222222, 'sud', 10, 2, 1);
           
INSERT INTO vpiastrella (PartitaIVA, CodLotto, ElementoStrutturale, Vano, LarghezzaFuga, MaterialeAdesivo) 
VALUES (14756, 1024578, 'pavimento', 2, 0, 'Stucco'),
	   (14756, 3333333, 'pavimento', 3, 10, 'Stucco'),
       (14756, 1024578, 'pavimento', 8, 1, 'Stucco'),
	   (14756, 3333333, 'pavimento', 9, 10, 'Stucco'),
       (14756, 1024578, 'pavimento', 6, 10, 'Stucco'),
	   (14756, 3333333, 'pavimento', 4, 11, 'Stucco');
        
INSERT INTO Pietra (PartitaIVA, CodLotto, X, Y, Z, PesoMedio, TipoPietra)
VALUES (20001, 4646646, 300, 200, 100, 50, 'Granito'),
	   (20001, 4444444, 300, 200, 200, 80, 'Ardesia');
    
INSERT INTO AsseLegno (PartitaIVA, CodLotto, TipoLegno, Colore)
VALUES (21001, 2817638, 'Salice', 'Marrone'),
	   (21001, 5555555, 'Betulla', 'Marrone');

INSERT INTO MaterialeGenerico (PartitaIVA, CodLotto, X, Y, Z, Costituzione)
VALUES (22001, 2974521, 300, 200, 50, 'Smalto'),
	   (22001, 6666666, 300, 200, 50, 'Ottone');
    
INSERT INTO VPietra (PartitaIVA, CodLotto, ElementoStrutturale, Vano, AreaVisibilePietra, Disposizione, Realizza) 
VALUES (20001, 4646646, 'nord', 12, 100, 'Naturale', 1),
	   (20001, 4444444, 'sud', 3, 100, 'Naturale', 0),
	   (20001, 4646646, 'nord', 11, 80, 'Orizzontale', 1),
       (20001, 4444444, 'est', 13, 10, 'Verticale', 1),
	   (20001, 4646646, 'nord', 13, 15, 'Verticale', 0),
       (20001, 4646646, 'ovest', 12, 100, 'Naturale', 1),
	   (20001, 4444444, 'nord', 3, 100, 'Naturale', 0),
	   (20001, 4646646, 'est', 11, 80, 'Orizzontale', 1),
       (20001, 4444444, 'sud', 13, 10, 'Verticale', 1),
	   (20001, 4646646, 'soffitto', 13, 15, 'Verticale', 1);

INSERT INTO VAsseLegno (PartitaIVA, CodLotto, ElementoStrutturale, Vano, Realizza) 
VALUES (21001, 5555555, 'nord', 12, 0), 
	   (21001, 2817638, 'sud', 13, 1),
       (21001, 5555555, 'nord', 13, 0), 
	   (21001, 2817638, 'soffitto', 1, 1),
       (21001, 5555555, 'nord', 2, 0), 
	   (21001, 2817638, 'sud', 4, 1),
       (21001, 5555555, 'nord', 5, 0), 
	   (21001, 2817638, 'soffitto', 6, 1);
           
INSERT INTO VGenerico (PartitaIVA, CodLotto, ElementoStrutturale, Vano, Realizza) 
VALUES (22001, 2974521, 'pavimento', 11, 1),
	   (22001, 6666666, 'pavimento', 13, 0),
       (22001, 2974521, 'pavimento', 6, 1),
	   (22001, 6666666, 'pavimento', 12, 0),
       (22001, 2974521, 'pavimento', 7, 1),
	   (22001, 6666666, 'pavimento', 9, 0); 
        
INSERT INTO Lavoratore (CodFiscale, Nome, Cognome, Responsabile, PagaOraria) 
VALUES ('BNCLGU80M11G702A', 'Luigi', 'Bianchi', 0, 20),
	   ('LNRFRR80A01G702Z', 'Leonardo', 'Ferrari', 0, 20),
       ('MTTSST80A01G702S', 'Mattia', 'Esposito', 0, 20),
       ('NDRCMB80A01G702W', 'Andrea', 'Colombo', 1, 20),
       ('RCCCNT80A01G702A', 'Ricciardo', 'Conti', 1, 20),
       ('DRDMTA80A01G702B', 'Edoardo', 'Amato', 0, 20),
       ('GSPGLL80A01G702B', 'Giuseppe', 'Galli', 0, 20),
       ('NTNMTN80A01G702Q', 'Antonio', 'Martini', 0, 20),
       ('KVNMRG80M11G702A', 'Kevin', 'Murga', 0, 10),
	   ('LMIJEL80A01G702Z', 'Joel', 'Olmi', 0, 20),
       ('PZZJCP80A01G702S', 'Jacopo', 'Piazza', 0, 20),
       ('VNIMTT80A01G702W', 'Matteo', 'Ivani', 1, 20),
       ('CRCMRZ80A01G702B', 'Maurizio', 'Croce', 0, 20),
       ('SPMMTN80A01G702Q', 'Antonia', 'Spumante', 0, 20),
       ('PRSKVN80M11G702A', 'Kevin', 'Prosecco', 0, 10),
	   ('SLTJEL80A01G702Z', 'Joel', 'Salita', 1, 20),
       ('PZZJCP81A01G002S', 'Jacopo', 'Pizza', 0, 20),
       ('DVNMTT80A01G702W', 'Matteo', 'Divano', 1, 20);
         
INSERT INTO Afferiscono (Lavoratore, Lavoro, Compenso) 
VALUES ('BNCLGU80M11G702A', 1, 10),
	   ('LNRFRR80A01G702Z', 1, 10),
       ('MTTSST80A01G702S', 1, 10),
       ('NDRCMB80A01G702W', 1, 10),
       ('RCCCNT80A01G702A', 2, 8),
       ('DRDMTA80A01G702B', 2, 8),
       ('GSPGLL80A01G702B', 2, 8),
       ('NTNMTN80A01G702Q', 2, 8),
       ('KVNMRG80M11G702A', 4, 0),
	   ('LMIJEL80A01G702Z', 4, 0),
       ('VNIMTT80A01G702W', 6, 10),
       ('PZZJCP80A01G702S', 5, 0),
       ('CRCMRZ80A01G702B', 7, 1),
       ('SPMMTN80A01G702Q', 8, 8),
       ('NTNMTN80A01G702Q', 9, 8),
       ('PRSKVN80M11G702A', 10, 0),
	   ('SLTJEL80A01G702Z', 11, 0),
       ('PZZJCP81A01G002S', 12, 10),
       ('DVNMTT80A01G702W', 11, 1);

INSERT INTO OrariLavoro (Lavoro, Data, OraInizio, OraFine) 
VALUES (1, '2022-10-22', '08:00:00', '16:00:00'),
	   (1, '2022-10-23', '08:00:00', '16:00:00'),
       (1, '2022-10-24', '08:00:00', '16:00:00'),
       (1, '2022-10-25', '08:00:00', '16:00:00'),
       (1, '2022-10-26', '08:00:00', '16:00:00'),
       (1, '2022-11-05', '08:00:00', '16:00:00'),
       (2, '2022-11-05', '08:00:00', '16:00:00'),
       (2, '2022-10-06', '08:00:00', '16:00:00'),
       (2, '2022-10-07', '08:00:00', '16:00:00'),
       (2, '2022-10-08', '08:00:00', '16:00:00'),
       (2, '2022-10-09', '08:00:00', '16:00:00'),
       (2, '2022-10-10', '08:00:00', '16:00:00'),
       (3, '2022-11-11', '08:00:00', '16:00:00'),
       (4, '2022-11-10', '08:00:00', '16:00:00'),
	   (5, '2022-11-11', '08:00:00', '16:00:00'),
       (6, '2022-11-12', '08:00:00', '16:00:00'),
	   (7, '2022-10-09', '08:00:00', '16:00:00'),
       (8, '2022-10-10', '08:00:00', '16:00:00'),
       (9, '2022-11-11', '08:00:00', '16:00:00'),
       (10, '2022-11-10', '08:00:00', '16:00:00'),
	   (11, '2022-11-11', '08:00:00', '16:00:00'),
       (12, '2022-11-12', '08:00:00', '16:00:00');

INSERT INTO PuntoAccesso (IdPuntoAccesso, Altezza, Tipo, Larghezza)
VALUES (1, 2000, 'Porta', 1500),
	   (2, 1000, 'Finestra', 500);
       
INSERT INTO Apertura (Vano, PuntoAccesso, ElementoStrutturale)
VALUES (1, 1, 'nord'),
	   (1, 2, 'sud');
