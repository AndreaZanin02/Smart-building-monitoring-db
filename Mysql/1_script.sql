-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `AreaGeografica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AreaGeografica` ;

CREATE TABLE IF NOT EXISTS `AreaGeografica` (
  `NomeLuogo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`NomeLuogo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Edificio` ;

CREATE TABLE IF NOT EXISTS `Edificio` (
  `IdEdificio` INT NOT NULL AUTO_INCREMENT,
  `Tipologia` VARCHAR(100) NOT NULL,
  `Zona` VARCHAR(10) NOT NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IdEdificio`),
  INDEX `fk_Edificio_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
  CONSTRAINT `fk_Edificio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`NomeLuogo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Piano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Piano` ;

CREATE TABLE IF NOT EXISTS `Piano` (
  `NumPiano` INT NOT NULL,
  `Pianta` VARCHAR(45) NOT NULL,
  `Edificio` INT NOT NULL,
  PRIMARY KEY (`NumPiano`, `Edificio`),
  INDEX `fk_Piano_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Piano_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`IdEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Vano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Vano` ;

CREATE TABLE IF NOT EXISTS `Vano` (
  `IdVano` INT NOT NULL AUTO_INCREMENT,
  `Forma` VARCHAR(45) NOT NULL,
  `LarghezzaMax` DOUBLE NOT NULL,
  `AltezzaMax` DOUBLE NULL,
  `LunghezzaMax` DOUBLE NOT NULL,
  `Piano` INT NOT NULL,
  `Edificio` INT NOT NULL,
  PRIMARY KEY (`IdVano`),
  INDEX `fk_Vano_Piano1_idx` (`Piano` ASC, `Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_Vano_Piano1`
    FOREIGN KEY (`Piano` , `Edificio`)
    REFERENCES `Piano` (`NumPiano` , `Edificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Funzione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Funzione` ;

CREATE TABLE IF NOT EXISTS `Funzione` (
  `Tipologia` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Tipologia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Adibito`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Adibito` ;

CREATE TABLE IF NOT EXISTS `Adibito` (
  `Vano` INT NOT NULL,
  `Funzione` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Vano`, `Funzione`),
  INDEX `fk_Adibito_Funzione1_idx` (`Funzione` ASC) VISIBLE,
  CONSTRAINT `fk_Adibito_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`IdVano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Adibito_Funzione1`
    FOREIGN KEY (`Funzione`)
    REFERENCES `Funzione` (`Tipologia`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PuntoAccesso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PuntoAccesso` ;

