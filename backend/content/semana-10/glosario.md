# Glosario Semana 10: Unicode y Emojis

Términos clave de esta semana, ordenados temáticamente para que puedas repasarlos con contexto.

---

## Fundamentos de Codificación

**ASCII** *(American Standard Code for Information Interchange)*
Estándar de codificación de caracteres creado en los años 60 que asigna valores del 0 al 127 a los caracteres del inglés. Usa 7 bits. Es la base de casi todos los sistemas modernos.

**Byte**
Unidad de 8 bits. En contextos de texto, un "byte" y un "carácter" no son lo mismo cuando se usa Unicode.

**Codificación** *(encoding)*
El esquema que define cómo se representan los code points Unicode en bytes reales en memoria o en disco. Los tres principales son UTF-8, UTF-16 y UTF-32.

**Code point**
El número único que Unicode asigna a cada carácter. Se escribe con el prefijo `U+` seguido de un número hexadecimal. Ejemplo: U+0041 es la letra `A`, U+1F602 es el emoji 😂.

**Página de código** *(code page)*
Sistema de codificación pre-Unicode donde fabricantes como IBM o Microsoft asignaban caracteres a los 256 valores de un byte, cada uno con asignaciones incompatibles entre sí. Fuente de gran confusión histórica.

---

## Unicode y sus Planos

**Unicode**
Estándar internacional que asigna un código único a cada carácter de todos los sistemas de escritura del mundo. Actualmente define más de 140,000 caracteres con capacidad para hasta 1,114,112 code points.

**BMP** *(Basic Multilingual Plane, Plano Básico Multilingüe)*
El primer plano de Unicode (U+0000 a U+FFFF), que contiene los caracteres más comunes de los idiomas modernos. La mayoría de los caracteres latinos, cirílicos, árabes, chinos y japoneses de uso cotidiano están en el BMP.

**SMP** *(Supplementary Multilingual Plane)*
El segundo plano de Unicode (U+10000 a U+1FFFF). Contiene emojis modernos, scripts históricos, símbolos matemáticos adicionales y otros caracteres especializados.

**Plano** *(plane)*
Cada uno de los 17 grupos de 65,536 code points en que se divide el espacio Unicode (Plano 0 a Plano 16).

---

## Codificaciones UTF

**UTF-8** *(Unicode Transformation Format - 8 bits)*
Codificación de longitud variable que usa 1 a 4 bytes por carácter. Compatible con ASCII (los primeros 128 caracteres ASCII se codifican de forma idéntica). Estándar dominante en la web (más del 98% de las páginas).

**UTF-16** *(Unicode Transformation Format - 16 bits)*
Codificación de longitud variable que usa 2 bytes para caracteres del BMP y 4 bytes (surrogate pairs) para caracteres de planos suplementarios. Usada internamente por JavaScript, Java y Windows.

**UTF-32** *(Unicode Transformation Format - 32 bits)*
Codificación de longitud fija que usa exactamente 4 bytes por carácter. Permite acceso aleatorio en O(1) pero usa más espacio. Poco usada en la práctica.

**Surrogate pair** *(par sustituto)*
En UTF-16, la combinación de dos valores de 16 bits usada para representar un carácter fuera del BMP (U+10000 en adelante). Cada mitad del par se llama *surrogate* y no tiene significado por sí sola.

**BOM** *(Byte Order Mark, marca de orden de bytes)*
El carácter U+FEFF colocado al inicio de algunos archivos de texto para indicar el encoding y el orden de bytes. Innecesario y a veces problemático en UTF-8, pero obligatorio en algunas variantes de UTF-16.

**Endianness** *(orden de bytes)*
El orden en que se almacenan los bytes de un valor multi-byte: big-endian (byte más significativo primero) o little-endian (byte menos significativo primero). Relevante principalmente para UTF-16 y UTF-32.

---

## Emojis y Composición

**Emoji**
Carácter Unicode que se renderiza como una imagen colorida. No es una imagen embebida, sino un code point (o secuencia de code points) que el sistema operativo mapea a su fuente de emojis local.

**Grapheme cluster** *(cluster de grafemas)*
La unidad mínima de texto que el usuario percibe como "un carácter". Puede estar compuesto por varios code points. Es el concepto correcto para contar "caracteres" desde la perspectiva del usuario.

