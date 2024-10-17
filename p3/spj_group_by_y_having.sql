USE SPJ;

/** A continuación se presentan algunos comandos de MySQL que pueden ser
de ayuda para entender como funciona GROUP BY.

Se pueden observar los resultados obtenidos de cada consulta como así
también observar algunos errores que pueden surgir. */

/* Agrupamos pero no decimos que hacer con otras columnas */
SELECT * FROM SPJ
GROUP BY `S#`;

/* Decimos que queremos hacer con las otras columnas  */
SELECT `S#`, COUNT(DISTINCT(`P#`)), COUNT(DISTINCT(`J#`)), SUM(CANTIDAD) FROM SPJ
GROUP BY `S#`;

/* Solo agrupa los proveedores cuya cantidad de envios supere los 700 */
SELECT `S#`, SUM(CANTIDAD) FROM SPJ
WHERE CANTIDAD >= 700
GROUP BY `S#`;

/*
Da error, CANTIDAD no es una columna valida de esta consulta.
Notar que en el resultado de la consulta hay una columna llamada SUM(CANTIDAD).

SELECT `S#`, SUM(CANTIDAD) FROM SPJ
GROUP BY `S#`
HAVING CANTIDAD >= 700;
*/

/* Agrupa los proveedores y filtra los que sumenun total de envios mayor o igual a 700*/
SELECT `S#`, SUM(CANTIDAD) FROM SPJ
GROUP BY `S#`
HAVING SUM(CANTIDAD) >= 700;

/* Agrupa los proveedores y filtra los que sumenun total de envios mayor o igual a 700*/
SELECT `S#`, SUM(CANTIDAD) AS `ENVIOS TOTALES` FROM SPJ
GROUP BY `S#`
HAVING `ENVIOS TOTALES` >= 700;

/* Toma el primer valor de S# */
SELECT `S#`, SUM(CANTIDAD) FROM SPJ;

/*
Error, no se puede usar SUM(CANTIDAD) en el WHERE. SUM(CANTIDAD) es
algo que se va a hacer luego de obtener la tabla que cumpla las condiciones dadas.

SELECT `S#`, SUM(CANTIDAD) FROM SPJ
WHERE SUM(CANTIDAD) > 700
GROUP BY `S#`;
*/

/* Suma las cantidades de aquellos proveedores que aparezcan tres o mas veces en la tabla.
Notar que en este caso si se puede usar COUNT en el HAVING. */
SELECT `S#`, SUM(CANTIDAD) FROM SPJ
GROUP BY `S#`
HAVING COUNT(CANTIDAD) >= 3;