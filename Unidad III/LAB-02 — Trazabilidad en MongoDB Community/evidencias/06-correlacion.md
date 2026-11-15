# Actividad 6 — Correlacionar un cambio de configuración con su autor

Preguntas

¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?
Usuario: El usuario administrador (admin).

Eventos que lo demuestran:
El evento de inicio de sesión exitoso (msg: "Successfully authenticated") asociado al contexto de conexión conn3.
El evento de modificación del perfilador (msg: "Profiler settings changed") grabado bajo ese mismo contexto (ctx: "conn3"). (Nota: en tu pantalla pusiste conn31 por error y por eso devolvió [ ], pero el identificador real en los registros de arriba es conn3).


¿Qué condición debe cumplirse para que esta correlación sea válida? Debe ocurrir dentro del mismo ciclo de vida del proceso mongod y mantener una secuencia temporal lógica. Si el servicio de MongoDB se reinicia, los números de conexión (conn1, conn2, conn3...) vuelven a contarse desde cero, por lo que la correlación por ctx solo es confiable si ambos eventos comparten la misma instancia activa del servidor sin reinicios intermedios.

¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro? Por integridad y prevención de encubrimientos. Si un atacante o un usuario con privilegios desactivara el perfilador (nivel 0), realizara acciones maliciosas o destructivas sobre la base de datos y luego volviera a activar el registro, la bitácora dejaría evidencia del apagado y encendido del sistema de auditoría, impidiendo que la manipulación pase desapercibida.