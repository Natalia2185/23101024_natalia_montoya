# Actividad 3 — Activar el perfilador y registrar operaciones

Preguntas

¿Puedes saber cuál era el RFC antes del cambio con la información de system.profile? No, no es posible saberlo. La colección system.profile solo guarda la instrucción que se envió a ejecutar con el nuevo valor del RFC, pero no almacena la información previa ni realiza un respaldo del valor que tenía el documento antes de aplicar el cambio.

¿Puedes saber qué datos tenía el documento eliminado? Tampoco es posible saberlo. El perfilador únicamente registra el filtro que se utilizó para la eliminación (como el _id: 2), pero no guarda una copia ni conserva los datos del cliente que fue borrado de la base de datos.

A diferencia de log_statement = 'mod' en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso? La ventaja es que permite tener un control total de qué usuarios están buscando o leyendo información. El riesgo es que al registrar absolutamente todas las búsquedas, el volumen de datos de registro crece muy rápido, puede alentar el rendimiento del servidor y expone información sensible que los usuarios escriban en los filtros.

¿Por qué el campo user incluye @comercial? Porque MongoDB identifica a los usuarios combinando el nombre de la cuenta con la base de datos exacta donde se autenticaron o fueron creados. En este caso, indica que el usuario app_ventas pertenece a la base de datos comercial.