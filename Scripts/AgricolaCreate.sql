-- ----------------------------------
-- Autore: Antonio Cruciani
-- Nome File:
-- Note: Creazione del DB e delle tabelle
-- ----------------------------------


-- ----------------------------------
-- Creazione Database
-- ----------------------------------

DROP DATABASE IF EXISTS Agricola;
CREATE DATABASE Agricola DEFAULT CHARACTER SET utf8;

USE Agricola; 

-- -----------------------------------------------
-- Creazione della tabella Dipendente
-- -----------------------------------------------
-- #ATTENZIONE_1: Il campo matricola è un campo formato solamente da interi 

CREATE TABLE Dipendente (
	matricola INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
	nome VARCHAR(30) NOT NULL,
	cognome VARCHAR(39) NOT NULL,
    anno_nascita DATE NOT NULL,
    n_patente CHAR(30),
	n_tel CHAR(30) NOT NULL,
	cf CHAR(30) NOT NULL,
	stipendio_annuale FLOAT UNSIGNED NOT NULL,
	PRIMARY KEY (matricola)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Agronomo
-- -----------------------------------------------

CREATE TABLE Agronomo (
		id_agronomo INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
        mat_dip INT(6) UNSIGNED NOT NULL,
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
		id_contadino INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
        mat_dip INT(6) UNSIGNED NOT NULL,
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
		id_enologo INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
		mat_dip INT(6) UNSIGNED NOT NULL,
        
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
	id_citta INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
	cap varchar(200) NOT NULL,
    provincia varchar(200) NOT NULL,
    nome VARCHAR(200) NOT NULL,
	PRIMARY KEY (id_citta)	
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Tipo_di_Animale
-- -----------------------------------------------
CREATE TABLE Tipo_di_Allevamento (
		id_tipo INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
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
	id_terreno INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
	dimensione FLOAT(53) NOT NULL,
    citta INT(6) UNSIGNED NOT NULL,
    via VARCHAR(200) NOT NULL,
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
	terreno INT(6) UNSIGNED NOT NULL,
	agronomo INT(6) UNSIGNED NOT NULL,
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
	id_prodotto INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	descrizione VARCHAR(200) NOT NULL,
	prezzo FLOAT(53) NOT NULL,
	PRIMARY KEY (id_prodotto)	
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Viene_Coltivato
-- -----------------------------------------------

CREATE TABLE Viene_Coltivato(
	terreno INT(6) UNSIGNED NOT NULL,
	prodotto INT(6) UNSIGNED NOT NULL,
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
		id_allevamento INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
        citta INT(6) UNSIGNED NOT NULL,
        tipo_allevamento INT (6) UNSIGNED NOT NULL,
        via VARCHAR(200) NOT NULL,
        qta bigint NOT NULL,
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
		id_vino INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
		nome VARCHAR(255) NOT NULL,
		descrizione VARCHAR(255) NOT NULL,
		PRIMARY KEY (id_vino)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Lavora in
-- -----------------------------------------------

CREATE TABLE Lavora_in(
	allevamento INT(6) UNSIGNED NOT NULL,
	contadino INT(6) UNSIGNED NOT NULL,
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
	terreno INT(6) UNSIGNED NOT NULL,
	contadino INT(6)  UNSIGNED NOT NULL,
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
	id_macchina INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
    cavalli INT(6) UNSIGNED NOT NULL,
    km_effettuati INT(6) UNSIGNED NOT NULL,
	PRIMARY KEY (id_macchina)
)
ENGINE = InnoDB;


-- -----------------------------------------------
-- Creazione della tabella Utilizza
-- -----------------------------------------------

CREATE TABLE Utilizza(
	macchina_agricola INT(6) UNSIGNED NOT NULL,
	contadino INT(6) UNSIGNED NOT NULL,
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
	id_cantina INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
    citta INT(6) UNSIGNED NOT NULL,
	enologo INT(6) UNSIGNED NOT NULL,
    nome VARCHAR(255) NOT NULL,
    via VARCHAR(200) NOT NULL,
    altro VARCHAR(255),
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
		vino INT(6) UNSIGNED NOT NULL,
		cantina INT(6) UNSIGNED NOT NULL,
		data_produzione DATE NOT NULL,
		prezzo float(53) NOT NULL,
		qta bigint NOT NULL,
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
	tipo_allevamento INT(6) UNSIGNED NOT NULL,
	agronomo INT(6) UNSIGNED NOT NULL,
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
	allevamento INT(6) UNSIGNED NOT NULL,
	agronomo INT(6) UNSIGNED NOT NULL,
	FOREIGN KEY (allevamento) REFERENCES Allevamento (id_allevamento)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (agronomo) REFERENCES Agronomo (id_agronomo)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
ENGINE = InnoDB;



