# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 9. Actividad 3 — El incidente sin bitácora

Preguntas
1. ¿Puedes demostrar quién modificó el RFC? Sí, una vez configurado log_statement = 'mod' y log_line_prefix, la bitácora registra explícitamente la sentencia UPDATE, la fecha, la aplicación (app-ventas-web) y el usuario (app_ventas).

2. ¿Puedes demostrar que el cambio no lo hizo soporte_ana? Sí, porque el registro de auditoría atribuible en dba.bitacora muestra la cuenta app_ventas y, además, soporte_ana solo cuenta con permiso de lectura (SELECT), por lo que el motor habría bloqueado cualquier intento de modificación de su parte.

3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo? No lo impidieron ni debían hacerlo para app_ventas, ya que posee el permiso explícito GRANT UPDATE. Los privilegios de acceso (RBAC) evitan accesos no autorizados, mientras que la auditoría vigila las acciones realizadas por usuarios legítimos.

4. ¿Qué tendría que haber estado configurado antes del incidente? Debió estar activado el colector de logs (logging_collector = on), el registro de sentencias de modificación (log_statement = 'mod') y el prefijo formateado con usuario, base de datos y aplicación (log_line_prefix = '%m [%p] %u@%d %a ').
