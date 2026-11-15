# Actividad 2 — El incidente sin perfilado

Preguntas

¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora? No es posible demostrar el cambio exacto realizado en la base de datos. Como el perfilador de MongoDB estaba desactivado (was: 0), la bitácora del servidor no guarda las operaciones de modificación (update) ni los valores anteriores o nuevos. En cuanto a las conexiones, la bitácora de mongod solo permite saber qué usuario se autenticó a esa hora, su dirección IP y el momento exacto, pero no existe evidencia en la bitácora que vincule a ese usuario directamente con la edición del RFC.

¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica? El cliente mongosh abre varias conexiones porque utiliza las primeras para enviar metadatos del cliente (como la versión del programa o el nombre de la aplicación) y revisar el estado del servidor, mientras que la conexión posterior se usa para validar las credenciales. La conexión que realmente se autentica es aquella donde la bitácora muestra explícitamente el mensaje de autenticación exitosa (Successfully authenticated).
