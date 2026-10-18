
/*Inserta un registro utilizando cifrado simétrico:

El RFC de la cliente no se almacena de forma legible 
dentro de la columna rfc_cifrado, sino como un arreglo 
de datos binarios cifrado, protegiendo la información 
confidencial almacenada en la tabla.
*/
INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);