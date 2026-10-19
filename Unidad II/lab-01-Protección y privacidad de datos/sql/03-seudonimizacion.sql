--Actividad 3 — Seudonimización 

--9.3 Generar los tokens

/*Crea un código secreto o "clave sustituta" 
para cada cliente y guarda en una tabla protegida 
la lista que dice a qué id corresponde cada código, 
permitiendo trabajar con los datos sin revelar quién 
es quién.*/

--Habilitar la extensión necesaria:
CREATE EXTENSION IF NOT EXISTS pgcrypto;
--Generar un token para cada cliente:
INSERT INTO pii.mapa_cliente
(token, cliente_id)
SELECT
    gen_random_uuid(),
    id
FROM clientes;