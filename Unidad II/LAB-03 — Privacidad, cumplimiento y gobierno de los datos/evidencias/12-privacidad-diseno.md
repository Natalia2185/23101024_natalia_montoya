
# Evidencia 12: Evaluación de Privacidad por Diseño

## Objetivo
Evaluar una propuesta de modelo de datos bajo los principios de Privacidad por Diseño y por Defecto para eliminar la recolección desproporcionada de información.

## Procedimiento
1. Se examinó una propuesta de tabla con 13+ campos (incluyendo `salario`, `estado_civil`, `ocupacion`).
2. Se identificaron los riesgos de recopilar información innecesaria "por si acaso".
3. Se reestructuró el DDL eliminando campos irrelevantes y configurando opciones por defecto orientadas a la privacidad.

## Resultado
Modelo DDL minimizado que elimina atributos especulativos y establece banderas de privacidad restrictivas por defecto (`DEFAULT FALSE`).

Preguntas

1.-¿Qué problemas identificas? 
El desarrollador propone juntar datos de más "por si acaso se necesitan después", guardando información muy privada que no hace falta para el sistema y usa campos de texto libres sin reglas que limiten qué se puede escribir, y sin incluir casillas para pedir ni guardar el permiso del usuario.

2.-¿Qué principio de privacidad se está ignorando? 
Se están ignorando la minimización de datos (pedir únicamente lo que se va a usar), la limitación de la finalidad (tener un motivo claro para cada dato) y la privacidad por diseño (proteger la información del cliente desde el momento en que se crea la base de datos).

3.-¿Qué preguntas realizarías antes de aprobar el diseño? 
Preguntaría para qué trabajo necesita la empresa saber el salario o el estado civil del usuario, si tenemos permiso legal para pedir la fecha de nacimiento completa en vez de solo revisar si es mayor de edad, y qué personas dentro de la empresa van a poder ver esos datos guardados.

4.-¿Qué datos eliminarías? 
Borraría los campos de salario, estado civil y ocupación, porque no se ocupan para registrar al cliente ni para atenderlo.

5.-¿Qué datos requerirían una justificación adicional? 
Pediría una razón clara antes de guardar la fecha de nacimiento, la dirección completa y el RFC.

6.-¿Cómo aplicarías privacidad por defecto? 
Crearía la tabla solo con los datos básicos para operar, dejaría la casilla de enviar promociones desactivada por defecto, y usaría permisos y vistas en la base de datos para que cada empleado únicamente vea la información que necesita para su trabajo.

## Análisis
Guardar datos innecesarios viola los principios de proporcionalidad y minimización, aumentando el impacto ante filtraciones de información sin aportar valor operativo real al negocio.

## Conclusión
Aplicar Privacidad por Diseño desde la fase de modelado de la base de datos evita costos futuros de remediación y protege la confidencialidad desde el origen.