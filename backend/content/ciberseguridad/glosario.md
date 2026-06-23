# Glosario de Ciberseguridad

Términos clave de este módulo, organizados por área temática para facilitar el repaso.

---

## Contraseñas y Autenticación

**Contraseña** *(password)*
Cadena de caracteres que actúa como secreto compartido entre el usuario y el sistema para verificar identidad. Por sí sola es la forma más débil de autenticación.

**Ataque de fuerza bruta** *(brute force attack)*
Método de ataque que prueba sistemáticamente todas las combinaciones posibles hasta encontrar la correcta. Su efectividad depende inversamente de la longitud y aleatoriedad de la contraseña, y del tiempo requerido para calcular cada intento.

**Diccionario de contraseñas** *(password dictionary)*
Lista de contraseñas comunes y variantes predecibles (como sustituciones `a→@`, `e→3`) que los atacantes usan como primer recurso en ataques de fuerza bruta. Son más eficientes que la búsqueda exhaustiva para contraseñas débiles.

**Autenticación de dos factores** *(two-factor authentication, 2FA)*
Sistema que requiere dos formas de verificación independientes: algo que sabes (contraseña), algo que tienes (teléfono, llave física), y/o algo que eres (biometría). Reduce drásticamente el riesgo de acceso no autorizado incluso si la contraseña es robada.

**Gestor de contraseñas** *(password manager)*
Software que genera, almacena y autocompleta contraseñas únicas y aleatorias para cada servicio. Permite usar contraseñas de alta seguridad sin necesidad de memorizarlas. Ejemplos: Bitwarden, 1Password, Keychain de Apple.

**Principio del menor privilegio** *(principle of least privilege)*
Regla de seguridad que establece que cada componente, usuario o proceso debe tener únicamente los permisos mínimos necesarios para cumplir su función. Limita el daño potencial de un ataque o error.

**Bloqueo por intentos fallidos** *(account lockout)*
Mecanismo que deniega o ralentiza el acceso después de cierto número de intentos de autenticación fallidos, frustrando los ataques de fuerza bruta automáticos.

**Timing attack** *(ataque de temporización)*
Ataque que infiere información secreta midiendo el tiempo que tarda el sistema en responder a diferentes inputs. Por ejemplo, una función de comparación que termina en cuanto encuentra la primera diferencia revela parcialmente el secreto.

---

## Hashing y Criptografía

**Función de hash**
Función matemática que convierte una entrada de cualquier longitud en una salida de longitud fija (el hash o *digest*). Debe ser determinista, de un solo sentido (no invertible), y resistente a colisiones. Úsalas para verificar integridad, nunca como cifrado.

**Hash**
El valor de salida de una función de hash. También llamado *digest*, *checksum* o *huella digital*. Ejemplo: el hash SHA-256 de "hola" es siempre `b94d27b9934d3e08...` (64 caracteres hexadecimales).

**MD5** *(Message Digest 5)*
Función de hash creada en 1991 que produce un digest de 128 bits (32 caracteres hexadecimales). Considerada criptográficamente rota desde 2004 (colisiones conocidas) y demasiado rápida para contraseñas. No debe usarse para propósitos de seguridad.

**SHA-256** *(Secure Hash Algorithm 256)*
Función de hash de la familia SHA-2 que produce un digest de 256 bits. Criptográficamente sólida para verificación de integridad y firmas digitales, pero demasiado rápida para almacenar contraseñas de forma segura.

**bcrypt**
Función de hashing diseñada específicamente para contraseñas (1999). Incorpora un salt automático y un cost factor ajustable que controla la lentitud intencional del cálculo. Recomendada para almacenar contraseñas en aplicaciones nuevas.

**Argon2**
Ganador del Password Hashing Competition de 2015. Más moderno que bcrypt, con resistencia adicional contra ataques con hardware especializado (GPUs y ASICs). Recomendado en proyectos nuevos.

**Salt**
Valor aleatorio único generado por usuario que se combina con la contraseña antes de hashearla. Impide los ataques con tablas arcoíris y garantiza que dos usuarios con la misma contraseña tengan hashes diferentes.

**Tabla arcoíris** *(rainbow table)*
Base de datos precomputada que mapea contraseñas comunes a sus hashes. Permite identificar contraseñas instantáneamente por búsqueda, sin necesidad de calcular. El uso de salt hace estas tablas inútiles.

