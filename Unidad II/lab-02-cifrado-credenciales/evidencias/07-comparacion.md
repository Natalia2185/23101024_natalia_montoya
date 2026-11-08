## Actividad 7 — Comparar protección en reposo y protección en tránsito

**Objetivo**  
Comparar los mecanismos de protección de datos en reposo frente a la protección en tránsito, analizando las amenazas que mitiga cada uno para comprender su complementariedad en la seguridad de PostgreSQL.

**Comando o procedimiento**  
Analicé y comparé el comportamiento del sistema al proteger la información almacenada en las tablas con cifrado simétrico y hashing (`pgp_sym_encrypt` y `crypt`) frente al uso de conexiones cifradas mediante TLS/SSL para la comunicación por red.

**Resultado obtenido**  
Comprobé que la protección en reposo mantiene los datos ilegibles dentro de la base de datos o respaldos, mientras que la protección en tránsito evita que las consultas, respuestas y credenciales sean interceptadas durante su trayecto por la red.

**Análisis**  
La protección en reposo resguarda la información contra robos de discos, accesos indebidos a las tablas o filtraciones de respaldos, pero no impide que los datos viajen expuestos si la red no está protegida. Por el contrario, la protección en tránsito asegura el canal de comunicación entre cliente y servidor, pero no evita que los datos almacenados en disco permanezcan legibles. Ningún mecanismo sustituye al otro; ambos forman capas de seguridad complementarias que deben operar juntas para lograr una defensa en profundidad.

**Conclusión**  
La protección en reposo y en tránsito resuelven problemas de seguridad distintos e igualmente críticos. Implementar ambas estrategias garantiza que la información confidencial permanezca protegida tanto cuando está almacenada en el servidor como cuando viaja a través de la red.


| Situación | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| Contraseña de usuario | `crypt` y `gen_salt` | Las credenciales de acceso; es decir, que no se filtre la contraseña y no se pueda revertir. |
| RFC almacenado en una tabla | `pgp_sym_encrypt` | Datos sensibles guardados en reposo; el dato se oculta en la tabla, pero puede ser descifrado al tener la clave. |
| Consulta enviada desde un cliente al servidor | `sslmode=require` | La información en movimiento, ya que cifra el contenido en tránsito para que ningún atacante pueda modificarlo durante este. |
| Respaldo de una base de datos | Cifrado de archivos o disco (GPG o LUKS) | Los archivos de copia de seguridad (dumps), para evitar que puedan leer los datos en caso de que se roben en donde estén almacenados. |
| Clave criptográfica | Variables de entorno o gestores de secretos (fuera de Git) | La llave maestra de todo el sistema; impide que se quede guardada la contraseña en los commits. |