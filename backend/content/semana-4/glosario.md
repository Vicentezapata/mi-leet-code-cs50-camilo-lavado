# Glosario: Semana 4 — Memoria, Punteros y Archivos

---

## puntero (*pointer*)

Variable que almacena la **dirección de memoria** de otra variable, en lugar de un valor directo. Se declara con el asterisco `*` después del tipo: `int *p`.

```c
int n = 42;
int *p = &n;   /* p guarda la dirección de n, no el valor 42 */
```

Un puntero es simplemente un número (la dirección) que le dice al programa dónde encontrar un dato en la RAM. El tipo (`int *`, `char *`, etc.) le indica al compilador cuántos bytes leer a partir de esa dirección.

---

## dirección de memoria (*memory address*)

Número único que identifica cada **byte** en la RAM de la computadora. Típicamente se expresa en hexadecimal (por ejemplo, `0x7ffd4a3c1234`). Cada variable vive en una o más direcciones contiguas según su tamaño.

El operador `&` devuelve la dirección de una variable:
```c
int x = 10;
printf("%p\n", &x);   /* imprime algo como 0x7ffd... */
```

---

## desreferencia (*dereference*)

Acción de **seguir un puntero** para acceder al valor almacenado en la dirección que contiene. Se realiza con el operador `*` aplicado a un puntero ya existente.

```c
int n = 99;
int *p = &n;
printf("%d\n", *p);   /* desreferencia: "ve a donde p apunta" → 99 */
*p = 200;             /* también se puede escribir mediante desreferencia */
```

Desreferenciar un puntero `NULL` o no inicializado produce un **segmentation fault**.

---

## stack (pila)

Región de memoria usada para almacenar **variables locales** y los **frames** de las funciones activas. Se gestiona automáticamente: cuando una función retorna, su frame se elimina del stack sin que el programador tenga que hacer nada.

- Crece en una dirección (convencionalmente "hacia arriba").
- Tiene tamaño limitado: demasiada recursión produce *stack overflow*.
- No se usa `malloc` ni `free` para memoria del stack.

---

## heap (montón)

Región de memoria usada para **asignación dinámica**. A diferencia del stack, la memoria del heap persiste hasta que el programador la libera explícitamente con `free`. Es gestionada con `malloc`, `calloc`, `realloc` y `free`.

- Crece en la dirección opuesta al stack.
- Si heap y stack se encuentran, el programa se queda sin memoria.
- Olvidar liberar memoria del heap produce un *memory leak*.

---

## malloc

Función de la librería estándar (`<stdlib.h>`) que solicita al sistema operativo un bloque contiguo de bytes en el **heap**. Devuelve un puntero al primer byte del bloque, o `NULL` si no hay memoria disponible.

```c
/* Pide espacio para 10 enteros */
int *arr = malloc(10 * sizeof(int));

if (arr == NULL)
{
    /* El sistema no pudo asignar la memoria */
    return 1;
}
```

El nombre viene de *memory allocation* (asignación de memoria). La memoria devuelta por `malloc` contiene valores indeterminados ("basura"); no se inicializa en cero.

---

## free

Función de `<stdlib.h>` que devuelve al sistema operativo un bloque de memoria previamente asignado con `malloc`. Cada llamada a `malloc` debe tener exactamente una llamada a `free`.

```c
int *p = malloc(sizeof(int));
*p = 42;
/* ... usamos p ... */
free(p);     /* devolvemos la memoria */
p = NULL;    /* buena práctica: evita dangling pointer */
```

Llamar `free(NULL)` es seguro y no hace nada. Llamar `free` dos veces sobre el mismo puntero (*double free*) produce comportamiento indefinido.

---

## memory leak (fuga de memoria)

Error que ocurre cuando se asigna memoria con `malloc` pero **nunca se llama a `free`**, de modo que esa memoria queda ocupada indefinidamente aunque el programa ya no la necesite.

En programas de corta duración el efecto es imperceptible (el SO recupera la memoria al terminar el proceso). En programas de larga duración (servidores, navegadores), los memory leaks agotan progresivamente la RAM.

