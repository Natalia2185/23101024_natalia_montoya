# Actividad 5 — Accesos en la bitácora de mongod

Preguntas

¿Qué campo distingue un acceso fallido de uno exitoso? El campo principal en la bitácora es msg (mensaje), donde una conexión exitosa se registra como "Successfully authenticated" y una fallida como "Authentication failed". Además, se distinguen por el campo attr.result (donde el código 0 indica éxito y un valor distinto representa un error) y por el identificador del evento (id).

¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos? Internamente, la bitácora del servidor sí distingue el motivo exacto guardando si el usuario no fue encontrado o si falló la verificación de la contraseña. Sin embargo, el cliente siempre recibe el mismo mensaje genérico (Authentication failed) por una regla de seguridad llamada prevención de enumeración de usuarios; esto evita que un atacante descubra qué nombres de usuario existen realmente en el sistema probando combinaciones al azar.

¿Por qué el nombre de la aplicación del intento fallido es mongosh 2.10.0 y no app-ventas-web? Porque la prueba de acceso fallido se envió directamente desde la terminal de comandos sin incluir el parámetro appName=app-ventas-web en la cadena de conexión. Al no definir explícitamente el nombre de la aplicación en la URL de conexión, el servidor registra por defecto la herramienta que está enviando la petición (en este caso, la consola interactiva mongosh y su versión).
