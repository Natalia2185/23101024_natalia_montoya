# UNIVERSIDAD AUTÓNOMA DE SINALOA
## FACULTAD DE INFORMÁTICA CULIACÁN
### Licenciatura en Informática

**Profesor:** Alexis Moises Montaño Araujo  
**Alumna:** Montoya Martinez Natalia  
**Grupo:** 4-1  

---

## Actividad 6 — Análisis del riesgo de reidentificación

### Preguntas de análisis

* **¿Qué identificadores directos fueron eliminados?**  
  Los datos que permiten identificar a las personas directamente o que son datos sensibles, como el RFC, el nombre, el correo y el teléfono.

* **¿Qué cuasi-identificadores permanecen?**  
  El rango de edad y los primeros dos dígitos del código postal (región).

* **¿Qué combinaciones de atributos podrían reducir el anonimato?**  
  La combinación de la región geográfica y el rango de edad al vincularse con datos externos.

* **¿Qué sucede cuando un grupo contiene pocos registros?**  
  Ocurre el fenómeno de aislamiento de registros (*singling out*), donde al haber muy pocos registros existe mayor probabilidad de que se identifique individualmente a las personas.

* **¿Qué atributos deberían generalizarse?**  
  La edad por rangos para dificultar la identificación, el código postal para mostrar únicamente la ciudad o zona en lugar de la colonia, y la fecha limitándose solo a mes y año.

* **¿Qué información debería suprimirse?**  
  Aquella información que esté fuera del rango establecido o que corresponda a registros extremadamente raros (casos atípicos).

* **¿Es correcto afirmar que el conjunto de datos es “100% anónimo”? ¿Por qué?**  
  No, nunca puede llegar a ser 100% anónimo porque aunque se cumpla con el rango, siempre existe el riesgo residual de que las personas compartan los mismos datos o que alguien combine dos tablas y obtenga la información.

### Reto
Modificar la consulta anterior para reducir aún más el riesgo de reidentificación.

![Reto](<Captura desde 2026-10-18 13-42-50.png>)

Se generalizó el código postal a 1 solo dígito y los rangos de edad se redujeron a sólo dos categorías, buscando reducir la precisión de la ubicación y edad para agrupar a más clientes dentro de la misma categoría. El resultado fue que en la base de datos de prueba la consulta arrojó 0 registros. Esto ocurre porque los 5 clientes quedan divididos en dos grupos (un grupo de 3 y otro de 2 personas); al no alcanzar ninguno la cuota mínima de $k = 5$, el filtro suprime ambas filas. Con ello se pretende minimizar el riesgo de reidentificación por cruce de datos con fuentes externas (ataques de enlace), asegurando que ningún grupo pequeño quede expuesto.

---

### 19.1 Clasificación

Los datos de la tabla `clientes` se clasificaron según su sensibilidad. Los campos `nombre`, `correo`, `telefono` y `rfc` se definieron como identificadores directos que exigen protección estricta por revelar la identidad del titular. Los datos `edad`, `ciudad` y `codigo_postal` son cuasi-identificadores que deben protegerse porque su combinación permite reidentificar personas. El `id` y la `fecha_alta` se mantuvieron como atributos técnicos de control interno y gestión del periodo de retención.

---

### 19.2 Enmascaramiento

Se ocultaron parcialmente el `correo`, `telefono` y `rfc` para el rol `soporte_natalia_montoya` con el fin de permitir la validación de clientes sin exponer la PII completa, aplicando el menor privilegio. Para esto se creó la vista `v_clientes_soporte` utilizando funciones de cadena que reemplazan los datos sensibles por asteriscos, revocando a la vez el acceso directo sobre la tabla `public.clientes`.

---

### 19.3 Seudonimización

Los tokens UUID se generaron con la función `gen_random_uuid()` del módulo `pgcrypto`. La relación entre tokens e identidades se guarda en la tabla `pii.mapa_cliente` dentro del esquema confidencial `pii`, cuyo acceso se limita al DBA o DPO. Se aislaron los esquemas para cumplir con la separación de funciones, impidiendo que el rol `analista_natalia_montoyaa` consulte el mapa y revierta la seudonimización.

---

### 19.4 Anonimización

En el conjunto analítico se eliminaron todos los identificadores directos. La `edad` se generalizó en rangos y el `codigo_postal` en regiones geográficas, aplicando $k$-anonimato con `HAVING COUNT(*) >= 5` para suprimir grupos pequeños y evitar el aislamiento de personas. A pesar de esto, se mantiene el riesgo de reidentificación por cruce con fuentes de datos externas que compartan los mismos cuasi-identificadores.

