-- Andres Grillo (), Santiago Libonati (L-3256/5), Fabrizio Mettini ()

-- Ejercicio 1

CREATE DATABASE IF NOT EXISTS slibonati_Biblioteca;

USE slibonati_Biblioteca;

DROP TABLE IF EXISTS Escribe;
DROP TABLE IF EXISTS Autor;
DROP TABLE IF EXISTS Libro;

CREATE TABLE Autor (
    ID INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Nacionalidad VARCHAR(50) NOT NULL,
    Residencia VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID)
);

-- Capaz explicar la eleccion de ISBN???
-- ISBN es una clave de entre 10 y 13 caracteres con hasta 4 guiones
-- que separan distintos grupos de la clave. Por lo que tomamos el
-- tamaño maximo que pueden tener
CREATE TABLE Libro (
    ISBN VARCHAR(17) NOT NULL,
    Titulo VARCHAR(60) NOT NULL,
    Editorial VARCHAR(30) NOT NULL,
    Precio INT NOT NULL,
    PRIMARY KEY (ISBN)
);

CREATE TABLE Escribe (
    id_autor INT NOT NULL,
    isbn_libro VARCHAR(17) NOT NULL,
    Año DATE NOT NULL,
    PRIMARY KEY (id_autor, isbn_libro),
    FOREIGN KEY (id_autor) REFERENCES Autor(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (isbn_libro) REFERENCES Libro(ISBN) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Ejercicio 2

CREATE INDEX id_apellido_autor ON Autor(Apellido);
CREATE UNIQUE INDEX id_titulo_libro ON Libro(Titulo);

-- Ejercicio 3

INSERT INTO Autor (Nombre, Apellido, Nacionalidad, Residencia) VALUES
("Tomas", "Maiza", "Surinamés", "Paramaribo"),
("Alejandro", "Rodriguez Costello", "Argentino", "Rosario"),
("Luciano", "Belardo", "Argentino", "Rosario");

INSERT INTO Libro (ISBN, Titulo, Editorial, Precio) VALUES
("10-11-12-13-14", "1001 chistes para armar y colorear", "Alfaguara", "10000"),
("5-4-3-2-1", "Yo", "UNR", "30000"),
("1-1-1-1-1", "La impresionante historia de como di una vuelta a la manzana", "Grupo Editorial Planeta", "8000");

INSERT INTO Escribe (id_autor, isbn_libro, Año) VALUES
((SELECT MIN(ID) FROM Autor WHERE Apellido = "Maiza"), "10-11-12-13-14", "2020-07-07"),
((SELECT MIN(ID) FROM Autor WHERE Apellido = "Rodriguez Costello"), "5-4-3-2-1", "1997-02-21"),
((SELECT MIN(ID) FROM Autor WHERE Apellido = "Belardo"), "1-1-1-1-1", "2010-08-12");

-- Ejercicio 4
-- a)

INSERT INTO Autor (Nombre, Apellido, Nacionalidad, Residencia) VALUES
("Abelardo", "Castillo", "Argentino", "Cordoba");

UPDATE Autor SET Residencia = "Buenos Aires" 
WHERE Nombre = "Abelardo" AND Apellido = "Castillo";

-- b)

UPDATE Libro SET Precio = 1.1*Precio
WHERE Editorial = "UNR";

-- c)
UPDATE Libro SET Precio = CASE WHEN Precio > 200 
                          THEN Precio*1.10
                          ELSE Precio*1.20 END
WHERE ISBN IN (SELECT isbn_libro FROM Escribe, Autor
                WHERE Nacionalidad <> "Argentina" AND Nacionalidad <> "Argentino"
                  AND ID = id_autor);

-- mayor a 200 = +20%
-- UPDATE Libro SET Precio = 1.20*Precio
-- WHERE Nacionalidad != "Argentina" AND Nacionalidad != "Argentino"
--   AND Precio > 200;

-- menor a 200 = +10%
-- UPDATE Libro SET Precio = 1.10*Precio
-- WHERE Nacionalidad != "Argentina" AND Nacionalidad != "Argentino"
--  AND Precio <= 200;

-- d)

DELETE FROM Libro
WHERE ISBN IN (SELECT isbn_libro FROM Escribe 
                WHERE YEAR(Año) = 1998);


