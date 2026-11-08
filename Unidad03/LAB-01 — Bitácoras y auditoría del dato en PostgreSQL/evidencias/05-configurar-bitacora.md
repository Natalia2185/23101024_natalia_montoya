# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 10. Actividad 4 — Configurar la bitácora

Preguntas

1. ¿Por qué el proceso que registra el cambio es el principal y no tu sesión? Porque tu sesión solo envía una señal del sistema (SIGHUP) al ejecutar SELECT pg_reload_conf(). Es el proceso principal del servidor (postmaster) el encargado de releer el archivo postgresql.auto.conf, aplicar los parámetros a nivel de todo el clúster en la memoria global y registrar el mensaje "parameter ... changed to ..." en la bitácora.

2. ¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'? ¿Quedaría rastro? Sí, sí quedaría rastro. Quedaría registrada la propia ejecución del comando ALTER SYSTEM (al ser una sentencia DDL/administración auditada) y, principalmente, el evento de recarga del servidor notificando en el log que el parámetro log_statement cambió a 'none' justo antes de que la desactivación de auditoría entre en vigor.

3. ¿Por qué no se recomienda editar postgresql.auto.conf a mano? Porque es un archivo administrado automáticamente por el motor. Modificarlo manualmente puede introducir errores de sintaxis que impidan el inicio del servicio, eludir las validaciones de tipo de dato de PostgreSQL y provocar que tus cambios manuales sean sobrescritos o eliminados sin previo aviso la próxima vez que alguien ejecute un ALTER SYSTEM o ALTER SYSTEM RESET.