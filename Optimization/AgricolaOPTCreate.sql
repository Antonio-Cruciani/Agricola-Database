-- ----------------------------------
-- Autore: Antonio Cruciani
-- Nome File:
-- Note: Creazione del DB e delle tabelle
-- ----------------------------------


-- ----------------------------------
-- Creazione Database
-- ----------------------------------

DROP DATABASE IF EXISTS AgricolaOPT;
CREATE DATABASE AgricolaOPT DEFAULT CHARACTER SET utf8;

USE AgricolaOPT; 

-- -----------------------------------------------
-- Creazione della tabella Dipendente
-- -----------------------------------------------
-- #ATTENZIONE_1: Il campo matricola è un campo formato solamente da interi 

CREATE TABLE Dipendente (
	matricola SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
	nome CHAR(19) NOT NULL,
	cognome CHAR(22) NOT NULL,
    anno_nascita DATE NOT NULL,
    n_patente CHAR(22),
	n_tel CHAR(18) NOT NULL,
	cf CHAR(17) NOT NULL,
	stipendio_annuale FLOAT NOT NULL,
	PRIMARY KEY (matricola)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Agronomo
-- -----------------------------------------------

CREATE TABLE Agronomo (
		id_agronomo SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
        mat_dip SMALLINT(4) UNSIGNED NOT NULL,
        PRIMARY KEY (id_agronomo),
        FOREIGN KEY (mat_dip) REFERENCES Dipendente (matricola)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Contadino
-- -----------------------------------------------

CREATE TABLE Contadino (
		id_contadino SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
        mat_dip SMALLINT(4) UNSIGNED NOT NULL,
        PRIMARY KEY (id_contadino),
        FOREIGN KEY (mat_dip) REFERENCES Dipendente (matricola)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Enologo
-- -----------------------------------------------

CREATE TABLE Enologo (
		id_enologo SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
		mat_dip SMALLINT(4) UNSIGNED NOT NULL,
        
        PRIMARY KEY (id_enologo),
        FOREIGN KEY (mat_dip) REFERENCES Dipendente (matricola)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Città
-- -----------------------------------------------

CREATE TABLE Citta(
	id_citta SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
	cap CHAR(19) NOT NULL,
    provincia varchar(200) NOT NULL,
    nome CHAR (27) NOT NULL,
	PRIMARY KEY (id_citta)	
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Tipo_di_Animale
-- -----------------------------------------------
CREATE TABLE Tipo_di_Allevamento (
		id_tipo TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
        nome varchar(200) NOT NULL,
        descrizione VARCHAR(200) NOT NULL,
        prezzo FLOAT(53) NOT NULL,
        PRIMARY KEY (id_tipo)
)
ENGINE = InnoDB;

-- -----------------------------------------------
-- Creazione della tabella Terreno
-- -----------------------------------------------
-- #ATTENZIONE_1: Il campo dimensione è espresso in ettari ed è un float

CREATE TABLE Terreno(
	id_terreno MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
	dimensione FLOAT  NOT NULL,
    citta SMALLINT(5) UNSIGNED NOT NULL,
    via CHAR(18) NOT NULL,
    PRIMARY KEY (id_terreno),
    FOREIGN KEY (citta) REFERENCES Citta(id_citta)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Analizza
-- -----------------------------------------------

CREATE TABLE Analizza(
	terreno  MEDIUMINT(6) UNSIGNED NOT NULL,
	agronomo SMALLINT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (terreno) REFERENCES Terreno(id_terreno)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	FOREIGN KEY (agronomo) REFERENCES Agronomo(id_agronomo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Prodotto
-- -----------------------------------------------

CREATE TABLE Prodotto(
	id_prodotto TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	descrizione VARCHAR(200) NOT NULL,
	prezzo FLOAT NOT NULL,
	PRIMARY KEY (id_prodotto)	
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Viene_Coltivato
-- -----------------------------------------------

CREATE TABLE Viene_Coltivato(
	terreno MEDIUMINT(6) UNSIGNED NOT NULL,
	prodotto TINYINT(2) UNSIGNED NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE,
	FOREIGN KEY (terreno) REFERENCES Terreno(id_terreno)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (prodotto) REFERENCES Prodotto(id_prodotto)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Allevamento
-- -----------------------------------------------

CREATE TABLE Allevamento (
		id_allevamento MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
        citta SMALLINT(5) UNSIGNED NOT NULL,
        tipo_allevamento TINYINT(2) UNSIGNED NOT NULL,
        via VARCHAR(200) NOT NULL,
        qta SMALLINT(5) UNSIGNED NOT NULL,
        PRIMARY KEY (id_allevamento),
        FOREIGN KEY (citta) REFERENCES Citta (id_citta)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
        FOREIGN KEY (tipo_allevamento) REFERENCES Tipo_di_Allevamento(id_tipo)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
ENGINE = InnoDB;



-- -----------------------------------------------
-- Creazione della tabella Tipo_di_Vino
-- -----------------------------------------------


CREATE TABLE Tipo_di_Vino(
		id_vino TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
		nome VARCHAR(255) NOT NULL,
		descrizione VARCHAR(255) NOT NULL,
		PRIMARY KEY (id_vino)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Lavora in
-- -----------------------------------------------

CREATE TABLE Lavora_in(
	allevamento  MEDIUMINT(6) UNSIGNED NOT NULL,
	contadino SMALLINT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (allevamento) REFERENCES Allevamento (id_allevamento)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (contadino) REFERENCES Contadino (id_contadino)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Coltiva
-- -----------------------------------------------

CREATE TABLE Coltiva(
	terreno MEDIUMINT(6) UNSIGNED NOT NULL,
	contadino SMALLINT(4)  UNSIGNED NOT NULL,
	FOREIGN KEY (terreno) REFERENCES Terreno(id_terreno)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (contadino) REFERENCES Contadino(id_contadino)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Macchina Agricola
-- -----------------------------------------------

CREATE TABLE Macchina_Agricola (
	id_macchina TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
    cavalli TINYINT(3) UNSIGNED NOT NULL,
    km_effettuati TINYINT(3) UNSIGNED NOT NULL,
	PRIMARY KEY (id_macchina)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Utilizza
-- -----------------------------------------------

CREATE TABLE Utilizza(
	macchina_agricola TINYINT(2) UNSIGNED NOT NULL,
	contadino SMALLINT(3) UNSIGNED NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE,
	FOREIGN KEY (macchina_agricola) REFERENCES Macchina_Agricola(id_macchina)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (contadino) REFERENCES Contadino(id_contadino)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Cantina
-- -----------------------------------------------

CREATE TABLE Cantina(
	id_cantina MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
    citta  SMALLINT(5) UNSIGNED NOT NULL,
	enologo SMALLINT(4) UNSIGNED NOT NULL,
    nome  CHAR(27) NOT NULL,
    via  CHAR(18) NOT NULL,
    altro  CHAR(26) NOT NULL,
    PRIMARY KEY (id_cantina),
    FOREIGN KEY (citta) REFERENCES Citta(id_citta)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
     FOREIGN KEY (enologo) REFERENCES Enologo(id_enologo)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;



-- -----------------------------------------------
-- Creazione della tabella Specializzato
-- -----------------------------------------------

CREATE TABLE Venduto(
		vino TINYINT(2) UNSIGNED NOT NULL,
		cantina MEDIUMINT(6) UNSIGNED NOT NULL,
		data_produzione DATE NOT NULL,
		prezzo FLOAT NOT NULL,
		qta TINYINT(2) UNSIGNED NOT NULL,
		FOREIGN KEY (vino) REFERENCES Tipo_di_Vino (id_vino)
		ON DELETE CASCADE
	    ON UPDATE CASCADE,
	    FOREIGN KEY (cantina) REFERENCES Cantina (id_cantina)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE
)
ENGINE = InnoDB;



-- -----------------------------------------------
-- Creazione della tabella Specializzato
-- -----------------------------------------------


CREATE TABLE Specializzato(
	tipo_allevamento TINYINT(2) UNSIGNED NOT NULL,
	agronomo  SMALLINT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (tipo_allevamento) REFERENCES Tipo_di_Allevamento (id_tipo)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (agronomo) REFERENCES Agronomo (id_agronomo)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Visita
-- -----------------------------------------------

CREATE TABLE Visita(
	allevamento MEDIUMINT(6) UNSIGNED NOT NULL,
	agronomo SMALLINT(4) UNSIGNED NOT NULL,
	FOREIGN KEY (allevamento) REFERENCES Allevamento (id_allevamento)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (agronomo) REFERENCES Agronomo (id_agronomo)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;



