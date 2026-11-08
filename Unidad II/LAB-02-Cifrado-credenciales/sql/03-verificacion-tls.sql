/*Actividad 5 — Verificar el estado de TLS en PostgreSQL*/

/*Verificar la configuración de seguridad en el servidor:

Compruebo si el servidor tiene activado el cifrado TLS/SSL,
la versión de seguridad mínima que exige y por cuál puerto
y dirección de red está escuchando.
*/
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;


/*Ver datos de mi propia conexión:

Muestra la dirección IP de mi computadora y el puerto que estoy 
usando para conectarme a PostgreSQL.
*/
SELECT
    inet_client_addr(),
    inet_client_port();


/*Verificar si mi sesión viaja segura y cifrada:

Muestra si mi conexión actual tiene el cifrado activo (ssl = true),
junto con la versión de TLS y el tipo de protección que se aplica.
*/
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();


/*Comprobación rápida de protección:

Devuelve 'true' si mi conexión actual está usando cifrado,
confirmando que nadie puede leer mis datos en el camino.
*/
SELECT ssl_is_used();