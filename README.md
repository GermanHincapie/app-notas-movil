\# 📝 App Notas Móvil – Aplicación con API REST y Persistencia Local

## 📌 Descripción del proyecto

Este proyecto corresponde al desarrollo de una aplicación móvil de notas que permite a los usuarios registrarse, iniciar sesión y gestionar sus notas personales mediante una **API REST**. La aplicación fue desarrollada utilizando **Flutter** como frontend y **Node.js + Express + MySQL** como backend.

Además, se implementó persistencia local con SQLite para permitir el acceso a las notas incluso cuando el dispositivo no tiene conexión a internet.

---

## 🎯 Objetivo del proyecto

Desarrollar una aplicación móvil que permita la gestión de notas personales con autenticación segura, almacenamiento remoto mediante API REST y sincronización local offline, aplicando buenas prácticas de desarrollo móvil y arquitectura cliente-servidor.

---

## 🔐 Funcionalidades implementadas

La aplicación incluye:

* registro de usuarios
* inicio de sesión con autenticación JWT
* creación de notas
* edición de notas
* eliminación de notas
* visualización de listado de notas
* persistencia local con SQLite
* sincronización con servidor cuando hay conexión
* consumo de API REST (GET, POST, PUT, DELETE)

Estas funcionalidades permiten garantizar disponibilidad de la información tanto online como offline.

---

## 🌐 Arquitectura del sistema

La aplicación está compuesta por dos partes principales:

### Backend

Desarrollado con:

* Node.js
* Express
* MySQL

Incluye:

* autenticación con JWT
* rutas protegidas
* CRUD completo de notas
* conexión a base de datos relacional

### Frontend

Desarrollado con:

* Flutter
* Dart

Incluye:

* interfaz de usuario móvil
* consumo de API REST
* almacenamiento local SQLite
* manejo de sesión del usuario

---

## 🔄 Persistencia local offline

Se implementó almacenamiento local mediante SQLite para permitir:

* acceso a notas sin conexión
* almacenamiento temporal de información
* sincronización automática cuando se restablece la conexión

Esto mejora la experiencia del usuario y garantiza disponibilidad de datos.

---

## 🛠️ Tecnologías utilizadas

Frontend:

* Flutter
* Dart
* SQLite

Backend:

* Node.js
* Express
* MySQL
* JWT

Herramientas:

* Visual Studio Code
* XAMPP / phpMyAdmin
* Postman

---

## 📂 Estructura del proyecto Flutter

```
lib/
 ├── models/
 ├── services/
 ├── screens/
 ├── database/
 └── main.dart
```

---

## ▶️ Cómo ejecutar el proyecto

### Backend

Entrar al proyecto backend:

```
cd notas_backend
```

Instalar dependencias:

```
npm install
```

Ejecutar servidor:

```
npm start
```

Servidor disponible en:

```
http://localhost:3000
```

---

### Frontend Flutter

Entrar al proyecto:

```
cd notas_app_flutter
```

Instalar dependencias:

```
flutter pub get
```

Ejecutar aplicación:

```
flutter run
```

---

## 🔑 Seguridad implementada

Se implementaron medidas de seguridad como:

* autenticación mediante JWT
* protección de rutas privadas
* validación de credenciales
* almacenamiento seguro del token de sesión

Estas medidas garantizan acceso controlado a la información del usuario.

---

## 👨‍💻 Autor

German Hincapié
Tecnología en Desarrollo de Software


