--10. Actividad 4 — Configurar la bitácora
--En la sesión de administrador:
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();

--Verifica el origen de los valores con una consulta nueva (ver el recuadro siguiente):
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');

--Revisa las últimas líneas de la bitácora:
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;
