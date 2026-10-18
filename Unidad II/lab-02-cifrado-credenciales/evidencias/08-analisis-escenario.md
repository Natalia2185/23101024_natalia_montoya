## Actividad 8 — Analizar un escenario de seguridad


**Objetivo**  
Evaluar un escenario de amenaza sobre la base de datos de DAYSA para identificar las vulnerabilidades potenciales y determinar qué capa de seguridad (hashing, cifrado simétrico o TLS) previene cada tipo de ataque.

**Comando o procedimiento**  
Analicé un escenario de intento de acceso no autorizado y extracción de datos, evaluando el impacto de tres vectores de ataque: interceptación de tráfico en la red, acceso directo o filtración de la base de datos y robo de credenciales de usuarios.

**Resultado obtenido**  
Comprobé que la interceptación del tráfico de red es bloqueada por TLS, la extracción no autorizada de tablas o respaldos no expone la información sensible gracias al cifrado con `pgp_sym_encrypt`, y el robo de contraseñas queda neutralizado porque `crypt` y `gen_salt` impiden recuperar las claves originales.

**Análisis**  
El análisis del escenario demuestra la efectividad de la estrategia de defensa en profundidad. Si un atacante captura el tráfico de red, TLS evita que lea las consultas e información en tránsito. Si logra acceder directamente a las tablas o a un respaldo del servidor, el cifrado simétrico impide la lectura del RFC o datos financieros sin la clave. Finalmente, si revisa la tabla de usuarios, las funciones de hashing unidireccional evitan que obtenga las contraseñas reales para suplantar identidades. Cada mecanismo responde a un riesgo específico y se complementan entre sí.

**Conclusión**  
El análisis del escenario confirma que ninguna medida de seguridad es suficiente de forma aislada. La integración de TLS, cifrado simétrico y hashing asegura una protección integral de la base de datos de DAYSA, garantizando la confidencialidad y la autenticidad frente a amenazas tanto internas como externas.

### Pregunta 1: ¿Cuáles son los principales riesgos?
Exponer las credenciales reales de los usuarios, permitir el acceso a datos confidenciales sin protección, exponer la información en tránsito durante la comunicación, permitir que cualquiera pueda visualizar las contraseñas en texto claro y dejar la información vulnerable ante cualquiera que tenga acceso a las copias de seguridad.

### Pregunta 2: ¿Qué mecanismo utilizarías para cada elemento?
* **Contraseñas:** Hashing unidireccional con `crypt` y `gen_salt`.
* **RFC e información financiera:** Cifrado simétrico o enmascaramiento/seudonimización, según el uso del dato.
* **Conexiones cliente-servidor:** Cifrado en tránsito mediante TLS/SSL.
* **Claves criptográficas:** Variables de entorno o un gestor de secretos (fuera de Git).
* **Respaldos:** Cifrado de los archivos de copia de seguridad.

### Pregunta 3: ¿Cuál de los problemas consideras más crítico y por qué?
Tener las claves criptográficas en los archivos SQL y las contraseñas en texto claro, porque si un atacante obtiene acceso a las llaves y contraseñas, se anula cualquier otra medida de seguridad que se agregue, comprometiendo por completo los datos del usuario.

### Pregunta 4: ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos? Justifica tu respuesta.
No. Aunque una correcta configuración de usuarios y permisos ayuda a reducir ciertos riesgos de acceso en la base de datos, no los elimina por completo; también es necesario proteger la información en los archivos de respaldo, el tráfico de red, el código fuente y la gestión de claves.