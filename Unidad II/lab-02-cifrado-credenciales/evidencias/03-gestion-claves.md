## Actividad 3 — El problema de la gestión de claves

**Objetivo**  
Analizar los riesgos de seguridad asociados al uso e inclusión de claves simétricas directamente en las consultas SQL y evaluar la necesidad de implementar mecanismos adecuados para la gestión y resguardo de claves.

**Comando o procedimiento**  
Evalué el comportamiento del sistema al ejecutar funciones de cifrado y descifrado pasando la clave simétrica explícitamente en texto plano dentro de las sentencias SQL y revisé su visibilidad en los registros y vistas de monitoreo del servidor.

**Resultado obtenido**  
Comprobé que al escribir la clave simétrica directamente en la consulta, esta queda expuesta en texto claro dentro del historial de comandos, archivos de registro del servidor (*logs*) y vistas de monitoreo de conexiones activas.

**Análisis**  
Incrustar la contraseña de cifrado dentro del código SQL compromete la confidencialidad, ya que cualquier persona con acceso a los *logs* o al monitoreo de la base de datos puede obtener la clave y descifrar la información protegida. La seguridad del cifrado simétrico recae completamente en el resguardo de la clave, por lo que esta no debe viajar en las consultas, sino gestionarse mediante variables de entorno, parámetros de sesión o herramientas externas de gestión de secretos.

**Conclusión**  
Hardcodear claves de cifrado en las sentencias SQL representa una falla grave en la gestión de claves que anula la efectividad del cifrado en reposo. Para mantener la información realmente protegida, es indispensable separar la clave de las consultas SQL y administrar su acceso desde capas externas y seguras.

### Riesgo de Exposición de Claves en Git

¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?
Si esa clave fuera real y el archivo se subiera a GitLab (o cualquier servicio Git), la seguridad del cifrado se perdería por completo. Cualquier persona o atacante con acceso al repositorio podría visualizar la clave en texto claro. Incluso si posteriormente se borra el archivo o la contraseña del proyecto, el secreto permanecerá guardado permanentemente en el historial de *commits* de Git, lo que permitiría a cualquiera utilizar esa clave junto con un respaldo o acceso a la base de datos para descifrar toda la información sensible.