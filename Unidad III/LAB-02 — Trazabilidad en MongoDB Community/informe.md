# Informe — LAB-02: Trazabilidad en MongoDB Community

## 19. Informe

### Despliegue, edición y limitación
Levanté el servidor usando un contenedor de Docker (`mongodb`) con **MongoDB 4.4.30 Community Edition** sobre Ubuntu. Para comprobar qué edición estaba corriendo y qué funciones traía, ejecuté `db.adminCommand({ buildInfo: 1 }).modules` y me devolvió `[ ]` (vacío). Eso confirma que es la edición gratuita Community y que **no tiene auditoría nativa** (esa herramienta solo viene en las versiones de pago Enterprise y MongoDB Atlas M10 o superior). También revisé `db.serverCmdLineOpts().parsed` y solo mostró `{ "net" : { "bindIp" : "*" } }`, lo que demuestra que no había ningún archivo de bitácora ni opción de auditoría configurada desde el arranque.

### Perfilador
Cuando arranca el servidor, el perfilador viene apagado por defecto (`"was": 0`), así que no guarda ningún rastro de lo que pasa con los datos. Al encenderlo en nivel 2 (`db.setProfilingLevel(2)`) dentro de la base `comercial`, empezó a guardar todas las operaciones (`query`, `update`, `remove`) en la colección `system.profile`, anotando qué comando se ejecutó, en qué colección, a qué hora (`ts`), desde qué IP (`client`), con qué aplicación (`appName`) y qué usuario (`user`) lo hizo. 

Como guardar absolutamente todas las consultas consume recursos y llena el espacio muy rápido, después lo cambié a nivel 1 con un filtro (`filter: { op: { $in: ["insert", "update", "remove"] } }`). Con eso gané guardar únicamente los cambios reales en los datos, a cambio de dejar de ver las consultas de lectura (`find`). Es muy importante aclarar que el perfilador sirve para rastrear actividad operativa, pero **no es una auditoría de seguridad**, porque solo mide 1 MB (va borrando lo viejo cuando se llena), se apaga si se reinicia el servidor y nunca guarda cómo estaba el dato antes de que lo modificaran o borraran.

### Bitácora de `mongod`
Como no tiene configurada una ruta de archivo en `systemLog.path`, el servidor manda su bitácora en formato JSON directamente a la salida estándar (`stdout`) del contenedor Docker y guarda en memoria RAM los últimos 1,024 eventos (que se pueden leer con `db.adminCommand({ getLog: "global" })`). En esa bitácora sí quedaron registrados los intentos fallidos de inicio de sesión (`Failed to authenticate`, donde internamente el motor sí distingue si falló la contraseña o si el usuario no existe), los accesos correctos (`Successfully authenticated`) y los cambios en la configuración del perfilador (`Profiler settings changed`). Aunque ese aviso de cambio no trae el nombre del usuario escrito directamente, pude comprobar que fue `admin` cruzando el identificador de la conexión (`ctx`, como `conn3` o `conn2`) con su inicio de sesión dentro de la misma ejecución del servidor.

### Privilegios
MongoDB Community no registra en ningún lado cuando alguien le da o le quita permisos a un usuario (`grantRolesToUser` o `revokeRolesFromUser`). Al buscar esos comandos tanto en `system.profile` como en la bitácora del servidor, ambos dieron `0` resultados. 

Para cubrir ese hueco apliqué un **control compensatorio**: guardar "fotos" (instantáneas) de los permisos de todos los usuarios en la colección `auditoria.instantaneas_privilegios`. Al comparar la instantánea de las `21:09:25.904Z` con la de las `21:10:47.805Z`, se comprobó que a `app_ventas` le agregaron el rol `dbAdmin` en `comercial`. Sin embargo, estas instantáneas **no equivalen a una auditoría nativa**, porque solo te enseñan *qué* permisos cambiaron entre una foto y otra, pero no te dicen *quién* dio el permiso ni en qué segundo exacto pasó.

### Conservación
En MongoDB Community la evidencia se puede perder muy fácil sin que nadie la borre a propósito:
* La bitácora que se consulta con `getLog` vive en la memoria RAM (solo guarda los últimos 1,024 eventos y se borra por completo si se reinicia el servidor).
* La colección `system.profile` tiene un límite fijo de 1 MB, así que cuando se llena va sobrescribiendo los registros más viejos.
* El nivel del perfilador regresa a `0` (apagado) después de un reinicio si no se deja fijo en un archivo de configuración.

