
# Evidencia 01: Inventario y Clasificación de Datos

## Objetivo
Identificar y clasificar todos los atributos almacenados en la tabla clientes según su sensibilidad, tipo de dato (identificador directo, cuasi-identificador, metadato) y requerimientos de protección.

## Procedimiento
1. Se analizó la estructura DDL de la tabla clientes.
2. Se evaluó cada campo (`id`, `nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal`, `fecha_alta`).
3. Se construyó una matriz clasificando los datos en identificadores directos, cuasi-identificadores y atributos técnicos, asignando la finalidad de negocio y tiempo de retención para cada uno.

## Resultado
| Campo | Clasificación | ¿Es dato personal? | Finalidad | Nivel de acceso | Retención |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | Atributo técnico | No (directo) | Identificador único interno | Soporte, Facturación, DBA | Fin de cuenta + 5 años |
| `nombre` | Identificador directo | Sí | Identificación para atención y facturación | Soporte, Facturación | Fin de cuenta + 5 años |
| `correo` | Identificador directo | Sí | Contacto principal y notificaciones | Soporte, Facturación | Fin de relación |
| `telefono` | Identificador directo | Sí | Atención directa y soporte | Soporte | Fin de relación |
| `rfc` | Identificador directo | Sí | Emisión de comprobantes fiscales (CFDI) | Facturación | 5 años (Art. 30 CFF) |
| `edad` | Cuasi-identificador | Sí | Segmentación demográfica | Analítica (Agregado) | Inmediata / Agregado |
| `ciudad` | Cuasi-identificador | Sí | Logística y análisis regional | Soporte, Analítica | Duración del servicio |
| `codigo_postal` | Cuasi-identificador | Sí | Cálculo fiscal e impuestos regionales | Facturación, Logística | 5 años contables |
| `fecha_alta` | Metadato técnico | No | Registro de auditoría y antigüedad | DBA, Analítica | Indefinido |

## Análisis
La tabla original concentra atributos con propósitos operativos dispares. Permitir el acceso directo de cualquier área a la tabla completa expone datos sensibles (como el RFC o teléfono) a usuarios que no los necesitan para realizar sus funciones.

## Conclusión
El inventario y clasificación de datos es el pilar del gobierno de datos. Permite aplicar el principio de minimización garantizando que cada rol acceda únicamente a la información indispensable para sus tareas.