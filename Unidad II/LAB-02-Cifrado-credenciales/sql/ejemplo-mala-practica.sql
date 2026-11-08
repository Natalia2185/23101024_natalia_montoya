/*9.1 Identificar una mala práctica*/

SELECT pgp_sym_decrypt(
    rfc_cifrado,
    'CLAVE-DE-PRUEBA'
)
FROM clientes_protegidos;

/*¿Qué ocurriría si esta clave fuera una clave utilizada realmente 
por una organización y el archivo se publicará en un repositorio Git? 
Si esa clave fuera real y el archivo se subiera a GitLab, la seguridad 
del cifrado se perdería por completo porque cualquier persona o atacante 
con acceso al repositorio podría ver la clave en texto claro; e incluso 
si después borras el archivo o la contraseña del proyecto, el secreto se 
queda guardado para siempre en el historial de commits de Git, por lo que 
cualquiera podría usar esa clave junto con un respaldo o acceso a la base 
de datos para descifrar toda la información sensible. */