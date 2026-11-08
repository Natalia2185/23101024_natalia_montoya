# 26. Informe final

## 1. Introducción
El problema de privacidad abordado consiste en proteger los datos personales almacenados en una base de datos de clientes. Si la información no se administra correctamente, personas no autorizadas podrían consultarla, utilizarla para otras finalidades o conservarla durante más tiempo del necesario. Por eso, es fundamental establecer controles de acceso, medidas de protección y procedimientos para administrar los datos de manera responsable.

## 2. Inventario de datos

| Dato | Clasificación |
| :--- | :--- |
| **ID del cliente** | Atributo técnico / Identificador indirecto |
| **Nombre** | Identificador directo |
| **Correo electrónico** | Identificador directo |
| **Teléfono** | Identificador directo |
| **RFC** | Identificador directo |
| **Edad** | Cuasi-identificador |
| **Ciudad** | Cuasi-identificador |
| **Código postal** | Cuasi-identificador |
| **Fecha de alta** | Metadato técnico |

## 3. Finalidades
* **Atención al cliente:** Utilizar el nombre, correo electrónico y teléfono para atender consultas y comunicarse con los clientes.
* **Facturación:** Utilizar el nombre, RFC y demás datos fiscales necesarios para elaborar comprobantes.
* **Analítica:** Utilizar datos agregados para generar estadísticas y conocer tendencias sin identificar a los clientes cuando no sea necesario.
* **Auditoría:** Registrar accesos y modificaciones relevantes para revisar las operaciones realizadas en la base de datos.

## 4. Minimización
En este caso, cada área debe trabajar exclusivamente con los datos indispensables para su función. Por ejemplo, el área de analítica puede trabajar con estadísticas agrupadas por ciudad sin consultar los nombres, correos electrónicos o teléfonos de los clientes. Asimismo, el área de atención al cliente no necesita consultar el RFC si no es necesario para resolver una solicitud.

## 5. Control de acceso
Se establece mediante roles y permisos en PostgreSQL. Cada usuario tiene acceso únicamente a la información que necesita para realizar sus funciones:
* **Atención a clientes:** Datos de contacto y requeridos para atender solicitudes.
* **Facturación:** Nombre, RFC y datos fiscales.
* **Analítica:** Datos agregados e información anonimizada.
* **Auditoría:** Registros de acceso, cambios y operaciones relevantes.
* **DBA:** Únicamente lo necesario para administrar, mantener y proteger la base de datos.

Cada uno de estos permisos fue asignado dependiendo de las necesidades de cada rol.

## 6. Derechos ARCO
* **Acceso:** Consultas SQL específicas para extraer el expediente completo del cliente y la metadata de su tratamiento.
* **Rectificación:** Instrucciones `UPDATE` sobre campos de contacto, acompañadas de registros de auditoría que documentan la autorización del cambio.
* **Cancelación:** Procedimientos de borrado seguro o purga coordinada que eliminan el registro no solo en la tabla activa, sino también en réplicas, vistas derivadas y respaldos.
* **Oposición:** Configuración de banderas de consentimiento (`acepta_promociones BOOLEAN DEFAULT FALSE`) para deshabilitar el uso de datos en campañas promocionales de marketing sin afectar la operación legal.

La empresa debe contar con un procedimiento formal para recibir, verificar, evaluar y responder las solicitudes. El DBA puede realizar las operaciones técnicas autorizadas, pero no debe decidir por sí solo si una solicitud procede legalmente.

## 7. Retención
La empresa debe establecer plazos para cada categoría de información y revisarlos periódicamente. Cuando los datos dejen de ser necesarios y no exista una obligación legal que justifique conservarlos, debe aplicarse el procedimiento correspondiente de eliminación o anonimización. Asimismo, deben considerarse las copias de seguridad, réplicas y exportaciones para evitar que la información permanezca indefinidamente en otros sistemas.

## 8. Gobierno de datos

| Responsable | Funciones principales |
| :--- | :--- |
| **DBA** | Administrar la base de datos, configurar permisos, aplicar medidas técnicas de seguridad y ejecutar eliminaciones autorizadas. |
| **Responsable de privacidad** | Coordinar las medidas de privacidad, revisar el tratamiento de datos y participar en la atención de solicitudes. |
| **Área jurídica** | Orientar sobre las obligaciones legales, los plazos de conservación y las implicaciones de las solicitudes. |
| **Propietario de los datos / Responsable del área** | Definir las necesidades de información de su área y justificar los datos necesarios para sus actividades. |
| **Desarrolladores** | Crear y mantener aplicaciones utilizando únicamente los datos necesarios y evitando exponer información personal. |

