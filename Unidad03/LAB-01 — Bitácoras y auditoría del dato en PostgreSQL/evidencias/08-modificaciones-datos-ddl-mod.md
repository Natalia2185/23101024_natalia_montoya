# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 13. Actividad 7 — Modificaciones de datos: ddl frente a mod

Preguntas
1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto? La lectura de datos (sentencias SELECT) se registraría únicamente configurando el nivel all. En un servidor con miles de consultas por minuto, esto generaría un costo enorme en rendimiento, ralentizando el servidor por el uso continuo de disco y procesador, además de llenar el almacenamiento rápidamente con millones de líneas de registro.

2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza? Le falta registrar el valor anterior (el estado previo o dato original) de los registros afectados. Como la bitácora básica de PostgreSQL solo guarda el comando SQL que se ejecutó pero no la información que fue sobrescrita o borrada, no hay forma de saber con certeza qué datos había antes para restaurarlos.