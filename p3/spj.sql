CREATE DATABASE IF NOT EXISTS SPJ;

USE SPJ;

DROP TABLE IF EXISTS SPJ;                            -- Recordar que ocurre si elimino
DROP TABLE IF EXISTS S;                              -- SPJ luego de las otras tablas.
DROP TABLE IF EXISTS J;
DROP TABLE IF EXISTS P;

/* Se utiliza (`) para incluir caracteres especiales en lo nombres de las columnas
y de las claves. Se considera que (#) es un caracter especial. */

/**
 * Tabla S: representa a los proveedores.
 * Cada proveedor tiene:
 *     - S#: número de proveedor único.
 *     - SNOMBRE: nombre de proveedor.
 *     - SITUACION: valor de calificación o situación.
 *     - CIUDAD: localidad.
 * Cada proveedor está situado en una sola ciudad.
 */
CREATE TABLE S (
    `S#`      CHAR(2)     NOT NULL  PRIMARY KEY,
    SNOMBRE   VARCHAR(30) NOT NULL,
    SITUACION TINYINT     NOT NULL,                  -- TINYINT va de 0 a 255.
    CIUDAD    VARCHAR(30) NOT NULL                   -- y ocupa solo un byte.
);

/**
 * Tabla P: representa a las partes.
 * Cada tipo de parte tiene:
 *     - P#: número de parte único.
 *     - PNOMBRE: nombre de parte.
 *     - COLOR: color.
 *     - PESO: peso.
 *     - CIUDAD: localidad donde se almacenan las partes de ese tipo.
 * Cada tipo de parte tiene un solo color y se almacena en una bodega de una sola ciudad.
 */
CREATE TABLE P (
    `P#`    CHAR(2)     NOT NULL  PRIMARY KEY,
    PNOMBRE VARCHAR(30) NOT NULL,
    COLOR   VARCHAR(10) NOT NULL,
    PESO    TINYINT     NOT NULL,
    CIUDAD  VARCHAR(30) NOT NULL
);

/**
 * Tabla J: representa a los proyectos.
 * Cada proyecto tiene:
 *     - J#: número de proyecto único.
 *     - JNOMBRE: nombre de proyecto JNOMBRE.
 *     - CIUDAD: localidad.
 */
CREATE TABLE J (
    `J#`    CHAR(2)     NOT NULL  PRIMARY KEY,
    JNOMBRE VARCHAR(30) NOT NULL,
    CIUDAD  VARCHAR(30) NOT NULL
);

/**
 * Tabla SPJ:
 * Representa a los envíos. El significado de un registro de esta tabla es que
 * el proveedor especificado suministra la parte especificada al proyecto especificado
 * en la cantidad especificada.
 * La combinación S#-P#-J#' identifica de manera única cada uno de estos registros.
 */
CREATE TABLE SPJ (
    `S#`     CHAR(2)  NOT NULL,
    `P#`     CHAR(2)  NOT NULL,
    `J#`     CHAR(2)  NOT NULL,                            -- SMALLINT va de -32768 a 32767.
    CANTIDAD SMALLINT NOT NULL,                            -- y ocupa solo dos bytes.
    PRIMARY KEY (`S#`,`P#`,`J#`),
    CONSTRAINT `FK_en_SPJ_para_S#` FOREIGN KEY (`S#`) REFERENCES S(`S#`), 
    CONSTRAINT `FK_en_SPJ_para_P#` FOREIGN KEY (`P#`) REFERENCES P(`P#`), 
    CONSTRAINT `FK_en_SPJ_para_J#` FOREIGN KEY (`J#`) REFERENCES J(`J#`)

    /* CONSTRAINT permite agregarle un nombre a la clave foranea.
       De no usarlo se crea con un valor por defecto. */
    
    /* Al no especificar ON DELETE y ON UPDATE estos toman valores por defecto. */
);                                                   

INSERT INTO S
VALUES ('S1', 'Salazar', 20, 'Londres'),
       ('S2', 'Jaimes', 10, 'París'),
       ('S3', 'Bernal', 30, 'París'),
       ('S4', 'Corona', 20, 'Londres'),
       ('S5', 'Aldana', 30, 'Atenas');

INSERT INTO P
VALUES ('P1', 'Tuerca', 'Rojo', 12, 'Londres'),
       ('P2', 'Perno', 'Verde', 17, 'París'),
       ('P3', 'Burlete', 'Azul', 17, 'Roma'),
       ('P4', 'Burlete', 'Rojo', 14, 'Londres'),
       ('P5', 'Leva', 'Azul', 12, 'París'),
       ('P6', 'Engranaje', 'Rojo', 19, 'Londres');

INSERT INTO J
VALUES ('J1', 'Clasificador', 'París'),
       ('J2', 'Perforadora', 'Roma'),
       ('J3', 'Lectora', 'Atenas'),
       ('J4', 'Consola', 'Atenas'),
       ('J5', 'Compaginador', 'Londres'),
       ('J6', 'Terminal', 'Oslo'),
       ('J7', 'Cinta', 'Londres');

INSERT INTO SPJ
VALUES ('S1', 'P1', 'J1', 200),
       ('S1', 'P1', 'J4', 700),
       ('S2', 'P3', 'J1', 400),
       ('S2', 'P3', 'J2', 200),
       ('S2', 'P3', 'J3', 200),
       ('S2', 'P3', 'J4', 500),
       ('S2', 'P3', 'J5', 600),
       ('S2', 'P3', 'J6', 400),
       ('S2', 'P3', 'J7', 800),
       ('S2', 'P5', 'J2', 100),
       ('S3', 'P3', 'J1', 200),
       ('S3', 'P4', 'J2', 500),
       ('S4', 'P6', 'J3', 300),
       ('S4', 'P6', 'J7', 300),
       ('S5', 'P2', 'J2', 200),
       ('S5', 'P2', 'J4', 100),
       ('S5', 'P5', 'J5', 500),
       ('S5', 'P5', 'J7', 100),
       ('S5', 'P1', 'J4', 100),
       ('S5', 'P3', 'J4', 200),
       ('S5', 'P4', 'J4', 800),
       ('S5', 'P5', 'J4', 400),
       ('S5', 'P6', 'J4', 500);