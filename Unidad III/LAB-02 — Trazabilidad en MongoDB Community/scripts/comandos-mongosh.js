// ============================================================================
// LAB-02 — Trazabilidad en MongoDB Community
// Archivo: scripts/comandos-mongosh.js
// ============================================================================

// ----------------------------------------------------------------------------
// 6. PREPARACIÓN DEL ENTORNO (Usuarios, datos y función auxiliar)
// ----------------------------------------------------------------------------
use admin
db.createUser({ user: "admin", pwd: "<REDACTED>", roles: ["root"] })
db.auth("admin", "<REDACTED>")

use comercial
db.createUser({ user: "app_ventas", pwd: "<REDACTED>", roles: [{ role: "readWrite", db: "comercial" }] })

db.clientes.insertMany([
  { _id: 1, nombre: "Ana López", correo: "ana.lopez@example.test", telefono: "6671234567", rfc: "LOAA850315ABC", edad: 41, ciudad: "Culiacán", codigo_postal: "80000" },
  { _id: 2, nombre: "Carlos Pérez", correo: "carlos.perez@example.test", telefono: "6672345678", rfc: "PECA900720DEF", edad: 35, ciudad: "Culiacán", codigo_postal: "80100" },
  { _id: 3, nombre: "María García", correo: "maria.garcia@example.test", telefono: "6673456789", rfc: "GAMA780912GHI", edad: 47, ciudad: "Mazatlán", codigo_postal: "82000" },
  { _id: 4, nombre: "Luis Torres", correo: "luis.torres@example.test", telefono: "6674567890", rfc: "TOLU920201JKL", edad: 34, ciudad: "Los Mochis", codigo_postal: "81200" },
  { _id: 5, nombre: "Laura Sánchez", correo: "laura.sanchez@example.test", telefono: "6675678901", rfc: "SALA880525MNO", edad: 38, ciudad: "Culiacán", codigo_postal: "80200" }
])

// Función auxiliar para leer y parsear la bitácora JSON en memoria
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l));
}


// ----------------------------------------------------------------------------
// 7. ACTIVIDAD 1 — Lo que no existe en esta edición
// ----------------------------------------------------------------------------
db.version()
db.adminCommand({ buildInfo: 1 }).modules
db.serverCmdLineOpts().parsed


// ----------------------------------------------------------------------------
// 8. ACTIVIDAD 2 — El incidente sin perfilado
// ----------------------------------------------------------------------------
db.getProfilingStatus()

// [Terminal] Ejecución de actualización como aplicación con perfilador apagado:
// sudo docker exec -it mongodb mongo "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XXX" } })'

// Búsqueda de evidencia en system.profile y bitácora:
db.system.profile.countDocuments()
bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length
bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg }))


// ----------------------------------------------------------------------------
// 9. ACTIVIDAD 3 — Activar el perfilador y registrar operaciones
// ----------------------------------------------------------------------------
db.setProfilingLevel(2)
db.getProfilingStatus()

// [Terminal] Ejecución de consulta, actualización y eliminación como aplicación:
// sudo docker exec -it mongodb mongo "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ ciudad: "Culiacán" }, { nombre: 1, ciudad: 1 }).toArray(); db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XYZ" } }); db.clientes.deleteOne({ _id: 2 });'

// Consulta de documentos registrados en system.profile:
db.system.profile.find(
  { ns: "comercial.clientes" },
  { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }
).sort({ ts: 1 })


// ----------------------------------------------------------------------------
// 10. ACTIVIDAD 4 — Reducir el volumen con un filtro
// ----------------------------------------------------------------------------
db.setProfilingLevel(0)
db.system.profile.drop()
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })
db.getProfilingStatus()

// [Terminal] Ejecución de consulta y actualización con el filtro activo:
// sudo docker exec -it mongodb mongo "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ _id: 1 }).toArray(); db.clientes.updateOne({ _id: 1 }, { $set: { telefono: "6670000000" } })'

// Verificación de que solo se registró el update:
db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 })


// ----------------------------------------------------------------------------
// 11. ACTIVIDAD 5 — Accesos en la bitácora de mongod
// ----------------------------------------------------------------------------
// [Terminal] Generación de dos intentos fallidos de autenticación:
// sudo docker exec -it mongodb mongo "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"
// sudo docker exec -it mongodb mongo "mongodb://usuario_inexistente:<REDACTED>@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"

// Consulta de intentos fallidos y acceso exitoso en la bitácora:
bitacora()
  .filter(e => e.c === "ACCESS" && e.msg.includes("Authentication failed"))
  .map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.client, result: e.attr.result }))

bitacora()
  .filter(e => e.msg === "Successfully authenticated" && e.attr.user === "app_ventas")
  .slice(-1)
  .map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.client, result: e.attr.result, app: e.attr.doc.application.name }))


// ----------------------------------------------------------------------------
// 12. ACTIVIDAD 6 — Correlacionar un cambio de configuración con su autor
// ----------------------------------------------------------------------------
bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({ t: e.t, ctx: e.ctx, msg: e.msg, attr: e.attr }))

// Correlación mediante el identificador de conexión ctx (sustituir conn3 por el observado):
bitacora()
  .filter(e => e.ctx === "conn3" && e.msg === "Successfully authenticated")
  .map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }))


// ----------------------------------------------------------------------------
// 13. ACTIVIDAD 7 — Cambios de privilegios: el límite más importante
// ----------------------------------------------------------------------------
// Primera instantánea de privilegios:
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
})

// Otorgamiento de rol con nivel 2 activo:
db.setProfilingLevel(2)
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])

// Comprobación de ausencia de evidencia nativa:
db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } })
bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length

// Segunda instantánea y comparación:
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
})
db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 })

// Revocación del rol y restablecimiento del filtro:
db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })


// ----------------------------------------------------------------------------
// 14. ACTIVIDAD 8 — Conservación: exportar antes de perder
// ----------------------------------------------------------------------------
// [Terminal] Exportación de system.profile, bitácora global y cálculo de hashes SHA-256:
// sudo docker exec -t mongodb mongo "mongodb://admin:<REDACTED>@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'JSON.stringify(db.system.profile.find({}, { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, "command.q": 1, "command.u": 1 }).toArray(), null, 2)' > evidencias/system-profile.json
// sudo docker exec -t mongodb mongo "mongodb://admin:<REDACTED>@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'db.adminCommand({ getLog: "global" }).log.join("\n")' > evidencias/bitacora-mongod.log
// sha256sum evidencias/system-profile.json evidencias/bitacora-mongod.log > evidencias/hashes.sha256

// Verificación tras reinicio del servicio:
db.getProfilingStatus()
db.system.profile.countDocuments()