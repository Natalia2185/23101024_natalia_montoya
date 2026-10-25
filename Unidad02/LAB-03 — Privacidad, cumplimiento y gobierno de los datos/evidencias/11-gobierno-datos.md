
# Evidencia 11: Matriz de Gobierno de Datos

## Objetivo
Asignar responsabilidades, usuarios autorizados, medidas de protección y acciones de fin de ciclo para cada atributo de la base de datos.

## Procedimiento
1. Se definieron los roles organizacionales (*Data Owner*, Usuarios autorizados, DBA).
2. Se cruzó cada campo de la entidad `clientes` con su finalidad, esquema de protección (`pgcrypto`, RBAC, enmascaramiento), plazo de retención y acción final.

## Resultado

| Dato | Finalidad | Responsable (Data Owner) | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| nombre | Identificación del cliente para atención y facturación. | Gerente de Atención al Cliente | Atención al cliente, Facturación | Control de acceso por rol (RBAC), Vistas restringidas | Fin de la relación + 5 años legales | DELETE en producción y backups |
| correo | Medio de contacto principal y notificaciones transaccionales. | Gerente de Marketing / Operaciones | Atención al cliente, Facturación | Máscara parcial en ambientes de prueba | Fin de la relación o retiro del consentimiento | Inclusión en lista de cosas bloqueadas. |
| teléfono | Contacto directo y soporte de incidencias. | Gerente de Operaciones | Atención al cliente | Restricción RLS, Cifrado a nivel de columna/vista | Fin de la relación contractual | Borrado seguro de la columna/registro |
| rfc | Emisión de comprobantes fiscales. | Director de Finanzas y Contabilidad | Facturación | Cifrado simétrico, Acceso restringido por rol | 5 años contables | Eliminación definitiva o Archivo contable sellado |
| edad | Segmentación demográfica y elegibilidad. | Director de Analítica | Analítica | Agregación por rangos, no se expone edad nominal | Durante el análisis comercial | Anonimización irreversible |
| ciudad | Logística y análisis demográfico regional. | Director de Analítica | Atención al cliente, Analítica, Dirección | Agregación por zona geográfica | Indefinido (desasociado de la identidad) | Pasa a ser dato estadístico histórico |
| codigo_postal | Cálculo fiscal e impuestos regionales. | Gerente de Logística | Facturación, Logística | RBAC, Generalización. | 5 años tras la operación | Borrado definitivo o generalización. |

## Análisis
Sin una matriz explícita, la asignación de accesos se vuelve caótica, permitiendo que áreas como Analítica o Desarrollo consulten PII sensible sin justificación operativa.

## Conclusión
La matriz de gobierno formaliza la responsabilidad sobre los datos, garantizando que el acceso se otorgue únicamente por estricta necesidad funcional.