CREATE TABLE IF NOT EXISTS `PuntoAccesso` (
  `IdPuntoAccesso` INT NOT NULL AUTO_INCREMENT,
  `Altezza` DOUBLE NOT NULL,
  `Tipo` VARCHAR(100) NOT NULL,
  `Larghezza` DOUBLE NOT NULL,
  PRIMARY KEY (`IdPuntoAccesso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Apertura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Apertura` ;

CREATE TABLE IF NOT EXISTS `Apertura` (
  `Vano` INT NOT NULL,
  `PuntoAccesso` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Vano`, `PuntoAccesso`),
  INDEX `fk_Ingressi_PuntoAccesso1_idx` (`PuntoAccesso` ASC) VISIBLE,
  CONSTRAINT `fk_Ingressi_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`IdVano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Ingressi_PuntoAccesso1`
    FOREIGN KEY (`PuntoAccesso`)
    REFERENCES `PuntoAccesso` (`IdPuntoAccesso`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coefficienti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Coefficienti` ;

CREATE TABLE IF NOT EXISTS `Coefficienti` (
  `TipoRischio` VARCHAR(100) NOT NULL,
  `Data` TIMESTAMP NOT NULL,
  `Valore` DOUBLE NOT NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`TipoRischio`, `Data`, `AreaGeografica`),
  INDEX `fk_Coefficienti_AreaGeografica_idx` (`AreaGeografica` ASC) VISIBLE,
  CONSTRAINT `AreaGeografica`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`NomeLuogo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EventoCalamitoso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EventoCalamitoso` ;

CREATE TABLE IF NOT EXISTS `EventoCalamitoso` (
  `Tipo` VARCHAR(100) NOT NULL,
  `DataAccadimento` TIMESTAMP NOT NULL,
  `Latitudine` DECIMAL(8,6) NOT NULL,
  `Longitudine` DECIMAL(9,6) NOT NULL,
  `AreaGeografica` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`DataAccadimento`, `AreaGeografica`, `Tipo`),
  INDEX `fk_EventoCalamitoso_AreaGeografica1_idx` (`AreaGeografica` ASC) VISIBLE,
  CONSTRAINT `fk_EventoCalamitoso_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica`)
    REFERENCES `AreaGeografica` (`NomeLuogo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ProgettoEdilizio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ProgettoEdilizio` ;

CREATE TABLE IF NOT EXISTS `ProgettoEdilizio` (
  `IdProgetto` INT NOT NULL AUTO_INCREMENT,
  `Esiste` TINYINT(1) NOT NULL,
  `CostoMateriali` DOUBLE NOT NULL DEFAULT 0,
  `DataInizio` DATE NOT NULL,
  `StimaDataFine` DATE NOT NULL,
  `DataApprovazione` DATE NOT NULL,
  `DataPresentazione` DATE NOT NULL,
  `DataFine` DATE NULL,
  `Edificio` INT NOT NULL,
  PRIMARY KEY (`IdProgetto`),
  INDEX `fk_ProgettoEdilizio_Edificio1_idx` (`Edificio` ASC) VISIBLE,
  CONSTRAINT `fk_ProgettoEdilizio_Edificio1`
    FOREIGN KEY (`Edificio`)
    REFERENCES `Edificio` (`IdEdificio`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StadioAvanzamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `StadioAvanzamento` ;

CREATE TABLE IF NOT EXISTS `StadioAvanzamento` (
  `IdFase` INT NOT NULL AUTO_INCREMENT,
  `DataCompletamento` DATE NULL,
  `DataInizio` DATE NOT NULL,
  `StimaDataFine` DATE NOT NULL,
  `ProgettoEdilizio` INT NOT NULL,
  PRIMARY KEY (`IdFase`),
  INDEX `fk_StadioAvanzamento_ProgettoEdilizio1_idx` (`ProgettoEdilizio` ASC) VISIBLE,
  CONSTRAINT `fk_StadioAvanzamento_ProgettoEdilizio1`
    FOREIGN KEY (`ProgettoEdilizio`)
    REFERENCES `ProgettoEdilizio` (`IdProgetto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CapoCantiere`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CapoCantiere` ;

CREATE TABLE IF NOT EXISTS `CapoCantiere` (
  `CodFiscale` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `PagaOraria` INT NOT NULL,
  `MaxOperai` INT NOT NULL,
  PRIMARY KEY (`CodFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lavoro` ;

CREATE TABLE IF NOT EXISTS `Lavoro` (
  `IdLavoro` INT NOT NULL AUTO_INCREMENT,
  `Tipologia` VARCHAR(100) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `DataFine` DATE NULL,
  `StadioAvanzamento` INT NOT NULL,
  `CapoCantiere` VARCHAR(16) NOT NULL,
  `Costo` DOUBLE NOT NULL DEFAULT 0,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`IdLavoro`),
  INDEX `fk_Lavoro_StadioAvanzamento1_idx` (`StadioAvanzamento` ASC) VISIBLE,
  INDEX `fk_Lavoro_CapoCantiere1_idx` (`CapoCantiere` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoro_StadioAvanzamento1`
    FOREIGN KEY (`StadioAvanzamento`)
    REFERENCES `StadioAvanzamento` (`IdFase`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Lavoro_CapoCantiere1`
    FOREIGN KEY (`CapoCantiere`)
    REFERENCES `CapoCantiere` (`CodFiscale`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Materiale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Materiale` ;

CREATE TABLE IF NOT EXISTS `Materiale` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `DataAcquisto` DATE NOT NULL,
  `TipoCosto` VARCHAR(45) NOT NULL,
  `QuantitaComprata` DOUBLE NOT NULL,
  `QuantitaRimasta` DOUBLE NOT NULL,
  `CostoUnitario` DOUBLE NOT NULL,
  `TipoMateriale` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Utilizzo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Utilizzo` ;

CREATE TABLE IF NOT EXISTS `Utilizzo` (
  `Lavoro` INT NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `QuantitaUsata` DOUBLE NOT NULL,
  PRIMARY KEY (`Lavoro`, `PartitaIVA`, `CodLotto`),
  INDEX `fk_Lavoro_has_Materiale_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  INDEX `fk_Lavoro_has_Materiale_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoro_has_Materiale_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`IdLavoro`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Lavoro_has_Materiale_Materiale1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MaterialeGenerico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MaterialeGenerico` ;

CREATE TABLE IF NOT EXISTS `MaterialeGenerico` (
  `Costituzione` VARCHAR(100) NOT NULL,
  `X` DOUBLE NOT NULL,
  `Y` DOUBLE NOT NULL,
  `Z` DOUBLE NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AsseLegno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AsseLegno` ;

CREATE TABLE IF NOT EXISTS `AsseLegno` (
  `TipoLegno` VARCHAR(100) NOT NULL,
  `Colore` VARCHAR(45) NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale10`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pietra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Pietra` ;

CREATE TABLE IF NOT EXISTS `Pietra` (
  `TipoPietra` VARCHAR(100) NOT NULL,
  `PesoMedio` DOUBLE NOT NULL,
  `X` DOUBLE NOT NULL,
  `Y` DOUBLE NOT NULL,
  `Z` DOUBLE NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale11`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Piastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Piastrella` ;

CREATE TABLE IF NOT EXISTS `Piastrella` (
  `Tipo` VARCHAR(100) NOT NULL,
  `DimensioneLato` DOUBLE NOT NULL,
  `Forma` VARCHAR(100) NOT NULL,
  `Disegno` VARCHAR(100) NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale110`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Intonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Intonaco` ;

CREATE TABLE IF NOT EXISTS `Intonaco` (
  `Tipo` VARCHAR(100) NOT NULL,
  `Colore` VARCHAR(45) NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale100`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mattone` ;

CREATE TABLE IF NOT EXISTS `Mattone` (
  `Forma` VARCHAR(100) NOT NULL,
  `X` DOUBLE NOT NULL,
  `Y` DOUBLE NOT NULL,
  `Z` DOUBLE NOT NULL,
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `Tipo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`),
  INDEX `fk_MaterialeGenerico_Materiale1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_Materiale111`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Materiale` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Alveolatura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Alveolatura` ;

CREATE TABLE IF NOT EXISTS `Alveolatura` (
  `MaterialeIsolante` VARCHAR(100) NOT NULL,
  `Forma` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MaterialeIsolante`, `Forma`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Caratterizzato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Caratterizzato` ;

CREATE TABLE IF NOT EXISTS `Caratterizzato` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `MaterialeIsolante` VARCHAR(100) NOT NULL,
  `FormaAlveolatura` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CodLotto`, `MaterialeIsolante`, `FormaAlveolatura`, `PartitaIVA`),
  INDEX `fk_Mattone_has_Alveolatura_Alveolatura1_idx` (`MaterialeIsolante` ASC, `FormaAlveolatura` ASC) VISIBLE,
  INDEX `fk_Mattone_has_Alveolatura_Mattone1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_Mattone_has_Alveolatura_Mattone1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Mattone` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Mattone_has_Alveolatura_Alveolatura1`
    FOREIGN KEY (`MaterialeIsolante` , `FormaAlveolatura`)
    REFERENCES `Alveolatura` (`MaterialeIsolante` , `Forma`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Parete`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parete` ;

CREATE TABLE IF NOT EXISTS `Parete` (
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`ElementoStrutturale`, `Vano`),
  INDEX `fk_Parete_Vano1_idx` (`Vano` ASC) VISIBLE,
  CONSTRAINT `fk_Parete_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`IdVano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VGenerico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VGenerico` ;

CREATE TABLE IF NOT EXISTS `VGenerico` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  `Realizza` TINYINT(1) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_MaterialeGenerico_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_MaterialeGenerico_has_Parete_MaterialeGenerico1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialeGenerico_has_Parete_MaterialeGenerico1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `MaterialeGenerico` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_MaterialeGenerico_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VAsseLegno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VAsseLegno` ;

CREATE TABLE IF NOT EXISTS `VAsseLegno` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  `Realizza` TINYINT(1) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_AsseLegno_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_AsseLegno_has_Parete_AsseLegno1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_AsseLegno_has_Parete_AsseLegno1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `AsseLegno` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_AsseLegno_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VPietra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VPietra` ;

CREATE TABLE IF NOT EXISTS `VPietra` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  `AreaVisibilePietra` DOUBLE NOT NULL,
  `Disposizione` VARCHAR(100) NOT NULL,
  `Realizza` TINYINT(1) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_Pietra_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_Pietra_has_Parete_Pietra1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_Pietra_has_Parete_Pietra1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Pietra` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pietra_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VPiastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VPiastrella` ;

CREATE TABLE IF NOT EXISTS `VPiastrella` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  `LarghezzaFuga` DOUBLE NOT NULL,
  `MaterialeAdesivo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_Piastrella_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_Piastrella_has_Parete_Piastrella1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_Piastrella_has_Parete_Piastrella1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Piastrella` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Piastrella_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VIntonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VIntonaco` ;

CREATE TABLE IF NOT EXISTS `VIntonaco` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  `Spessore` DOUBLE NOT NULL,
  `NumStrato` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_Intonaco_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_Intonaco_has_Parete_Intonaco1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_Intonaco_has_Parete_Intonaco1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Intonaco` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Intonaco_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VMattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VMattone` ;

CREATE TABLE IF NOT EXISTS `VMattone` (
  `PartitaIVA` INT NOT NULL,
  `CodLotto` INT NOT NULL,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`PartitaIVA`, `CodLotto`, `ElementoStrutturale`, `Vano`),
  INDEX `fk_Mattone_has_Parete_Parete1_idx` (`ElementoStrutturale` ASC, `Vano` ASC) VISIBLE,
  INDEX `fk_Mattone_has_Parete_Mattone1_idx` (`PartitaIVA` ASC, `CodLotto` ASC) VISIBLE,
  CONSTRAINT `fk_Mattone_has_Parete_Mattone1`
    FOREIGN KEY (`PartitaIVA` , `CodLotto`)
    REFERENCES `Mattone` (`PartitaIVA` , `CodLotto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Mattone_has_Parete_Parete1`
    FOREIGN KEY (`ElementoStrutturale` , `Vano`)
    REFERENCES `Parete` (`ElementoStrutturale` , `Vano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sensore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sensore` ;

CREATE TABLE IF NOT EXISTS `Sensore` (
  `IdSensore` INT NOT NULL AUTO_INCREMENT,
  `ElementoStrutturale` VARCHAR(10) NOT NULL,
  `TipoSensore` VARCHAR(100) NOT NULL,
  `SogliaSicurezza` DOUBLE NOT NULL,
  `Vano` INT NOT NULL,
  PRIMARY KEY (`IdSensore`),
  INDEX `fk_Sensore_Vano1_idx` (`Vano` ASC) VISIBLE,
  CONSTRAINT `fk_Sensore_Vano1`
    FOREIGN KEY (`Vano`)
    REFERENCES `Vano` (`IdVano`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Misure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Misure` ;

CREATE TABLE IF NOT EXISTS `Misure` (
  `Timestamp` TIMESTAMP NOT NULL,
  `AsseX` DOUBLE NOT NULL,
  `AsseY` DOUBLE NOT NULL,
  `AsseZ` DOUBLE NOT NULL,
  `Sensore` INT NOT NULL,
  PRIMARY KEY (`Timestamp`, `Sensore`),
  INDEX `fk_Misure_Sensore1_idx` (`Sensore` ASC) VISIBLE,
  CONSTRAINT `fk_Misure_Sensore1`
    FOREIGN KEY (`Sensore`)
    REFERENCES `Sensore` (`IdSensore`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ElencoAlert`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ElencoAlert` ;

CREATE TABLE IF NOT EXISTS `ElencoAlert` (
  `Timestamp` TIMESTAMP NOT NULL,
  `Sensore` INT NOT NULL,
  PRIMARY KEY (`Timestamp`, `Sensore`),
  CONSTRAINT `fk_ElencoAlert_Misure1`
    FOREIGN KEY (`Timestamp` , `Sensore`)
    REFERENCES `Misure` (`Timestamp` , `Sensore`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Lavoratore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Lavoratore` ;

CREATE TABLE IF NOT EXISTS `Lavoratore` (
  `CodFiscale` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Responsabile` TINYINT(1) NOT NULL,
  `PagaOraria` INT NOT NULL,
  PRIMARY KEY (`CodFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Afferiscono`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Afferiscono` ;

CREATE TABLE IF NOT EXISTS `Afferiscono` (
  `Lavoratore` VARCHAR(16) NOT NULL,
  `Lavoro` INT NOT NULL,
  `Compenso` INT NOT NULL,
  PRIMARY KEY (`Lavoratore`, `Lavoro`),
  INDEX `fk_Lavoratore_has_Lavoro_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
  INDEX `fk_Lavoratore_has_Lavoro_Lavoratore1_idx` (`Lavoratore` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoratore_has_Lavoro_Lavoratore1`
    FOREIGN KEY (`Lavoratore`)
    REFERENCES `Lavoratore` (`CodFiscale`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Lavoratore_has_Lavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`IdLavoro`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `OrariLavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OrariLavoro` ;

CREATE TABLE IF NOT EXISTS `OrariLavoro` (
  `Data` DATE NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NOT NULL,
  `Lavoro` INT NOT NULL,
  PRIMARY KEY (`Data`, `Lavoro`),
  INDEX `fk_OrariLavoro_Lavoro1_idx` (`Lavoro` ASC) VISIBLE,
  CONSTRAINT `fk_OrariLavoro_Lavoro1`
    FOREIGN KEY (`Lavoro`)
    REFERENCES `Lavoro` (`IdLavoro`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `mydb`;

DELIMITER $$

USE `mydb`$$
DROP TRIGGER IF EXISTS `Edificio_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Edificio_BEFORE_INSERT` BEFORE INSERT ON `Edificio` FOR EACH ROW
BEGIN
	IF NEW.Zona NOT IN ('nord','sud','est','ovest','nord-ovest','nord-est','sud-est','sud-ovest')
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: coordinata della zona errata. Scegliere fra (nord, sud, est, ovest, nord-ovest, nord-est, sud-est, sud-ovest )";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Piano_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Piano_BEFORE_INSERT` BEFORE INSERT ON `Piano` FOR EACH ROW
BEGIN
	IF NEW.NumPiano > 0 AND NOT EXISTS (
						SELECT *
                        FROM Piano p
                        WHERE NEW.Edificio = p.Edificio
								AND p.NumPiano = NEW.NumPiano-1
					)
	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='Errore: non si può inserire il piano senza che ci sia il piano sottostante.';
    END IF;
    IF NEW.NumPiano < 0 AND NOT EXISTS (
										select 1 
                                        from Piano 
                                        where Edificio = new.Edificio 
											and NumPiano = new.NumPiano+1)
	THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Errore: Non puoi inserire il piano sotterraneo senza che ci sia il piano superiore.";
	END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Vano_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Vano_BEFORE_INSERT` BEFORE INSERT ON `Vano` FOR EACH ROW
BEGIN
	IF NEW.LarghezzaMax <= 0 OR NEW.AltezzaMax <= 0 OR NEW.LunghezzaMax <= 0 THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire misure minore o uguali a 0.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `PuntoAccesso_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`PuntoAccesso_BEFORE_INSERT` BEFORE INSERT ON `PuntoAccesso` FOR EACH ROW
BEGIN
	IF NEW.Altezza <= 0 OR NEW.Larghezza <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire una misura minore o uguale a 0.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Apertura_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Apertura_BEFORE_INSERT` BEFORE INSERT ON `Apertura` FOR EACH ROW
BEGIN
	IF NEW.ElementoStrutturale NOT IN ('nord','sud','est','ovest','nord-ovest','nord-est','sud-est','sud-ovest', 'pavimento', 'soffitto')
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: coordinata del muro errata. Scegliere fra (nord, sud, est, ovest, nord-ovest, nord-est, sud-est, sud-ovest, pavimento, soffitto)";
    END IF;
    
    IF (
			SELECT PA.Tipo
            FROM PuntoAccesso PA
            WHERE PA.IdPuntoAccesso = NEW.PuntoAccesso
		) = 'finestra' AND EXISTS (
										SELECT 1
                                        FROM Apertura I
                                        WHERE I.PuntoAccesso = NEW.PuntoAccesso
									)
		THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: non puoi inserire due volte la stessa finestra.';
        END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `ProgettoEdilizio_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`ProgettoEdilizio_BEFORE_INSERT` BEFORE INSERT ON `ProgettoEdilizio` FOR EACH ROW
BEGIN
	IF NEW.StimaDataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: StimaDataFIne non puo' essere minore di DataInizio";
    END IF;
    
    IF NEW.DataApprovazione < NEW.DataPresentazione THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: DataApprovazione non puo' essere minore di DataPresentazione";
    END IF;
    
    IF NEW.DataFine IS NOT NULL AND NEW.DataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataFine non e' null, DataFine non puo' essere minore di DataInizio";
    END IF;
    
    IF NEW.DataApprovazione > NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: DataApprovazione non puo' essere maggiore di DataInizio";
    END IF;
    
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `ProgettoEdilizio_BEFORE_UPDATE` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`ProgettoEdilizio_BEFORE_UPDATE` BEFORE UPDATE ON `ProgettoEdilizio` FOR EACH ROW
BEGIN
	IF NEW.DataFine IS NOT NULL AND NEW.DataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataFine non e' null, DataFine non puo' essere minore di DataInizio";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `StadioAvanzamento_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`StadioAvanzamento_BEFORE_INSERT` BEFORE INSERT ON `StadioAvanzamento` FOR EACH ROW
BEGIN
	IF NEW.StimaDataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: StimaDataFine non può essere minore di DataInizio";
    END IF;
    
    IF NEW.DataCompletamento IS NOT NULL AND NEW.DataCompletamento < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataCompletamento non e' null, DataCompletamento non può essere minore di DataInizio";
    END IF;
    
    IF (SELECT PE.DataInizio
		FROM ProgettoEdilizio PE
        WHERE PE.IdProgetto = NEW.ProgettoEdilizio) > NEW.DataInizio THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: La data di inizio non può essere minore della data di inizio del relativo progetto edilizio.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `StadioAvanzamento_BEFORE_UPDATE` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`StadioAvanzamento_BEFORE_UPDATE` BEFORE UPDATE ON `StadioAvanzamento` FOR EACH ROW
BEGIN
	IF NEW.DataCompletamento IS NOT NULL AND NEW.DataCompletamento < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataCompletamento non e' null, DataCompletamento non può essere minore di DataInizio";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `CapoCantiere_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`CapoCantiere_BEFORE_INSERT` BEFORE INSERT ON `CapoCantiere` FOR EACH ROW
BEGIN
	IF NEW.PagaOraria < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: la paga oraria non può essere negativa";
    END IF;
    
    IF NEW.MaxOperai < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: il numero di operai massimi non può essere negativo";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Lavoro_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Lavoro_BEFORE_INSERT` BEFORE INSERT ON `Lavoro` FOR EACH ROW
BEGIN
	IF NEW.DataFine IS NOT NULL AND NEW.DataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataFine non e' null, DataFine non puo' essere minore di DataInizio";
    END IF;
    
    IF (SELECT SA.DataInizio
		FROM StadioAvanzamento SA
        WHERE NEW.StadioAvanzamento = SA.IdFase) > NEW.DataInizio THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: La data di inizio non può essere minore della data di inizio del relativo stadio di avanzamento.';
    END IF;
    
    IF NOT EXISTS (
					SELECT 1
                    FROM Vano V
                    WHERE V.IdVano = NEW.Vano
				   ) THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Non può essere inserito un lavoro che è associato a un vano che non è presente nella base di dati.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Lavoro_BEFORE_UPDATE` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Lavoro_BEFORE_UPDATE` BEFORE UPDATE ON `Lavoro` FOR EACH ROW
BEGIN
	IF NEW.DataFine IS NOT NULL AND NEW.DataFine < NEW.DataInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: Visto che DataFine non e' null, DataFine non puo' essere minore di DataInizio";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Materiale_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Materiale_BEFORE_INSERT` BEFORE INSERT ON `Materiale` FOR EACH ROW
BEGIN
	IF NEW.TipoCosto NOT IN ('chilogrammo', 'metro-quadrato') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: il tipo costo è errato. I valori possibili sono: chilogrammo o metro-quadrato.";
    END IF;
    
    IF NEW.QuantitaComprata <= 0 OR NEW.CostoUnitario < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per la quantia comprata o per il costo unitario';
    END IF;
    
    SET NEW.QuantitaRimasta = NEW.QuantitaComprata;
    
    IF NEW.TipoMateriale NOT IN ('Materiale Generico', 'Asse di Legno', 'Pietra', 'Piastrella', 'Intonaco', 'Mattone') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il tipo materiale può essere: Materiale Generico, Asse di Legno, Pietra, Piastrella, Intonaco, Mattone.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Utilizzo_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Utilizzo_AFTER_INSERT` AFTER INSERT ON `Utilizzo` FOR EACH ROW
BEGIN
	DECLARE costo DOUBLE DEFAULT 0;
    DECLARE progetto INT DEFAULT 0;
	UPDATE Materiale M
    SET QuantitaRimasta = QuantitaRimasta - NEW.QuantitaUsata
	WHERE M.PartitaIVA = NEW.PartitaIVA
		AND M.CodLotto = NEW.CodLotto;	
        
	SET costo = (
					SELECT M.CostoUnitario
                    FROM Materiale M
					WHERE M.PartitaIVA = NEW.PartitaIVA
						AND M.CodLotto = NEW.CodLotto
				);
                
	SET progetto = (
						SELECT S.ProgettoEdilizio
                        FROM Utilizzo U
							 INNER JOIN
                             Lavoro L ON U.Lavoro = L.IdLavoro
                             INNER JOIN
                             StadioAvanzamento S ON L.StadioAvanzamento = S.IdFase
						WHERE U.PartitaIVA = NEW.PartitaIVA
							AND U.CodLotto = NEW.CodLotto
                            AND L.IdLavoro = NEW.Lavoro
					);
                    
	UPDATE ProgettoEdilizio PE
    SET PE.CostoMateriali = PE.CostoMateriali + (costo * NEW.QuantitaUsata)
    WHERE PE.IdProgetto = progetto;
    
    UPDATE Lavoro L
    SET L.Costo = L.Costo + (costo * NEW.QuantitaUsata)
    WHERE L.IdLavoro = NEW.Lavoro;   
    
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Utilizzo_BEFORE_UPDATE` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Utilizzo_BEFORE_UPDATE` BEFORE UPDATE ON `Utilizzo` FOR EACH ROW
BEGIN
	IF NEW.QuantitaUsata > (
								SELECT QuantitaRimasta
                                FROM Materiale M
                                WHERE M.PartitaIVA = NEW.PartitaIVA 
										AND M.CodLotto = NEW.CodLotto
							)
	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: La quantita' usata e' minore della quantita' rimasta. Comprare nuovi lotti del materiale.";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Utilizzo_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Utilizzo_BEFORE_INSERT` BEFORE INSERT ON `Utilizzo` FOR EACH ROW
BEGIN
	IF NEW.QuantitaUsata <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per la quantita usata.';
    END IF;
	
	IF NEW.QuantitaUsata > (
								SELECT QuantitaRimasta
                                FROM Materiale M
                                WHERE M.PartitaIVA = NEW.PartitaIVA 
										AND M.CodLotto = NEW.CodLotto
							)
	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: La quantita' usata e' minore della quantita' rimasta. Comprare nuovi lotti del materiale.";
    END IF;
    
    
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `MaterialeGenerico_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`MaterialeGenerico_BEFORE_INSERT` BEFORE INSERT ON `MaterialeGenerico` FOR EACH ROW
BEGIN
	IF NEW.X <= 0 OR NEW.Y <= 0 OR NEW.Z <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire valori negativi per la X o la Y o la Z.';
    END IF;
    
    IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Materiale Generico') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `AsseLegno_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`AsseLegno_BEFORE_INSERT` BEFORE INSERT ON `AsseLegno` FOR EACH ROW
BEGIN
	IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Asse di Legno') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Pietra_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Pietra_BEFORE_INSERT` BEFORE INSERT ON `Pietra` FOR EACH ROW
BEGIN
	IF NEW.X <= 0 OR NEW.Y <= 0 OR NEW.Z <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire valori negativi per la X o la Y o la Z.';
    END IF;
    
    IF NEW.PesoMedio <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per il peso medio.';
    END IF;
    
    IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Pietra') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Piastrella_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Piastrella_BEFORE_INSERT` BEFORE INSERT ON `Piastrella` FOR EACH ROW
BEGIN
	IF NEW.DimensioneLato <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per la dimensione del lato.';
    END IF;
    
    IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Piastrella') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Intonaco_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Intonaco_BEFORE_INSERT` BEFORE INSERT ON `Intonaco` FOR EACH ROW
BEGIN
	IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Intonaco') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Mattone_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Mattone_BEFORE_INSERT` BEFORE INSERT ON `Mattone` FOR EACH ROW
BEGIN
	IF NEW.X <= 0 OR NEW.Y <= 0 OR NEW.Z <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire valori negativi per la X o la Y o la Z.';
    END IF;
    
    IF (SELECT M.TipoMateriale
		FROM Materiale M
		WHERE M.PartitaIVA = NEW.PartitaIVA
			AND M.CodLotto = NEW.CodLotto
		) NOT IN ('Mattone') THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: Il materiale inserito non fa parte di questa tipologia.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Parete_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Parete_BEFORE_INSERT` BEFORE INSERT ON `Parete` FOR EACH ROW
BEGIN
	IF NEW.ElementoStrutturale NOT IN ('nord','sud','est','ovest','nord-ovest','nord-est','sud-est','sud-ovest', 'pavimento', 'soffitto')
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: elemento strutturale errato. Scegliere fra (nord, sud, est, ovest, nord-ovest, nord-est, sud-est, sud-ovest, pavimento, soffitto)";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `VPietra_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`VPietra_BEFORE_INSERT` BEFORE INSERT ON `VPietra` FOR EACH ROW
BEGIN
	IF NEW.AreaVisibilePietra < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per area visibile della pietra.';
    END IF;
    
    IF NEW.Disposizione NOT IN ('orizzontale','verticale', 'naturale') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per area visibile della pietra.';
    END IF;
    
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `VPiastrella_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`VPiastrella_BEFORE_INSERT` BEFORE INSERT ON `VPiastrella` FOR EACH ROW
BEGIN
	IF NEW.LarghezzaFuga < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per la larghezza della fuga.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `VIntonaco_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`VIntonaco_BEFORE_INSERT` BEFORE INSERT ON `VIntonaco` FOR EACH ROW
BEGIN
	IF NEW.NumStrato > 1 AND NOT EXISTS (
											SELECT 1
                                            FROM VIntonaco I
                                            WHERE I.Vano = NEW.Vano
													AND I.ElementoStrutturale = NEW.ElementoStrutturale
                                                    AND I.PartitaIVA = NEW.PartitaIVA
                                                    AND I.CodLotto = NEW.CodLotto
                                                    AND I.NumStrato = NEW.NumStrato - 1
										)
	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: non puo' essere inserito uno strato x > 1 se non è presente lo stato x-1.";
    END IF;
    
    IF NEW.Spessore <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Errore: non puoi inserire un valore negativo per lo spessore.';
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Sensore_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Sensore_BEFORE_INSERT` BEFORE INSERT ON `Sensore` FOR EACH ROW
BEGIN
	IF NEW.ElementoStrutturale NOT IN ('nord','sud','est','ovest','nord-ovest','nord-est','sud-est','sud-ovest', 'pavimento', 'soffitto')
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: elemento strutturale errato. Scegliere fra (nord, sud, est, ovest, nord-ovest, nord-est, sud-est, sud-ovest, pavimento, soffitto)";
    END IF;
    
    IF NEW.TipoSensore NOT IN ("SensorePosizione", "SensoreTemperatura", "SensoreUmidita", "Giroscopio", "SensorePioggia", "Accelerometro")
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: il tipo sensore deve essere uno fra questi: SensorePosizione, SensoreTemperatura, SensoreUmidita, Giroscopio, SensorePioggia, Accelerometro";
    END IF;
    
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Misure_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Misure_AFTER_INSERT` AFTER INSERT ON `Misure` FOR EACH ROW
BEGIN
	SET @tipo = (SELECT S.TipoSensore
				 FROM Sensore S
				 WHERE NEW.Sensore = S.IdSensore);
	SET @soglia = (SELECT S.SogliaSicurezza
				 FROM Sensore S
				 WHERE NEW.Sensore = S.IdSensore);
	IF (@tipo = 'SensorePosizione' OR @tipo = 'SensorePioggia') AND NEW.AsseX > @soglia THEN
    INSERT INTO ElencoAlert (Sensore, Timestamp)
    VALUES (NEW.Sensore, NEW.Timestamp);
    END IF;
    
    IF (@tipo = 'SensoreTemperatura' OR @tipo = 'SensoreUmidita') AND (NEW.AsseX > @soglia OR NEW.AsseY > @soglia) THEN
    INSERT INTO ElencoAlert (Sensore, Timestamp)
    VALUES (NEW.Sensore, NEW.Timestamp);
    END IF;
    
    IF (@tipo = 'Giroscopio' OR @tipo = 'Accelerometro') AND (NEW.AsseX + NEW.AsseY + NEW.AsseZ)/3 > @soglia THEN
    INSERT INTO ElencoAlert (Sensore, Timestamp)
    VALUES (NEW.Sensore, NEW.Timestamp);
    END IF;
             
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Lavoratore_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Lavoratore_BEFORE_INSERT` BEFORE INSERT ON `Lavoratore` FOR EACH ROW
BEGIN
	IF NEW.PagaOraria < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: la PagaOraria non puo' essere negativa.";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `Afferiscono_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Afferiscono_BEFORE_INSERT` BEFORE INSERT ON `Afferiscono` FOR EACH ROW
BEGIN
	IF NEW.Compenso < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: il valore di Compenso non puo' essere negativo";
    END IF;
    
    IF EXISTS (
				SELECT 1
                FROM Afferiscono A
					 INNER JOIN
                     Lavoro L ON A.Lavoro = L.IdLavoro
				WHERE L.DataFine IS NULL
						AND NEW.Lavoratore = A.Lavoratore
				)
                AND (
						SELECT DISTINCT L.Vano  
						FROM Afferiscono A
							INNER JOIN
							Lavoro L ON A.Lavoro = L.IdLavoro
						WHERE L.DataFine IS NULL
							AND NEW.Lavoratore = A.Lavoratore
							 
					) <> (
							SELECT L.Vano
                            FROM Lavoro L
                            WHERE L.IdLavoro = NEW.Lavoro
						)
	THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = "Errore: un lavoratore non può partecipare contemporaneamente a lavori che riguardano vani diversi.";
	END IF;
        
	IF (
			SELECT COUNT(DISTINCT A.Lavoratore) + 1
			FROM Lavoro L
				INNER JOIN
				Afferiscono A ON L.IdLavoro = A.Lavoro
			WHERE L.DataFine IS NULL
				AND L.CapoCantiere IN (
										SELECT C.CodFiscale
                                           FROM CapoCantiere C
											 INNER JOIN
                                                Lavoro L1 ON C.CodFiscale = L1.CapoCantiere
										WHERE NEW.Lavoro = L1.IdLavoro
									)
		)
        >
        (
			SELECT C.MaxOperai
			FROM CapoCantiere C
				 INNER JOIN
				 Lavoro L ON C.CodFiscale = L.CapoCantiere
			WHERE NEW.Lavoro = L.IdLavoro
         )
	THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: non può essere superato il numero massimo di lavoratori che un capocantiere può controllare.";
    END IF;
    
	IF (
		SELECT COUNT(DISTINCT A.Lavoratore) + 1
		FROM Afferiscono A
		WHERE NEW.Lavoro = A.Lavoro
	) > 10
	THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = "Errore: superato il numero massimo di lavoratori.";
	END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `OrariLavoro_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`OrariLavoro_BEFORE_INSERT` BEFORE INSERT ON `OrariLavoro` FOR EACH ROW
BEGIN
	IF NEW.OraFine < NEW.OraInizio THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "Errore: OraFine non puo' essere minore di OraInizio.";
    END IF;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `OrariLavoro_AFTER_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`OrariLavoro_AFTER_INSERT` AFTER INSERT ON `OrariLavoro` FOR EACH ROW
BEGIN
	UPDATE Lavoro L2
    SET L2.Costo = L2.Costo + (
						SELECT IF(SUM(L.PagaOraria + IF(Responsabile = 1, A.Compenso, 0)) * (SELECT HOUR(TIMEDIFF(OL.OraFine, OL.OraInizio))
																		  FROM OrariLavoro OL
                                                                          WHERE OL.Lavoro = NEW.Lavoro
																			AND OL.Data = NEW.Data
																		  ) IS NULL, 0, SUM(L.PagaOraria + IF(Responsabile = 1, A.Compenso, 0)) * (SELECT HOUR(TIMEDIFF(OL.OraFine, OL.OraInizio))
																		  FROM OrariLavoro OL
                                                                          WHERE OL.Lavoro = NEW.Lavoro
																			AND OL.Data = NEW.Data
																		  )) AS Costo1
						FROM Afferiscono A
							INNER JOIN
							Lavoratore L ON A.Lavoratore = L.CodFiscale
						WHERE A.Lavoro = NEW.Lavoro
				  )
                  +
                  (
					SELECT CC.PagaOraria * (SELECT HOUR(TIMEDIFF(OL.OraFine, OL.OraInizio))
													FROM OrariLavoro OL
													WHERE OL.Lavoro = NEW.Lavoro
														AND OL.Data = NEW.Data
													) AS Costo2
						   FROM CapoCantiere CC 
								INNER JOIN 
                                (SELECT *
                                 FROM Lavoro) AS L ON CC.CodFiscale = L.CapoCantiere
							WHERE L.IdLavoro = NEW.Lavoro
                  )
    WHERE L2.IdLavoro = NEW.Lavoro;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
