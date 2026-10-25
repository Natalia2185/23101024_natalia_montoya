
--Crear un rol:
CREATE ROLE analista_nataliaa_montoya NOLOGIN;

--Otorga únicamente acceso a la información preparada para analítica.
--Por ejemplo, crear una vista:
CREATE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;

--Otorga permisos:
GRANT USAGE ON SCHEMA public TO analista_nataliaa_montoya;

GRANT SELECT
ON v_analitica_clientes
TO analista_nataliaa_montoya;

--No otorgues:
GRANT SELECT ON clientes TO analista_nataliaa_montoya;

--Verificación
--Comprueba los privilegios:
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista_nataliaa_montoya';