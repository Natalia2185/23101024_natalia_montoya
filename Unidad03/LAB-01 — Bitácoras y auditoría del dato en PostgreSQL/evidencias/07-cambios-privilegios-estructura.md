# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 12. Actividad 6 — Cambios de privilegios y de estructura

Preguntas

1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?REVOKE y GRANT son eventos de privilegio porque sirven para quitar o dar permisos de acceso a los usuarios sobre los datos, mientras que ALTER TABLE es un evento de estructura porque modifica directamente la forma y las columnas de la tabla.

2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'? Quedan registrados ahí porque PostgreSQL considera que cambiar permisos modifica el catálogo interno de seguridad de la base de datos, por lo que el motor agrupa las sentencias de permisos junto con los cambios de estructura bajo la misma regla de auditoría ddl.

3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II. Solo debe leerla el administrador (DBA) o el personal de seguridad autorizado, ya que cuando alguien crea cuentas escribiendo claves en el comando (CREATE ROLE ... PASSWORD), la contraseña queda guardada en texto claro dentro del archivo de registros, convirtiendo a la bitácora en información sensible que debe protegerse igual que cualquier otro secreto de la empresa.