Detectar memory leaks: usar **Valgrind** (`valgrind ./programa`) y revisar si aparece `"definitely lost"` en el resumen.

---

## dangling pointer (puntero colgante)

Puntero que apunta a memoria que **ya fue liberada** con `free` o que pertenece a una variable local de una función que ya retornó. Usar un dangling pointer produce comportamiento indefinido: puede retornar basura, puede crashear el programa o puede parecer funcionar correctamente hasta el momento más inoportuno.

```c
int *p = malloc(sizeof(int));
*p = 5;
free(p);
/* p sigue guardando la dirección, pero esa memoria ya no nos pertenece */
printf("%d\n", *p);   /* comportamiento indefinido */
```

Solución: inmediatamente después de `free(p)`, asignar `p = NULL`.

---

## buffer overflow (desbordamiento de búfer)

Error que ocurre cuando un programa escribe **más datos de los que caben** en un bloque de memoria reservado, pisando la memoria adyacente. Es una de las vulnerabilidades de seguridad más explotadas históricamente.

```c
char nombre[4];         /* espacio para 3 chars + '\0' */
strcpy(nombre, "Alejandro");   /* desbordamiento: 9 chars + '\0' */
```

Consecuencias: datos corruptos, crashes, y en manos de un atacante, ejecución de código malicioso (*code injection*).

---

## segmentation fault (fallo de segmentación)

Error en tiempo de ejecución que ocurre cuando un programa intenta acceder a una región de memoria que el sistema operativo no le ha asignado. El SO detiene el proceso inmediatamente.

Causas comunes:
- Desreferenciar un puntero `NULL`.
- Acceder fuera de los límites de un array.
- Usar un puntero no inicializado.
- Acceder a memoria ya liberada (dangling pointer).

El mensaje en la terminal suele ser simplemente: `Segmentation fault (core dumped)`.

---

## NULL

Constante que representa la **dirección 0**, que por convención ningún objeto válido ocupa. Se usa como valor centinela para punteros que no apuntan a nada.

- `malloc` devuelve `NULL` si no puede asignar memoria.
- `fopen` devuelve `NULL` si no puede abrir el archivo.
- Desreferenciar `NULL` siempre produce segfault.
- `free(NULL)` es seguro (no hace nada).

```c
int *p = NULL;   /* puntero explícitamente vacío */

if (p != NULL)
    printf("%d\n", *p);   /* solo accedemos si p es válido */
```

No confundir con el carácter nulo `'\0'` (NUL con una sola L), que es el terminador de strings.

---

## sizeof

Operador de C que devuelve el **tamaño en bytes** de un tipo o variable en tiempo de compilación. No es una función; no genera código en tiempo de ejecución.

```c
printf("%zu\n", sizeof(int));      /* 4 en la mayoría de sistemas */
printf("%zu\n", sizeof(char));     /* 1 siempre */
printf("%zu\n", sizeof(double));   /* 8 en la mayoría de sistemas */

int arr[5];
printf("%zu\n", sizeof(arr));      /* 20 = 5 × 4 bytes */
```

Usar `sizeof` en lugar de números fijos hace el código portable entre diferentes arquitecturas.

---

## archivo binario (*binary file*)

Archivo cuyos datos se almacenan en **formato binario crudo** (bytes tal como se representan en memoria), sin conversión a texto legible. Contrasta con un archivo de texto, donde los datos son caracteres ASCII o UTF-8.

Ejemplos de archivos binarios: imágenes (BMP, PNG, JPEG), audio (WAV, MP3), video (MP4), ejecutables compilados.

Para leer y escribir archivos binarios en C se usa `fopen` con los modos `"rb"` y `"wb"`, y las funciones `fread` y `fwrite`:

```c
FILE *img = fopen("foto.bmp", "rb");   /* rb = read binary */
```

A diferencia de los archivos de texto, en modo binario no hay conversión de saltos de línea ni interpretación especial de ningún byte.
