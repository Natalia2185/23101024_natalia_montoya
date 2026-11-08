### Actividad 4 — Verificar el estado de TLS en PostgreSQL

**Objetivo**  
Auditar la configuración del servidor de PostgreSQL y verificar que la conexión activa del cliente esté cifrada mediante TLS/SSL para garantizar la protección de los datos en tránsito a través de la red.

**Comando o procedimiento**  
Ejecuté comandos de verificación global (`SHOW ssl;`, `SHOW ssl_min_protocol_version;`, `SHOW port;` y `SHOW listen_addresses;`) para revisar los parámetros de red del servidor, e inspeccioné mi sesión activa consultando la vista `pg_stat_ssl` filtrada por el identificador del proceso actual (`pg_backend_pid()`).

**Resultado obtenido**  
Confirmé que el servicio tiene habilitado el cifrado (`ssl = on`) y que la sesión actual utiliza un canal cifrado (`ssl = true`), mostrando la versión del protocolo TLS activa y el tipo de algoritmo de cifrado aplicado a mi conexión.

**Análisis**  
El uso de TLS protege la información en tránsito evitando que un atacante en la red pueda interceptar o leer datos confidenciales y credenciales mediante análisis de tráfico (*sniffing*). Comprobar el estado de TLS desde `pg_stat_ssl` permite validar que las políticas de seguridad del servidor no solo están configuradas, sino que se están aplicando eficazmente en la conexión real.

**Conclusión**  
La verificación del estado de TLS confirma que el canal de comunicación entre el cliente y PostgreSQL es seguro. Mantener el tráfico cifrado garantiza la confidencialidad e integridad de las consultas y resultados frente a intercepciones en la red.

### Información en Tránsito (Cliente — Servidor)

¿Qué sucede con la información mientras viaja entre el cliente y PostgreSQL?
Cuando ejecuto una consulta como `SELECT * FROM clientes;`, la información tanto la petición que envío como los datos que me devuelve la base de datos viaja en paquetes a través de la red entre mi equipo cliente y el servidor de PostgreSQL.

Si la conexión no está protegida: La información viaja en texto plano. Cualquier persona con capacidad de monitorear la red podría interceptar el tráfico (por ejemplo, con Wireshark) y leer directamente las consultas, las credenciales y los datos devueltos por el servidor.
Si la conexión está protegida con TLS/SSL:Los datos se cifran antes de salir de mi equipo y solo se descifran al llegar al servidor. Aunque alguien logre interceptar los paquetes en la red, únicamente verá datos cifrados e ininteligibles, protegiendo la confidencialidad de la información en tránsito.
