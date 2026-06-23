# Material Complementario: El Flujo Completo de una Aplicación Web

Este documento profundiza en tres preguntas que los estudiantes suelen hacerse al terminar la lectura principal de la Semana 9.

---

## 1. Del clic del usuario a la respuesta en pantalla: cada paso explicado

Imaginemos que entras a `http://localhost:5000/buscar?q=office` en tu navegador. Esto es lo que ocurre, paso a paso:

### Paso 1 — El navegador construye la request HTTP

Tu navegador arma un mensaje de texto con este formato:

```
GET /buscar?q=office HTTP/1.1
Host: localhost:5000
Cookie: session=abc123xyz
Accept: text/html,application/xhtml+xml
```

Cada campo tiene un propósito:
- `GET` — método HTTP: quiero *obtener* algo.
- `/buscar?q=office` — la ruta y el parámetro de búsqueda.
- `Cookie: session=abc123xyz` — el navegador reenvía automáticamente todas las cookies asociadas a ese dominio. Así es como el servidor sabe quién eres sin que tengas que escribir tu contraseña en cada página.

### Paso 2 — Flask recibe la request y busca la ruta

El servidor de desarrollo de Flask (`flask run`) está escuchando en el puerto 5000. Recibe el texto anterior y lo procesa:

1. Lee el método (`GET`) y la ruta (`/buscar`).
2. Busca en su tabla interna de rutas qué función Python tiene decorada con `@app.route("/buscar")`.
3. Llama a esa función.

Si no encuentra ninguna ruta que coincida, devuelve automáticamente **404 Not Found**.
Si la ruta existe pero el método no está permitido, devuelve **405 Method Not Allowed**.

### Paso 3 — La función Python se ejecuta

```python
@app.route("/buscar")
def buscar():
    q = request.args.get("q")  # Lee el parámetro ?q=office
    shows = db.execute("SELECT * FROM shows WHERE titulo LIKE ?", f"%{q}%")
    return render_template("resultados.html", shows=shows)
```

Flask pone los parámetros de la URL dentro de `request.args` (para GET) y los datos del formulario en `request.form` (para POST).

### Paso 4 — Consulta a la base de datos

`db.execute(...)` convierte la llamada Python en una query SQL real, la envía al motor SQLite, y recibe de vuelta una lista de diccionarios Python, donde cada diccionario es una fila de la tabla:

```python
[
    {"id": 1, "titulo": "The Office", "año": 2005},
    {"id": 8, "titulo": "The Office UK", "año": 2001},
]
```

### Paso 5 — Jinja2 renderiza el template

`render_template("resultados.html", shows=shows)` hace dos cosas:
1. Carga el archivo `templates/resultados.html` del disco.
2. Reemplaza todos los marcadores Jinja (`{{ show.titulo }}`, bucles `{% for %}`, etc.) con los datos reales.

El resultado es un string de HTML puro, sin ningún marcador Jinja.

### Paso 6 — Flask arma la response HTTP y la envía

Flask envuelve el HTML en una respuesta HTTP:

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 2483

<!DOCTYPE html>
<html>
...
</html>
```

### Paso 7 — El navegador muestra la página

El navegador recibe ese texto, interpreta el HTML, descarga los CSS y JavaScript referenciados, y dibuja la página en pantalla.

**Tiempo total:** decenas de milisegundos en local. En producción, sobre una red real, el cuello de botella suele ser la latencia de red y las consultas lentas a la base de datos.

---

## 2. Sesiones vs cookies: diferencias y cuándo usar cada una

Esta es una de las confusiones más frecuentes. Son conceptos relacionados pero distintos.

### Cookie: el mecanismo de transporte

Una **cookie** es un pequeño fragmento de texto que el servidor envía al navegador y el navegador devuelve en cada request posterior. Es solo un mecanismo de transporte, como un sobre que el cartero te entrega y tú le devuelves cada vez que lo visitas.

**Características:**
- Se guarda en el disco o en la memoria del navegador.
- Tiene una fecha de expiración configurable.
- El usuario puede verla y borrarla desde las devtools del navegador.
- Tiene un tamaño límite de ~4 KB.
- Puede contener directamente los datos (cookie de datos) o solo una referencia (cookie de sesión).

**Cuándo usarla directamente:** cuando quieres guardar preferencias simples del usuario que no son sensibles, como el idioma preferido o el tema oscuro/claro.

```python
from flask import make_response, request

