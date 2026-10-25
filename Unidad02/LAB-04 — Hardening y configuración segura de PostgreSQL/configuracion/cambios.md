# Registro Detallado de Cambios de Hardening

## 1. Seguridad de Red
* **Interfaces de escucha:** Modificación de `listen_addresses` a `127.0.0.1` en `postgresql.conf`.
* **Firewall perimetral:** Definición de política conceptual para el puerto 5432 (Permitir `10.10.10.0/24`, Denegar `0.0.0.0/0`).
* **Reglas de acceso (`pg_hba.conf`):** Restricción de entradas a subredes específicas obligando autenticación `scram-sha-256`.

## 2. Gestión de Identidades y Roles
* **Aislamiento de Superusuario:** Desuso de `postgres` en la capa de aplicación.
* **Segregación de funciones:**
  * Creación de rol `DBA` para tareas de mantenimiento.
  * Creación de rol `APP` con privilegios DML acotados (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).
  * Creación de rol `CONSULTA` con permisos exclusivos de lectura (`SELECT`).

## 3. Parámetros Operativos
* **`statement_timeout`:** Fijado en `30s` para abortar consultas pesadas o maliciosas.
* **`idle_in_transaction_session_timeout`:** Fijado en `10min` para liberar bloqueos e inactividad.
* **`superuser_reserved_connections`:** Configurado en `3` para garantizar canal de emergencia.

## 4. Protección del Sistema Operativo y Cifrado
* **Permisos del directorio de datos:** Máscara `700` (`drwx------`) sobre `/var/lib/postgresql/16/main`.
* **Permisos de archivos de configuración:** Permisos `640` sobre `pg_hba.conf` y `postgresql.conf` bajo usuario/grupo `postgres:postgres`.
* **TLS:** Activación de `ssl = on` con `ssl_min_protocol_version = TLSv1.2`.