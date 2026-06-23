# Clase 10: Emoji, Unicode y Representación de Texto

Bienvenidos a la Semana 10 de LocalCode (CS50x). Esta semana es diferente: no hay problemas de código que resolver. En cambio, nos detenemos a entender algo que usas todos los días sin pensarlo —el texto mismo— y cómo la computadora lo convierte en ceros y unos. Al terminar, comprenderás por qué un emoji puede "romper" tu código en C, por qué los chats miden mal la longitud de los mensajes, y cómo un estándar global llamado **Unicode** cambió para siempre la manera en que compartimos información.

---

## 1. El Problema de Representar el Mundo en Bits

Desde la Semana 0 sabes que una computadora solo maneja **bits**: ceros y unos. Para representar texto, alguien tuvo que decidir qué número corresponde a qué carácter. Esa asignación se llama una **codificación** (encoding).

### ASCII: el primer estándar

En los años 60, los ingenieros de telecomunicaciones estadounidenses crearon el **ASCII** (*American Standard Code for Information Interchange*). La idea era simple: 7 bits bastan para representar todos los caracteres del inglés.

Con 7 bits tienes 2⁷ = **128 posibles valores** (del 0 al 127). Eso alcanza para:

- Las letras del alfabeto inglés, mayúsculas y minúsculas (52 caracteres)
- Los dígitos del 0 al 9 (10 caracteres)
- Signos de puntuación comunes: `.`, `,`, `!`, `?`, etc.
- Caracteres de control como `\n` (salto de línea) y `\0` (nulo)

```
Carácter | Decimal | Binario
---------|---------|--------
'A'      |  65     | 1000001
'a'      |  97     | 1100001
'0'      |  48     | 0110000
'\n'     |  10     | 0001010
'\0'     |   0     | 0000000
```

El problema surgió casi de inmediato: el inglés no tiene tildes, ni ñ, ni ü, ni ç. Para cualquier hablante de español, francés, alemán, árabe o chino, 128 caracteres eran completamente insuficientes.

### Extensiones de 8 bits: el caos de las páginas de código

La solución inmediata fue usar el octavo bit del byte para agregar 128 caracteres más, dando un total de 256 posibles valores. Con eso cabían, por ejemplo, las vocales con tilde del español. Pero el problema fue que **cada fabricante definió esos 128 caracteres extra de forma diferente**.

IBM definió su **Code Page 850** para Europa occidental. Microsoft definió **Windows-1252**. Surgieron decenas de codificaciones incompatibles. Un texto creado en una computadora con una codificación podía mostrarse como basura (los famosos "caracteres raros" o *mojibake*) en otra computadora con una codificación diferente.

El mundo necesitaba un estándar universal. Ese estándar es **Unicode**.

---

## 2. Unicode: Un Número para Cada Carácter del Mundo

**Unicode** es un estándar internacional que asigna un número único —llamado **code point**— a cada carácter de todos los sistemas de escritura humanos conocidos: latin, árabe, chino, japonés, coreano, devanágari, cirílico, jeroglíficos egipcios, escrituras antiguas extintas, y también emojis.

### La notación de code points

Un code point se escribe con el prefijo `U+` seguido de un número hexadecimal. Por ejemplo:

| Carácter | Code Point | Nombre oficial |
|----------|------------|----------------|
| A        | U+0041     | LATIN CAPITAL LETTER A |
| ñ        | U+00F1     | LATIN SMALL LETTER N WITH TILDE |
| α        | U+03B1     | GREEK SMALL LETTER ALPHA |
| 中       | U+4E2D     | CJK UNIFIED IDEOGRAPH-4E2D |
| 😂       | U+1F602    | FACE WITH TEARS OF JOY |
| 🥟       | U+1F95F    | DUMPLING |

Unicode actualmente define más de **140,000 caracteres** asignados y tiene capacidad para representar hasta **1,114,112 code points** (del U+0000 al U+10FFFF).

