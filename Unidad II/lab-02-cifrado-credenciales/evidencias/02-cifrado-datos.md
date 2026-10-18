## Actividad 2 — Cifrado de información sensible

**Objetivo**  
Demostrar la protección de datos confidenciales en reposo mediante cifrado simétrico con `pgp_sym_encrypt` y `pgp_sym_decrypt`, garantizando que la información sensible no sea legible directamente dentro de las tablas.

**Comando o procedimiento**  
Inserté registros con datos sensibles aplicando la función `pgp_sym_encrypt()` junto con una clave simétrica, y posteriormente ejecuté consultas de lectura utilizando `pgp_sym_decrypt()` con la clave correspondiente para recuperar la información original en texto claro.

**Resultado obtenido**  
Comprobé que la información confidencial no se guarda de forma legible en la columna, sino como un bloque de datos binarios (`bytea`) cifrado. Al realizar la lectura con la clave simétrica correcta logré recuperar el valor original, mientras que al usar una clave incorrecta el sistema rechazó el descifrado.

**Análisis**  
El cifrado simétrico utiliza la misma contraseña tanto para ocultar como para recuperar la información. A diferencia del hash, este proceso sí es reversible porque su objetivo es proteger los datos en reposo sin perder la capacidad de leerlos cuando sea necesario. De esta manera, si un atacante u observador no autorizado obtiene acceso a la tabla o a un respaldo de la base de datos, solo verá datos cifrados incomprensibles sin la clave adecuada.

**Conclusión**  
El uso de cifrado simétrico mediante `pgp_sym_encrypt` asegura la confidencialidad de los datos sensibles dentro de la base de datos. Este mecanismo protege la información almacenada en reposo frente a accesos no autorizados, permitiendo descifrar y consultar el valor original únicamente cuando se proporciona la clave simétrica correcta.

## Comparación entre `crypt()` y `pgp_sym_encrypt()`

#### 1. ¿Qué diferencia existe entre `crypt()` y `pgp_sym_encrypt()`?
`crypt()` se utiliza para contraseñas, ya que genera un hash unidireccional que permite verificar si la clave ingresada es correcta sin recuperar el texto original. Por otro lado, `pgp_sym_encrypt()` sirve para proteger datos confidenciales que requieren ser recuperados a su texto original mediante el uso de una clave secreta.

#### 2. ¿Cuál de los dos mecanismos permite recuperar el dato original?
`pgp_sym_encrypt()`, pero se requiere la clave secreta con la que se cifró la información.

#### 3. ¿Qué ocurre si se utiliza una clave incorrecta?
PostgreSQL arroja un error de descifrado y cancela la operación, impidiendo la lectura o recuperación del dato original.

#### 4. ¿Qué problema de seguridad representa colocar la clave directamente en una consulta?
Representa la exposición de secretos en el código fuente, historial de consultas o archivos de registro (*logs*). Si un atacante obtiene acceso a estos registros, podrá extraer la clave y descifrar de inmediato toda la información almacenada en la base de datos.