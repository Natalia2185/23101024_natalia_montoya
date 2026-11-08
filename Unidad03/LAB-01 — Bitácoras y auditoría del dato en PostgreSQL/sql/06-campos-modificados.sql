--25. Actividad 19 — Auditoría de objeto sobre columnas sensibles
CREATE ROLE auditor_datos NOLOGIN;
GRANT SELECT (rfc, telefono), UPDATE (rfc, telefono) ON clientes TO auditor_datos;
ALTER SYSTEM SET pgaudit.log = 'role, ddl';
ALTER SYSTEM SET pgaudit.role = 'auditor_datos';
ALTER SYSTEM SET pgaudit.log_relation = on;
SELECT pg_reload_conf();
--Y, como administrador, un cambio de privilegios:
GRANT SELECT ON clientes TO soporte_ana;
SELECT linea FROM dba.bitacora WHERE linea LIKE '%AUDIT:%';