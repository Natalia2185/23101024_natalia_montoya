# LAB-04 — Hardening y Configuración Segura de PostgreSQL 16

**Universidad Autónoma de Sinaloa**  
**Facultad de Informática Culiacán**  
**Licenciatura en Informática**  
**Alumna:** Montoya Martínez Natalia (Grupo 4-1)  
**Profesor:** Alexis Moisés Montaño Araujo  

---

## 1. Objetivo
Documentar, implementar y auditar un conjunto de medidas de endurecimiento (*hardening*) sobre PostgreSQL 16 en Debian, reduciendo la superficie de ataque inicial mediante la restricción de exposición en red, la separación de roles por el principio de mínimo privilegio, el reforzamiento de mecanismos de autenticación y cifrado, el ajuste de tiempos de espera para prevenir Denegación de Servicio (DoS), y la protección de archivos a nivel de sistema operativo.

---

## 2. Entorno
* **Motor de Base de Datos:** PostgreSQL 16
* **Sistema Operativo:** Debian Linux
* **Herramientas:** Terminal SO (`bash`, `ss -lntp`), `psql`, pgAdmin 4
* **Rutas Principales:**
  * `data_directory`: `/var/lib/postgresql/16/main`
  * `config_file`: `/etc/postgresql/16/main/postgresql.conf`
  * `hba_file`: `/etc/postgresql/16/main/pg_hba.conf`

---

## 3. Superficie de Ataque Inicial
* Enlace en red permisivo (`listen_addresses = '*'`), escuchando en todas las interfaces sobre el puerto TCP 5432.
* Reglas de acceso en `pg_hba.conf` y firewall perimetral abiertas (`0.0.0.0/0`).
* Uso indiscriminado de la cuenta superusuario `postgres` para operaciones cotidianas y aplicaciones web.
* Ausencia de límites en tiempos de ejecución de consultas (`statement_timeout = 0`) e inactividad (`idle_in_transaction_session_timeout = 0`).
* Transmisión de datos sin cifrado obligatorio en tránsito (`ssl = off`).

---

## 4. Hallazgos
1. **Exposición en Red:** PostgreSQL escuchaba abiertamente en la interfaz pública, permitiendo intentos de conexión no autorizados.
2. **Falta de Segregación de Roles:** Las aplicaciones operaban con permisos administrativos máximos, exponiendo la base de datos completa ante vulnerabilidades del código como Inyección SQL (SQLi).
3. **Mecanismo de Autenticación Inseguro:** Reglas de acceso no restringían subredes específicas ni forzaban esquemas seguros Challenge-Response.
4. **Vulnerabilidad de Disponibilidad:** Consultas colgadas o sesiones inactivas podían saturar las conexiones permitidas (`max_connections`) o la memoria del servidor.
5. **Comportamiento en Vistas de Auditoría:** En PostgreSQL 16, la vista `pg_stat_ssl` no contiene los campos `usename` ni `client_addr`, requiriendo un `JOIN` con `pg_stat_activity` mediante la columna `pid` para evitar errores en las consultas de auditoría.

---

## 5. Cambios Realizados
1. Restricción de `listen_addresses` a `127.0.0.1` (o IPs privadas de aplicación).
2. Segregación de funciones mediante roles: `DBA` (con `superuser_reserved_connections = 3`), `APP` (mínimos privilegios DML) y `CONSULTA` (solo lectura `SELECT`).
3. Actualización de `pg_hba.conf` imponiendo `scram-sha-256`, delimitando subredes explícitas (ej. `10.10.10.0/24`) y requiriendo conexiones `hostssl`.
4. Habilitación de cifrado en tránsito: `ssl = on` y `ssl_min_protocol_version = TLSv1.2`.
5. Configuración de límites de ejecución: `statement_timeout = '30s'` e `idle_in_transaction_session_timeout = '10min'`.
6. Protección de permisos en el SO: `700` (`drwx------`) en `/var/lib/postgresql/16/main` y `640`/`644` en archivos de configuración asignados a `postgres:postgres`.
7. Auditoría y reducción de extensiones, conservando únicamente la extensión nativa `plpgsql` (1.0).

---

## 6. Justificación de los Cambios
* **Red:** Aísla el motor de la red pública, reduciendo drásticamente los intentos de intrusión y escaneos de puertos.
* **Roles:** Aplica el mínimo privilegio para contener el impacto en caso de que una aplicación web sea vulnerada.
* **Autenticación y TLS:** Garantiza un intercambio de credenciales resistente a tablas precalculadas (*rainbow tables*) e impide la captura de tráfico confidencial (*sniffing*).
* **Timeouts:** Evita el consumo desmedido de RAM/CPU y bloqueos persistentes en las tablas (*bloat*).
* **Permisos del SO:** Bloquea la lectura directa de los archivos físicos de datos por parte de otros usuarios del sistema operativo.

---

