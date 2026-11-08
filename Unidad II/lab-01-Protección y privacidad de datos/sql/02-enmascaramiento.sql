--Actividad 2 — Enmascaramiento 

/*Crea un rol llamado soporte y genera una vista (v_clientes_soporte) 
que oculta la información sensible de los clientes reemplazando parte 
del correo, teléfono y RFC con asteriscos. Luego, le otorga al rol 
soporte permiso únicamente para consultar esta vista protegida y le
 bloquea el acceso directo a la tabla original de clientes, garantizando 
 que el personal de soporte solo pueda visualizar datos parciales y no la 
 información real completa.*/

--8.1 Crear el rol

CREATE ROLE soporte NOLOGIN;

--8.2 Crear una vista de acceso restringido

CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,

    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,

    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,

    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc

FROM clientes;

--Consultar la vista:
SELECT *
FROM v_clientes_soporte;

--8.3 Conceder acceso a la vista

GRANT USAGE
ON SCHEMA public
TO soporte;

GRANT SELECT
ON v_clientes_soporte
TO soporte;

--Revocar el acceso directo a la tabla:
REVOKE ALL
ON clientes
FROM soporte;

--8.4 Verificar el resultado

--La consulta a la vista debe mostrar los datos protegidos:
SELECT *
FROM v_clientes_soporte;

--El acceso directo a la tabla debe estar restringido para el rol soporte:
SELECT *
FROM clientes;