Para asegurar las pruebas antes de que se perdieran, exporté los registros a los archivos `evidencias/system-profile.json` y `evidencias/bitacora-mongod.log`, y calculé sus huellas digitales en `evidencias/hashes.sha256` (`72f6ade3c98da748c4c6b0623e7d898a47b7c9c4542710adf50ab5777a9fec62` y `8e05f8ff1f3db4b61569d8f5a20353d71c5189742d140ead3bfb4fad5215e675`) para poder demostrar que nadie alteró los archivos después de exportarlos.

### Comparación
Al comparar los tres escenarios de la Actividad 9:
* **PostgreSQL (bitácora + disparadores):** Es la opción gratuita más completa; registra accesos, cambios de permisos (`ddl`), modificaciones en los datos y hasta guarda el valor anterior del dato (`OLD`) gracias a los disparadores (*triggers*).
* **MongoDB Community (perfilador + bitácora):** Registra accesos exitosos y fallidos, lecturas y modificaciones en `system.profile`, y cambios de configuración de forma parcial (usando `ctx`), pero no registra absolutamente nada de cambios de permisos ni guarda valores anteriores.
* **MongoDB Enterprise / Atlas:** Incluye auditoría nativa para registrar accesos, cambios de permisos, cambios de estructura y operaciones sobre los datos de forma inmutable, aunque tampoco guarda copias del valor anterior de los documentos.

### Recomendación
* **Hechos verificados en la práctica:** MongoDB Community no deja rastro cuando se asignan o quitan roles (`grantRolesToUser`), su perfilador es temporal ante reinicios y se sobrescribe al llegar a 1 MB, y las instantáneas solo detectan diferencias de estado sin decir quién hizo el cambio.
* **Supuestos:** Si la empresa maneja datos personales o fiscales delicados (como el RFC de sus clientes) y tiene que cumplir con auditorías legales o normas de seguridad (como ISO 27001, PCI-DSS o leyes de protección de datos), depender de instantáneas periódicas no alcanza para investigar un incidente serio.
* **Recomendación:** Si la organización necesita saber con certeza quién y cuándo cambia privilegios en MongoDB, lo recomendable es **migrar a MongoDB Enterprise Edition o usar MongoDB Atlas (clúster M10 o superior)** y activar la auditoría nativa (`auditLog`) enviándola a un archivo externo seguro. Si por presupuesto no se puede pagar la licencia de inmediato, se deben programar instantáneas automáticas de privilegios muy seguidas, configurar `systemLog.destination: file` para guardar la bitácora en disco fuera del contenedor y limitar al máximo quién tiene acceso a la cuenta `admin`.

---

## 20. Preguntas de reflexión

**1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?**
Porque fue hecho para medir el rendimiento de las consultas, no para seguridad. Tiene un límite de 1 MB y borra lo más viejo automáticamente cuando se llena, se apaga si se reinicia el servidor, cualquiera con permisos de administrador lo puede vaciar con `drop()` y no registra eventos críticos como cambios de roles o permisos.

**2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?**
Porque mientras está encendido permite reconstruir qué pasó en la base de datos: qué operación se ejecutó, sobre qué colección, a qué hora exacta, desde qué IP, con qué aplicación y bajo qué usuario, ayudando a rastrear fallos o cambios operativos.

**3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?**
Como el nivel 2 guarda textualmente toda la consulta (`filter`), si una aplicación o usuario busca a un cliente por su RFC, correo o teléfono, esos datos privados quedan guardados en texto normal dentro de `system.profile` y en cualquier respaldo que se exporte, exponiendo información sensible de las personas.

**4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?**
**Detectar un cambio** es darte cuenta de que algo ya no está igual que antes (por ejemplo, ver en una foto de permisos que `app_ventas` ahora tiene el rol `dbAdmin`). **Atribuirlo a alguien** es tener pruebas claras de qué usuario o persona específica hizo ese cambio, cuándo lo hizo y desde dónde, para poder fincar responsabilidades.

**5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?**
Porque decir que una base de datos audita cosas que en realidad no registra crea una falsa sensación de seguridad en la empresa. Ser claro y honesto con lo que la herramienta sí hace y lo que no puede hacer permite medir los riesgos reales, justificar la compra de mejores licencias o poner controles extra a tiempo.