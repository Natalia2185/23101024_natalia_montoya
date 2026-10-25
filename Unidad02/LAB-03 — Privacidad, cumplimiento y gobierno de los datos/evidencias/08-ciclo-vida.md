
# Evidencia 08: Análisis del Ciclo de Vida y Cancelación de Datos

## Objetivo
Mapear la trazabilidad de los datos personales a lo largo de la infraestructura técnica para determinar el impacto de una solicitud de cancelación (Derechos ARCO).

## Procedimiento
1. Se analizó el flujo de los datos desde la tabla productiva `clientes` hacia otros entornos.
2. Se elaboró un mapa de trazabilidad identificando dependencias en tablas relacionadas, esquemas de analítica, réplicas de lectura, archivos de respaldo (*pg_dump*), registros de auditoría y exportaciones externas.
3. Se definió un procedimiento de purga coordinada.

## Resultado
clientes (Tabla principal en schema public)
   │
   ├── Tablas y vistas derivadas del laboratorio
   │   ├── clientes_soporte (Tabla segregada para atención a clientes)
   │   ├── v_analitica_clientes (Vista agregada con rangos de edad y ciudad)
   │   ├── pii.mapa_cliente (Tabla de tokens UUID para seudonimización)
   │   └── analitica.clientes (Tabla de analítica vinculada por token)
   │
   ├── Respaldos y archivos de persistencia
   │   ├── Archivos de respaldo de base de datos (pg_dump / backups lógicos)
   │   └── Archivos WAL (Write-Ahead Logging de PostgreSQL)
   │
   ├── Auditoría y registros del motor
   │   ├── Archivos de log del servidor (postgresql.log)
   │   └── Registros de la extensión pgaudit
   │
   └── Exportaciones y evidencias del laboratorio
       ├── Copias completas entregadas a desarrollo/pruebas
       └── Archivos de evidencias (01-inventario-datos.md, reportes SQL)

Pregunta

¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?

Ejecutar la sentencia DELETE sobre la tabla principal únicamente elimina el registro de la base de datos transaccional activa, pero la información personal suele continuar existiendo dentro de la organización porque permanece duplicada o vinculada en tablas derivadas y de soporte, archivos de transacciones y registros del motor, bitácoras de auditoría , respaldos históricos (backups), réplicas de lectura, bases de datos analíticas, entornos de desarrollo y pruebas, reportes o archivos exportados en local, y plataformas externas de terceros como servicios de facturación, por ello  la cancelación o eliminación efectiva de un dato exige una política coordinada sobre todo el ciclo de vida de la información y no solo la ejecución de un comando SQL.

## Análisis
Ejecutar una instrucción `DELETE` en la tabla principal no garantiza la desaparición total del dato personal. Si no se purgan coordinadamente las réplicas, respaldos y exportaciones, persiste el riesgo de filtración y no conformidad legal.

## Conclusión
Atender el derecho de cancelación exige un protocolo integral de ciclo de vida que abarque la depuración en sistemas activos, rotación de respaldos y desasociación en tablas derivadas.