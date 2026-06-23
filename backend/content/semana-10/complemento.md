# Complemento Semana 10: Unicode en la Práctica

Este complemento profundiza en los aspectos más técnicos y curiosos de Unicode que no entraron en la lectura principal. Aquí encontrarás ejercicios mentales, curiosidades históricas y herramientas concretas para trabajar con texto Unicode en tus proyectos.

---

## 1. Cómo Leer una Cadena UTF-8 a Mano

Entender el encoding de UTF-8 te permite depurar problemas de codificación sin depender de herramientas. Practiquemos con la palabra **"café"**:

```
c → U+0063 → rango 0x0000-0x007F → 1 byte → 01100011
a → U+0061 → rango 0x0000-0x007F → 1 byte → 01100001
f → U+0066 → rango 0x0000-0x007F → 1 byte → 01100110
é → U+00E9 → rango 0x0080-0x07FF → 2 bytes → 11000011 10101001
```

Bytes resultantes: `63 61 66 C3 A9`

La longitud en bytes: **5**. La longitud en caracteres: **4**.

### Regla mnemotécnica para UTF-8

- Si el byte empieza con `0` → es un carácter ASCII completo (1 byte)
- Si el byte empieza con `110` → es el inicio de un carácter de 2 bytes
- Si el byte empieza con `1110` → es el inicio de un carácter de 3 bytes
- Si el byte empieza con `11110` → es el inicio de un carácter de 4 bytes
- Si el byte empieza con `10` → es un **byte de continuación** (no es el inicio de ningún carácter)

---

## 2. Herramientas para Explorar Unicode

### Desde la terminal

```bash
# Ver los bytes de un string en Python 3
python3 -c "print('😂'.encode('utf-8').hex())"
# Salida: f09f9882

# Ver el code point de un carácter
python3 -c "print(hex(ord('😂')))"
# Salida: 0x1f602

# Ver el nombre oficial Unicode de un carácter
python3 -c "import unicodedata; print(unicodedata.name('😂'))"
# Salida: FACE WITH TEARS OF JOY

# Contar bytes vs. code points vs. clusters
python3 -c "
texto = '👨‍👩‍👧'
print('Bytes:', len(texto.encode('utf-8')))  # bytes en UTF-8
print('Code points:', len(texto))             # code points
"
```

### Desde el navegador

Abre la consola de desarrollador (F12) y prueba:

```javascript
// JavaScript usa UTF-16 internamente
let emoji = "😂";
console.log(emoji.length);        // 2 (!)  → surrogate pair en UTF-16
console.log([...emoji].length);   // 1      → spread operator respeta code points

let familia = "👨‍👩‍👧";
console.log(familia.length);       // 8      → bytes UTF-16
console.log([...familia].length);  // 5      → code points
// Nota: ninguna da 1 (el cluster de grafemas real)

// Para clusters de grafemas en JS moderno:
let segmenter = new Intl.Segmenter();
let clusters = [...segmenter.segment(familia)];
console.log(clusters.length);     // 1 ✓
```

---

## 3. La Historia del BOM (Byte Order Mark)

El **BOM** (U+FEFF) es un carácter especial que algunos programas insertan al inicio de un archivo de texto para indicar el encoding y el orden de bytes. Esto puede causar problemas inesperados:

```bash
# Un archivo con BOM puede romper scripts de shell
# Síntoma clásico: "command not found" aunque el comando es correcto
# porque el shell ve \xEF\xBB\xBF antes de #!/usr/bin/env python3

# Para verificar si un archivo tiene BOM:
file mi_script.py
# Salida con BOM: "UTF-8 Unicode (with BOM) text"
# Salida sin BOM: "UTF-8 Unicode text"

# Para eliminar el BOM:
sed -i '1s/^\xEF\xBB\xBF//' mi_script.py
```

**Regla general:** UTF-8 **nunca** necesita BOM. Si tu editor agrega un BOM automáticamente, configúralo para que no lo haga.

---

## 4. Normalización Unicode: Cuando el Mismo Texto No Es Igual

Aquí hay un hecho sorprendente: la misma palabra puede tener **dos representaciones Unicode diferentes** que se ven idénticas pero no son iguales.

Toma la letra **"é"**:

- **Forma NFC (compuesta):** U+00E9 → `é` como un solo code point (é precompuesto)
- **Forma NFD (descompuesta):** U+0065 + U+0301 → `e` + combinando acento agudo

```python
# NFC: un code point
nfc = "é"   # é precompuesto
# NFD: dos code points
nfd = "é"  # e + acento agudo combinado

print(nfc == nfd)         # False (!)
print(len(nfc))           # 1
print(len(nfd))           # 2
print(nfc.encode())       # b'\xc3\xa9'    (2 bytes)
print(nfd.encode())       # b'e\xcc\x81'  (3 bytes)

# Visualmente idénticos:
print(nfc)  # é
print(nfd)  # é (parece igual)

# Solución: normalizar antes de comparar
import unicodedata
print(unicodedata.normalize('NFC', nfd) == nfc)  # True ✓
```

Las cuatro formas de normalización Unicode:

| Forma | Nombre | Descripción |
|-------|--------|-------------|
| NFC   | Canonical Decomposition, followed by Canonical Composition | Forma compuesta (más común en la web) |
| NFD   | Canonical Decomposition | Forma descompuesta |
| NFKC  | Compatibility Decomposition, followed by Canonical Composition | Compuesta con equivalencias de compatibilidad |
| NFKD  | Compatibility Decomposition | Descompuesta con equivalencias |