## 9. Evaluación integral
Se identificaron diversos riesgos operativos en la organización, tales como:
1. Acceso directo del equipo de analítica a datos nominales de clientes.
2. Conservación de información personal durante 12 años sin política de retención.
3. Entrega de copias con datos reales de producción a desarrolladores.
4. Uso de correos para marketing sin verificación de consentimiento (*opt-in*).
5. Ausencia de documentación sobre la finalidad asignada a cada campo.
6. Falta de enmascaramiento en vistas operativas para el personal de soporte.
7. Falta de auditoría sobre consultas a datos fiscales sensibles.
8. Almacenamiento de cadenas de texto libre sin cifrado ni restricciones de dominio.
9. Inexistencia de un procedimiento técnico automatizado para el borrado por derechos ARCO.
10. Ausencia de segregación de funciones entre roles técnicos y de negocio.

## 10. Conclusiones
Administrar una base de datos no consiste solamente en guardar información y mantenerla disponible; también es necesario proteger los datos personales, controlar quién puede consultarlos y definir para qué se utilizan. La privacidad, la seguridad y la administración de bases de datos están íntimamente relacionadas, ya que las decisiones técnicas pueden reducir o aumentar los riesgos para las personas. Por ello, es fundamental aplicar permisos adecuados, minimizar los datos, establecer plazos de conservación y contar con procedimientos para atender solicitudes y eliminar información cuando corresponda.

---

# 27. Preguntas de reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
No. A pesar de que la base de datos cuente con contraseñas, cifrado y controles de acceso, utilizar los datos para finalidades no justificadas o conservarlos más tiempo del necesario genera un riesgo de incumplimiento legal. La privacidad requiere reglas claras sobre el uso, la finalidad y la administración responsable de la información.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque limita el acceso de cada usuario estrictamente a los datos que necesita para realizar su trabajo. Con ello se reduce la superficie de exposición y la posibilidad de que alguien consulte, modifique o divulgue información personal sin autorización o justificación de negocio.

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque el DBA es el responsable de la administración técnica de la base de datos, no del negocio ni del marco regulatorio. Las finalidades deben definirse conjuntamente con las áreas propietarias del proceso (*Data Owners*), considerando el aviso de privacidad, los contratos y las obligaciones legales.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
Porque las bases de datos de producción contienen información personal y sensible real que los desarrolladores no necesitan para programar o probar. Entregar copias completas incrementa innecesariamente los puntos de vulnerabilidad y el riesgo de filtraciones.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Porque los entornos de desarrollo y pruebas suelen almacenarse en computadoras personales o servidores locales que no poseen el mismo nivel de seguridad, cifrado, monitoreo ni restricciones de acceso que el servidor de producción, dejando la PII expuesta.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque conservar datos de manera indefinida genera un pasivo legal y aumenta el daño potencial ante una eventual brecha de seguridad. La retención garantiza que la información se borre o anonimice oportunamente en cuanto cumpla su plazo legal u operativo.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
La privacidad por diseño consiste en incorporar la protección de datos desde la planificación del sistema. En una base de datos, esto se traduce en estructurar esquemas separados por finalidad, limitar permisos, aplicar minimización y definir mecanismos de retención y borrado desde la fase inicial de modelado.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
Implementaría control de acceso basado en roles (RBAC), el principio de menor privilegio, enmascaramiento dinámico de datos, cifrado de columnas sensibles con `pgcrypto`, registros de auditoría (`pgaudit`), seguridad a nivel de fila (RLS) y el uso exclusivo de datos sintéticos o anonimizados en entornos de prueba.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
Debería conocer la ubicación exacta de los datos del titular (tablas, esquemas, réplicas, vistas y respaldos), las relaciones con otras tablas por llaves foráneas, quiénes tienen acceso a ellos, y las instrucciones o procedimientos almacenados autorizados para ejecutar la consulta, modificación, bloqueo o eliminación solicitada.

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?
* **DBA:** Ejecutar las tareas técnicas autorizadas, configurar los permisos y proteger la infraestructura de la base de datos.
* **Responsable de privacidad:** Coordinar las políticas de protección de datos y supervisar la atención de solicitudes ARCO.
* **Área jurídica:** Orientar sobre el cumplimiento normativo (LFPDPPP), contratos, avisos de privacidad y plazos legales de conservación.
* **Propietario de los datos:** Justificar la necesidad de la información para su área, autorizar los niveles de acceso y definir el uso operativo que se le dará a los datos.