## 7. Verificación
* Verificación de puertos mediante `ss -lntp` confirmando que el puerto 5432 solo escucha en `127.0.0.1`.
* Ejecución de la consulta de auditoría corregida con `JOIN`:
  ```sql
  SELECT s.pid, a.usename, a.client_addr, s.ssl, s.version, s.cipher
  FROM pg_stat_ssl s
  JOIN pg_stat_activity a ON s.pid = a.pid
  WHERE s.pid = pg_backend_pid();

  ## 9. Cuestionario / Informe

1. **¿Cuál era la principal superficie de ataque?**  
   La exposición directa en red provocada por `listen_addresses = '*'` junto con directivas perimetrales y de `pg_hba.conf` que aceptaban conexiones desde cualquier origen (`0.0.0.0/0`).

2. **¿Qué configuración representaba el mayor riesgo?**  
   El uso de la cuenta superusuario (`postgres`) por parte de aplicaciones web en un entorno no cifrado. Una inyección SQL habría permitido al atacante tomar control total de la base de datos y del sistema operativo.

3. **¿Qué cambio produjo la mayor reducción de exposición?**  
   Restringir `listen_addresses` a `127.0.0.1` (o IPs privadas autorizadas) y filtrar el puerto 5432 mediante firewall. Esto bloqueó de inmediato cualquier intento de acceso remoto no autorizado a nivel de red.

4. **¿Qué diferencia existe entre firewall y `pg_hba.conf`?**  
   El **firewall** actúa en las capas 3 y 4 del modelo OSI (Red/Transporte) filtrando paquetes antes de que alcancen el servicio; **`pg_hba.conf`** actúa en la capa 7 (Aplicación), evaluando qué usuario, base de datos y método de autenticación se permiten una vez establecida la conexión TCP.

5. **¿Qué diferencia existe entre autenticación y autorización?**  
   La **autenticación** valida la identidad del usuario (¿quién eres?), mientras que la **autorización** determina los permisos de un usuario ya autenticado sobre los objetos del sistema (¿qué puedes hacer?).

6. **¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**  
   Porque viola el principio de mínimo privilegio. Si la aplicación sufre una Inyección SQL (SQLi), un atacante con rol `SUPERUSER` podría borrar la base de datos, modificar configuraciones o ejecutar comandos arbitrarios en el sistema operativo host.

7. **¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**  
   Porque cambiar el puerto es únicamente "seguridad por obscuridad". Un escaneo de puertos automatizado descubre el nuevo puerto en pocos segundos; si las reglas de acceso y credenciales siguen siendo débiles, el sistema sigue expuesto.

8. **¿Por qué `listen_addresses='*'` puede ser innecesario?**  
   Porque la mayoría de los servidores de bases de datos solo necesitan comunicarse con servidores de aplicaciones específicos dentro de una red privada o mediante un socket local. Escuchar en `*` expone la base de datos innecesariamente a redes públicas o no seguras.

9. **¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**  
   El sistema operativo es el guardián de los archivos físicos. Si los permisos en el SO son laxos (ej. si `data_directory` no tiene permisos `700`), un usuario local podría leer las tablas directamente del disco omitiendo por completo los usuarios y contraseñas de PostgreSQL.

10. **¿Qué controles deberían revisarse periódicamente?**  
    * Los roles activos y sus privilegios asignados (`pg_roles`).
    * Las reglas de red en `pg_hba.conf` y el firewall perimetral.
    * La validez y uso de certificados TLS (`pg_stat_ssl`).
    * Los logs de auditoría para detectar intentos fallidos de conexión o consultas inusuales.
    * Los permisos en el sistema de archivos del SO.

---

## 10. Reflexión

**¿Qué cambiarías primero si recibieras la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción?**

Si recibiera la responsabilidad de asegurar un servidor PostgreSQL en producción ya operativo, el **primer cambio** que realizaría sería **restringir la Exposición en Red (configurar el Firewall y acotar `pg_hba.conf` eliminando accesos `0.0.0.0/0`)**, garantizando que solo las direcciones IP explícitas de los servidores de aplicación autorizados puedan alcanzar el puerto 5432.

**Justificación:**

* **Riesgo y Exposición:** La exposición en red es la puerta de entrada para ataques remotos (escaneos automatizados, fuerza bruta o explotación de vulnerabilidades). Cerrar la red elimina el vector de ataque más crítico de forma inmediata.
* **Disponibilidad y Continuidad:** Configurar el firewall para permitir únicamente las IPs de la aplicación en producción asegura que el tráfico legítimo siga funcionando sin ninguna interrupción ni tiempo de caída (*downtime*).
* **Privilegios y Autenticación:** Reorganizar roles o cambiar métodos de autenticación en un sistema en vivo exige modificar el código o las configuraciones de las aplicaciones cliente, lo que conlleva un alto riesgo de romper el servicio si no se coordina previamente. En cambio, restringir la red bloquea a los atacantes externos inmediatamente sin alterar el funcionamiento interno de las aplicaciones autorizadas, permitiendo trabajar posteriormente en el resto de los controles de manera segura y ordenada.