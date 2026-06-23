# Glosario: Semana 9 — Flask y Aplicaciones Web

Términos clave de esta semana, en orden de aparición conceptual.

---

**framework**
Conjunto de herramientas, convenciones y código reutilizable que simplifica el desarrollo de un tipo específico de software. Un framework web, como Flask o Django, resuelve las partes repetitivas de construir aplicaciones web (enrutamiento, manejo de requests, templates) para que te concentres en la lógica propia de tu app.

---

**Flask**
Micro-framework web de Python creado por Armin Ronacher. "Micro" porque no impone una estructura fija ni incluye un ORM o sistema de autenticación por defecto. Se instala con `pip install flask` y el punto de entrada de toda app Flask es una instancia de la clase `Flask`.

---

**ruta (route)**
La asociación entre una URL y una función Python. En Flask se define con el decorador `@app.route("/mi-url")`. Cuando el servidor recibe una request a esa URL, ejecuta la función decorada y devuelve su valor como respuesta HTTP. También conocida como *endpoint* en el contexto de APIs.

---

**template**
Archivo de texto (generalmente HTML) que contiene marcadores especiales que un motor de templates reemplaza con datos reales en tiempo de ejecución. Flask usa la función `render_template("archivo.html", variable=valor)` para cargar y renderizar templates desde la carpeta `templates/`.

---

**Jinja2**
Motor de templates de Python que usa Flask por defecto. Permite embeber lógica Python-like dentro de archivos HTML usando una sintaxis especial: `{{ variable }}` para imprimir valores, `{% if %}`, `{% for %}`, `{% block %}` para estructuras de control. También permite herencia de templates con `{% extends %}`.

---

**GET**
Método (verbo) HTTP para *obtener* un recurso. Los parámetros van en la URL (`?clave=valor`), son visibles en el historial del navegador y se pueden guardar como marcadores. En Flask se acceden con `request.args.get("clave")`. Se usa para búsquedas, lecturas y navegación; nunca para enviar datos sensibles o modificar el estado del servidor.

---

**POST**
Método HTTP para *enviar* datos al servidor con el fin de crear o modificar un recurso. Los datos van en el cuerpo de la request (no en la URL), por lo que no quedan en el historial. En Flask se acceden con `request.form.get("clave")`. Se usa en formularios de registro, login, compras y cualquier acción que modifique datos.

---

**sesión (session)**
Mecanismo para mantener estado entre requests HTTP sucesivas de un mismo usuario. HTTP es sin estado (stateless) por diseño, así que las sesiones resuelven ese problema. En Flask, `session` es un diccionario que persiste automáticamente entre requests. Lo que escribes en `session["clave"] = valor` sigue disponible en la próxima request del mismo usuario.

---

**cookie**
Pequeño fragmento de texto que el servidor envía al navegador mediante la cabecera HTTP `Set-Cookie`. El navegador lo almacena y lo reenvía automáticamente en cada request posterior al mismo dominio mediante la cabecera `Cookie`. Flask usa una cookie firmada criptográficamente para implementar las sesiones. También se usan directamente para guardar preferencias del usuario (idioma, tema visual).

---

**CRUD**
Acrónimo de las cuatro operaciones fundamentales sobre datos persistentes:
- **C**reate (Crear) → `INSERT INTO`
- **R**ead (Leer) → `SELECT`
- **U**pdate (Actualizar) → `UPDATE`
- **D**elete (Eliminar) → `DELETE`

Toda aplicación que gestiona datos implementa alguna combinación de estas cuatro operaciones. El proyecto Finance de CS50 es un ejemplo completo de CRUD.

---

**API REST**
Application Programming Interface de tipo Representational State Transfer. Es una convención para diseñar servicios web que devuelven datos estructurados (JSON) en lugar de HTML. Usa los verbos HTTP para indicar la operación: GET para leer, POST para crear, PUT/PATCH para actualizar, DELETE para eliminar. Las URLs identifican recursos (`/api/shows`, `/api/shows/42`).

---

**endpoint**
En el contexto de APIs REST, un endpoint es una URL específica que acepta requests y devuelve datos. Cada endpoint corresponde a un recurso o acción concreta. Por ejemplo: `GET /api/shows` lista todos los shows, `POST /api/shows` crea uno nuevo, `DELETE /api/shows/5` elimina el show con id 5.

---

**JSON**
JavaScript Object Notation. Formato de texto estándar para intercambiar datos entre sistemas. Usa llaves `{}` para objetos (equivalentes a diccionarios Python), corchetes `[]` para arrays (equivalentes a listas) y comillas dobles para strings. Es legible por humanos y parseable por cualquier lenguaje moderno. En Flask, `jsonify(datos)` convierte listas o diccionarios Python a una respuesta JSON con el Content-Type correcto.

---

**redirect**
Respuesta HTTP que instruye al navegador a ir a una URL diferente. Flask lo implementa con la función `redirect("/otra-ruta")`, que devuelve un código de estado 302 (Found) junto con la nueva URL en la cabecera `Location`. Se usa frecuentemente después de procesar un formulario POST para evitar que el usuario reenvíe el formulario al presionar F5 (patrón Post/Redirect/Get).

---

**render_template**
Función de Flask que carga un archivo de template desde la carpeta `templates/`, le pasa las variables indicadas como argumentos de nombre, ejecuta el motor Jinja2 para renderizarlo y devuelve el HTML resultante como string. Ejemplo: `render_template("index.html", nombre="Ana", items=lista)`.

---

**autenticación**
Proceso de verificar la identidad de un usuario: ¿eres quien dices ser? Típicamente se implementa con un formulario de login donde el usuario ingresa un nombre de usuario y una contraseña. El servidor compara la contraseña con el hash almacenado en la BD. Si coinciden, registra al usuario en la sesión. En CS50 Finance se usa la librería `werkzeug` para generar y verificar hashes de contraseñas con `generate_password_hash` y `check_password_hash`.

---

**autorización**
Proceso de verificar qué acciones puede realizar un usuario ya autenticado: ¿tienes permiso para hacer esto? La autenticación responde "¿quién eres?"; la autorización responde "¿qué puedes hacer?". Por ejemplo, un usuario autenticado puede ver su propio portafolio, pero no el de otro usuario. La autorización se implementa comprobando el ID del usuario en sesión contra el propietario del recurso solicitado.
