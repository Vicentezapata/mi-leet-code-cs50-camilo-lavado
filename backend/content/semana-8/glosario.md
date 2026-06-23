# Glosario — Semana 8: HTML, CSS y JavaScript

---

**HTML** (HyperText Markup Language)
Lenguaje de marcado que define la **estructura y el significado semántico** del contenido de una página web. No es un lenguaje de programación: no tiene funciones, bucles ni variables. Todo HTML se expresa mediante etiquetas (tags) y atributos. La versión actual es HTML5.

---

**CSS** (Cascading Style Sheets — Hojas de Estilo en Cascada)
Lenguaje que controla la **presentación visual** del HTML: colores, tipografías, tamaños, márgenes, disposición de los elementos. La "C" de cascada indica que los estilos definidos en un elemento padre se heredan (caen en cascada) hacia sus descendientes, a menos que sean sobreescritos. No es un lenguaje de programación.

---

**JavaScript**
Lenguaje de programación de propósito general que los navegadores ejecutan de forma nativa. En el contexto del frontend, se usa para añadir **interactividad** a las páginas: responder a eventos del usuario, manipular el DOM, realizar solicitudes de red sin recargar la página. También corre en el servidor mediante Node.js.

---

**DOM** (Document Object Model — Modelo de Objeto del Documento)
Representación en memoria que el navegador construye a partir del HTML. Es un árbol de nodos donde cada etiqueta HTML es un nodo, y los nodos tienen relaciones de padre, hijo y hermano. JavaScript puede leer y modificar este árbol en tiempo real, lo que permite cambiar la página sin recargarla.

---

**tag** (etiqueta)
Instrucción en HTML delimitada por corchetes angulares. La mayoría de las etiquetas tienen una apertura (`<p>`) y un cierre (`</p>`). El contenido entre ambas es el "interior" del elemento. Algunas etiquetas son auto-cerradas y no tienen contenido (`<br>`, `<img>`, `<input>`).

---

**atributo**
Información adicional que se añade dentro de la etiqueta de apertura para modificar el comportamiento o las propiedades de un elemento. Siempre tiene la forma `nombre="valor"`. Ejemplos: `href="https://example.com"`, `class="destacado"`, `id="titulo"`, `lang="es"`.

---

**selector CSS**
Expresión que le dice al navegador qué elementos del DOM debe estilizar. Los tres tipos fundamentales son:
- **Selector de tipo:** `p` — afecta todos los párrafos.
- **Selector de clase:** `.destacado` — afecta todos los elementos con `class="destacado"`.
- **Selector de ID:** `#titulo` — afecta el único elemento con `id="titulo"`.

Los selectores se pueden combinar para mayor precisión: `main p.destacado` selecciona solo los párrafos con clase `destacado` que están dentro del elemento `<main>`.

---

**modelo de caja** (box model)
Modelo fundamental de CSS que trata cada elemento HTML como una caja rectangular compuesta de cuatro capas concéntricas: el **contenido** (texto o imagen), el **padding** (relleno interno entre el contenido y el borde), el **border** (borde visible) y el **margin** (espacio externo entre esta caja y las demás). Comprender el box model es esencial para controlar el tamaño y el espaciado de los elementos.

---

**evento** (event)
Acción que ocurre en el navegador y a la que el código JavaScript puede reaccionar. Los eventos pueden ser generados por el usuario (clic, tecla presionada, movimiento del ratón, envío de un formulario) o por el sistema (página cargada, imagen lista, temporizador expirado). Cada evento tiene un nombre estándar: `"click"`, `"keyup"`, `"submit"`, `"DOMContentLoaded"`, etc.

---

**listener** (escuchador de eventos)
Función de JavaScript que se registra para ejecutarse cuando ocurre un evento específico en un elemento del DOM. Se registra con `element.addEventListener("nombre-del-evento", función)`. Cuando el evento ocurre, el navegador llama automáticamente a esa función y le pasa un objeto `Event` con información sobre lo sucedido.

---

**fetch API**
Interfaz moderna de JavaScript para realizar solicitudes HTTP de forma asíncrona desde el navegador. Reemplaza a `XMLHttpRequest`. Devuelve una `Promise` que se resuelve con un objeto `Response`. Se usa comúnmente con `async/await` para leer datos de una API sin recargar la página. Ejemplo mínimo: `const res = await fetch("/api/datos"); const datos = await res.json();`

---

**JSON** (JavaScript Object Notation)
Formato de texto ligero para intercambiar datos estructurados entre el cliente y el servidor. Su sintaxis es un subconjunto de JavaScript: usa llaves `{}` para objetos, corchetes `[]` para arreglos, y admite strings, números, booleanos y `null`. Es el formato estándar que devuelven la mayoría de las APIs web modernas. Ejemplo: `{"nombre": "Ana", "puntos": 95, "activo": true}`.

---

**frontend**
La parte de una aplicación web que se ejecuta en el navegador del usuario. Incluye todo lo que el usuario ve e interactúa: el HTML que estructura el contenido, el CSS que lo estiliza y el JavaScript que lo hace interactivo. El frontend se comunica con el backend mediante solicitudes HTTP (normalmente usando la Fetch API y recibiendo JSON).

---

**backend**
La parte de una aplicación web que se ejecuta en el servidor. Se encarga de la lógica de negocio, el acceso a la base de datos, la autenticación de usuarios y la generación de respuestas a las solicitudes del frontend. Puede estar escrito en cualquier lenguaje que corra en un servidor: Python, Go, Node.js, Java, Ruby, etc. El backend de LocalCode está escrito en Go.

---

**HTTP** (HyperText Transfer Protocol)
Protocolo de comunicación que define cómo se intercambian mensajes entre navegadores (clientes) y servidores. Cada interacción sigue el esquema **request → response**: el cliente envía una solicitud con un método (GET, POST, etc.) y una URL; el servidor responde con un código de estado (200 OK, 404 Not Found, 500 Internal Server Error) y el cuerpo del mensaje (HTML, JSON, imagen, etc.).

---

**request** (solicitud)
Mensaje que el cliente (navegador o código JavaScript) envía al servidor. Contiene el método HTTP, la URL de destino, encabezados (headers) con metadatos (tipo de contenido, autenticación, etc.) y, en métodos como POST, un cuerpo con los datos enviados.

---

**response** (respuesta)
Mensaje que el servidor devuelve al cliente como resultado de una request. Contiene un **código de estado** que indica el resultado (200 = éxito, 301 = redirección, 404 = no encontrado, 500 = error del servidor), encabezados con metadatos y un **cuerpo** con el contenido solicitado (HTML, JSON, imagen, etc.).