### Planos de Unicode

El espacio completo de Unicode se divide en **17 planos**, cada uno con 65,536 posiciones:

```
Plano 0: U+0000 – U+FFFF   → BMP (Basic Multilingual Plane)
Plano 1: U+10000 – U+1FFFF → Supplementary Multilingual Plane (SMP)
Plano 2: U+20000 – U+2FFFF → Supplementary Ideographic Plane (SIP)
...
Plano 16: U+100000 – U+10FFFF → Supplementary Private Use Area-B
```

**El BMP (Plano Básico Multilingüe)** contiene los caracteres más comunes de todos los idiomas del mundo moderno. Los planos suplementarios contienen caracteres históricos, emojis, símbolos matemáticos adicionales, y más.

> Los emojis modernos, como 😂 (U+1F602), viven en el **Plano 1** (SMP), no en el BMP. Esto tiene consecuencias importantes para la programación, como veremos más adelante.

---

## 3. Codificaciones: Cómo se Almacenan los Code Points

Tener un número asignado a cada carácter es solo la mitad del problema. El otro desafío es decidir **cómo representar ese número en memoria**. Ahí entran las codificaciones de Unicode: UTF-8, UTF-16 y UTF-32.

### UTF-32: la más simple, la más costosa

**UTF-32** usa exactamente **4 bytes (32 bits) por cada code point**, sin importar cuál sea.

```
'A' (U+0041)  →  00 00 00 41  (4 bytes)
'ñ' (U+00F1)  →  00 00 00 F1  (4 bytes)
'😂'(U+1F602) →  00 01 F6 02  (4 bytes)
```

**Ventaja:** Acceso aleatorio en tiempo O(1). Si quieres el carácter número 1000, simplemente saltas 4000 bytes.  
**Desventaja:** Un archivo de texto en inglés puro ocupa 4 veces más espacio que en ASCII. Para la web, esto es inaceptable.

### UTF-16: el punto medio (con trampa)

**UTF-16** usa **2 bytes** para los caracteres del BMP y **4 bytes** para los de los planos suplementarios. Los caracteres de 4 bytes se representan mediante un par llamado **surrogate pair** (par sustituto).

```
'A' (U+0041)  →  00 41          (2 bytes)
'ñ' (U+00F1)  →  00 F1          (2 bytes)
'😂'(U+1F602) →  D8 3D DE 02   (4 bytes, surrogate pair)
```

**Ventaja:** Eficiente para textos en asiático (chino, japonés, coreano ocupan 2 bytes cada carácter).  
**Desventaja:** Los surrogate pairs complican el procesamiento. Además, tiene un problema de orden de bytes (*endianness*): necesitas saber si los bytes están en orden big-endian o little-endian, lo que se resuelve con un **BOM** (Byte Order Mark) al inicio del archivo.

JavaScript internamente usa UTF-16, lo que explica algunos comportamientos extraños con emojis en ese lenguaje.

### UTF-8: el campeón de la web

**UTF-8** es una codificación de **longitud variable** que usa de 1 a 4 bytes según el code point:

| Rango de code points | Bytes usados | Patrón de bits |
|----------------------|--------------|----------------|
| U+0000 – U+007F      | 1 byte       | `0xxxxxxx` |
| U+0080 – U+07FF      | 2 bytes      | `110xxxxx 10xxxxxx` |
| U+0800 – U+FFFF      | 3 bytes      | `1110xxxx 10xxxxxx 10xxxxxx` |
| U+10000 – U+10FFFF   | 4 bytes      | `11110xxx 10xxxxxx 10xxxxxx 10xxxxxx` |

Veamos un ejemplo concreto con la letra **ñ** (U+00F1):

```
U+00F1 en binario: 11110001
Cabe en el rango U+0080–U+07FF → necesita 2 bytes
Patrón: 110xxxxx 10xxxxxx
Distribución: 110 00011  10 110001
              ↓           ↓
Bytes:      0xC3        0xB1
```

