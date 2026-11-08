# Actividad 10 — Política Mínima de Protección de Claves

### Actividad 10 — Política Mínima de Protección de Claves

**Objetivo**  
Definir y documentar una política mínima para el manejo, almacenamiento y rotación de claves de cifrado en la base de datos de DAYSA, previniendo la exposición no autorizada de secretos en scripts SQL o en los registros del servidor.

**Comando o procedimiento**  
Diseñé e implementé los lineamientos para la gestión de claves, estableciendo la prohibición de escribir contraseñas en texto plano dentro del código SQL, regulando el uso de variables de sesión o de entorno para la inyección de claves y fijando procedimientos de rotación periódica.

**Resultado obtenido**  
Establecí un estándar operativo seguro que elimina la presencia de claves hardcodeadas en los scripts de la base de datos y repositorios, asegurando que solo las aplicaciones o roles autorizados puedan suministrar la clave en tiempo de ejecución.

**Análisis**  
Cualquier algoritmo de cifrado depende totalmente del resguardo de la clave simétrica. Si la clave se incluye directamente en las consultas SQL, queda expuesta en los archivos de registro (*logs*) y en el historial de comandos, anulando la protección en reposo. Una política de protección de claves asegura que la responsabilidad de almacenar el secreto recaiga en componentes externos seguros (como administradores de secretos o variables de entorno), reduciendo drásticamente la superficie de ataque.

**Conclusión**  
La política mínima de protección de claves formaliza el uso adecuado de los recursos criptográficos en PostgreSQL. Normar el ciclo de vida y la custodia de las claves garantiza que el cifrado simétrico cumpla su propósito de proteger la información confidencial de DAYSA sin generar vulnerabilidades por descuido en la gestión de credenciales.

## Política de Protección de Claves — Empresa Camaronera DAYSA

Para proteger los datos de clientes, ventas y embarques de camarón de DAYSA, se establecen las siguientes 8 reglas sencillas para el manejo de las llaves y contraseñas secretas de la base de datos:

### 1. Generación
Nada de usar llaves o contraseñas fáciles como `Camaron2026`, `Daysa123` o fechas de cumpleaños. Las llaves secretas deben ser generadas automáticamente por sistemas que creen códigos largos, complejos y aleatorios.

### 2. Almacenamiento
Prohibido escribir las llaves secretas dentro del código del sistema, en archivos SQL o subirlas al GitHub de la empresa. Las llaves se deben guardar en variables de entorno ocultas dentro del servidor o en un gestor de secretos seguro.

### 3. Acceso
Aplica la regla del "mínimo acceso necesario". Solo el administrador del sistema de DAYSA tendrá acceso a las llaves. Ni los vendedores, ni los empacadores, ni los clientes necesitan conocer la llave maestra de cifrado.

### 4. Rotación
Las llaves secretas no son para siempre. Se deben cambiar como mínimo una vez al año, o de inmediato si un encargado del sistema o programador renuncia o deja la empresa.

### 5. Respaldo
Las copias de seguridad de las llaves se guardan por separado de los respaldos diarios de la base de datos de inventario y ventas. Se deben guardar cifradas y en un lugar seguro (fuera del servidor principal).

### 6. Revocación
Si una llave ya no se usa o hay sospechas de que alguien la descubrió, se debe desactivar (revocar) de inmediato en el sistema para que no puedan usarla para entrar o robar información.

### 7. Exposición accidental
Si a algún empleado se le pasa y escribe la llave en un correo, un chat de WhatsApp o la sube por error a GitHub, esa llave queda anulada en ese mismo instante. Se borra, se genera una nueva y se vuelve a cifrar toda la información afectada.

### 8. Eliminación segura
Cuando una llave cumple su ciclo y ya no se necesita para leer datos viejos, se borra por completo del sistema de forma irreversible (*crypto-shredding*), garantizando que nadie pueda recuperarla jamás para ver los datos antiguos de la camaronera.