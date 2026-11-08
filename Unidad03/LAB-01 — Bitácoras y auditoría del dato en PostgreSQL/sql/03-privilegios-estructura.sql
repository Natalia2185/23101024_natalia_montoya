--12. Actividad 6 — Cambios de privilegios y de estructura
--Con log_statement = 'ddl', en la sesión de administrador:
REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

--12.1 La bitácora también puede filtrar secretos
--Crea un rol desechable escribiendo la contraseña en la sentencia, y elimínalo:
CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';
DROP ROLE rol_temporal;

--Consulta las sentencias registradas:
SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;

--14. Actividad 8 — Errores y operaciones rechazadas
--El administrador intenta eliminar un rol que todavía tiene privilegios:
DROP ROLE soporte_ana;

SELECT linea FROM dba.bitacora
WHERE linea ~ '(ERROR|STATEMENT|DETAIL):  (permission|privileges|role|DELETE|DROP)'
ORDER BY num;