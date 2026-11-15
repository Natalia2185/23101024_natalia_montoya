# Actividad 8 — Conservación: exportar antes de perder

Preguntas

1. Tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin borrado deliberado:

*Reinicio del servicio mongod: La memoria volátil utilizada por getLog se vacía completamente al reiniciar el motor, y el nivel de perfilado activo se restablece automáticamente a 0 (apagado).

*Sobrescritura en system.profile por colección limitada (capped collection): Al alcanzar su tamaño máximo por defecto (1 MB), los registros más antiguos son sobrescritos automáticamente por los nuevos eventos.

*Desbordamiento del buffer circular de getLog: getLog solo almacena los 1024 eventos más recientes en memoria; cuando se generan nuevos eventos, los más antiguos se descartan de forma continua.

2. ¿Por qué el tamaño de 1 MB de system.profile es un problema de conservación y no solo de espacio? Porque al ser una colección limitada (capped collection), el límite de 1 MB implica la destrucción automática de la evidencia histórica. La pérdida de registros ocurre de forma continua y desapercibida a medida que el sistema procesa transacciones, impidiendo mantener una trazabilidad a mediano o largo plazo sin una estrategia activa de exportación externa.

3. ¿Por qué getLog sirve para interpretar pero no para conservar?
*Sirve para interpretar porque ofrece una vista rápida e inmediata en memoria de las estructuras JSON de los eventos recientes directamente desde la consola, facilitando el análisis en tiempo real.

*No sirve para conservar porque reside exclusivamente en la memoria RAM del servidor y se limita a una capacidad máxima de 1024 eventos. Ante cualquier reinicio del proceso o del servidor, toda la información almacenada en esa memoria se destruye definitivamente.