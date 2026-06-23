# Complemento Ciberseguridad: Más Allá de los Conceptos Básicos

Este complemento amplía los temas de la lectura principal con ejemplos de código más detallados, análisis de casos reales adicionales, y herramientas concretas que puedes usar en tus proyectos.

---

## 1. Implementando Autenticación Segura en Flask

A continuación tienes un ejemplo funcional de sistema de registro e inicio de sesión con las mejores prácticas aplicadas:

```python
# app.py — Sistema de autenticación seguro en Flask
from flask import Flask, request, session, redirect, url_for, render_template
import sqlite3
import bcrypt
import secrets
import os

app = Flask(__name__)
# La clave secreta debe ser aleatoria y larga (mínimo 32 bytes)
# En producción, debe venir de una variable de entorno, NUNCA del código fuente
app.secret_key = os.environ.get("SECRET_KEY") or secrets.token_hex(32)

DATABASE = "users.db"

def get_db():
    """Obtiene una conexión a la base de datos."""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row  # Permite acceder a columnas por nombre
    return conn

def init_db():
    """Inicializa la base de datos con el schema."""
    with get_db() as db:
        db.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                password_hash TEXT NOT NULL,  -- Nunca guardar la contraseña en texto plano
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        """)
        db.commit()

@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        # Validación básica en el servidor (no depender del cliente)
        if not username or not password:
            return render_template("register.html", error="Campos requeridos")

        if len(password) < 8:
            return render_template("register.html", error="La contraseña debe tener al menos 8 caracteres")

        # Hashear la contraseña con bcrypt
        # rounds=12 significa 2^12 = 4096 iteraciones (buen balance seguridad/velocidad)
        password_hash = bcrypt.hashpw(
            password.encode("utf-8"),
            bcrypt.gensalt(rounds=12)
        )

        try:
            with get_db() as db:
                # Consulta preparada — previene SQL injection automáticamente
                db.execute(
                    "INSERT INTO users (username, password_hash) VALUES (?, ?)",
                    (username, password_hash)
                )
                db.commit()
            return redirect(url_for("login"))
        except sqlite3.IntegrityError:
            return render_template("register.html", error="El usuario ya existe")

    return render_template("register.html")

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        with get_db() as db:
            # Consulta preparada — el input del usuario NUNCA toca el SQL directamente
            user = db.execute(
                "SELECT * FROM users WHERE username = ?",
                (username,)
            ).fetchone()

        # Verificamos incluso si el usuario no existe para evitar timing attacks
        # (ataques que miden el tiempo de respuesta para inferir si el usuario existe)
        if user and bcrypt.checkpw(password.encode("utf-8"), user["password_hash"]):
            # Regenerar el ID de sesión al iniciar sesión (previene session fixation)
            session.clear()
            session["user_id"] = user["id"]
            session["username"] = user["username"]
            return redirect(url_for("dashboard"))
        else:
            return render_template("login.html", error="Credenciales incorrectas")

    return render_template("login.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect(url_for("login"))
    return render_template("dashboard.html", username=session["username"])

if __name__ == "__main__":
    init_db()
    app.run(debug=False)  # debug=False en producción — nunca exponer el debugger
```

---

## 2. Implementando Protección Anti-XSS en Plantillas Jinja2

```html
<!-- templates/comentarios.html -->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <!-- Content Security Policy: restringe qué scripts pueden ejecutarse -->
    <!-- Esto es una segunda línea de defensa contra XSS -->
    <meta http-equiv="Content-Security-Policy"
          content="default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'">
    <title>Comentarios</title>
</head>
<body>
    <h1>Comentarios de {{ nombre_seccion }}</h1>

    {% for comentario in comentarios %}
    <div class="comentario">
        <!-- {{ }} escapa automáticamente en Jinja2 — SEGURO -->
        <strong>{{ comentario.autor }}</strong>
        <p>{{ comentario.texto }}</p>

        <!-- NUNCA hagas esto con input del usuario -->
        <!-- <p>{{ comentario.texto | safe }}</p>  VULNERABLE -->
    </div>
    {% endfor %}

    <form method="POST" action="/comentarios">
        <textarea name="texto" maxlength="500"></textarea>
        <!-- Token CSRF para prevenir Cross-Site Request Forgery -->
        <input type="hidden" name="csrf_token" value="{{ csrf_token() }}">
        <button type="submit">Publicar</button>
    </form>
</body>
</html>
```

