
# Actividad 15 — Propuesta de arquitectura de datos protegidos

## 1. Objetivo

Diseñar una propuesta conceptual para separar la información de la base de datos de clientes de acuerdo con su finalidad, estableciendo controles de privacidad para proteger los datos personales y evitar accesos no autorizados.

## 2. Propuesta de separación de datos

La base de datos de clientes se divide conceptualmente en tres áreas: operación, analítica y auditoría. Cada una tiene una finalidad diferente y utiliza la información necesaria para cumplir sus funciones.

```text
                  BASE DE DATOS DE CLIENTES
                            |
           +----------------+----------------+
           |                |                |
           v                v                v
       OPERACIÓN         ANALÍTICA        AUDITORÍA
           |                |                |
           v                v                v
      Datos necesarios  Datos agregados   Registros de accesos,
      para atender      para estadísticas cambios y operaciones
      a los clientes                    realizadas
```

### Finalidad de cada área

- **Operación:** utiliza los datos necesarios para atender a los clientes y realizar las actividades de la empresa.
- **Analítica:** utiliza datos agregados para generar estadísticas y analizar información, evitando identificar a los clientes cuando no sea necesario.
- **Auditoría:** conserva registros de los accesos y cambios realizados para revisar quién efectuó cada operación y cuándo.

## 3. Controles de privacidad

| **Control** | **Propuesta técnica** |
|---|---|
| **Acceso** | Crear roles y permisos en PostgreSQL para que cada área de la empresa pueda consultar únicamente la información necesaria para realizar su trabajo. |
| **Minimización** | Crear estructuras separadas para cada finalidad y utilizar solamente los datos necesarios para cada operación. |
| **Protección de información sensible** | Clasificar los datos según su sensibilidad, limitar su acceso y cifrar aquellos que requieran protección reforzada. Cada tipo de dato almacenado debe contar con las medidas de protección adecuadas. |
| **Retención** | Definir plazos de conservación según la finalidad, las necesidades operativas y las obligaciones aplicables. Revisar periódicamente los datos para determinar cuándo dejan de ser necesarios. |
| **Trazabilidad** | Registrar las consultas, modificaciones y eliminaciones relevantes, incluyendo el usuario responsable, la fecha, la hora y la acción realizada. Esto permitirá revisar las operaciones y detectar posibles actividades no autorizadas. |
| **Eliminación** | Establecer un procedimiento para eliminar los datos cuando corresponda. Revisar también las copias de seguridad, réplicas, exportaciones y conjuntos utilizados para analítica para gestionar adecuadamente su eliminación. |
| **Atención de solicitudes** | Establecer un procedimiento para localizar los datos de una persona y atender sus solicitudes de acceso, rectificación, cancelación u oposición. Las áreas responsables determinarán cómo proceder y el DBA realizará las acciones técnicas autorizadas. |

## 4. Procedimiento

1. Identificar los datos personales almacenados en la base de datos de clientes.
2. Determinar la finalidad para la que se utiliza cada dato.
3. Separar conceptualmente la información destinada a operación, analítica y auditoría.
4. Definir roles y permisos para limitar el acceso según las responsabilidades de cada área.
5. Establecer medidas de protección, plazos de conservación, procedimientos de eliminación y mecanismos para atender solicitudes de los titulares.
6. Registrar las operaciones relevantes para facilitar la supervisión y la revisión de posibles incidentes.

## 5. Resultado

Se propone una arquitectura conceptual que organiza la información de acuerdo con su finalidad y establece siete controles de privacidad: acceso, minimización, protección de información sensible, retención, trazabilidad, eliminación y atención de solicitudes.

La propuesta permite definir cómo se protegerían los datos personales sin necesidad de implementar físicamente toda la arquitectura.

## 6. Análisis

Separar la información según su finalidad ayuda a reducir el acceso innecesario a los datos personales. Por ejemplo, el área de analítica puede trabajar con datos agregados para obtener estadísticas sin necesitar los nombres o correos de los clientes.

Además, los permisos permiten limitar quién puede consultar o modificar la información, mientras que la trazabilidad facilita revisar las operaciones realizadas. Los plazos de retención y los procedimientos de eliminación ayudan a evitar que los datos se conserven más tiempo del necesario.

## 7. Conclusión

Esta propuesta demuestra que los principios de privacidad pueden convertirse en decisiones técnicas para organizar y proteger una base de datos. Separar la información por finalidad y establecer controles de acceso, protección, conservación, trazabilidad, eliminación y atención de solicitudes contribuye a un manejo más seguro y responsable de los datos personales.