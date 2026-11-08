# Informe de Investigación del Incidente y Preservación Forense (LAB-01)

**Institución:** Universidad Autónoma de Sinaloa — Facultad de Informática Culiacán  
**Asignatura:** Administración de Bases de Datos  
**Laboratorio:** LAB-01 — Bitácoras, Auditoría del Dato y Preservación Forense  
**Alumna:** Natalia Montoya Martínez  
**Fecha:** 08 de Noviembre 2026

## 28.Informe

### Despliegue y situación inicial

El servidor se instaló de forma local en Ubuntu Linux con PostgreSQL 16. Al principio, la base de datos venía con la bitácora apagada (`logging_collector = off`), por lo que no guardaba registros de las acciones que realizaban los usuarios ni de los errores. Cuando Dirección preguntó quién había modificado el RFC del cliente en la tabla, fue imposible responder porque el servidor no guardaba historial de cambios ni decía qué usuario ejecutó la consulta.

### Configuración aplicada

Para corregir el problema se activó el colector de bitácoras (`logging_collector = on`), lo cual requirió reiniciar el servicio de PostgreSQL. Luego se activó el registro de conexiones y desconexiones (`log_connections = on` y `log_disconnections = on`), el nivel de registro de sentencias (`log_statement = 'mod'` para cambios de datos y `'ddl'` para cambios de estructura), y la extensión `pgaudit` para monitorear columnas sensibles (`rfc` y `telefono`). Estos últimos ajustes solo requirieron recargar la configuración (`SELECT pg_reload_conf();`). Además, se agregó un prefijo de línea (`log_line_prefix`) para que cada mensaje indique la hora exacta, el usuario, la base de datos, la aplicación y la IP desde donde se conectó.

### Eventos observados

En la bitácora se pueden identificar cinco tipos de eventos clave. Primero, los accesos exitosos que muestran cuándo un usuario inicia o cierra sesión con su IP. Segundo, los errores de acceso que muestran cuando alguien intenta entrar con una contraseña incorrecta. Tercero, las modificaciones de estructura (`DDL`) como agregar una columna a una tabla. Cuarto, los cambios de datos (`DML`) como actualizar una fila. Y quinto, las alertas de `pgAudit` que registran cuando un usuario lee o consulta columnas protegidas.

### Auditoría del dato

Se creó la tabla `auditoria.cambios_clientes` usando campos de tipo `JSONB` para guardar la foto exacta de los datos como estaban antes y como quedaron después del cambio. La función de auditoría se configuró con `SECURITY DEFINER` para que se ejecute con los permisos del administrador (`postgres`), permitiendo que usuarios operativos como `app_ventas` guarden su registro de auditoría sin tener permisos directos de modificar la tabla de auditoría. Se utilizó `session_user` para saber quién se conectó originalmente y `current_user` para conocer con qué permisos se ejecutó la acción. Gracias a esto, se comprobó que el usuario `app_ventas` realizó el cambio de RFC del cliente 3 de `GAMA780912X...` a `GAMA780912Z...`.

### Limitaciones

Este sistema tiene tres limitaciones principales. La primera es que la bitácora estándar no registra qué usuarios leen información sensible si no modifican nada, a menos que se use `pgAudit`. La segunda es que guardar cada cambio genera muchos archivos en disco y puede alentar el servidor si hay miles de transacciones por segundo. La tercera es que un usuario administrador con superpoderes dentro del sistema operativo aún podría apagar las bitácoras o modificar los archivos directamente.

### Riesgos de la bitácora

Las bitácoras tienen tres riesgos de seguridad que deben cuidarse. El primero es que se escriban claves o contraseñas en texto claro dentro del archivo de log si alguien las envía en un comando SQL. El segundo es que el disco se llene y se pierda información antigua si no se hace un respaldo externo. El tercero es que usuarios no autorizados lean los archivos de log si no se protegen los permisos a nivel del sistema operativo Linux.

### Cronología y conclusión

Con la configuración final implementada (colector de bitácora, triggers con `JSONB`, `pgAudit` y sellado con hash SHA-256), sí se puede demostrar exactamente quién cambió un dato sensible, desde qué equipo, a qué hora y qué valor tenía antes del cambio.

---

## 29.Preguntas de Reflexión

### 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

La auditoría funciona registrando los eventos en el momento exacto en que ocurren. Si un incidente sucede mientras las bitácoras están apagadas, la información nunca se guardó y no existe manera de recuperarla hacia atrás.

### 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

El propio motor de PostgreSQL sabe cuándo rotar los archivos, cómo organizar los metadatos y cómo no perder información si ocurre un fallo. Los sistemas de despliegue como Docker solo capturan la pantalla de la terminal, lo cual puede perder datos al reiniciar el contenedor o fragmentar los mensajes de error.

### 3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?

El nivel de `log_statement` dice qué comando SQL se ejecutó, pero sin el prefijo de línea no sabrías a qué hora ocurrió, quién lo hizo, desde qué dirección IP ni desde qué sistema se conectaron. El prefijo aporta todo el contexto indispensable para una investigación.

### 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

Registrar la sentencia solo guarda el texto SQL escrito por el usuario, pero no muestra qué filas cambiaron ni qué valores tenían antes. Registrar el cambio en el dato con un disparador (*trigger*) guarda la foto completa antes y después de la modificación, permitiendo conocer el impacto real sobre la información.

### 5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?

`pg_stat_activity` muestra lo que está pasando en este instante preciso dentro del servidor, como quién está conectado ahorita y qué consulta está ejecutando en tiempo real. La bitácora, en cambio, guarda la historia del pasado para revisar lo que ocurrió horas, días o meses atrás.

### 6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?

Al administrador lo auditan los sistemas externos. Para lograrlo, los archivos de log se envían en tiempo real a un servidor seguro fuera de su control (`syslog` o SIEM), y los archivos extraídos se firman con un hash criptográfico (SHA-256) guardado en un repositorio al que el administrador de la base de datos no tiene acceso para modificar.