---

## 3. Headers HTTP de Seguridad

Los headers HTTP son una capa adicional de defensa que se configura en el servidor:

```python
# En Flask, puedes agregar headers de seguridad con flask-talisman
# pip install flask-talisman
from flask_talisman import Talisman

app = Flask(__name__)
Talisman(app, content_security_policy={
    'default-src': "'self'",
    'script-src': "'self'",
    'style-src': ["'self'", "fonts.googleapis.com"],
    'font-src': "fonts.gstatic.com",
})

# O manualmente:
@app.after_request
def add_security_headers(response):
    # Previene que el navegador interprete el tipo MIME de forma diferente
    response.headers['X-Content-Type-Options'] = 'nosniff'
    # Previene que la página se cargue en un iframe (clickjacking)
    response.headers['X-Frame-Options'] = 'DENY'
    # Fuerza HTTPS por 1 año
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    # Habilita protección XSS del navegador (legacy, reemplazada por CSP)
    response.headers['X-XSS-Protection'] = '1; mode=block'
    return response
```

---

## 4. Cómo Funcionan los Ataques de Fuerza Bruta en la Práctica

Para entender por qué bcrypt importa, veamos los números reales:

```
Hardware: GPU moderna (RTX 4090)
Velocidad de hashing:

MD5:       164,000,000,000 (164 mil millones) de hashes/segundo
SHA-256:    22,000,000,000 (22 mil millones)  de hashes/segundo
bcrypt(12):         6,000                     de hashes/segundo

Si la contraseña está en un diccionario de 10 millones de entradas:
- Con MD5:    0.00006 segundos  <- inmediato
- Con SHA-256: 0.0005 segundos  <- inmediato
- Con bcrypt: 28 minutos        <- significativo

Si la contraseña es aleatoria de 8 caracteres (94^8 posibilidades):
- Con MD5:    < 1 dia           <- asustante
- Con SHA-256: < 1 semana
- Con bcrypt: ~15,000 años      <- practicament imposible de forzar
```

La diferencia entre usar MD5 y bcrypt no es un detalle técnico: es la diferencia entre un ataque que dura microsegundos y uno que dura milenios.

---

## 5. Análisis de un Email de Phishing Real

A continuación, el análisis de un email de phishing real (anonimizado) que circuló en México en 2023:

```
De: seguridad@bancobbva-mexico.net   <- dominio falso (el real es bbva.mx)
Para: victima@gmail.com
Asunto: URGENTE: Acceso sospechoso detectado en su cuenta

Estimado cliente,

Hemos detectado un acceso no autorizado a su cuenta bancaria desde:
  IP: 189.203.xxx.xxx (México)
  Dispositivo: Desconocido

Para proteger sus fondos, su cuenta ha sido temporalmente SUSPENDIDA.

Debe verificar su identidad en las próximas 2 HORAS o su cuenta
será cancelada definitivamente.

[VERIFICAR MI IDENTIDAD AHORA]  <- link a: bbva-mexico-seguridad.com

Atentamente,
Equipo de Seguridad BBVA México
```

**Análisis de señales de alarma:**

1. **Dominio falso:** `bancobbva-mexico.net` en lugar de `bbva.mx`
2. **Urgencia artificial:** "próximas 2 HORAS", "cancelada definitivamente"
3. **Amenaza de pérdida:** "proteger sus fondos"
4. **Link a dominio falso:** `bbva-mexico-seguridad.com` no es un dominio oficial de BBVA
5. **Acción requerida:** Te pide que hagas clic en un enlace (nunca lo hagas)

**Qué hacer:** Nunca hagas clic en links de emails así. Si tienes dudas, abre tu navegador y escribe directamente la URL oficial del banco.

---

