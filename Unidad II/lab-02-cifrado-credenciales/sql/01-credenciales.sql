

/*7.3 Generar una representación no reversible

Genera una cadena única que comienza por $2a$ o $2b$. 
Esta representación es irreversible (no existe una función 
para "descifrar" y recuperar la clave original). Si vuelvo 
a ejecutar la consulta, el resultado cambiará debido a que 
gen_salt() crea una nueva sal aleatoria cada vez.
*/

SELECT crypt(
    'Password123',
    gen_salt('bf')
);

