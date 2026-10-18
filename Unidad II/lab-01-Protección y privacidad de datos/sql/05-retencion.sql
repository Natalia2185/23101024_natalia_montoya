
--Para este ejercicio se utilizará un periodo de cinco años:
/*Evalua la política de retención de datos, permitiendo saber 
qué clientes o expedientes superan el límite de conservación de 
5 años para determinar cuáles deberían ser archivados o depurados.*/


SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';