**ZWJ** *(Zero Width Joiner, unidor de ancho cero)*
El carácter U+200D, invisible, que une secuencias de emojis para crear composiciones nuevas. Ejemplo: 👨 + ZWJ + 👩 + ZWJ + 👧 = 👨‍👩‍👧.

**Modificador de tono de piel** *(skin tone modifier)*
Uno de cinco caracteres Unicode (U+1F3FB a U+1F3FF) basados en la escala Fitzpatrick. Cuando sigue a un emoji de persona, cambia el tono de piel de ese emoji.

**Variation selector**
Carácter invisible que modifica la presentación del carácter anterior. U+FE0E (VS-15) forza presentación de texto, U+FE0F (VS-16) forza presentación como emoji. Ejemplo: ♥ vs ♥️.

**Secuencia de emojis** *(emoji sequence)*
Una serie de code points que juntos forman un emoji compuesto. Incluye secuencias ZWJ, secuencias de modificadores de tono de piel, y secuencias de banderas.

**Emoji de bandera** *(flag emoji)*
Formado por dos caracteres de "indicador regional" (U+1F1E6 a U+1F1FF) que corresponden a las letras ISO de un país. Ejemplo: 🇲🇽 = indicador-M + indicador-X.

---

## Problemas y Normalización

**Mojibake** *(文字化け)*
Término japonés para el fenómeno de caracteres corruptos causado por interpretar un texto con una codificación diferente a la que se usó para escribirlo. Signo: texto como `AÃ±o` cuando debería decir `Año`.

**Normalización Unicode**
El proceso de convertir text a una forma canónica, porque algunos caracteres tienen múltiples representaciones Unicode válidas que se ven idénticas. Las cuatro formas son NFC, NFD, NFKC y NFKD.

**NFC** *(Normalization Form Canonical Composition)*
Forma normalizada más común: caracteres compuestos ("é" como un solo code point U+00E9). Recomendada para la web y la mayoría de aplicaciones.

**NFD** *(Normalization Form Canonical Decomposition)*
Forma normalizada descompuesta: "é" como "e" + acento combinante (dos code points). Útil en algunas operaciones de búsqueda y ordenamiento.

**Carácter combinante** *(combining character)*
Code point que se combina visualmente con el carácter anterior para modificarlo. Los acentos en NFD son caracteres combinantes. Ejemplo: U+0301 es el acento agudo combinante.

---

## Instituciones y Procesos

**Consorcio Unicode** *(Unicode Consortium)*
Organización sin fines de lucro con sede en Mountain View, California, que mantiene el estándar Unicode. Sus miembros incluyen grandes empresas tecnológicas como Apple, Google, Microsoft y Meta.

**UTC** *(Unicode Technical Committee)*
El comité técnico del Consorcio Unicode responsable de las decisiones sobre el estándar, incluyendo la aprobación de nuevos emojis una vez al año.

**Subcomité de Emojis** *(Emoji Subcommittee)*
Grupo dentro del UTC que evalúa propuestas de nuevos emojis y recomienda al pleno del UTC cuáles aprobar.

**ICU** *(International Components for Unicode)*
Librería de software de código abierto mantenida por el Consorcio Unicode que proporciona soporte de Unicode para desarrolladores en C/C++ y Java.

**CLDR** *(Common Locale Data Repository)*
Base de datos mantenida por el Consorcio Unicode con información de localización: formatos de fecha, moneda, separadores decimales, y nombres de emojis por idioma.

**Escala Fitzpatrick**
Sistema de clasificación dermatológica de tipos de piel en seis categorías (I a VI), adoptado por Unicode en 2015 como base para los cinco modificadores de tono de piel de emojis (los tipos I y II se combinan en un solo modificador).

---

## En el Código

**`strlen()`**
Función de C que cuenta bytes hasta el carácter nulo `\0`. Con strings UTF-8 que contienen caracteres multi-byte, el resultado es el número de bytes, no el número de caracteres Unicode.

**`mbstowcs()`**
Función de la librería estándar de C que convierte una string multi-byte (como UTF-8) a una secuencia de "wide characters" (caracteres anchos), útil para contar caracteres Unicode correctamente.

**`wchar_t`**
Tipo de dato de C para "caracteres anchos" (wide characters). Su tamaño varía: en Linux es 4 bytes (suficiente para cualquier code point Unicode), en Windows es 2 bytes (solo cubre el BMP).

**`unicodedata`**
Módulo de la librería estándar de Python 3 que proporciona acceso a la base de datos de caracteres Unicode, incluyendo nombres, categorías y normalización.