Y con el emoji **😂** (U+1F602):

```
U+1F602 en binario: 0001 1111 0110 0000 0010
Cabe en el rango U+10000–U+10FFFF → necesita 4 bytes
Patrón: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
Distribución: 11110 000  10 011111  10 011000  10 000010
Bytes:         0xF0      0x9F       0x98       0x82
```

**Ventaja clave:** UTF-8 es **compatible con ASCII**. Cualquier texto ASCII válido es automáticamente UTF-8 válido, sin cambios. Esto hizo que la migración del mundo a UTF-8 fuera relativamente sencilla.

**Otra ventaja:** Es auto-sincronizante. Si empiezas a leer desde un byte cualquiera, puedes saber si es el inicio de un carácter (byte con `0` o con `11`) o un byte de continuación (empieza con `10`), lo que facilita recuperarse de errores.

> UTF-8 es hoy el estándar dominante en la web. Más del 98% de las páginas web usan UTF-8.

---

## 4. Por Qué `strlen()` en C Miente con Emojis

Aquí es donde la teoría se vuelve muy concreta. En C, las cadenas de texto son arrays de bytes (`char`) terminados en `\0`. La función `strlen()` cuenta los bytes hasta encontrar ese `\0`.

El problema: **bytes no son lo mismo que caracteres Unicode**.

```c
#include <stdio.h>
#include <string.h>

int main(void)
{
    // "Hola" → 4 caracteres, 4 bytes en UTF-8
    char *saludo = "Hola";
    printf("strlen(\"Hola\") = %zu\n", strlen(saludo)); // Imprime: 4 ✓

    // "Holañ" → 5 caracteres, pero ñ ocupa 2 bytes en UTF-8
    char *saludo2 = "Hola\xC3\xB1"; // ñ codificada en UTF-8
    printf("strlen(\"Hola ñ\") = %zu\n", strlen(saludo2)); // Imprime: 6 ✗

    // El emoji 😂 (U+1F602) ocupa 4 bytes en UTF-8
    char *emoji = "😂";
    printf("strlen(\"😂\") = %zu\n", strlen(emoji)); // Imprime: 4 ✗
    // El usuario ve 1 emoji, C ve 4 bytes

    return 0;
}
```

Resultado:
```
strlen("Hola") = 4
strlen("Hola ñ") = 6
strlen("😂") = 4
```

Para contar **caracteres Unicode** (code points) correctamente, necesitas una función que entienda UTF-8, como `mbstowcs()` de la librería estándar de C, o usar una librería especializada.

Este fue uno de los problemas reales que enfrentó Twitter cuando limitaba los tweets a 140 caracteres: al principio medían bytes, no caracteres Unicode. Un tweet en chino (donde cada carácter ocupa 3 bytes en UTF-8) parecía "más largo" que uno en inglés con la misma cantidad de palabras.

---

## 5. Emojis: Mucho Más que Imágenes Bonitas

Un emoji no es una imagen insertada en el texto. Es un **carácter Unicode** como cualquier otro, con su propio code point. Cuando tu teléfono muestra 😂, está:

1. Recibiendo el número **U+1F602**
2. Buscando ese code point en la **fuente de emojis** del sistema (Apple Color Emoji, Noto Emoji, etc.)
3. Renderizando la imagen correspondiente de esa fuente

Eso explica por qué el mismo emoji se ve diferente en iPhone, Android y WhatsApp Web: **el código transmitido es idéntico, pero cada plataforma tiene su propia fuente**.

```
iPhone envía:     F0 9F 98 82  (UTF-8 de U+1F602)
Android recibe:   F0 9F 98 82  (exactamente los mismos bytes)
Android muestra:  su propia versión gráfica de "face with tears of joy"
```

### 5.1 Modificadores de Tono de Piel

