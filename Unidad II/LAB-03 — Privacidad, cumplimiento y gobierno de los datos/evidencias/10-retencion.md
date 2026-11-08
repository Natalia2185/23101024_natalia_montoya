# Evidencia 10: Política de Retención y Depuración de Datos

## Objetivo
Diseñar y fundamentar una política de retención de datos personales que evite la conservación indefinida de información y reduzca los riesgos asociados.

## Procedimiento
1. Se analizó la propuesta de mantener datos de clientes de manera indefinida.
2. Se estableció un plazo límite de 5 años posterior al fin de la relación comercial, fundamentado en obligaciones fiscales (Art. 30 CFF).
3. Se construyó una consulta de verificación (`WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years'`) y se definieron los requisitos para el proceso de depuración (aprobaciones, respaldo previo, bitácora).

## Resultado
Regla formal de retención a 5 años con un procedimiento de purga automatizada que requiere respaldo en frío cifrado, autorización formal de DPO/TI y registro inmutable en bitácora.

Responde:

Pregunta 1.- ¿Es compatible con el principio de minimización? 

No de hecho es todo lo contrario a ese principio ya que la ley y los marcos de gobierno de datos exigen que los datos personales sólo se recaben y conserven durante el tiempo estrictamente necesario para cumplir con la finalidad informada y autorizada por el titular, osea que mantener datos de forma especulativa o indefinida carece de base jurídica e infringe los derechos de privacidad.

Pregunta 2.- ¿Qué riesgos genera conservar información innecesaria? 

Riesgos como el aumento de superficie la cual pueden atacar, impacto de rendimiento e infraestructura es decir tener un exceso de información en las bases de datos, responsabilidad legal y sanciones puede ocurrir que haya multas debido a la falta de justificación de mantener esos datos innecesariamente y dificultad de gestión de derechos ARCO puede ocurrir que al realizar alguno de los derechos (solicitudes de Acceso, Cancelación u Oposición ) haya demasiada información de registros sin depurar. 

Pregunta 3.- ¿Qué debería determinar la organización antes de establecer un periodo de retención?

Leyes sectoriales, fiscales y mercantiles, plazos de prescripción de acciones legales, vigencia de la relación comercial y el ciclo de vida y obsolescencia del dato.

Pregunta 4.- ¿Qué información debería documentarse para justificar el periodo seleccionado? 

Para justificar ante una auditoría por qué guardamos los datos durante cierto tiempo, solo debemos tener un documento que explique qué ley o regla nos exige ese plazo, para qué usamos cada dato y cuántos años lo mantendremos, los riesgos de conservarlo frente a borrarlo, y el paso a paso técnico de cómo los eliminaremos o borraremos para siempre cuando se venza el plazo.

## Análisis
Conservar información de exclientes por más de 12 años viola el principio de minimización y retención limitada, incrementando innecesariamente el daño en caso de un incidente de seguridad o robo de información.

## Conclusión
Establecer periodos de conservación definidos reduce la superficie de ataque de la base de datos y garantiza el cumplimiento con el marco legal de protección de datos.