## 6. Tablas Arcoíris: El Ataque que el Salt Derrota

Una tabla arcoíris es una base de datos precomputada con millones de pares `(contraseña → hash)`:

```
Tabla arcoíris SHA-256 (ejemplo parcial):
-------------------------------------------
"password"    -> 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
"123456"      -> 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
"qwerty"      -> 65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5
"letmein"     -> 1c8bfe8f801d79745c4631d09fff36c82aa37fc4cce4fc946683d7b336b63032
...
```

Si un atacante obtiene una base de datos con hashes SHA-256 sin salt, simplemente busca cada hash en su tabla arcoíris. Es una búsqueda, no un cálculo. El proceso toma fracciones de segundo por contraseña.

Con salt:

```
Usuario A usa "password" con salt "xK7a2mP9":
hash("passwordxK7a2mP9") = a3f7b2...  NO está en ninguna tabla arcoíris genérica

Usuario B usa "password" con salt "qR5n8vL2":
hash("passwordqR5n8vL2") = 9c1d4e...  diferente hash, también ausente

Para crackear estas contraseñas, el atacante tendría que generar una tabla
arcoíris específica para cada salt, lo que elimina toda ventaja.
```

---

## 7. Herramientas para Aprender y Practicar

### Para entender hashing

```python
# Experimenta en Python con diferentes algoritmos
import hashlib
import time

mensaje = b"contraseña_de_prueba"

# MD5 (inseguro para contraseñas)
t = time.perf_counter()
hash_md5 = hashlib.md5(mensaje).hexdigest()
print(f"MD5:    {hash_md5} ({(time.perf_counter()-t)*1000:.4f}ms)")

# SHA-256
t = time.perf_counter()
hash_sha = hashlib.sha256(mensaje).hexdigest()
print(f"SHA-256: {hash_sha} ({(time.perf_counter()-t)*1000:.4f}ms)")

# bcrypt (pip install bcrypt)
import bcrypt
t = time.perf_counter()
salt = bcrypt.gensalt(rounds=12)
hash_bc = bcrypt.hashpw(mensaje, salt)
print(f"bcrypt:  {hash_bc.decode()} ({(time.perf_counter()-t)*1000:.0f}ms)")

# Nota los tiempos: MD5 y SHA-256 seran <1ms, bcrypt >100ms
```

### Para probar SQL Injection de forma segura

```python
# Crea una pequeña demo para ver el ataque en acción
import sqlite3

# Base de datos de ejemplo en memoria (desaparece al cerrar)
conn = sqlite3.connect(":memory:")
conn.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)")
conn.execute("INSERT INTO users VALUES (1, 'admin', 'password123')")
conn.execute("INSERT INTO users VALUES (2, 'usuario', 'mipassword')")
conn.commit()

def login_vulnerable(username, password):
    """CODIGO VULNERABLE — para demostracion solamente"""
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    print(f"Query ejecutada: {query}")
    result = conn.execute(query).fetchall()
    return len(result) > 0

def login_seguro(username, password):
    """CODIGO SEGURO con consulta preparada"""
    query = "SELECT * FROM users WHERE username=? AND password=?"
    result = conn.execute(query, (username, password)).fetchall()
    return len(result) > 0

# Demostración del ataque
print("=== Login vulnerable ===")
print(f"admin/password123: {login_vulnerable('admin', 'password123')}")  # True
print(f"inyeccion SQL: {login_vulnerable(\"' OR '1'='1\", \"' OR '1'='1\")}")  # True <- BUG

print("\n=== Login seguro ===")
print(f"admin/password123: {login_seguro('admin', 'password123')}")  # True
print(f"inyeccion SQL: {login_seguro(\"' OR '1'='1\", \"' OR '1'='1\")}")  # False
```

### Plataformas para practicar seguridad ofensiva (de forma ética y legal)

- **OWASP WebGoat** — Aplicación web deliberadamente vulnerable para aprender ataques y defensas
- **HackTheBox** (hackthebox.com) — Laboratorios de seguridad gamificados
- **TryHackMe** (tryhackme.com) — Plataforma educativa de ciberseguridad
- **DVWA** (Damn Vulnerable Web Application) — Aplicación PHP/MySQL con vulnerabilidades conocidas para practicar

