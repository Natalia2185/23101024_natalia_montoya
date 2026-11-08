# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 14. Actividad 8 — Errores y operaciones rechazadas

Preguntas

1. ¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos? No causó ningún daño directo porque PostgreSQL bloqueó la operación al no tener los permisos necesarios. Debe auditarse de todos modos para detectar comportamientos sospechosos, abusos de privilegios o errores de configuración antes de que se conviertan en un problema de seguridad real.

2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)? La autenticación verifica quién eres al intentar iniciar sesión (comprobando si el usuario y la contraseña son correctos), mientras que la autorización verifica qué tienes permitido hacer una vez que ya entraste (comprobando si tu cuenta posee los permisos para consultar o modificar una tabla).

3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario? Indica que PostgreSQL no permite borrar a un usuario si todavía posee objetos o conserva permisos asignados. El orden correcto exige revocar sus permisos y reasignar o eliminar los objetos que le pertenecen (REASSIGN OWNED / DROP OWNED) antes de poder ejecutar el comando DROP ROLE.