\# Aplicación móvil de gestión de notas



Este proyecto consiste en una aplicación móvil desarrollada en Flutter que permite gestionar notas mediante un API REST desarrollado en Node.js y una base de datos MySQL.



La aplicación permite trabajar en modo online y offline gracias al uso de SQLite.



\## Tecnologías utilizadas



Frontend:

\- Flutter

\- SQLite



Backend:

\- Node.js

\- Express

\- MySQL



Autenticación:

\- JWT



\## Funcionalidades



La aplicación permite:



\- Registro de usuarios

\- Inicio de sesión

\- Crear notas

\- Editar notas

\- Eliminar notas

\- Consultar notas

\- Funcionamiento sin conexión

\- Sincronización automática al volver internet



\## Persistencia local



Se utilizó SQLite para guardar notas cuando no hay conexión.



Las notas creadas offline quedan como:



Pendiente de sincronizar



Cuando vuelve la conexión:



Se sincronizan con el servidor automáticamente.



\## API REST



El backend implementa:



GET /api/notes

POST /api/notes

PUT /api/notes/:id

DELETE /api/notes/:id



\## Autor



Germán H

Tecnología en Desarrollo de Software

