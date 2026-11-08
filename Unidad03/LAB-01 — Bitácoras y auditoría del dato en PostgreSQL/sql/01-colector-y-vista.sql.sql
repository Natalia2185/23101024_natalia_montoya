--8. Actividad 2 — Que el servidor administre su propia bitácora
--Activa el colector:
ALTER SYSTEM SET logging_collector = on;
SELECT name, setting, pending_restart FROM pg_settings WHERE name = 'logging_collector';

--Comprueba el resultado:
SELECT name, setting, source FROM pg_settings WHERE name = 'logging_collector';
SELECT pg_current_logfile();

--La ruta es relativa al directorio de datos (sección 6.3). Lee el archivo desde el propio motor:
SELECT linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n') AS linea;
 
--Una vista guarda una consulta con nombre y se usa como si fuera una tabla:
CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
     WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';

-- A partir de aquí, leer y filtrar la bitácora es una consulta SQL:
-- últimas 10 líneas
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 10;

-- líneas que contienen un texto, sin distinguir mayúsculas
SELECT linea FROM dba.bitacora WHERE linea ILIKE '%update%';

-- líneas que cumplen una expresión regular
SELECT linea FROM dba.bitacora WHERE linea ~ '(FATAL|ERROR)';