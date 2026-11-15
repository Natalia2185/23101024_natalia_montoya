# Actividad 1 — Lo que no existe en esta edición

Preguntas

¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra? Estoy usando la versión Community Edition (versión 4.4.30). La prueba de esto es que al consultar los módulos del sistema con db.adminCommand({ buildInfo: 1 }).modules, el resultado nos devuelve un arreglo vacío [], mientras que la versión de pago Enterprise mostraría explícitamente el módulo "enterprise".

¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes? El servidor manda sus registros directamente a la pantalla de la consola dentro del contenedor de Docker (salida estándar). Lo sabemos porque al revisar la configuración con db.serverCmdLineOpts().parsed, no aparece configurada ninguna ruta ni archivo guardado en el disco para almacenar las bitácoras.

Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa? Registraría los cambios en las estructuras de las bases de datos (DDL), los eventos o modificaciones en los clústeres y réplicas, las operaciones de inicio de sesión y asignación de permisos a usuarios (autenticación y autorización), y la lectura, modificación o eliminación de datos (operaciones CRUD).

¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría? La empresa debe evaluar si el costo de pagar la licencia de Enterprise o la nube de Atlas se ajusta a su presupuesto. También debe analizar si las normas de su sector le exigen obligatoriamente esta auditoría por ley, si el servidor perderá velocidad al registrar cada acción, o si les resulta suficiente usar los mecanismos básicos que ya incluye la versión gratuita Community.
