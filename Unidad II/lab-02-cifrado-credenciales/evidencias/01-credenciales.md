## Actividad 1 — Punto 7

**Objetivo**  
Demostrar la seguridad en el almacenamiento de contraseñas mediante `crypt` y `gen_salt`, analizando el riesgo de guardar texto claro y cómo funciona la validación durante la autenticación.

**Comando o procedimiento**  
Evalué el impacto de guardar claves sin protección, generé valores seguros combinando `crypt()` con `gen_salt()` y probé la autenticación comparando la respuesta ante contraseñas correctas e incorrectas.

**Resultado obtenido**  
Comprobé que almacenar claves en texto plano permite a un atacante leerlas, robar datos y suplantar usuarios. Al generar los hashes, los resultados no son iguales en cada intento aunque la clave sea la misma. En la validación, obtuve `TRUE` con la contraseña correcta e ingresada y `FALSE` con una contraseña incorrecta o no registrada.

**Análisis**  
Los resultados varían porque `gen_salt()` crea una cadena de caracteres aleatorios para evitar que claves idénticas muestren el mismo resultado, mientras que `crypt()` combina esa sal con la contraseña en una sola cadena. Este proceso no es cifrado reversible, por lo que no se puede recuperar ni descifrar la clave original. Tampoco es necesario recuperarla para autenticar, ya que el sistema toma la contraseña escrita al iniciar sesión, la procesa y la compara con la registrada. Un hash no debe confundirse con cifrado: el hash es irreversible y sirve solo para validar datos, mientras que el cifrado oculta la información para recuperarla después con una clave.

**Conclusión**  
El uso de `crypt` y `gen_salt` evita la exposición de credenciales en la base de datos. Al ser una función unidireccional e irreversible, mantiene la seguridad del sistema incluso ante accesos no autorizados a la tabla, permitiendo validar al usuario mediante comparación directa sin almacenar ni descifrar la clave original.

## ¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?
El atacante podría ver la contraseña del usuario en texto claro y podría robar todos los datos, permitiéndole además suplantar la identidad de los usuarios al no contar con ninguna medida de protección en esa etapa.

## Preguntas
1.-¿Son iguales? No 
2.-Si no son iguales, ¿por qué? Porque aunque la contraseña siempre es la misma, en cada ejecución se inventa un dato aleatorio diferente que hace que el resultado final cambie en cada intento.
3.-¿Qué función cumple gen_salt()?Generar una cadena de caracteres aleatorias para que dos usuarios al tener la misma contraseña no se muestre la misma.
4.-¿Qué función cumple crypt()? Convierte la contraseña del usuario y la generada por gen_salt y las combina en una sola cadena de texto
¿5.-¿Esto es cifrado reversible? No, ya no se puede recuperar la contraseña original osea ya no se puede descifrar.


## Preguntas
1.-¿Qué resultado obtuviste con la contraseña correcta? Devuelve TRUE lo que significa que es la contraseña correcta la ingresada.
2.-¿Qué resultado obtuviste con la contraseña incorrecta? Se obtuvo un FALSE lo que significa que no es una contraseña que esté registrada.
3.-¿Por qué no es necesario recuperar la contraseña original? Porque no se ocupa la contraseña real si no la clave que se acaba de escribir, es decir toma la contraseña ingresada y la que ya tiene registrada y las compara.
4.-¿Por qué un hash no debe confundirse con cifrado? Porque el hash es irreversible osea que ya no se puede recuperar mientras que el cifrado está diseñado para ocultar el dato y recuperarlo con la clave de cifrado en caso de ser necesario.