Los emojis de personas originalmente eran todos de color amarillo (una convención "neutral" tomada de los *Simpsons*). En 2015, Unicode introdujo **5 modificadores de tono de piel** basados en la escala Fitzpatrick, usada en dermatología:

| Emoji | Code Point | Nombre |
|-------|------------|--------|
| 🏻    | U+1F3FB   | EMOJI MODIFIER FITZPATRICK TYPE-1-2 |
| 🏼    | U+1F3FC   | EMOJI MODIFIER FITZPATRICK TYPE-3 |
| 🏽    | U+1F3FD   | EMOJI MODIFIER FITZPATRICK TYPE-4 |
| 🏾    | U+1F3FE   | EMOJI MODIFIER FITZPATRICK TYPE-5 |
| 🏿    | U+1F3FF   | EMOJI MODIFIER FITZPATRICK TYPE-6 |

El mecanismo es sencillo: cuando el modificador sigue inmediatamente a un emoji de persona, el sistema los combina visualmente.

```
👋 + 🏽 = 👋🏽
(U+1F44B) + (U+1F3FD) = mano agitando con tono de piel medio

strlen("👋🏽") = 8  ← C ve 8 bytes, tú ves 1 gesto
```

Para C, eso es una cadena de 8 bytes. Para ti, es un solo carácter. Esta discrepancia es una fuente constante de bugs.

### 5.2 El Zero Width Joiner (ZWJ)

El carácter **U+200D** se llama **Zero Width Joiner** (ZWJ, unidor de ancho cero). Es invisible, pero tiene un superpoder: une secuencias de emojis para formar uno nuevo.

Originalmente creado para usos tipográficos en árabe y devanágari, fue adoptado por el sistema de emojis para crear composiciones complejas:

```
🌈 + ZWJ + 🏳️ = 🏳️‍🌈 (Bandera del arcoíris)
U+1F308 + U+200D + U+1F3F3 = Bandera LGBT+

🐻 + ZWJ + ❄️ = 🐻‍❄️ (Oso polar)
U+1F43B + U+200D + U+2744 = Oso polar (bear + snowflake)

👨 + ZWJ + 👩 + ZWJ + 👧 = 👨‍👩‍👧 (Familia)
```

La familia con dos padres y una hija no es un solo code point: es una **secuencia de 5 code points** unidos por ZWJ. Internamente es una cadena de más de 25 bytes en UTF-8.

```c
// "Familia" compuesta (👨‍👩‍👧)
char *familia = "👨‍👩‍👧";
printf("strlen = %zu\n", strlen(familia)); // ¡Puede imprimir 25 o más!
// El usuario ve 1 emoji de familia, C ve 25 bytes
```

### 5.3 Variantes de Texto y Emoji

Muchos caracteres en Unicode tienen dos formas de presentación: **texto** (monocromático, como tipografía) o **emoji** (colorido y gráfico). El selector se controla con caracteres especiales:

- **U+FE0E** — Variation Selector 15 (VS-15): forza presentación de texto
- **U+FE0F** — Variation Selector 16 (VS-16): forza presentación de emoji

```
☀ → ☀ texto (U+2600 solo)
☀️ → ☀️ emoji (U+2600 + U+FE0F)

♥ → ♥ texto (U+2665 solo)
♥️ → ♥️ emoji (U+2665 + U+FE0F)
```

Esto explica por qué algunos "emojis" se ven diferentes según el contexto: puede estar faltando o sobrando un variation selector.

---

## 6. Secuencias de Emojis: El Problema de la Longitud

Todas estas técnicas de composición crean lo que se llama un **cluster de grafemas** (grapheme cluster): lo que el usuario percibe como "un solo carácter visual", que puede estar compuesto por varios code points, que a su vez se almacenan como varios bytes.

Veamos la escala completa de complejidad:

