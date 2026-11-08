
# Evidencia 05: Tratamiento de Finalidades Secundarias y Consentimiento

## Objetivo
Establecer los mecanismos técnicos para gestionar el consentimiento del usuario sobre finalidades secundarias (campañas de marketing) y atender el derecho de oposición.

## Procedimiento
1. Se evaluó el escenario donde el área de marketing utiliza los correos electrónicos para publicidad sin autorización explícita.
2. Se incorporó una bandera de consentimiento (`acepta_promociones BOOLEAN DEFAULT FALSE`) en el modelo.
3. Se diseñaron vistas filtradas que aíslan a los clientes que ejercieron su derecho de oposición (*opt-out*).

## Resultado
Mecanismo de control de consentimiento que bloquea automáticamente el envío de correos promocionales a titulares que no hayan otorgado su consentimiento explícito o que hayan solicitado su oposición.

1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad? No, según el Principio de Limitación de Finalidad tener los datos legalmente no autoriza a la organización a utilizarlos para finalidades distintas, en todo caso se tendría que pedir autorización.

2.¿Qué preguntas debería realizar la organización antes de implementar este tratamiento? Legitimidad del Aviso(enviar promociones), Gestión del Consentimiento(derecho a cancelación y consentimiento), Minimización de Datos(solicitar datos 100% necesarios), Evaluación de Riesgo y Destinatarios(los datos serán manejados solo internamente o también externamente), Aprobación Multidisciplinaria(el área legal aprobó antes de que el dba actúe).

3.¿Qué datos serían realmente necesarios? medio de contacto ya sea correo o whatsapp, atributos de segmentación es decir ciudad y edad, perfil, indicador de consentimiento osea si quieren recibir promociones o no.

4.¿Necesitaría el área de marketing acceso directo a clientes? No, marketing solo debería tener acceso a la sección de indicador de consentimiento para ver si quieren recibir promociones o no.

5.¿Qué controles técnicos podrían limitar la información entregada? Control de Acceso Basado en Roles, Enmascaramiento , Seudonimización, seguridad a nivel de fila, etc.

## Análisis
La oposición a una finalidad secundaria no implica la eliminación del cliente de la base de datos principal, ya que sus datos de contacto siguen siendo necesarios para la operación primaria (soporte y facturación).

## Conclusión
La separación lógica de finalidades mediante controles en la base de datos permite respetar la voluntad del titular sobre usos secundarios sin interrumpir la prestación del servicio principal.