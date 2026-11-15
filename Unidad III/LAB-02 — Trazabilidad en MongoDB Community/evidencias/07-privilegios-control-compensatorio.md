# Actividad 7 — Cambios de privilegios: el límite más importante

Preguntas de Reflexión

¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes? La elevación de privilegios es el principal vector para el acceso no autorizado y la evasión de controles de seguridad. Dado que otorgar roles no modifica datos de forma inmediata, no deja rastro en la actividad DML habitual. Como MongoDB Community omite registrar grantRolesToUser en el perfilador y en los logs globales, auditar los cambios de permisos es esencial para detectar accesos indebidos.

¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen? Se deben programar instantáneas automáticas diariamente (o por hora en entornos críticos), además de tomarlas justo antes y después de ejecutar cambios en ventanas de mantenimiento. Los factores clave son la tasa de modificación de usuarios, las normativas de cumplimiento de la empresa y la capacidad de almacenamiento disponible en la base de datos de auditoría.

¿Quién debería poder escribir en auditoria.instantaneas_privilegios? Exclusivamente una cuenta de servicio técnico automatizada o el rol de administrador de la base de datos (DBA). Las cuentas de aplicación (como app_ventas) y los usuarios operativos no deben poseer permisos de escritura o modificación sobre esta colección para evitar la alteración de evidencias.

Comunicación de la limitación a Dirección (3 líneas):
MongoDB Community no audita nativamente la asignación de privilegios en sus logs ni en el profilador.
La falta de trazabilidad se mitiga mediante instantáneas periódicas que identifican variaciones de roles por comparación diferencial.
Para obtener trazabilidad en tiempo real con identificación exacta del autor y momento del cambio, se sugiere evaluar la versión Enterprise.