# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# Actividad 11 — Crear la función y el disparador

Preguntas

1. ¿Por qué se ejecuta REVOKE ALL ON FUNCTION ... FROM PUBLIC si el disparador seguirá funcionando para app_ventas? Se ejecuta para evitar que cualquier usuario pueda llamar la función manualmente desde una consulta SQL (haciendo un SELECT), garantizando que la función solo se active de manera automática a través del disparador (trigger) cuando ocurra una modificación en los datos.

2. ¿Qué pasaría si la función no fuera SECURITY DEFINER? Formula una hipótesis antes de la Actividad 12. Si la función no fuera SECURITY DEFINER, se ejecutaría usando los permisos de app_ventas; por lo tanto, como ese usuario no tiene permiso directo para escribir en la tabla de auditoría, la operación fallaría marcando un error de permisos denegados (permission denied).

3. Consulta dba.bitacora. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué? Sí, todas quedaron registradas porque las instrucciones CREATE SCHEMA, CREATE TABLE, CREATE FUNCTION y CREATE TRIGGER son sentencias de estructura (DDL), y el servidor tiene activa la auditoría log_statement = 'ddl' que guarda automáticamente cualquier cambio en las definiciones de la base de datos.