**Colisión**
Dos entradas diferentes que producen el mismo hash. Una función de hash segura debe hacer las colisiones computacionalmente inviables de encontrar. MD5 tiene colisiones conocidas y explotables.

**Criptografía simétrica**
Sistema donde el emisor y el receptor comparten la misma clave secreta para cifrar y descifrar. Rápida y eficiente para grandes volúmenes de datos. Ejemplos: AES, ChaCha20.

**Criptografía asimétrica**
Sistema con un par de claves: una pública (se puede compartir libremente) y una privada (se guarda en secreto). Lo que una cifra, solo la otra puede descifrar. Base de TLS y las firmas digitales. Ejemplos: RSA, ECDSA.

**Cifrado extremo a extremo** *(end-to-end encryption, E2EE)*
Sistema donde solo el emisor y el receptor pueden leer los mensajes. Ni el proveedor del servicio ni intermediarios tienen acceso a las claves de descifrado. Ejemplos: Signal, iMessage, WhatsApp (con ciertas configuraciones).

---

## HTTPS y Seguridad Web

**HTTP** *(HyperText Transfer Protocol)*
Protocolo de comunicación web que transmite datos en texto plano. Inseguro para cualquier información sensible: cualquier intermediario puede leer el contenido.

**HTTPS** *(HTTP Secure)*
HTTP sobre TLS. Cifra la comunicación entre el navegador y el servidor. El candado en la barra de direcciones indica HTTPS activo. Estándar actual para cualquier sitio web.

**TLS** *(Transport Layer Security)*
Protocolo criptográfico que proporciona confidencialidad, integridad y autenticación para comunicaciones en red. Reemplazó a SSL (que está obsoleto). HTTPS usa TLS.

**SSL** *(Secure Sockets Layer)*
Predecesor obsoleto de TLS. Los términos "SSL" y "TLS" se usan incorrectamente como sinónimos en conversaciones informales, pero en la práctica todos los sistemas modernos usan TLS.

**Certificado digital**
Documento electrónico que vincula una clave pública con la identidad de un servidor (dominio). Emitido por una **Autoridad de Certificación** (CA) de confianza. El navegador lo verifica al establecer una conexión HTTPS.

**Let's Encrypt**
Autoridad de certificación gratuita y automatizada que emite certificados TLS válidos en segundos. Eliminó la principal barrera económica para adoptar HTTPS universalmente.

**CSP** *(Content Security Policy)*
Header HTTP que indica al navegador qué fuentes de contenido son confiables. Una CSP restrictiva puede prevenir ataques XSS incluso si el código de la aplicación tiene vulnerabilidades.

**Modo incógnito** *(private browsing)*
Modo del navegador que no guarda historial, cookies ni caché localmente después de cerrar la ventana. No oculta el tráfico de red ante el proveedor de internet, la empresa o la red local.

**Cookie**
Pequeño archivo de texto que el servidor envía al navegador para recordar información entre peticiones (como el estado de sesión). Pueden tener flags de seguridad: `HttpOnly` (inaccesible por JavaScript), `Secure` (solo por HTTPS), `SameSite` (restricción de origen cruzado).

**Cifrado de disco completo** *(full disk encryption)*
Técnica que cifra todos los datos almacenados en un dispositivo. Si el dispositivo es robado, los datos son ilegibles sin la clave de descifrado. Ejemplos: BitLocker (Windows), FileVault (macOS).

**Ransomware**
Tipo de malware que cifra los archivos de la víctima y exige un pago (generalmente en criptomonedas) para proporcionar la clave de descifrado. Especialmente devastador en hospitales, municipios y empresas sin backups actualizados.

---

## Vulnerabilidades de Aplicaciones Web

**OWASP** *(Open Web Application Security Project)*
Organización sin fines de lucro que publica recursos de seguridad web, incluyendo el **OWASP Top 10**: la lista de las diez vulnerabilidades más críticas en aplicaciones web. De consulta obligatoria para desarrolladores.

**SQL Injection** *(inyección SQL)*
Vulnerabilidad que permite a un atacante ejecutar consultas SQL arbitrarias al incluir código SQL en datos de entrada que el servidor concatena directamente en sus consultas. Puede resultar en robo, modificación o eliminación de datos.