---

### 19.5 Retención

Se definió una regla de retención a 5 años mediante la consulta `WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years'`. Debe conservarse la información de clientes activos dentro del plazo legal y depurarse los registros inactivos antiguos. Antes de eliminar datos, deben existir aprobaciones formales (DPO/TI), respaldo previo en frío, bitácora de borrado y un procedimiento de restauración en un ambiente aislado.

---

### 19.6 Conclusiones

* **¿Qué técnica utilizarías para un área de soporte?**  
  **Enmascaramiento dinámico (*Masking*):** Para permitir la consulta parcial de los datos necesarios en la atención a clientes (como los últimos dígitos del teléfono o RFC) mediante vistas restringidas, evitando exponer la información completa.

* **¿Qué técnica utilizarías para un área de analítica?**  
  **Seudonimización (*Pseudonymization*):** Sustituyendo los identificadores directos por tokens sustitutos (UUID), lo que permite estudiar tendencias y patrones sin vincular los datos directamente a la persona.

* **¿Qué técnica utilizarías para publicar estadísticas?**  
  **Anonimización (*Anonymization*):** Mediante agregación, generalización en rangos/regiones y supresión de grupos pequeños ($k$-anonimato) para evitar el aislamiento de registros y reducir el riesgo de reidentificación.

* **¿Por qué ninguna de estas técnicas sustituye al control de acceso?**  
  Porque la transformación de datos solo modifica la forma o vista en que se presenta la información, pero no limita la capacidad de un usuario para consultar objetos no autorizados. Si no se aplican permisos explícitos (`GRANT`/`REVOKE`), cualquier persona podría eludir la vista o acceder directamente a las tablas originales.

---

## 20. Preguntas de reflexión

1. **¿Cuál es la diferencia entre enmascaramiento y seudonimización?**  
   El enmascaramiento crea una visualización modificada u ocultada del dato (por ejemplo, mostrando asteriscos) sin alterar el valor original almacenado. La seudonimización sustituye el identificador directo por un valor sustituto (token UUID) y mantiene la relación original aislada en una tabla de correspondencia.

2. **¿Por qué la seudonimización no significa anonimización?**  
   Porque la seudonimización es reversible; si un usuario obtiene acceso a la tabla de correspondencia, puede recuperar la identidad real del titular. La anonimización busca ser un proceso irreversible.

3. **¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo?**  
   Porque los atributos restantes (como la edad, el código postal o la ciudad) actúan como cuasi-identificadores. Al combinarse entre sí o cruzarse con otras fuentes de datos externas, pueden permitir la reidentificación de una persona.

4. **¿Qué función tienen los cuasi-identificadores?**  
   Son datos que por sí solos no identifican directamente a un individuo, pero que al combinarse con otros atributos reducen el grupo de búsqueda hasta individualizar a un usuario dentro de una población.

5. **¿Por qué es importante separar el mapa de seudonimización?**  
   Para evitar que usuarios no autorizados (como los del área de analítica) puedan cruzar ambas tablas mediante un `JOIN` y comprometer la privacidad de los usuarios.

6. **¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?**  
   El principio de Separación de Funciones (*Separation of Duties - SoD*) y el de Menor Privilegio.

7. **¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?**  
   Porque funciona como una capa de abstracción intermedia que permite restringir filas y columnas sensibles o aplicar reglas de enmascaramiento, entregando únicamente los datos autorizados sin otorgar permisos sobre la tabla base.

8. **¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?**  
   Proteger para visualización condiciona cómo se presenta la consulta (`SELECT`), pero el usuario mantiene permisos sobre el objeto. Proteger contra acceso no autorizado utiliza el control de accesos (`REVOKE`) para impedir que el usuario pueda consultar, modificar o extraer los objetos no permitidos en el motor de base de datos.

9. **¿Por qué la retención forma parte de la protección de datos?**  
   Porque atiende al principio de minimización de datos: al conservar la información personal únicamente durante el tiempo estrictamente necesario, se reduce el impacto y el riesgo ante un eventual incidente de seguridad.

10. **¿Qué riesgo existe si una organización conserva información indefinidamente?**  
    Aumenta innecesariamente la superficie de ataque, incrementa los costos de infraestructura y almacenamiento, y expone a la organización a sanciones legales o regulatorias por incumplir las normativas de conservación.