## 1. Introducción
En este laboratorio se llevó a cabo la exposición y explicación de problemas de seguridad que pueden ocurrir, como por ejemplo la exposición de credenciales en texto plano, la falta de cifrado en datos confidenciales almacenados en tablas, la vulnerabilidad en las comunicaciones cliente-servidor y el mal manejo de claves criptográficas dentro del código fuente o repositorios de control de versiones.

## 2. Protección de credenciales
El texto claro es cuando se guarda la contraseña sin seguridad, es decir, que cualquier persona puede acceder a ella en cualquier momento. El hash es una forma de almacenar tu contraseña en donde se convierte en una cadena irreversible y que no necesita ser conocida por el sistema. Por último, el cifrado es cuando para visualizar un dato original se solicita una clave.

## 3. Protección de datos sensibles
Se protegió mediante el cifrado de datos el RFC y la información bancaria porque es un dato sensible y en el futuro es posible que se necesite la información original usando la clave.

## 4. TLS
Protege el tráfico de datos, es decir, que en la comunicación cliente-servidor no haya infiltraciones o modificaciones y que llegue la información original a su destino. Se verificó que estuviera en la práctica, pero estaba desactivado.

## 5. Gestión de claves
Las claves no se deben almacenar con los scripts porque cualquier persona podría tener acceso a ellas, generando una violación a la privacidad y permitiendo el robo de la información.

## 6. Resultados
Se implementó el almacenamiento seguro de contraseñas mediante hash unidireccional con sal, se cifraron exitosamente los campos sensibles en reposo mediante cifrado simétrico, se diagnosticó la falta de soporte SSL en el servidor de pruebas al forzar la conexión cifrada, entre otros resultados.

## 7. Problemas encontrados
Durante las pruebas de conexión segura con `psql` usando `sslmode=require`, el servidor rechazó la conexión devolviendo el error: `server does not support SSL, but SSL was required`. Esto confirmó que el servidor PostgreSQL de laboratorio no tenía habilitados los certificados ni la configuración TLS.

## 8. Conclusiones
En este laboratorio aprendí conceptos que antes había escuchado pero que no sabía qué significaban o cómo se aplicaban, como el cifrado de datos, la seudonimización, el enmascaramiento y TLS, entre otros problemas de seguridad que pueden existir.

## Preguntas de Reflexión

### 1. ¿Por qué una contraseña no debe almacenarse como texto claro?
Porque en caso de que una persona no autorizada obtenga acceso a la base de datos o se produzca una filtración, quedarían expuestas de manera inmediata todas las contraseñas almacenadas en el sistema.

### 2. ¿Por qué un hash no es equivalente a un cifrado?
Porque el hash es una función unidireccional e irreversible, lo que significa que no se puede volver al dato original. En cambio, el cifrado es bidireccional, por lo que con la clave adecuada es posible recuperar la información original.

### 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?
Porque el control de acceso limita los permisos sobre lo que un usuario puede consultar o modificar en la base de datos, mientras que el cifrado garantiza que el dato permanezca oculto e incomprensible aunque el usuario tenga acceso a ver la columna.

### 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?
Porque TLS solo se encarga de proteger el canal de comunicación en tránsito (el trayecto entre el cliente y el servidor), mientras que los mecanismos de autorización de PostgreSQL controlan las acciones y permisos permitidos dentro del motor de la base de datos.

### 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?
Toda la información cifrada con esa clave se volvería totalmente inaccesible de forma permanente, ya que no existe ninguna otra llave que pueda desencriptar esos datos.

### 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?
Cualquier persona con acceso al repositorio podría recuperarla y utilizarla. Además, aunque el archivo o la clave se borren posteriormente, el secreto continuará guardado dentro del historial de *commits*.

### 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?
Porque la información queda registrada permanentemente en el historial y estará al alcance de cualquier persona que tenga acceso al repositorio, además del riesgo de filtración o cambio de permisos.

### 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?
Proteger la información almacenada (datos en reposo) resguarda las tablas, discos y archivos de respaldo. Proteger la información en transmisión (datos en tránsito) asegura que el contenido viaje de forma cifrada en la red durante el trayecto entre cliente y servidor.

### 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?
Porque aunque se utilice el algoritmo más seguro, si la clave criptográfica se almacena en texto plano o se gestiona de forma descuidada, cualquier persona con acceso a ella podrá descifrar toda la información inmediatamente.

### 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?
Implementaría el cifrado en todos los archivos de respaldo (por ejemplo, con GPG o LUKS) y aplicaría la separación de funciones por roles para garantizar que solo el personal autorizado pueda manipular o restaurar las copias de seguridad.