```
Emoji            | Code Points | Bytes UTF-8 | Lo que ves
-----------------|-------------|-------------|------------
A                | 1           | 1           | A
ñ                | 1           | 2           | ñ
😂               | 1           | 4           | 😂
👋🏽              | 2           | 8           | 👋🏽
🏳️‍🌈             | 4           | 14          | 🏳️‍🌈
👨‍👩‍👧‍👦           | 7           | 25          | 👨‍👩‍👧‍👦
```

El emoji de familia con dos padres y dos hijos (👨‍👩‍👧‍👦) es una cadena de **25 bytes** en UTF-8, compuesta por **7 code points**, pero visualmente se percibe como **1 solo emoji**.

Esto fue un problema real para Twitter cuando implementó el límite de 280 caracteres. La decisión de qué contar como "un carácter" requirió implementar un contador de grapheme clusters, no un contador de bytes ni de code points.

---

## 7. El Consorcio Unicode y el Proceso de Creación de Emojis

El **Consorcio Unicode** es una organización sin fines de lucro con sede en Mountain View, California. Su misión original era unificar todas las codificaciones de caracteres del mundo en un solo estándar. Cuando Apple y Google llegaron a Japón en 2007 y encontraron un ecosistema fragmentado de emojis (cada operador telefónico tenía los suyos propios, incompatibles entre sí), acudieron a Unicode para unificar ese sistema también.

### Cómo se aprueba un nuevo emoji

El proceso tiene varios pasos:

1. **Propuesta pública:** Cualquier persona puede proponer un emoji. Unicode tiene un formulario disponible entre abril y agosto de cada año.

2. **Evaluación por el subcomité de emojis:** Se revisan criterios como:
   - **Demanda popular:** ¿Con qué frecuencia se busca el concepto? El punto de referencia es el elefante 🐘, que aparece entre 500 y 700 millones de veces en búsquedas de Google.
   - **Múltiples usos y significados:** Los emojis más exitosos tienen lecturas literales y metafóricas.
   - **Distinguibilidad visual:** ¿Se puede reconocer claramente a tamaño pequeño?
   - **Completitud:** ¿Llena un hueco evidente en el conjunto existente?

3. **Voto del UTC (Unicode Technical Committee):** Una vez al año, el comité completo vota el conjunto de nuevos emojis.

4. **Adopción por plataformas:** Apple, Google, Microsoft y otros implementan los emojis en sus sistemas operativos. Este proceso toma históricamente entre 18 y 24 meses desde la propuesta hasta que aparece en tu teléfono.

### Qué descalifica una propuesta

- Demasiado específico o de nicho muy reducido
- Redundante con emojis existentes
- No visualmente distinguible a tamaño pequeño
- Logos, marcas comerciales, deidades o celebridades
- (Desde hace unos años) Nuevas banderas nacionales

---

## 8. El Caso del Emoji de Mate 🧉

Un ejemplo latinoamericano que ilustra perfectamente el proceso: el emoji del **mate** (🧉, U+1F9C9). Un grupo de personas de Argentina propuso este emoji como símbolo de su bebida nacional. El mate pasó por el proceso completo de propuesta, evaluación, y votación, y fue aprobado en **Unicode 11.0 (2018)**.

Es un ejemplo de cómo el proceso Unicode, aunque controlado históricamente por empresas tecnológicas estadounidenses, ha ido abriéndose a la diversidad cultural global.

---

## 9. Implicaciones Prácticas para Programadores

### Al trabajar con texto en C

- Nunca asumas que `strlen()` te da el número de caracteres que ve el usuario.
- Para trabajar correctamente con Unicode en C, necesitas funciones como `mbstowcs()` o librerías como **libunicode** o **ICU** (International Components for Unicode).
- Si procesas texto carácter por carácter, debes entender UTF-8 y manejar bytes de continuación.

### Al trabajar con bases de datos

