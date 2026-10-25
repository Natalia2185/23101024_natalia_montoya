
# Evidencia 14: Evaluación Integral de Riesgos y Controles

## Objetivo
Identificar, clasificar y mitigar los riesgos derivados del mal manejo de datos personales en el escenario operativo de Comercializadora Norte S.A. de C.V.

## Procedimiento
1. Se analizó el caso de estudio detectando las deficiencias técnicas y administrativas.
2. Se construyó una matriz de 10 problemas asociando el principio violado, el riesgo generado y el control técnico propuesto.

## Resultado

| Problema | Principio afectado | Riesgo | Control propuesto |
| :--- | :--- | :--- | :--- |
| La empresa tiene una base de datos con información de 50,000 clientes. | Seguridad de la Información | Si un atacante entra, se roba la información de todos los clientes de un solo golpe. | Separar los datos en vistas protegidas y cifrar la información sensible con `pgcrypto`. |
| Todos los empleados del área de analítica pueden consultar directamente la tabla clientes. | Menor Privilegio | Un empleado podría copiar o vender la lista de clientes con nombres y teléfonos. | Quitarles el acceso directo a la tabla y darles solo vistas con datos generales. |
| La tabla contiene nombre, correo, teléfono, RFC, edad, ciudad y código postal. | Minimización de Datos | Cualquiera que revise un dato sencillo (como una ciudad) ve también el RFC o teléfono. | Dividir los datos en tablas o vistas separadas según lo que ocupa cada departamento. |
| El área de analítica únicamente genera estadísticas mensuales. | Minimización de Datos | Ver nombres reales para hacer simples sumas o promedios expone la privacidad sin necesidad. | Entregarles solo totales, promedios y grupos generales de población (sin nombres). |
| Los datos se conservan desde hace 12 años. | Retención de Datos | Guardar información vieja de exclientes aumenta el daño en caso de un robo de información. | Crear una regla automática para borrar o archivar datos después de 5 años. |
| No existe una política documentada de retención. | Responsabilidad / Gobierno | Borrar o guardar datos al azar, lo que trae multas en una auditoría. | Escribir y publicar una política oficial de retención de datos. |
| Los desarrolladores reciben copias completas de la base de datos para realizar pruebas. | Confidencialidad | Las computadoras de desarrollo tienen menos seguridad y pueden sufrir robos de información. | Prohibir copias reales y usar datos inventados (ficticios) para hacer pruebas. |
| Las copias de desarrollo contienen información real. | Privacidad por Defecto | Los datos reales quedan expuestos en laptops o chats de trabajo de los programadores. | Enmascarar u ocultar los nombres y correos reales antes de mandarlos a desarrollo. |
| El área de marketing utiliza los correos electrónicos para campañas promocionales. | Consentimiento del Usuario | La empresa puede recibir multas legales por enviar publicidad no deseada (spam). | Poner una casilla que por defecto diga "No acepta publicidad" hasta que el cliente diga sí. |
| No existe documentación clara sobre qué finalidad corresponde a cada dato. | Transparencia | No saber por qué tenemos un dato ni poder responder a solicitudes de clientes o auditorías. | Crear un catálogo sencillo donde se anote para qué se usa cada dato y quién es el responsable. |

## Análisis
La combinación de múltiples deficiencias en el manejo de datos incrementa drásticamente la vulnerabilidad de la empresa, exponiéndola a multas severas y pérdida de reputación.

## Conclusión
La evaluación integral permite priorizar remediaciones técnicas y transicionar de una postura reactiva a un modelo de gobierno de datos proactivo y conforme a la ley.