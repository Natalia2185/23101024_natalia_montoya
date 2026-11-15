# Actividad 4 — Reducir el volumen con un filtro

Preguntas

¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste? Al aplicar el filtro se perdió el registro de las consultas de lectura, por lo que búsquedas como db.clientes.find({ _id: 1 }) ya no dejan rastro dentro de system.profile. Lo que se ganó fue optimizar el espacio y el rendimiento del servidor al eliminar el ruido de las lecturas, logrando que el perfilador guarde únicamente las modificaciones reales a los datos (insert, update y remove).

¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes? Usaría un filtro delimitado por el espacio de nombres de la colección (ns: "comercial.clientes"), ejecutando el comando db.setProfilingLevel(1, { filter: { ns: "comercial.clientes" } }). Con esto, el perfilador registraría únicamente las acciones ejecutadas sobre la tabla de clientes e ignoraría cualquier otra colección de la base de datos.