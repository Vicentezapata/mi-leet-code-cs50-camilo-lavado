# Glosario Técnico: Semana 2

Definiciones de los términos clave de esta semana. Están ordenados del más fundamental al más específico.

---

### Array (Arreglo)

Una colección de valores del mismo tipo de dato almacenados de forma **contigua** (uno al lado del otro) en la memoria. Se accede a cada elemento mediante un **índice** numérico que empieza en 0. En C se declara así: `int notas[3];` crea un arreglo de 3 enteros.

---

### Índice

El número entero que indica la posición de un elemento dentro de un arreglo. El primer elemento tiene índice `0`, el segundo `1`, y así sucesivamente. Si un arreglo tiene `n` elementos, el último índice válido es `n - 1`. Acceder a un índice fuera de ese rango produce comportamiento indefinido (y frecuentemente un *crash*).

---

### String (Cadena de texto)

En C, un *string* es simplemente un **arreglo de caracteres** (`char`) que termina con el carácter nulo `\0`. La librería CS50 provee el tipo `string` como sinónimo conveniente, pero por debajo sigue siendo un arreglo. El string `"hola"` ocupa 5 bytes: `'h'`, `'o'`, `'l'`, `'a'`, `'\0'`.

---

### Carácter Nulo (`\0`)

El carácter con valor ASCII 0 (todos sus bits en cero). Actúa como **marcador de fin** de todo string en C. Cuando funciones como `printf` o `strlen` recorren un string, se detienen al encontrar `\0`. No lo pones tú explícitamente — C lo agrega de forma automática al final de cualquier literal de texto entre comillas dobles.

---

### ASCII

*American Standard Code for Information Interchange*. Es una tabla que asigna un número entero a cada carácter imprimible y de control. Por ejemplo: `'A'` = 65, `'a'` = 97, `'0'` = 48. Gracias a ASCII, un `char` en C puede tratarse como número y realizarse operaciones aritméticas sobre él (restar 32 convierte una minúscula en mayúscula).

---

### Desbordamiento de Buffer (*Buffer Overflow*)

Error que ocurre cuando un programa escribe datos **más allá del límite** de un arreglo, pisando memoria que pertenece a otras variables o al sistema. Es una de las vulnerabilidades de seguridad más comunes en C. Ejemplo: declarar `char nombre[5]` e intentar guardar `"Alexander"` (9 chars + `\0`) produce un desbordamiento. C no verifica los límites automáticamente; esa responsabilidad es tuya.

---

### `argc` (*Argument Count*)

Parámetro de `main` que contiene el **número de argumentos** que el usuario escribió en la terminal, incluyendo el nombre del propio programa. Si ejecutas `./caesar 3`, entonces `argc = 2` (el programa + la clave).

---

### `argv` (*Argument Vector*)

Parámetro de `main` que contiene los **argumentos de la terminal como arreglo de strings**. `argv[0]` es siempre el nombre del programa. `argv[1]` es el primer argumento adicional, `argv[2]` el segundo, y así. La firma completa es: `int main(int argc, string argv[])`.

---

### ASCII (Aritmética sobre caracteres)

Dado que cada `char` es un número, puedes usar operadores aritméticos directamente. La expresión `c - 'A'` convierte una letra mayúscula a su posición en el alfabeto (0 para `'A'`, 25 para `'Z'`). Sumar `'A'` después de operar vuelve al rango ASCII correcto. Este patrón es la base de los cifrados de esta semana.

---

### Cifrado César (*Caesar Cipher*)

Algoritmo de cifrado simple que **desplaza** cada letra del alfabeto un número fijo de posiciones (la clave). Con clave 3, `A` → `D`, `B` → `E`, ..., `Z` → `C`. Es un ejemplo de *cifrado de sustitución monoalfabética*. La operación inversa (descifrar) consiste en restar la clave.

---

### Clave (de cifrado)

El valor secreto que controla cómo se transforma el mensaje. En el cifrado César es un número entero (el desplazamiento). En el cifrado de sustitución es un string de 26 letras. Tanto el emisor como el receptor deben conocer la clave para cifrar y descifrar.

---

### Módulo (`%`)

Operador aritmético que devuelve el **residuo** de una división entera. Ejemplo: `28 % 26 = 2`. Es indispensable en los cifrados para que el desplazamiento "dé la vuelta" al final del alfabeto: `(posición + clave) % 26` garantiza que el resultado siempre quede entre 0 y 25.

---

### `strlen` (*String Length*)

Función de la librería `string.h` que devuelve el número de caracteres de un string **sin contar el `\0` final**. `strlen("hola")` = 4. Internamente recorre el arreglo hasta encontrar `\0`. Por eficiencia, guarda el resultado en una variable antes de usarlo dentro de un bucle.

---

### Compilación vs. Enlazado (*Linking*)

Dos fases distintas del proceso de construir un ejecutable:
- **Compilación:** transforma tu archivo `.c` a código objeto (`.o`) — instrucciones binarias para la CPU, pero sin resolver referencias externas.
- **Enlazado:** combina uno o varios archivos objeto con las librerías necesarias (`stdio`, `cs50`, `string`, etc.) para producir el ejecutable final. Cuando olvidas `#include <string.h>`, el compilador no sabe que `strlen` existe; cuando falta la bandera `-lcs50`, el enlazador no puede encontrar la implementación de `get_string`.
