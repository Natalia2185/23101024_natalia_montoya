

--12.4 Suprimir grupos pequeños

/*Esta consulta junta a los clientes en grupos 
usando su rango de edad y su zona tomando los 
primeros dos números del código postal. Después 
cuenta cuántos clientes hay en cada grupo y oculta
 los que tengan menos de 5 personas, para proteger 
 la privacidad y evitar que se pueda identificar a 
 alguien en particular.*/

SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2

HAVING COUNT(*) >= 5;