@app.route("/preferencias")
def preferencias():
    respuesta = make_response(render_template("preferencias.html"))
    # Guardamos el idioma en una cookie que dura 30 días
    respuesta.set_cookie("idioma", "es", max_age=30*24*60*60)
    return respuesta
```

### Sesión: la abstracción de alto nivel

Una **sesión** es un concepto de más alto nivel: es un diccionario de datos asociado a un usuario específico. Flask la implementa *usando* cookies, pero añade una capa importante: **firma criptográfica**.

Cuando Flask guarda algo en `session`, serializa ese diccionario, lo firma con `secret_key`, y lo mete en una cookie. Cuando el navegador devuelve esa cookie, Flask verifica la firma antes de confiar en los datos.

**¿Qué impide que un usuario modifique su cookie de sesión?** La firma. Si alguien intenta cambiar `session["usuario"]` de `"ana"` a `"admin"` manipulando la cookie, la firma ya no coincidirá y Flask rechazará la cookie.

**Cuándo usar sesión:** siempre que necesites mantener estado entre requests para un usuario específico: login, carrito de compras, formularios de varios pasos, mensajes flash ("Tu perfil fue actualizado").

### Tabla comparativa

| Aspecto | Cookie directa | Sesión Flask |
|---|---|---|
| Dónde se guarda | Solo en el navegador | Datos en servidor, referencia en cookie |
| Tamaño | Máx. ~4 KB | Ilimitado (server-side) |
| Seguridad | El usuario puede modificarla | Firmada criptográficamente |
| Expiración | Configurable (días, semanas) | Por defecto al cerrar el navegador |
| Caso de uso típico | Preferencias no sensibles | Login, carrito, estado de la sesión |

### Ciclo de vida de una sesión

1. **Primera visita:** no hay cookie. Flask crea una sesión vacía.
2. **Login exitoso:** `session["usuario"] = "ana"`. Flask firma y guarda la sesión en una cookie.
3. **Requests posteriores:** el navegador envía la cookie. Flask verifica la firma y carga la sesión.
4. **Logout:** `session.clear()`. Flask borra los datos de sesión.
5. **Cookie expirada o eliminada:** el usuario queda "deslogueado" automáticamente.

---

## 3. Por qué Flask y no Django para empezar

Esta pregunta aparece constantemente. La respuesta corta: **Flask te deja ver el funcionamiento interno, Django te lo esconde**.

### Django: baterías incluidas

Django viene con todo preinstalado: ORM propio, sistema de autenticación, panel de administración, manejo de formularios, sistema de migraciones de BD, entre otros. Escribes menos código boilerplate para cosas comunes.

El problema para aprender: cuando algo falla, no sabes en cuál de las veinte capas de abstracción está el error. Además, debes aprender las convenciones específicas de Django antes de poder hacer algo simple.

### Flask: el mínimo que funciona

Flask te da solo tres cosas:
- Enrutamiento de URLs a funciones.
- Manejo de requests y responses HTTP.
- Sistema de templates (Jinja2).

Todo lo demás —autenticación, BD, formularios, validación— lo agregas tú, librería por librería. Eso significa más código, pero también que entiendes exactamente qué hace cada pieza.

### La analogía con CS50

En CS50 aprendiste C antes de Python, y punteros antes de usar listas dinámicas automáticas. No porque C sea mejor que Python, sino porque entender el nivel bajo hace que el nivel alto tenga sentido.

Flask es el equivalente web de C. Cuando eventualmente uses Django (o FastAPI, o cualquier otro framework), comprenderás qué está pasando por debajo porque ya lo implementaste tú mismo con Flask.

### Una guía rápida para elegir

| Si necesitas... | Usa |
|---|---|
| Aprender cómo funciona la web | Flask |
| Un prototipo rápido con BD y auth | Flask + extensiones |
| Una app grande en equipo con convenciones establecidas | Django |
| Una API de alto rendimiento con tipado estático | FastAPI |

Para el alcance de CS50 y tu proyecto final, Flask es la elección correcta. Cuando seas profesional, ya tendrás la base para evaluar qué framework conviene en cada situación.
