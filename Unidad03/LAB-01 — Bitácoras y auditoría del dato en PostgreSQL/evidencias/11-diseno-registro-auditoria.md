# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# Actividad 10 — Diseñar y crear el registro de auditoría

Preguntas

1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?TIMESTAMPTZ guarda la fecha y la hora registrando también la zona horaria, lo que permite saber con total precisión en qué instante real ocurrió un evento sin importar en qué país se encuentre el servidor, la ubicación del cliente o si hay cambios de horario de verano.

2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió? Se guarda todo el registro en JSONB porque conserva una fotografía completa de la fila y su contexto original, facilitando la comparación de datos previos y nuevos de forma flexible sin tener que modificar la tabla de auditoría cada vez que se agreguen o eliminen columnas en la tabla auditada.

3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso? Implica que la tabla de auditoría debe clasificarse como un contenedor de datos personales sensibles (PII), por lo que requiere un control de acceso sumamente restringido donde solo el DBA o el auditor de seguridad puedan consultarla, evitando que usuarios no autorizados expongan información confidencial leyendo la bitácora.