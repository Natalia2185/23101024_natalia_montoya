# Línea Base de Seguridad (Antes vs. Después)

| Control | Antes | Después | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **`listen_addresses`** | `*` (Escucha en todas las interfaces) | `127.0.0.1` / Interfaces autorizadas | Aísla el motor de la red pública, reduciendo la superficie de ataque expuesta. |
| **`pg_hba.conf`** | Permisivo (métodos débiles, IPs abiertas) | Restringido a subredes específicas (ej. `10.10.10.0/24`) y conexiones `hostssl` | Aplica el principio de mínimo privilegio sobre el acceso de red a nivel de motor. |
| **Método de autenticación** | `trust` o `md5` | `scram-sha-256` | Garantiza autenticación desafío-respuesta con sal por usuario, resistente a intercepción y tablas *rainbow*. |
| **Usuarios administrativos** | Uso indistinto de la cuenta superusuario `postgres` | Rol `DBA` separado con `superuser_reserved_connections = 3` | Garantiza canal de rescate administrativo y permite una auditoría clara de acciones. |
| **Cuentas de aplicación** | Aplicaciones conectadas con permisos administrativos | Cuentas segregadas: `APP` (mínimos privilegios) y `CONSULTA` (solo lectura) | Mitiga el impacto de fallas de seguridad de la aplicación como Inyección SQL (SQLi). |
| **Puerto** | Puerto `5432` expuesto sin reglas perimetrales | Puerto `5432` filtrado por Firewall (Permitir solo Red DBA `10.10.10.0/24`) | Bloquea conexiones no autorizadas en capas 3 y 4 antes de consumir recursos del motor. |
| **TLS** | `ssl = off` (Tráfico transmitido en texto claro) | `ssl = on` con `ssl_min_protocol_version = TLSv1.2` | Previene la captura de credenciales y la intercepción de tráfico confidencial en la red (*sniffing*/MiTM). |
| **Permisos SO** | Permisos permisivos en el sistema de archivos host | `700` en `data_directory`, `640` en `pg_hba.conf` (propietario `postgres`) | Impide que usuarios locales sin privilegios lean directamente archivos físicos de datos o configuraciones. |
| **Extensiones** | Riesgo de extensiones innecesarias (`dblink`, `file_fdw`) | Únicamente `plpgsql` (1.0) nativa instalada | Aplica el principio *Secure by default*: habilita exclusivamente las funciones requeridas. |
| **Conexiones** | `statement_timeout = 0`, `idle_in_transaction_session_timeout = 0` | `statement_timeout = '30s'`, `idle_in_transaction_session_timeout = '10min'` | Protege contra Denegación de Servicio (DoS), agotamiento de RAM y saturación de bloqueos (*bloat*). |