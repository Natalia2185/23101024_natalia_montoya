
--1. Auditoría de roles existentes en la instancia
SELECT
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

--2. Creación de roles segregados por responsabilidad

--Rol DBA: Exclusivo para administración del motor
CREATE ROLE dba_user WITH
    LOGIN
    PASSWORD 'ClaveRobustadba2026!'
    NOSUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT;

--Rol APP: Exclusivo para operaciones DML de la aplicación web
CREATE ROLE app_user WITH
    LOGIN
    PASSWORD 'ClaveRobustaApp2026!'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT;

--Rol CONSULTA: Exclusivo para lectura (SELECT) e inspección
CREATE ROLE consulta_user WITH
    LOGIN
    PASSWORD 'ClaveRobustaConsulta2026!'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT;

--3. Asignación de privilegios mínimos sobre esquemas y tablas

--Privilegios DML para rol APP
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

--Privilegios de solo lectura para rol CONSULTA
GRANT USAGE ON SCHEMA public TO consulta_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO consulta_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO consulta_user;