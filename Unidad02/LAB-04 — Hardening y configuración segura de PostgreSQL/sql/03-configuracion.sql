
--1. Restricción de interfaz de escucha (loopback local)
ALTER SYSTEM SET listen_addresses = '127.0.0.1';

--2. Habilitación de cifrado en tránsito TLS/SSL y versión mínima segura
ALTER SYSTEM SET ssl = 'on';
ALTER SYSTEM SET ssl_min_protocol_version = 'TLSv1.2';

--3. Configuración de timeouts para mitigación de DoS e inactividad
ALTER SYSTEM SET statement_timeout = '30s';
ALTER SYSTEM SET idle_in_transaction_session_timeout = '10min';

--4. Reserva de conexiones para rescate administrativo de emergencia
ALTER SYSTEM SET superuser_reserved_connections = 3;

--5. Recarga de la configuración en memoria
SELECT pg_reload_conf();