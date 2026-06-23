# Material Complementario: Strings, ASCII y Aritmética de Cifrados

En la lectura principal aprendiste los conceptos. Aquí profundizamos con tablas de referencia rápida, patrones de código que encontrarás en los problemas de esta semana, y la matemática detrás del módulo.

---

## 1. Tabla ASCII Práctica

No necesitas memorizar todos los valores, pero sí los rangos clave para trabajar con letras y dígitos en C:

| Rango        | Decimal | Ejemplo          |
|--------------|---------|------------------|
| Minúsculas   | 97–122  | `'a'`=97, `'z'`=122 |
| Mayúsculas   | 65–90   | `'A'`=65, `'Z'`=90  |
| Dígitos      | 48–57   | `'0'`=48, `'9'`=57  |
| Espacio      | 32      | `' '`            |
| Punto        | 46      | `'.'`            |
| Signo `!`    | 33      | `'!'`            |
| Signo `?`    | 63      | `'?'`            |
| `\0` (nulo)  | 0       | fin de string    |

**Truco de memoria:** minúsculas = mayúsculas + 32. Por eso restar/sumar 32 convierte entre ambas.

---

## 2. Iterar sobre un String en C: Cuatro Patrones

Existen varias formas de recorrer un string. Aquí están los patrones que verás en los problemas de esta semana:

### Patrón A: índice con `strlen` (el más común)

```c
#include <string.h>

int n = strlen(s);
for (int i = 0; i < n; i++)
{
    // usar s[i]
}
```

Calcula la longitud una sola vez antes del bucle. Es la forma recomendada.

### Patrón B: comparar con `\0` (muestra cómo funcionan los strings por dentro)

```c
for (int i = 0; s[i] != '\0'; i++)
{
    // usar s[i]
}
```

Funciona porque todo string en C termina con el carácter nulo `\0`. No necesitas `string.h`.

### Patrón C: puntero avanzante (lo verás más adelante en el curso)

```c
for (char *p = s; *p != '\0'; p++)
{
    // usar *p en lugar de s[i]
}
```

Por ahora no es necesario que lo uses, pero es bueno saber que existe.

### Patrón D: índice declarado en el `for` con `strlen` en la condición (forma corta pero ineficiente)

```c
// EVITAR en producción — strlen se llama en cada iteración
for (int i = 0; i < strlen(s); i++) { ... }
```

Funciona, pero es lento para strings largos. Evítalo cuando sepas de antemano que el string no cambia.

---

## 3. Aritmética Modular para Cifrados

El operador `%` (módulo) da el **residuo** de una división entera. Es la herramienta clave para que el cifrado "dé la vuelta" al llegar al final del alfabeto.

### ¿Qué hace `%`?

```
7 % 3 = 1   (7 = 3×2 + 1)
10 % 5 = 0
26 % 26 = 0
27 % 26 = 1
```

### Aplicado al cifrado César

Para cifrar la letra `Z` (posición 25) con clave 3:
```
(25 + 3) % 26 = 28 % 26 = 2  →  'C'
```

Para cifrar `A` (posición 0) con clave 1:
```
(0 + 1) % 26 = 1  →  'B'
```

### La fórmula completa explicada

```c
// Para una letra MAYÚSCULA:
char cifrada = ((c - 'A') + clave) % 26 + 'A';

// Paso 1: (c - 'A')       → convierte 'A'-'Z' a 0-25
// Paso 2: (... + clave)   → desplaza por la clave
// Paso 3: (... % 26)      → da la vuelta si supera 25
// Paso 4: (... + 'A')     → vuelve al rango ASCII de letras
```

Si omites el `% 26`, cuando llegues a `Z` + 1 obtendrías `[` (carácter ASCII 91), que no es una letra.

### Tabla de verificación: cifrado con clave 13

