
--1. Identificación de la versión del motor de base de datos
SELECT version();

--2. Inspección de parámetros de red, puerto y mecanismos de autenticación
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

--3. Identificación de rutas físicas de archivos de configuración
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
SHOW data_directory;

--4. Inspección de parámetros de registro y auditoría
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

--5. Revisión de sesiones y conexiones activas
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;

--6. Inspección de reglas de acceso de red registradas
SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;

--7. Revisión de extensiones habilitadas en el motor
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;

--8. Inspección de límites de conexión y timeouts
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;