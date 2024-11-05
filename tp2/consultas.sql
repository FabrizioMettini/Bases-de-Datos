-- EJERCICIO 5

-- a) Obtener los nombres de los duenios de los inmuebles.

SELECT DISTINCT nombre FROM Persona P, PoseeInmueble PI
WHERE P.codigo = PI.codigo_propietario;

-- b) Obtener todos los codigos de los inmuebles cuyo precio esta
--    en el intervalo 600.000 a 700.000 inclusive.

SELECT codigo FROM Inmueble
WHERE precio >= 600000 AND precio <= 700000;

-- c) Obtener los nombres de los clientes que prefieran inmuebles 
--    solo en la zona Norte de Santa Fe.

-- Asumo que "codigo_cliente" en la tabla PrefiereZona implica que solo clientes
-- prefieren una zona, y no incluye a vendedores y propietarios que no sean clientes

SELECT DISTINCT nombre FROM Persona
WHERE codigo IN (SELECT codigo_cliente FROM PrefiereZona
                 WHERE nombre_poblacion="Santa Fe" AND nombre_zona="Norte")
  AND codigo NOT IN (SELECT codigo_cliente FROM PrefiereZona
                     WHERE nombre_poblacion<>"Santa Fe" OR nombre_zona<>"Norte");

-- d) Obtener los nombres de los empleados que atiendan a algun cliente
--    que prefiera la zona Centro de Rosario.
       
SELECT DISTINCT P.nombre FROM Vendedor V, Persona P, Cliente C
WHERE V.codigo = P.codigo AND V.codigo = C.vendedor
  AND C.codigo IN (SELECT codigo_cliente FROM PrefiereZona
                   WHERE nombre_poblacion="Rosario" AND nombre_zona="Centro");

-- e) Para cada zona de Rosario, obtener el numero de inmuebles en venta
--    y el promedio de su valor.
          
SELECT COUNT(codigo), AVG(precio) FROM Inmueble
WHERE nombre_poblacion = "Rosario"
GROUP BY nombre_zona;

-- f) Obtener los nombres de los clientes que prefieran inmuebles
--    en todas las zonas de Santa Fe

SELECT DISTINCT P.nombre FROM Persona P, PrefiereZona Z
WHERE P.codigo = Z.codigo_cliente
  AND Z.nombre_poblacion = "Santa Fe"
  AND NOT EXISTS (SELECT * FROM Zona 
                WHERE nombre_poblacion = "Santa Fe"
                AND nombre_zona NOT IN (SELECT nombre_zona FROM Persona P2, PrefiereZona Z2
                                        WHERE P2.codigo = Z2.codigo_cliente
                                        AND P2.codigo = P.codigo
                                        AND Z2.nombre_poblacion = "Santa Fe"));