| Original | Posición | +13 | % 26 | Cifrada |
|----------|----------|-----|------|---------|
| A        | 0        | 13  | 13   | N       |
| M        | 12       | 25  | 25   | Z       |
| N        | 13       | 26  | 0    | A       |
| Z        | 25       | 38  | 12   | M       |

---

## 4. Validar que una Clave es Solo Dígitos

En el problema Caesar, el argumento de línea de comandos debe ser un número. Pero `argv[1]` siempre llega como `string`. Necesitas verificar que sea numérico antes de convertirlo con `atoi`.

```c
#include <ctype.h>
#include <string.h>

// Devuelve 1 si todos los caracteres de s son dígitos, 0 si no
int solo_digitos(string s)
{
    int n = strlen(s);
    for (int i = 0; i < n; i++)
    {
        if (!isdigit(s[i]))
        {
            return 0;  // encontró un no-dígito
        }
    }
    return 1;
}
```

Uso:

```c
if (!solo_digitos(argv[1]))
{
    printf("Uso: ./caesar <numero>\n");
    return 1;
}
int clave = atoi(argv[1]);
```

---

## 5. El Cifrado de Sustitución: Validar la Clave

Para el problema Substitution la clave es un string de 26 letras (cada letra del alfabeto exactamente una vez). Antes de usarla, debes validar:

1. Longitud exacta de 26.
2. Solo letras (sin números ni símbolos).
3. Sin letras repetidas.

```c
#include <ctype.h>
#include <string.h>

int clave_valida(string clave)
{
    // Verificar longitud
    if (strlen(clave) != 26)
    {
        return 0;
    }

    // Verificar que todas sean letras y sin repetición
    int visto[26] = {0};  // contador de cada letra
    for (int i = 0; i < 26; i++)
    {
        if (!isalpha(clave[i]))
        {
            return 0;  // no es letra
        }

        // Normalizar a índice 0-25 (ignorando mayúsculas/minúsculas)
        int indice = tolower(clave[i]) - 'a';
        if (visto[indice] != 0)
        {
            return 0;  // letra repetida
        }
        visto[indice] = 1;
    }
    return 1;
}
```

---

## 6. Contar Letras, Palabras y Oraciones para Readability

El problema Readability requiere tres contadores. Aquí el esqueleto:

```c
#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string texto = get_string("Texto: ");
    int n = strlen(texto);

    int letras = 0;
    int palabras = 0;
    int oraciones = 0;

    // Una palabra empieza con el primer carácter no-espacio
    // La forma más simple: contar espacios entre palabras
    // (y agregar 1 al final si el texto no está vacío)
    int en_palabra = 0;

    for (int i = 0; i < n; i++)
    {
        char c = texto[i];

        // Contar letras
        if (isalpha(c))
        {
            letras++;
            if (!en_palabra)
            {
                palabras++;
                en_palabra = 1;
            }
        }
        else if (c == ' ')
        {
            en_palabra = 0;
        }

        // Contar oraciones: punto, admiración o interrogación
        if (c == '.' || c == '!' || c == '?')
        {
            oraciones++;
        }
    }

    printf("Letras: %i\n", letras);
    printf("Palabras: %i\n", palabras);
    printf("Oraciones: %i\n", oraciones);
}
```

Una vez que tienes los tres contadores, aplicar la fórmula Coleman-Liau es directo.

---

## 7. Diferencia entre `atoi` y Leer un Entero

Cuando recibes datos por línea de comandos, llegan como `string`. Para convertirlos a `int` usas `atoi` (de `stdlib.h`):

```c
#include <stdlib.h>

int clave = atoi("13");   // clave = 13
int clave2 = atoi("abc"); // clave2 = 0  ← ojo, no da error
```

`atoi` **no valida** si el string es realmente un número. Por eso necesitas hacer la validación manual (como en la sección 4) antes de llamarla.

Cuando recibes datos interactivamente con `get_int` (de la librería CS50), la validación ya está incluida: repite el prompt hasta que el usuario ingrese un entero válido.