- Asegúrate de que la codificación de tu base de datos esté configurada en **UTF-8** (en MySQL/MariaDB es `utf8mb4`, no `utf8`, que solo soporta hasta 3 bytes por carácter y excluye a los emojis del Plano 1).
- Truncar texto en el byte incorrecto puede corromper un carácter multi-byte.

### Al trabajar con APIs y JSON

- JSON en Python 3 maneja Unicode de forma transparente por defecto.
- Al enviar emojis por HTTP, deben estar correctamente codificados en UTF-8.
- Los límites de longitud en APIs (como los 280 caracteres de Twitter/X) no son límites de bytes sino de grapheme clusters, lo que requiere una implementación cuidadosa.

### Al trabajar con expresiones regulares

- En muchos lenguajes, `.` en una regex no coincide con caracteres fuera del BMP a menos que actives una opción especial.
- En JavaScript: `/^.$/` no coincide con `'😂'` a menos que uses el flag `/u`.
- En Python 3, el manejo por defecto es correcto gracias a que las strings son Unicode nativas.

---

## 10. Python 3 y el Manejo Correcto de Unicode

Python 3 (a diferencia de Python 2) trata las cadenas de texto como secuencias de **code points Unicode**, no como secuencias de bytes. Esto lo hace mucho más amigable para trabajar con texto internacional:

```python
# Python 3 entiende Unicode de forma nativa
texto = "Hola 😂"

# len() cuenta code points, no bytes
print(len(texto))  # 7 (5 letras + 1 espacio + 1 emoji) ✓

# Pero OJO: los clusters de grafemas siguen siendo un problema
familia = "👨‍👩‍👧"
print(len(familia))  # 5 (cuenta los 5 code points, no 1 cluster) ✗

# Para contar clusters de grafemas en Python necesitas:
# pip install grapheme
import grapheme
print(grapheme.length(familia))  # 1 ✓
```

Python 3 usa internamente un sistema flexible: almacena strings como Latin-1 (1 byte/char), UCS-2 (2 bytes/char) o UCS-4 (4 bytes/char) según el carácter más "grande" que contenga la string, optimizando automáticamente el uso de memoria.

---

## Resumen

| Concepto | Definición clave |
|----------|------------------|
| **Code point** | Número único asignado a cada carácter en Unicode (ej: U+1F602) |
| **BMP** | Plano Básico Multilingüe: los primeros 65,536 code points de Unicode |
| **UTF-8** | Codificación de longitud variable (1-4 bytes), compatible con ASCII, dominante en la web |
| **UTF-16** | Codificación de longitud variable (2-4 bytes), usada internamente en JavaScript y Java |
| **UTF-32** | Codificación de longitud fija (4 bytes), simple pero costosa en espacio |
| **Surrogate pair** | Par de values de 16 bits en UTF-16 para representar caracteres fuera del BMP |
| **ZWJ** | Zero Width Joiner (U+200D): une emojis para crear composiciones |
| **Grapheme cluster** | Lo que el usuario percibe como "un carácter", independientemente de cuántos code points/bytes usa |
| **Variation selector** | Carácter que fuerza la presentación en modo texto (U+FE0E) o emoji (U+FE0F) |
| **Consorcio Unicode** | Organización que mantiene el estándar Unicode, incluyendo la aprobación de nuevos emojis |

---

## Para Profundizar

- **Unicode.org** — El sitio oficial del Consorcio Unicode. Puedes buscar cualquier carácter y ver su código, nombre, y propiedades.
- **UTF-8 Everywhere** (utf8everywhere.org) — Manifiesto técnico que explica por qué UTF-8 debe ser el estándar universal.
- **Emojipedia** (emojipedia.org) — Enciclopedia de emojis con historia, variantes por plataforma y code points.
- **grapheme-splitter** — Librería JavaScript para contar clusters de grafemas correctamente.
- El libro *Emoji: The History of a Smiley Face* de Jennifer 8. Lee — La historia de la gobernanza global de los emojis desde dentro.