**Regla práctica:** Siempre normaliza a **NFC** antes de comparar strings que provienen de fuentes diferentes (formularios web, bases de datos, APIs).

---

## 5. Emojis Compuestos: La Combinatoria

Los emojis de parejas con diferentes tonos de piel son un ejercicio fascinante de combinatoria. Considera:

- 3 géneros (hombre, mujer, persona neutra)
- 6 tonos de piel (amarillo + 5 de Fitzpatrick)
- 2 personas en una pareja

El número de combinaciones posibles de parejas es:

```
(3 géneros × 6 tonos) × (3 géneros × 6 tonos) = 18 × 18 = 324 combinaciones
```

Cada una de esas 324 parejas es una secuencia ZWJ única. Internamente son cadenas de aproximadamente 15-25 bytes en UTF-8, pero visualmente se perciben como un solo símbolo.

Para implementar esto correctamente en una aplicación (como un selector de emojis), necesitas manejar estas secuencias como unidades atómicas, no como cadenas de bytes individuales.

---

## 6. El Problema del "Mojibake"

**Mojibake** (文字化け) es una palabra japonesa que describe el fenómeno de ver caracteres corruptos cuando se mezclan codificaciones. Es común al abrir archivos de texto en el programa incorrecto.

```
Texto original (UTF-8): "Año nuevo"
Leído como Latin-1:    "AÃ±o nuevo"

Texto original (Latin-1): "Año nuevo"
Leído como UTF-8:      Error o caracteres incorrectos
```

### Cómo diagnosticarlo en Python

```python
# Simulación de mojibake
original_utf8 = "Año nuevo".encode('utf-8')
# b'A\xc3\xb1o nuevo'

# Si lo lees con Latin-1 por error:
leido_mal = original_utf8.decode('latin-1')
print(leido_mal)  # AÃ±o nuevo ← mojibake

# Cómo recuperar el texto correcto si sabes que hay mojibake:
recuperado = leido_mal.encode('latin-1').decode('utf-8')
print(recuperado)  # Año nuevo ✓
```

### Casos reales de mojibake en español

- Archivos CSV exportados desde Excel en Windows que usan Windows-1252 pero se abren en Linux como UTF-8.
- Emails antiguos que usan ISO-8859-1 (Latin-1) abiertos en clientes modernos configurados para UTF-8.
- Bases de datos MySQL configuradas con `charset=latin1` cuando deberían ser `charset=utf8mb4`.

---

## 7. Unicode Más Allá del Texto

Unicode no es solo para texto legible. También incluye:

### Caracteres de dirección de texto (Bidi)

El árabe y el hebreo se escriben de derecha a izquierda. Unicode incluye caracteres de control de dirección (U+202A–U+202E, U+2066–U+2069) que indican al sistema de renderizado cómo mezclar texto de diferentes direcciones.

Esto fue usado en un famoso ataque de seguridad en 2021 llamado **"Trojan Source"**: se insertaban caracteres de control Bidi invisibles en código fuente para hacer que el código pareciera seguro al revisarlo, pero se ejecutara de forma diferente.

### El espacio de uso privado (Private Use Area)

Los code points U+E000–U+F8FF están reservados para uso privado. No tienen asignación oficial. Empresas como Apple los usan para sus propios símbolos internos (los iconos de  en macOS usan esta zona).

### Caracteres históricos

Unicode incluye scripts de civilizaciones extintas:
- **Cuneiforme sumerio** (U+12000–U+123FF)
- **Jeroglíficos egipcios** (U+13000–U+1342F)
- **Lineal B micénico** (U+10000–U+1007F)
- **Ogham irlandés medieval** (U+1680–U+169F)

---

## 8. Ejercicios para Pensar

**Ejercicio 1:** ¿Cuántos bytes ocupa la cadena `"¡Hola, mundo!"` en UTF-8? ¿Y cuántos caracteres tiene?

*(Pista: los caracteres ASCII ocupan 1 byte, pero ¡ (U+00A1) ocupa 2 bytes en UTF-8.)*

**Ejercicio 2:** Si una API tiene un límite de 280 "caracteres" y decides medir eso en bytes UTF-8, ¿qué tipo de usuario podría sentirse discriminado? ¿Por qué?

**Ejercicio 3:** Explica por qué `"👨‍👩‍👧".split("")` en JavaScript podría dar resultados inesperados.

**Ejercicio 4:** Una base de datos MySQL tiene la columna `nombre VARCHAR(50) CHARACTER SET utf8`. ¿Puede guardar el nombre `"José 😊"`? ¿Por qué sí o no?

*(Pista: `utf8` en MySQL solo soporta hasta 3 bytes por carácter. Los emojis necesitan 4 bytes. La codificación correcta es `utf8mb4`.)*

---

## 9. Curiosidades Finales

- El símbolo de **Bitcoin** (₿) es el code point U+20BF, agregado en Unicode 10.0 (2017).
- El signo de **copyright** (©) es U+00A9, el de **trademark** (™) es U+2122, y el de **registered** (®) es U+00AE.
- El carácter "más largo" en UTF-8 es cualquier emoji o símbolo del Plano 1 o superior: 4 bytes.
- Existe un emoji oficial del **Consorcio Unicode**: 🔤 no, pero sí hay una propuesta recurrente para agregar uno.
- El emoji **🤌** (gesto de pellizco italiano, U+1F90C) fue aprobado en 2020 y rápidamente se convirtió en uno de los más usados en países mediterráneos.
- La lengua con más caracteres únicos en Unicode es el **chino**, con más de 90,000 ideogramas (distribuidos en varios bloques CJK).
