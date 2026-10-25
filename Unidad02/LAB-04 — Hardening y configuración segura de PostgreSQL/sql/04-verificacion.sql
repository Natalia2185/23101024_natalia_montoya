
-- 1. Verificación de estado de cifrado TLS en la conexión activa
-- NOTA: Se aplica JOIN con pg_stat_activity debido a que en PostgreSQL 16
-- pg_stat_ssl carece de las columnas usename y client_addr.
SELECT
    s.pid,
    a.usename,
    a.client_addr,
    s.ssl,
    s.version,
    s.cipher
FROM pg_stat_ssl s
JOIN pg_stat_activity a ON s.pid = a.pid
WHERE s.pid = pg_backend_pid();

-- 2. Verificación de parámetros de seguridad actualizados
SHOW listen_addresses;
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
SHOW superuser_reserved_connections;

-- 3. Confirmación de extensión plpgsql como única instalada
SELECT extname, extversion FROM pg_extension;