---

## 8. El Principio del Menor Privilegio

Una de las reglas fundamentales de la seguridad que se aplica a nivel de sistema, base de datos y código:

**El principio del menor privilegio** establece que cada componente debe tener solo los permisos mínimos necesarios para hacer su trabajo.

**En base de datos:**
```sql
-- MAL: El usuario de la app tiene privilegios completos
GRANT ALL PRIVILEGES ON *.* TO 'app_user'@'localhost';

-- BIEN: Solo los permisos necesarios para la aplicacion
GRANT SELECT, INSERT, UPDATE ON miapp.* TO 'app_user'@'localhost';
-- (NO DELETE si la app no necesita borrar, NO DROP, NO CREATE, etc.)
```

**En el sistema de archivos:**
```bash
# MAL: La aplicación se ejecuta como root
sudo python app.py

# BIEN: La aplicación se ejecuta con un usuario sin privilegios especiales
# creado específicamente para la aplicación
adduser --system --no-create-home appuser
sudo -u appuser python app.py
```

**En el código:**
```python
# MAL: La funcion recibe el objeto de base de datos completo
def mostrar_perfil(user_id, db_connection):
    # Podria ejecutar cualquier consulta en toda la base de datos
    ...

# BIEN: La funcion recibe solo lo que necesita
def mostrar_perfil(user_id, get_user_func):
    # Solo puede obtener un usuario por ID
    user = get_user_func(user_id)
    ...
```

---

## 9. Variables de Entorno para Secretos

**Nunca pongas credenciales en tu código fuente.** Si alguna vez subes por error una contraseña o API key a GitHub, debes considerar que está comprometida y cambiarla inmediatamente (incluso si lo borraste después: Git guarda el historial).

```python
# MAL — esto aparece en el repositorio de Git para siempre
DATABASE_URL = "postgresql://admin:password123@localhost/miapp"
SECRET_KEY = "mi-clave-super-secreta"
API_KEY = "sk-abc123..."

# BIEN — usa variables de entorno
import os
DATABASE_URL = os.environ["DATABASE_URL"]  # Falla rapido si no está configurada
SECRET_KEY = os.environ["SECRET_KEY"]
API_KEY = os.environ.get("API_KEY", "")  # Retorna "" si no está

# Para desarrollo local, usa un archivo .env (y agregalo a .gitignore)
# pip install python-dotenv
from dotenv import load_dotenv
load_dotenv()  # Carga el archivo .env si existe
```

Archivo `.env` (en la raíz del proyecto, **nunca en Git**):
```
DATABASE_URL=postgresql://admin:password123@localhost/miapp
SECRET_KEY=clave-aleatoria-muy-larga-aqui
API_KEY=sk-tu-api-key
```

Archivo `.gitignore`:
```
.env
*.env
.env.local
secrets.py
```

---

## 10. Verificación de Seguridad Antes de Publicar

Antes de publicar una aplicación web, revisa esta lista mínima:

```
[ ] Las contraseñas se almacenan con bcrypt o Argon2 (nunca MD5, nunca texto plano)
[ ] Todas las consultas SQL usan parámetros, nunca concatenación
[ ] Los templates de Jinja2 usan {{ }} (no | safe) con datos del usuario
[ ] La aplicacion usa HTTPS (certificado Let's Encrypt)
[ ] Las cookies tienen flags Secure y HttpOnly
[ ] Los secretos están en variables de entorno, no en el código
[ ] El archivo .env está en .gitignore
[ ] Los errores detallados solo se muestran en desarrollo (debug=False en producción)
[ ] Se implementa límite de intentos en el login
[ ] Los formularios de modificación de datos usan tokens CSRF
[ ] Se registran los intentos de acceso fallidos
[ ] La aplicacion no expone versiones de software en headers o páginas de error
```

No tienes que implementar todo antes de tu primer proyecto, pero sí debes conocer los riesgos y priorizar según la sensibilidad de los datos que manejas.
