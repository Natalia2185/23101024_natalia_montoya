# Montoya Martinez Natalia Fecha:06 de Noviembre del 2026
# 6. Preparación del entorno

Pregunta

1.-¿Por qué una regla trust afecta lo que la bitácora puede demostrar sobre la identidad del usuario? Relaciona tu respuesta con el endurecimiento del servidor de la Unidad II.
Bajo una regla trust, PostgreSQL permite la conexión sin solicitar ni validar credenciales. Un usuario puede declarar ser cualquier rol (por ejemplo, app_ventas o postgres) y el servidor le otorgará el acceso de inmediato. En ese escenario, la bitácora registraría un nombre de usuario, pero no habría prueba ni garantía de que la persona o proceso fuera realmente quien decía ser. Al imponer scram-sha-256, el servidor exige la autenticación criptográfica de la contraseña, garantizando que los eventos registrados en la bitácora correspondan a identidades verdaderamente verificadas (trazabilidad y hardening).

