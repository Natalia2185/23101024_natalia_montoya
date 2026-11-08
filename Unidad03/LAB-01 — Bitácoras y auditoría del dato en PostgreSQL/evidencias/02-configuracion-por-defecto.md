# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 7. Actividad 1 — Revisar la configuración de registro por defecto

Preguntas

1.-¿Se registra quién se conecta?
No. Con log_connections = off, el servidor ignora y no escribe en bitácora ningún intento de conexión, sea exitoso o fallido.

2.-¿Se registran las sentencias UPDATE?
No. El parámetro log_statement = none evita que se registre cualquier tipo de sentencia ejecutada en la base de datos (SELECT, INSERT, UPDATE, DELETE, etc.).

3.-¿La línea de bitácora incluye el usuario o la dirección IP del cliente?
No. El prefijo predeterminado log_line_prefix = '%m [%p]' solo imprime la fecha/hora con milisegundos (%m) y el ID del proceso (%p), omitiendo el usuario (%u), la base de datos (%d) y la IP remota (%h).

4.-¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología? 
Se registran en America/Mazatlan (log_timezone). Es vital para la reconstrucción cronológica porque si los eventos de la base de datos no están sincronizados con la zona horaria de las aplicaciones o servidores web, resulta imposible determinar la secuencia real de acciones durante un peritaje o auditoría.

5.-Con logging_collector = off, ¿quién decide dónde termina la bitácora: 
PostgreSQL o el mecanismo con que se desplegó el servidor? Lo decide el mecanismo con que se desplegó el servidor (Linux/systemd, Docker, servicio de Windows, etc.). PostgreSQL simplemente envía sus salidas a stderr (salida de error) y deja que el entorno decida dónde guardarlas.