**Consulta preparada** *(prepared statement, parameterized query)*
Técnica para interactuar con bases de datos donde los valores variables se especifican por separado del SQL, impidiendo que sean interpretados como código. La defensa principal contra SQL Injection.

**XSS** *(Cross-Site Scripting)*
Vulnerabilidad que permite inyectar código JavaScript malicioso en páginas web vistas por otros usuarios. El script se ejecuta en el navegador de la víctima con los permisos del sitio legítimo.

**XSS reflejado** *(reflected XSS)*
Variante de XSS donde el payload malicioso está en la URL y se "refleja" inmediatamente en la respuesta. Requiere que la víctima visite una URL especialmente construida.

**XSS almacenado** *(stored XSS)*
Variante de XSS donde el payload se almacena en la base de datos y afecta a todos los usuarios que visiten la página. El más peligroso por su alcance masivo.

**Escape de caracteres** *(HTML escaping)*
Proceso de convertir caracteres especiales HTML como `<`, `>`, `"` en sus entidades equivalentes (`&lt;`, `&gt;`, `&quot;`) para evitar que sean interpretados como código. Defensa principal contra XSS.

**CSRF** *(Cross-Site Request Forgery)*
Ataque que engaña al navegador de la víctima para enviar peticiones no autorizadas a un sitio donde está autenticada. Se previene con tokens CSRF únicos por sesión.

**Inyección de dependencias** *(dependency injection)*
Patrón de diseño donde los componentes reciben sus dependencias desde fuera en lugar de crearlas internamente. En seguridad, facilita el principio del menor privilegio al limitar el alcance de cada componente.

---

## Ingeniería Social y Phishing

**Ingeniería social** *(social engineering)*
Conjunto de técnicas psicológicas que manipulan a personas para que revelen información confidencial o realicen acciones perjudiciales para la seguridad. No explota vulnerabilidades técnicas, sino humanas.

**Phishing**
Técnica de ingeniería social, generalmente por email, que imita comunicaciones legítimas para robar credenciales o instalar malware. El nombre alude a "pescar" víctimas.

**Spear phishing**
Variante de phishing dirigida a una persona o empresa específica, usando información personal para aumentar la credibilidad del engaño.

**Smishing**
Phishing realizado mediante SMS (mensajes de texto).

**Vishing**
Phishing realizado mediante llamadas de voz (*voice phishing*).

**BEC** *(Business Email Compromise)*
Fraude donde el atacante se hace pasar por un ejecutivo de la empresa para solicitar transferencias bancarias o información confidencial.

**Pretexting**
Crear una historia o contexto falso (un *pretext*) para manipular a alguien para que proporcione información o acceso.

**Baiting**
Técnica de ingeniería social que usa un señuelo físico o digital (como una USB abandonada) para tentar a la víctima a ejecutar malware.

**Tailgating** *(piggybacking)*
Acceder físicamente a instalaciones restringidas siguiendo de cerca a alguien con acceso autorizado.

---

## Ataques y Malware

**Vector de ataque** *(attack vector)*
Camino o método que un atacante usa para obtener acceso no autorizado a un sistema. Ejemplos: phishing, SQL Injection, dispositivos físicos, vulnerabilidades de software.

**Exploit**
Código o técnica que aprovecha una vulnerabilidad específica en un sistema para lograr un efecto no autorizado.

**Malware** *(malicious software)*
Software diseñado para causar daño o acceso no autorizado. Incluye virus, troyanos, ransomware, spyware, adware y más.

**Virus**
Malware que se replica adjuntándose a otros programas. Requiere que el usuario ejecute el programa infectado para activarse.

**Troyano** *(trojan)*
Malware que se disfraza de software legítimo para engañar al usuario para que lo instale. Referencia al Caballo de Troya.

**Keylogger**
Software (o hardware) que registra todas las teclas pulsadas, capturando contraseñas y otra información sensible.

**Modelo de amenaza** *(threat model)*
Análisis formal de los posibles atacantes, sus motivaciones, y las vulnerabilidades relevantes para un sistema específico. Permite priorizar inversiones en seguridad según el riesgo real.

**Seguridad por oscuridad** *(security through obscurity)*
Estrategia incorrecta que basa la seguridad en mantener secreto el diseño o funcionamiento del sistema. Considerada mala práctica: los sistemas deben ser seguros incluso si su diseño es público.
