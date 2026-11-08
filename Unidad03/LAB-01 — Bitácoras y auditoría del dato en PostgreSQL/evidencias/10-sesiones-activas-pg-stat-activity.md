# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 15. Actividad 9 — Sesiones activas con pg_stat_activity

Preguntas:

1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora? La columna pid (ID del proceso). En la vista pg_stat_activity identifica el proceso de la sesión activa y en la bitácora se registra entre corchetes [%p], permitiendo cruzar la información de la sesión con sus registros.

2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió? La bitácora del servidor (dba.bitacora o archivos de log en disco). La vista pg_stat_activity es en tiempo real y borra la información en cuanto la sesión se desconecta, mientras que la bitácora guarda el historial de forma permanente.

3. ¿Por qué client_addr aparece vacío en la sesión del administrador? Aparece vacío (o nulo) porque el administrador se conecta localmente al servidor mediante sockets de Unix del propio sistema operativo, sin utilizar una red TCP/IP que requiera una dirección IP.