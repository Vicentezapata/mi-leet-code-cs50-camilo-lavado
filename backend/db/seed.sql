INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-mario-c', 'Mario', '## El reto de Mario

Implementa un programa que imprima una media pirámide alineada a la derecha, usando el caracter `#`, de una altura especificada por el usuario (entre 1 y 8).

### Ejemplo de salida para altura 4:
```
   #
  ##
 ###
####
```

### Requisitos
- Solicitar al usuario un número entre 1 y 8.
- Si el input es inválido, volver a solicitar.
- Imprimir la pirámide con los espacios y `#` correctos.', 'Fácil', 'c', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-mario-1', 'p-mario-c', '1\n', '#\n', 0),
('tc-mario-2', 'p-mario-c', '2\n', ' #\n##\n', 0),
('tc-mario-3', 'p-mario-c', '4\n', '   #\n  ##\n ###\n####\n', 0),
('tc-mario-4', 'p-mario-c', '8\n', '       #\n      ##\n     ###\n    ####\n   #####\n  ######\n #######\n########\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-mario-1', 'p-mario-c', 1, '¿Cuántas filas necesitas imprimir en total? ¿Está relacionado con la altura que ingresó el usuario?'),
('h-mario-2', 'p-mario-c', 2, 'En cada fila `i` (comenzando desde 1), ¿cuántos espacios van antes del primer `#`? ¿Y cuántos `#` van en esa fila?'),
('h-mario-3', 'p-mario-c', 3, 'Piensa en un bucle anidado: el exterior controla las filas, y los interiores imprimen primero los espacios y luego los `#`. ¿Qué condición de parada tiene cada uno?'),
('h-mario-4', 'p-mario-c', 4, '¿Qué función de C usas para validar el input? ¿Qué pasa si el usuario escribe "0" o "9"? ¿Cómo harías un bucle que siga pidiendo hasta obtener un valor válido?')
ON CONFLICT(id) DO NOTHING;

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-1-1', 1, '¿Qué hace la función `printf` en C?', 'Imprime texto formateado en la salida estándar (stdout). Acepta una cadena de formato y argumentos adicionales. Ejemplo: `printf("Hola %s, tienes %d años", nombre, edad);`', 1),
('fc-1-2', 1, '¿Cuál es la diferencia entre `int` y `float` en C?', '`int` almacena números enteros sin decimales (ej: 42). `float` almacena números con punto flotante/decimales (ej: 3.14). `int` ocupa 4 bytes y es más rápido; `float` también 4 bytes pero representa un rango diferente de valores.', 2),
('fc-1-3', 1, '¿Qué es una variable en C y cómo se declara?', 'Una variable es un espacio en memoria con un nombre y tipo. Se declara especificando el tipo y el nombre: `int altura = 5;`. En C clásico, las variables se declaran al inicio del bloque.', 3),
('fc-1-4', 1, '¿Para qué sirve el bucle `for` en C?', 'Repite un bloque de código un número determinado de veces. Tiene 3 partes: inicialización, condición y actualización. Ejemplo: `for (int i = 0; i < 10; i++) { ... }` ejecuta 10 veces.', 4),
('fc-1-5', 1, '¿Qué hace el operador `%` (módulo) en C?', 'Devuelve el **resto** de una división entera. Ejemplo: `10 % 3 = 1` porque 10 / 3 = 3 con resto 1. Es muy útil para saber si un número es par (`n % 2 == 0`) o para limitar valores a un rango.', 5),
('fc-1-6', 1, '¿Cuál es la diferencia entre `=` y `==` en C?', '`=` es el operador de **asignación**: guarda un valor en una variable (`x = 5`). `==` es el operador de **comparación**: evalúa si dos valores son iguales y devuelve 1 (verdadero) o 0 (falso). Confundirlos es un error muy común.', 6),
('fc-1-7', 1, '¿Qué es `scanf` y cuándo se usa?', '`scanf` lee datos desde la entrada estándar (stdin). Usa especificadores de formato igual que `printf`. Ejemplo: `scanf("%d", &n);` lee un entero y lo guarda en `n`. El `&` es crucial: le indica a `scanf` la **dirección de memoria** donde guardar el valor.', 7),
('fc-1-8', 1, '¿Qué significa `#include <stdio.h>` al inicio de un programa C?', 'Le indica al compilador que incluya la **librería estándar de entrada/salida**. Esta librería define funciones como `printf`, `scanf`, `puts`, etc. Sin este include, el compilador no reconocería esas funciones.', 8)
ON CONFLICT(id) DO NOTHING;

-- Cash Problem Seed
INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-cash-c', 'Cash', '## El reto de Cash

Implementa un programa que calcule el número mínimo de monedas necesarias para dar un cambio especificado por el usuario (en centavos).

Las monedas disponibles son:
- **Quarters** (25¢)
- **Dimes** (10¢)
- **Nickels** (5¢)
- **Pennies** (1¢)

### Ejemplo de ejecución:
Si el usuario introduce `41` centavos, el cambio mínimo es 4 monedas (1 de 25¢, 1 de 10¢, 1 de 5¢, y 1 de 1¢).

### Requisitos:
- Solicitar al usuario un número entero no negativo de centavos.
- Si el usuario introduce un número negativo, volver a solicitar.
- Imprimir únicamente el número total de monedas necesarias seguido de un salto de línea.', 'Fácil', 'c', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-cash-1', 'p-cash-c', '41\n', '4\n', 0),
('tc-cash-2', 'p-cash-c', '160\n', '7\n', 0),
('tc-cash-3', 'p-cash-c', '4\n', '4\n', 0),
('tc-cash-4', 'p-cash-c', '0\n', '0\n', 0),
('tc-cash-5', 'p-cash-c', '-10\n15\n', '2\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-cash-1', 'p-cash-c', 1, 'Para resolver Cash, necesitas saber qué monedas tienes disponibles. ¿Cuáles son sus valores?'),
('h-cash-2', 'p-cash-c', 2, 'Siempre queremos usar la moneda más grande posible primero (un enfoque Greedy o voraz). Si el cambio es mayor o igual a 25 centavos, ¿cuántas monedas de 25 puedes usar?'),
('h-cash-3', 'p-cash-c', 3, 'Puedes restar 25 al total de forma repetida (con un bucle) o usar el operador `/` para obtener la división entera y `%` para el residuo.'),
('h-cash-4', 'p-cash-c', 4, 'Una vez que termines con las de 25, haz el mismo proceso con las de 10, luego 5 y finalmente 1 centavo. Al final, suma todas las monedas usadas y muéstralas.')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 0: Pensamiento Computacional y Representación Binaria
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-binary-py', 'Binary', '## El reto de Binary

Implementa un programa en Python que convierta un número entero no negativo a su representación en binario, **sin usar** la función incorporada `bin()`.

El programa debe:
1. Leer un entero `n` desde la entrada estándar
2. Imprimir su representación binaria (solo los dígitos, sin prefijos como `0b`)

### Ejemplos:

| Entrada | Salida     |
|---------|------------|
| `0`     | `0`        |
| `1`     | `1`        |
| `5`     | `101`      |
| `42`    | `101010`   |
| `255`   | `11111111` |

### Restricciones
- No puedes usar `bin()`, `format()` con `b`, ni f-strings con formato `f"{n:b}"`
- El algoritmo debe implementar divisiones sucesivas por 2', 'Fácil', 'python', 0)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-binary-1', 'p-binary-py', '0\n',   '0\n',          0),
('tc-binary-2', 'p-binary-py', '1\n',   '1\n',          0),
('tc-binary-3', 'p-binary-py', '42\n',  '101010\n',     0),
('tc-binary-4', 'p-binary-py', '255\n', '11111111\n',   1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-binary-1', 'p-binary-py', 1, '¿Cuál es la regla para determinar el último bit (el menos significativo) de un número? Si el número es par, ese bit es 0; si es impar, es 1. ¿Qué operador de Python te da el residuo de una división?'),
('h-binary-2', 'p-binary-py', 2, 'Después de anotar el bit menos significativo (el residuo de dividir por 2), ¿cómo "eliminas" ese bit del número para seguir procesando los bits restantes? Pista: usa división entera `//`.'),
('h-binary-3', 'p-binary-py', 3, 'Los bits que obtienes por divisiones sucesivas salen en orden inverso: del menos significativo al más significativo. ¿Cómo invertirías una lista o un string en Python para presentarlos en el orden correcto?'),
('h-binary-4', 'p-binary-py', 4, '¿Qué caso especial debes manejar? Si `n = 0`, el bucle de divisiones nunca se ejecuta porque la condición `n > 0` ya es falsa. ¿Cuál debería ser la salida para ese caso?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 1 (adicional): Population
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-population-c', 'Population', '## El reto de Population

Implementa un programa en C que calcule cuántos **años** tarda una población de llamas en crecer de un tamaño inicial a un tamaño objetivo.

Cada año, nacen `n/3` llamas nuevas y mueren `n/4` llamas (división entera), donde `n` es la población actual al inicio del año:

```
n = n + n/3 - n/4
```

El programa debe:
1. Solicitar un tamaño de población inicial (mínimo 9; si el usuario ingresa un valor menor, volver a preguntar)
2. Solicitar un tamaño de población objetivo (debe ser mayor o igual al inicial; si no, volver a preguntar)
3. Imprimir el número de años necesarios para alcanzar o superar la población objetivo

### Ejemplo para inicial=20, objetivo=28:

| Año | Cálculo                      | Población |
|-----|------------------------------|-----------|
| 1   | 20 + 20/3 - 20/4 = 20+6-5   | 21        |
| 2   | 21 + 21/3 - 21/4 = 21+7-5   | 23        |
| 3   | 23 + 23/3 - 23/4 = 23+7-5   | 25        |
| 4   | 25 + 25/3 - 25/4 = 25+8-6   | 27        |
| 5   | 27 + 27/3 - 27/4 = 27+9-6   | 30 ≥ 28   |

Salida: `5`', 'Fácil', 'c', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-population-1', 'p-population-c', '20\n28\n',   '5\n', 0),
('tc-population-2', 'p-population-c', '100\n200\n', '9\n', 0),
('tc-population-3', 'p-population-c', '9\n9\n',     '0\n', 0),
('tc-population-4', 'p-population-c', '9\n18\n',    '8\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-population-1', 'p-population-c', 1, '¿Qué tipo de dato usarías para la población? ¿Un `int` es suficiente para poblaciones grandes, o necesitas un `long`? Considera que el enunciado no especifica un límite superior.'),
('h-population-2', 'p-population-c', 2, 'La fórmula `n = n + n/3 - n/4` usa división entera en C (los decimales se truncan automáticamente). ¿Cómo inicializas el contador de años y en qué momento lo incrementas dentro del bucle?'),
('h-population-3', 'p-population-c', 3, 'Para validar los inputs, ¿qué tipo de bucle usarías para seguir pidiendo al usuario hasta que ingrese un valor válido? ¿`while` o `do-while`? ¿Cuál comunica mejor la intención de "pedir al menos una vez"?'),
('h-population-4', 'p-population-c', 4, '¿Cuál es la condición de parada del bucle de simulación? El enunciado dice "alcanzar o superar". Si la población inicial ya es igual al objetivo, ¿cuántos años deberías imprimir? Revisa el caso de prueba `9 → 9`.')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 0
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-0-1', 0, '¿Qué es un `bit` y de dónde viene ese nombre?', 'Un `bit` es la unidad mínima de información en informática: puede ser `0` o `1`. El nombre es una contracción de *binary digit* (dígito binario). Representa un transistor en estado apagado (`0`) o encendido (`1`).', 1),
('fc-0-2', 0, '¿Cuántos valores distintos puede representar un `byte`? ¿Por qué ese número?', 'Un `byte` tiene 8 bits y cada bit puede ser `0` o `1`. Esto da 2⁸ = **256** combinaciones posibles, representando valores del 0 al 255. Es la razón por la que los colores RGB van de 0 a 255 por canal.', 2),
('fc-0-3', 0, '¿Por qué las computadoras usan el sistema binario en lugar del decimal?', 'Por razones físicas: un transistor es un interruptor que solo puede estar en dos estados confiables (conduce electricidad o no). Distinguir entre 10 niveles de voltaje distintos (base 10) sería mucho más difícil de fabricar con precisión y más propenso a errores.', 3),
('fc-0-4', 0, '¿Qué es `ASCII` y cuál es su limitación principal?', '`ASCII` es un estándar de 1963 que asigna un número del 0 al 127 a cada carácter del inglés básico (letras, dígitos, puntuación). Su limitación es que solo cubre el inglés: no tiene `ñ`, `á`, caracteres chinos, árabes, emojis ni ningún otro símbolo fuera del inglés básico.', 4),
('fc-0-5', 0, '¿En qué se diferencia `Unicode` de `ASCII`?', '`Unicode` es un estándar moderno que unifica todos los sistemas de escritura del mundo en una sola tabla de más de 1.1 millones de puntos de código, incluyendo emojis. `ASCII` solo define 128 caracteres del inglés. `Unicode` con codificación `UTF-8` es compatible con `ASCII` para los primeros 128 caracteres.', 5),
('fc-0-6', 0, '¿Qué es un algoritmo? Menciona sus tres propiedades esenciales.', 'Un algoritmo es una secuencia finita, precisa y sin ambigüedad de pasos para resolver un problema. Sus tres propiedades esenciales son: (1) **Correcto** — produce la respuesta correcta para todas las entradas válidas. (2) **Finito** — siempre termina. (3) **Eficiente** — usa los recursos (tiempo, memoria) de forma razonable.', 6),
('fc-0-7', 0, '¿Por qué la búsqueda binaria es más eficiente que la búsqueda lineal? ¿Cuándo no se puede usar?', 'La búsqueda lineal revisa cada elemento uno a uno: hasta O(n) pasos. La búsqueda binaria divide el espacio a la mitad en cada paso: O(log n) pasos. Para 1,024 elementos, lineal necesita hasta 1,024 pasos; binaria solo 10. La condición: **los datos deben estar ordenados**. Si no están ordenados, no se puede aplicar.', 7),
('fc-0-8', 0, '¿Qué es el `pseudocódigo` y para qué sirve?', 'El `pseudocódigo` es una descripción informal de un algoritmo escrita en lenguaje humano estructurado, sin la sintaxis exacta de ningún lenguaje de programación. Se usa para planificar la lógica antes de codificar, facilitando la detección de errores de diseño sin preocuparse por detalles sintácticos.', 8)
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 1: Credit (Algoritmo de Luhn)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-credit-c', 'Credit', '## El reto de Credit

Implementa un programa en C que determine si un número de tarjeta de crédito es válido usando el **algoritmo de Luhn**, e identifique qué tipo de tarjeta es.

### Algoritmo de Luhn

1. Empieza desde el **penúltimo dígito** y avanza hacia la izquierda tomando cada segundo dígito.
2. **Multiplica** cada uno de esos dígitos por 2.
3. Si el producto es mayor a 9, **suma sus dígitos** (ej: 12 → 1+2 = 3).
4. Suma todos esos productos.
5. Suma los dígitos que **no** fueron multiplicados (el último dígito y los alternados).
6. Si el total termina en 0, el número es válido.

### Tipos de tarjeta

| Tipo       | Prefijo(s)      | Longitud |
|------------|-----------------|----------|
| AMEX       | 34 o 37         | 15 dígitos |
| MASTERCARD | 51–55           | 16 dígitos |
| VISA       | 4               | 13 o 16 dígitos |

### Ejemplo

Para `4003600000000014`:
- El número pasa la verificación de Luhn.
- Empieza con 4 y tiene 16 dígitos → `VISA`.

### Requisitos

- Leer el número de tarjeta desde stdin (como `long`).
- Imprimir `VISA`, `MASTERCARD`, `AMEX` o `INVALID` seguido de un salto de línea.', 'Media', 'c', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-credit-1', 'p-credit-c', '4003600000000014\n', 'VISA\n', 0),
('tc-credit-2', 'p-credit-c', '378282246310005\n', 'AMEX\n', 0),
('tc-credit-3', 'p-credit-c', '5555555555554444\n', 'MASTERCARD\n', 0),
('tc-credit-4', 'p-credit-c', '1234567890\n', 'INVALID\n', 1),
('tc-credit-5', 'p-credit-c', '4111111111111111\n', 'VISA\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-credit-1', 'p-credit-c', 1, '¿Cómo extraerías los dígitos individuales de un número entero grande? ¿Qué operadores de C te permiten obtener el dígito menos significativo y luego "eliminarlo"?'),
('h-credit-2', 'p-credit-c', 2, 'El algoritmo de Luhn trabaja con dos grupos de dígitos alternados. ¿Cómo distingues en tu bucle cuáles dígitos deben multiplicarse por 2 y cuáles no? ¿Qué variable te ayuda a alternar entre uno y otro?'),
('h-credit-3', 'p-credit-c', 3, 'Cuando multiplicas un dígito por 2 y el resultado es 10 o más (ej: 8×2=16), debes sumar los dígitos del producto (1+6=7). ¿Cómo calcularías la suma de los dígitos de un número de dos cifras usando `%` y `/`?'),
('h-credit-4', 'p-credit-c', 4, 'Una vez que tienes la suma total y sabes que el número es válido (suma % 10 == 0), ¿cómo determinarías el tipo de tarjeta? ¿Qué operaciones te dan los dos primeros dígitos y la longitud del número?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 2: Scrabble
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-scrabble-c', 'Scrabble', '## El reto de Scrabble

Implementa un programa en C que determine cuál de dos jugadores gana una ronda de Scrabble basándose en los puntos de sus palabras.

### Puntuación de letras

| Letra | Puntos | Letra | Puntos |
|-------|--------|-------|--------|
| A, E, I, O, U, L, N, R, S, T | 1 | D, G | 2 |
| B, C, M, P | 3 | F, H, V, W, Y | 4 |
| K | 5 | J, X | 8 |
| Q, Z | 10 | | |

### Formato de entrada/salida

- **Entrada**: dos líneas, cada una con la palabra de un jugador.
- **Salida**:
  - `Player 1 wins!` si el jugador 1 tiene más puntos.
  - `Player 2 wins!` si el jugador 2 tiene más puntos.
  - `Tie!` si ambos tienen la misma puntuación.

### Ejemplo

```
Question?
Quiet
```
Salida: `Player 2 wins!` (Q=10, U=1, I=1, E=1, T=1 = 14 vs Q=10, U=1, E=1, S=1, T=1, I=1, O=1, N=1 = 17... espera, recalcula con las letras reales)

### Requisitos

- El programa debe ignorar mayúsculas/minúsculas.
- Los caracteres que no son letras (espacios, signos de puntuación) valen 0 puntos.', 'Fácil', 'c', 2)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-scrabble-1', 'p-scrabble-c', 'Question?\nQuiet\n', 'Player 1 wins!\n', 0),
('tc-scrabble-2', 'p-scrabble-c', 'Oh\nHa\n', 'Tie!\n', 0),
('tc-scrabble-3', 'p-scrabble-c', 'COMPUTER\nscience\n', 'Player 1 wins!\n', 1),
('tc-scrabble-4', 'p-scrabble-c', 'jazz\nfuzz\n', 'Player 1 wins!\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-scrabble-1', 'p-scrabble-c', 1, '¿Cómo representarías la tabla de puntuación de las 26 letras en C? ¿Un array de enteros indexado por posición alfabética sería útil? ¿Cómo usarías la aritmética de `char` para obtener el índice de cada letra?'),
('h-scrabble-2', 'p-scrabble-c', 2, 'El problema dice que el programa debe ignorar mayúsculas y minúsculas. ¿Qué función de `<ctype.h>` convierte cualquier letra a minúscula (o mayúscula) antes de calcular su índice?'),
('h-scrabble-3', 'p-scrabble-c', 3, '¿Cómo recorrerías cada carácter de un string en C? ¿Qué condición usas para saber cuándo llegaste al final de la cadena? ¿Qué función de `<ctype.h>` te dice si un carácter es una letra del alfabeto?'),
('h-scrabble-4', 'p-scrabble-c', 4, 'Una vez que calculas la puntuación de ambas palabras, ¿qué estructura de control (`if`/`else if`/`else`) usarías para comparar los dos valores e imprimir el resultado correcto?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 2: Readability (Legibilidad)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-readability-c', 'Readability', '## El reto de Readability

Implementa un programa en C que calcule el nivel de lectura de un texto usando el **índice Coleman-Liau**.

### Fórmula

```
index = 0.0588 * L - 0.296 * S - 15.8
```

Donde:
- **L** = número promedio de letras por cada 100 palabras
- **S** = número promedio de oraciones por cada 100 palabras

### Reglas de conteo

- **Letras**: solo caracteres alfabéticos (`isalpha`).
- **Palabras**: secuencias separadas por espacios (puedes asumir que hay al menos una palabra).
- **Oraciones**: terminan en `.`, `!` o `?`.

### Salida

- Si el índice calculado es **menor que 1**: `Before Grade 1`
- Si el índice calculado es **16 o mayor**: `Grade 16+`
- En cualquier otro caso: `Grade X` (donde X es el índice redondeado al entero más cercano)

### Ejemplo

```
Texto: "One fish. Two fish. Red fish. Blue fish."
```
Letras: 30, Palabras: 8, Oraciones: 4
L = (30/8)*100 = 375.0, S = (4/8)*100 = 50.0
index = 0.0588*375 - 0.296*50 - 15.8 = 22.05 - 14.8 - 15.8 = -8.55 → `Before Grade 1`', 'Media', 'c', 2)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-readability-1', 'p-readability-c', 'One fish. Two fish. Red fish. Blue fish.\n', 'Before Grade 1\n', 0),
('tc-readability-2', 'p-readability-c', 'Harry Potter was a highly unusual boy in many ways. For one thing, he hated the summer holidays more than any other time of year.\n', 'Grade 5\n', 0),
('tc-readability-3', 'p-readability-c', 'It was a bright cold day in April, and the clocks were striking thirteen. Winston Smith, his chin nuzzled into his breast in an effort to escape the vile wind, slipped quickly through the glass doors of Victory Mansions, though not quickly enough to prevent a swirl of gritty dust from entering along with him.\n', 'Grade 10\n', 1),
('tc-readability-4', 'p-readability-c', 'A large class of computational problems involve the determination of properties of graphs, digraphs, integers, arrays of integers, finite families of finite sets, boolean formulas and elements of other countable domains.\n', 'Grade 16+\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-readability-1', 'p-readability-c', 1, '¿Cómo contarías letras, palabras y oraciones en un solo recorrido del string? ¿Qué funciones de `<ctype.h>` te ayudan a identificar letras? ¿Cómo detectas el inicio de una nueva palabra?'),
('h-readability-2', 'p-readability-c', 2, 'Para contar palabras, una estrategia es contar los espacios y sumar 1 al final. Pero, ¿qué pasa con espacios dobles o al inicio/fin? ¿Existe una estrategia más robusta basada en detectar transiciones de "no-letra" a "letra"?'),
('h-readability-3', 'p-readability-c', 3, 'La fórmula usa `L` y `S` que son promedios por 100 palabras, no conteos directos. ¿Cómo calcularías `L = (letras / palabras) * 100.0`? ¿Por qué es importante usar punto flotante (`float` o `double`) en este cálculo?'),
('h-readability-4', 'p-readability-c', 4, 'Para redondear el índice al entero más cercano, ¿qué función de `<math.h>` usarías: `round()`, `floor()` o `ceil()`? ¿Y cómo manejas los casos límite (índice < 1 o índice >= 16) antes de imprimir el grado?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 2: Caesar (Cifrado César)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-caesar-c', 'Caesar', '## El reto de Caesar

Implementa un programa en C que cifre un mensaje usando el **cifrado César**.

### El cifrado César

Cada letra del texto se desplaza `k` posiciones en el alfabeto. Por ejemplo, con `k = 1`:
- `A` → `B`, `B` → `C`, ..., `Z` → `A`
- `a` → `b`, `b` → `c`, ..., `z` → `a`

Las mayúsculas siguen siendo mayúsculas, las minúsculas siguen siendo minúsculas, y los caracteres no alfabéticos (espacios, números, puntuación) no se modifican.

### Formato de entrada

En esta plataforma, el input se pasa por stdin:
1. **Primera línea**: la clave `k` (entero no negativo)
2. **Segunda línea**: el texto a cifrar

### Formato de salida

El texto cifrado, seguido de un salto de línea.

### Ejemplo

```
Entrada:
13
Hello, World!

Salida:
Uryyb, Jbeyq!
```

### Requisitos

- Si `k = 0`, el texto no cambia.
- El desplazamiento debe ser **circular** (la Z con k=1 se convierte en A).
- Usa la aritmética modular: `(índice + k) % 26`.', 'Media', 'c', 2)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-caesar-1', 'p-caesar-c', '13\nHello, World!\n', 'Uryyb, Jbeyq!\n', 0),
('tc-caesar-2', 'p-caesar-c', '1\nabc\n', 'bcd\n', 0),
('tc-caesar-3', 'p-caesar-c', '0\nNo change!\n', 'No change!\n', 1),
('tc-caesar-4', 'p-caesar-c', '26\nWrap Around\n', 'Wrap Around\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-caesar-1', 'p-caesar-c', 1, '¿Cómo leerías la clave `k` y luego el texto completo (incluyendo espacios) desde stdin? ¿Qué función es mejor que `scanf("%s")` para leer una línea completa con espacios?'),
('h-caesar-2', 'p-caesar-c', 2, 'Para cifrar una letra mayúscula, necesitas su posición en el alfabeto (0-25). ¿Cómo la obtienes a partir del valor ASCII del carácter? ¿Y cómo la conviertes de vuelta a un carácter ASCII después de aplicar el desplazamiento?'),
('h-caesar-3', 'p-caesar-c', 3, '¿Por qué es necesario el operador módulo `% 26` al calcular el nuevo índice? ¿Qué pasaría con la letra ''Z'' (índice 25) si aplicaras `k = 1` sin el módulo?'),
('h-caesar-4', 'p-caesar-c', 4, '¿Cómo tratas por separado las letras mayúsculas y minúsculas? ¿Qué función de `<ctype.h>` te dice si un carácter es una letra, y cómo distingues entre mayúsculas y minúsculas?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 2
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-2-1', 2, '¿Qué es un array en C y cómo se declara?', 'Un array es una colección de elementos del mismo tipo almacenados en posiciones de memoria contiguas. Se declara con: `tipo nombre[tamaño];`. Ejemplo: `int puntos[26];` crea 26 enteros. Los índices van de `0` a `tamaño-1`. Acceder fuera del rango es un comportamiento indefinido.', 1),
('fc-2-2', 2, '¿Cómo se representa un string en C y qué es el carácter nulo `\0`?', 'En C, un string es un array de `char` que termina con el carácter nulo `\0` (valor ASCII 0). Ejemplo: `"hola"` se almacena como `{''h'', ''o'', ''l'', ''a'', ''\0''}`, ocupando 5 bytes. El `\0` marca el fin de la cadena y funciones como `printf` y `strlen` dependen de él para saber dónde termina.', 2),
('fc-2-3', 2, '¿Qué es `argc` y `argv` en la función `main` de C?', '`argc` (*argument count*) es el número de argumentos de línea de comandos, incluyendo el nombre del programa. `argv` (*argument vector*) es un array de strings con esos argumentos. Ejemplo: si ejecutas `./programa 13`, entonces `argc = 2` y `argv[1] = "13"`. Se usa `atoi(argv[1])` para convertir el string a entero.', 3),
('fc-2-4', 2, '¿Para qué sirven `toupper` y `tolower` en C?', '`toupper(c)` convierte un carácter a mayúscula y `tolower(c)` lo convierte a minúscula. Ambas están en `<ctype.h>`. Si el carácter ya está en el caso correcto o no es una letra, lo devuelven sin cambios. Son útiles para normalizar input antes de procesarlo, como en el problema de Scrabble donde la puntuación es igual para mayúsculas y minúsculas.', 4),
('fc-2-5', 2, '¿Qué es el cifrado César y cómo se implementa con aritmética modular?', 'El cifrado César desplaza cada letra `k` posiciones en el alfabeto de forma circular. La fórmula es: `nuevo_índice = (índice_original + k) % 26`. Para una mayúscula `c`: `(c - ''A'' + k) % 26 + ''A''`. El módulo 26 garantiza que al llegar a la ''Z'' se vuelva a la ''A'', haciendo el cifrado circular.', 5),
('fc-2-6', 2, '¿Qué es la aritmética de `char` en C? ¿Por qué `''A'' - ''A'' == 0`?', 'En C, los `char` son internamente enteros (su valor ASCII). Por eso se pueden hacer operaciones aritméticas con ellos. `''A''` vale 65, `''B''` vale 66, etc. La expresión `c - ''A''` da el índice de la letra en el alfabeto (0 para A, 1 para B, ..., 25 para Z). Esto funciona porque las letras son consecutivas en ASCII.', 6),
('fc-2-7', 2, '¿Qué hace `strlen` y por qué su resultado es de tipo `size_t`?', '`strlen(s)` devuelve el número de caracteres de un string **sin contar** el `\0` final. Por ejemplo, `strlen("hola") == 4`. Devuelve `size_t`, que es un tipo entero sin signo (no negativo), porque una longitud nunca puede ser negativa. Está definida en `<string.h>`. Llamarla dentro de un bucle `for` es ineficiente; es mejor guardar el resultado en una variable.', 7),
('fc-2-8', 2, '¿Qué es el índice Coleman-Liau y para qué mide el nivel de legibilidad?', 'El índice Coleman-Liau es una fórmula que estima el grado escolar necesario para comprender un texto: `index = 0.0588 * L - 0.296 * S - 15.8`, donde L = letras por 100 palabras y S = oraciones por 100 palabras. A diferencia de otras métricas, no usa conteo de sílabas sino longitud de palabras y oraciones, lo que lo hace más fácil de calcular computacionalmente.', 8)
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 3: Plurality (Votación por pluralidad)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-plurality-c', 'Plurality', '## El reto de Plurality

Implementa un programa en C que simule una **elección por pluralidad simple**: gana quien tenga más votos.

### Formato de entrada

```
<número de candidatos>
<nombre1> <nombre2> ... <nombreN>
<voto1>
<voto2>
...
(línea vacía para terminar la votación)
```

1. Primera línea: número de candidatos (entre 2 y 9).
2. Segunda línea: nombres de los candidatos separados por espacios.
3. Las siguientes líneas: un voto por línea (el nombre de un candidato).
4. Una **línea vacía** señala el fin de los votos.

### Formato de salida

Los nombres de los candidatos ganadores, uno por línea (en caso de empate, se imprimen todos los ganadores en el orden en que aparecieron).

### Ejemplo

```
Entrada:
3
Alice Bob Charlie
Alice
Bob
Alice
Bob
Charlie
Alice

Salida:
Alice
```

### Requisitos

- Los votos inválidos (nombres que no coinciden con ningún candidato) se ignoran silenciosamente.
- En caso de empate, se imprimen todos los candidatos con el máximo de votos.', 'Media', 'c', 3)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-plurality-1', 'p-plurality-c', '3\nAlice Bob Charlie\nAlice\nBob\nAlice\nBob\nCharlie\nAlice\n\n', 'Alice\n', 0),
('tc-plurality-2', 'p-plurality-c', '2\nAlice Bob\nAlice\nBob\n\n', 'Alice\nBob\n', 0),
('tc-plurality-3', 'p-plurality-c', '3\nMaria Pedro Juan\nPedro\nJuan\nPedro\nMaria\nJuan\nPedro\n\n', 'Pedro\n', 1),
('tc-plurality-4', 'p-plurality-c', '2\nCarlos Ana\nCarlos\nAna\nCarlos\nAna\n\n', 'Carlos\nAna\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-plurality-1', 'p-plurality-c', 1, '¿Qué estructuras de datos necesitas para representar a los candidatos? ¿Un array de strings para los nombres y un array de enteros para los votos sería suficiente? ¿Cómo los mantendrías sincronizados?'),
('h-plurality-2', 'p-plurality-c', 2, '¿Cómo procesarías cada voto? ¿Qué función de C compara dos strings para saber si son iguales? (Pista: `strcmp` de `<string.h>` devuelve 0 si son iguales.)'),
('h-plurality-3', 'p-plurality-c', 3, 'Para determinar el ganador, primero necesitas encontrar el **máximo** de votos. ¿Cómo recorrerías el array de conteos para encontrar ese máximo? ¿Y luego cómo imprimirías todos los candidatos que tienen exactamente ese número de votos?'),
('h-plurality-4', 'p-plurality-c', 4, '¿Cómo detectas la línea vacía que señala el fin de los votos? Si usas `fgets` para leer, ¿cómo compararías la línea leída con una cadena que solo contiene `\n`?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 3
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-3-1', 3, '¿En qué consiste la búsqueda lineal y cuál es su complejidad?', 'La búsqueda lineal recorre cada elemento de una lista uno por uno hasta encontrar el objetivo o llegar al final. Su complejidad es **O(n)** en el peor caso, donde n es el número de elementos. Es el único método aplicable cuando los datos **no están ordenados**.', 1),
('fc-3-2', 3, '¿En qué consiste la búsqueda binaria y cuál es su complejidad?', 'La búsqueda binaria divide el espacio de búsqueda a la mitad en cada paso: compara el objetivo con el elemento central, y descarta la mitad incorrecta. Su complejidad es **O(log n)**. Requisito indispensable: **los datos deben estar ordenados**. Para 1,000,000 elementos, necesita como máximo ~20 comparaciones.', 2),
('fc-3-3', 3, '¿Cómo funciona el Bubble Sort y cuál es su complejidad?', 'Bubble Sort compara pares de elementos adyacentes y los intercambia si están en el orden incorrecto, repitiendo el proceso hasta que no haya más intercambios. Los elementos "burbujean" hacia su posición correcta. Complejidad: **O(n²)** en el peor caso. Es simple de implementar pero ineficiente para listas grandes.', 3),
('fc-3-4', 3, '¿Cómo funciona el Merge Sort y por qué es más eficiente que Bubble Sort?', 'Merge Sort usa **divide y conquista**: divide la lista en mitades recursivamente hasta tener sublistas de 1 elemento (siempre ordenadas), y luego las fusiona (*merge*) en orden. Complejidad: **O(n log n)** en todos los casos. Es más eficiente que O(n²) para listas grandes porque crece mucho más lentamente.', 4),
('fc-3-5', 3, '¿Qué significa O(n), O(log n) y O(n²) en notación Big-O?', 'La notación Big-O describe cómo **escala** el tiempo de ejecución con el tamaño de la entrada n. **O(n)**: crece linealmente (doble de datos = doble de tiempo). **O(log n)**: crece logarítmicamente (muy eficiente; duplicar datos solo agrega 1 paso más). **O(n²)**: cuadrático (doble de datos = cuádruple de tiempo; malo para n grande).', 5),
('fc-3-6', 3, '¿Qué es la recursión y cuáles son sus dos componentes esenciales?', 'La recursión es cuando una función se llama a sí misma para resolver una versión más pequeña del mismo problema. Sus dos componentes esenciales son: (1) **Caso base**: la condición que detiene la recursión (sin él, hay recursión infinita y stack overflow). (2) **Caso recursivo**: la llamada a sí misma con una entrada más pequeña que se acerca al caso base.', 6),
('fc-3-7', 3, '¿Qué es un ordenamiento estable (*stable sort*)?', 'Un ordenamiento estable preserva el **orden relativo** de elementos con claves iguales. Si dos elementos A y B tienen el mismo valor de ordenamiento y A aparecía antes que B en la lista original, un sort estable garantiza que A seguirá antes que B en el resultado. Merge Sort es estable; Bubble Sort también; Quick Sort generalmente no.', 7),
('fc-3-8', 3, '¿Qué es la estrategia "divide y conquista" en algoritmos?', 'Divide y conquista es un paradigma algorítmico que divide el problema en subproblemas más pequeños del mismo tipo, los resuelve recursivamente y combina sus soluciones. Los tres pasos son: **Dividir** (partir el problema), **Conquistar** (resolver recursivamente cada parte), **Combinar** (unir las soluciones). Merge Sort y búsqueda binaria son ejemplos clásicos.', 8)
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 4: Volume (Amplificación de audio)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-volume-c', 'Volume', '## El reto de Volume

En archivos de audio WAV, el volumen se controla multiplicando cada muestra de audio por un factor. En esta versión adaptada para la plataforma, implementarás esa lógica leyendo muestras desde stdin.

### Concepto

Un archivo WAV almacena el audio como una secuencia de muestras numéricas de 16 bits (rango: −32,768 a 32,767). Para cambiar el volumen:
- **Amplificar** (factor > 1.0): multiplica cada muestra por el factor.
- **Reducir** (factor < 1.0): multiplica cada muestra por el factor.

El resultado debe estar en el rango válido de int16 (clampear entre −32,768 y 32,767).

### Formato de entrada

```
<factor>
<muestra1>
<muestra2>
...
(EOF para terminar)
```

1. **Primera línea**: el factor como número decimal (ej: `2.0`, `0.5`).
2. **Líneas siguientes**: una muestra entera por línea (int16, entre −32768 y 32767).
3. El input termina con EOF.

### Formato de salida

Cada muestra procesada, una por línea (entero redondeado).

### Ejemplo

```
Entrada:
2.0
100
-200
16000

Salida:
200
-400
32000
```

### Requisitos

- Usar `float` o `double` para el factor.
- Clampear el resultado: si excede 32767, imprimir 32767; si es menor que -32768, imprimir -32768.', 'Fácil', 'c', 4)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-volume-1', 'p-volume-c', '2.0\n100\n-200\n16000\n', '200\n-400\n32000\n', 0),
('tc-volume-2', 'p-volume-c', '0.5\n1000\n-500\n200\n', '500\n-250\n100\n', 0),
('tc-volume-3', 'p-volume-c', '3.0\n20000\n-20000\n100\n', '32767\n-32768\n300\n', 1),
('tc-volume-4', 'p-volume-c', '1.0\n0\n32767\n-32768\n', '0\n32767\n-32768\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-volume-1', 'p-volume-c', 1, '¿Cómo leerías el factor float y luego múltiples enteros desde stdin hasta EOF? ¿Qué valor devuelve `scanf` cuando ya no hay más datos para leer? ¿Cómo usarías eso como condición de un bucle?'),
('h-volume-2', 'p-volume-c', 2, '¿Qué tipo de dato en C puede representar enteros con signo de 16 bits exactamente? (Pista: revisa `<stdint.h>` y el tipo `int16_t`). ¿O podrías usar `int` común y verificar el rango manualmente?'),
('h-volume-3', 'p-volume-c', 3, 'Al multiplicar una muestra por el factor, ¿el resultado puede exceder el rango de int16? ¿Cómo implementarías el "clampeo": si el resultado es mayor que 32767 usa 32767, si es menor que -32768 usa -32768, de lo contrario usa el resultado normal?'),
('h-volume-4', 'p-volume-c', 4, '¿Cuándo conviertes el resultado float de vuelta a entero, importa el redondeo? ¿`(int)` trunca o redondea? ¿Cambiaría el resultado si usaras `round()` de `<math.h>` antes de convertir a entero?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 4
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-4-1', 4, '¿Qué es un puntero en C y cómo se declara?', 'Un puntero es una variable que almacena la **dirección de memoria** de otra variable. Se declara con `*`: `int *p;` declara un puntero a int. Para obtener la dirección de una variable se usa `&`: `p = &x;`. Para acceder al valor en esa dirección (*desreferenciar*) se usa `*`: `*p = 42;` modifica el valor de `x`.', 1),
('fc-4-2', 4, '¿Para qué sirven `malloc` y `free` en C?', '`malloc(n)` (*memory allocation*) reserva `n` bytes en el **heap** y devuelve un puntero al inicio. Si falla (sin memoria disponible), devuelve `NULL`. `free(p)` libera la memoria previamente reservada con `malloc`. **Toda memoria reservada con `malloc` debe liberarse con `free`** para evitar fugas de memoria (*memory leaks*).', 2),
('fc-4-3', 4, '¿Cuál es la diferencia entre stack (pila) y heap en memoria?', 'El **stack** almacena variables locales y frames de funciones. Es automático: la memoria se reserva al entrar a una función y se libera al salir. Tamaño limitado. El **heap** es memoria dinámica gestionada manualmente con `malloc`/`free`. Es mucho más grande pero el programador debe liberar la memoria explícitamente para evitar *memory leaks*.', 3),
('fc-4-4', 4, '¿Qué es un memory leak (fuga de memoria)?', 'Un *memory leak* ocurre cuando un programa reserva memoria con `malloc` pero nunca la libera con `free`. La memoria sigue ocupada durante toda la ejecución, aunque el programa ya no la use. En programas largos o servidores, esto puede consumir toda la RAM disponible y causar que el sistema se vuelva lento o se bloquee. Herramientas como `valgrind` detectan fugas de memoria.', 4),
('fc-4-5', 4, '¿Qué es un segmentation fault y cuándo ocurre?', 'Un *segmentation fault* (SIGSEGV) ocurre cuando un programa intenta acceder a memoria que no le pertenece. Causas comunes: desreferenciar un puntero `NULL`, acceder fuera de los límites de un array, usar memoria ya liberada con `free`, o escribir en memoria de solo lectura. El sistema operativo termina el programa abruptamente cuando detecta esta violación.', 5),
('fc-4-6', 4, '¿Qué es un puntero NULL y por qué es importante verificarlo?', 'Un puntero `NULL` (valor 0) es un puntero que no apunta a ninguna dirección de memoria válida. Es importante verificarlo porque `malloc` devuelve `NULL` cuando no puede reservar memoria. Desreferenciar `NULL` causa un *segmentation fault* inmediato. Siempre verifica: `if (p == NULL) { /* manejar error */ }` después de llamar a `malloc`.', 6),
('fc-4-7', 4, '¿Qué hace el operador `*` (dereference) y cuándo se usa?', 'El operador `*` tiene dos usos: (1) En la **declaración** de un puntero: `int *p;` indica que `p` es un puntero a int. (2) Al **desreferenciar**: `*p` accede al valor almacenado en la dirección de memoria que contiene `p`. Es equivalente a "ir a la dirección que indica `p` y leer/escribir el valor ahí".', 7),
('fc-4-8', 4, '¿Qué devuelve `sizeof` en C y para qué se usa con `malloc`?', '`sizeof(tipo)` devuelve el número de bytes que ocupa un tipo de dato en la plataforma actual. Se usa con `malloc` para reservar el tamaño correcto: `int *arr = malloc(n * sizeof(int));` reserva espacio para `n` enteros. Esto hace el código portable porque `sizeof(int)` puede variar entre plataformas (4 bytes en la mayoría, pero no siempre).', 8)
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 5: Inheritance (Herencia Genética)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-inheritance-c', 'Inheritance', '## El reto de Inheritance

Implementa un programa en C que simule la **herencia de grupos sanguíneos** a lo largo de generaciones.

### Conceptos

Cada persona tiene dos **alelos** de tipo sanguíneo, que pueden ser `A`, `B` u `O`. El grupo sanguíneo se determina por la combinación de dos alelos. Cada hijo hereda exactamente un alelo de cada progenitor, elegido **al azar**.

Por ejemplo, si el padre tiene alelos `(A, O)` y la madre `(B, O)`, el hijo puede heredar:
- `A` o `O` del padre (50% cada uno)
- `B` o `O` de la madre (50% cada uno)

### Formato de entrada

```
<generaciones> <semilla>
```

- `generaciones`: número de generaciones a simular (1–4).
- `semilla`: entero para inicializar `srand()`, asegurando resultados reproducibles.

### Formato de salida

El árbol familiar desde la generación más antigua hasta la persona de la generación actual, con sangría que indica el nivel:

```
Child (blood type: AB):
    Parent (blood type: AO):
        Grandparent (blood type: OO):
        Grandparent (blood type: AO):
    Parent (blood type: BO):
        Grandparent (blood type: BB):
        Grandparent (blood type: OO):
```

La generación raíz tiene alelos asignados **al azar** (usando la semilla dada). Cada nivel intermedio hereda un alelo al azar de cada progenitor.

### Requisitos

- Usar `srand(semilla)` para inicializar el generador de números aleatorios.
- Usar `rand() % 2` para elegir qué alelo heredar de cada progenitor.
- Los alelos de la generación raíz se eligen al azar de `{A, B, O}` con `rand() % 3`.', 'Media', 'c', 5)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-inheritance-1', 'p-inheritance-c', '1 42\n', 'Child (blood type: AO):\n', 0),
('tc-inheritance-2', 'p-inheritance-c', '2 42\n', 'Child (blood type: AO):\n    Parent (blood type: AO):\n        Grandparent (blood type: OO):\n        Grandparent (blood type: AO):\n', 0),
('tc-inheritance-3', 'p-inheritance-c', '1 7\n', 'Child (blood type: OB):\n', 1),
('tc-inheritance-4', 'p-inheritance-c', '1 99\n', 'Child (blood type: OA):\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-inheritance-1', 'p-inheritance-c', 1, '¿Cómo modelarías una "persona" en C? ¿Una `struct` con dos campos `char` para los alelos y dos punteros a `struct` para los progenitores sería apropiado? ¿Cómo reservarías memoria para cada persona con `malloc`?'),
('h-inheritance-2', 'p-inheritance-c', 2, 'La creación de la familia es inherentemente recursiva: para crear una persona de la generación N, primero debes crear sus dos progenitores de la generación N-1. ¿Cuál es el caso base de esta recursión (generación raíz)? ¿Cómo asignas los alelos en ese caso?'),
('h-inheritance-3', 'p-inheritance-c', 3, 'Para heredar un alelo de un progenitor, necesitas elegir al azar entre sus dos alelos (índice 0 o 1). ¿Cómo usarías `rand() % 2` para hacer esa elección? ¿Y cómo accederías al alelo seleccionado del struct del progenitor?'),
('h-inheritance-4', 'p-inheritance-c', 4, 'Para imprimir el árbol con sangría correcta, ¿cómo pasarías el nivel de profundidad a una función recursiva? ¿Y cómo imprimirías los espacios proporcionales al nivel antes del nombre "Child", "Parent" o "Grandparent"?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 5
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-5-1', 5, '¿Qué es una lista enlazada y en qué se diferencia de un array?', 'Una lista enlazada es una estructura de datos donde cada elemento (*nodo*) contiene un valor y un **puntero al siguiente nodo**. A diferencia de los arrays, los nodos no están en posiciones de memoria contiguas. Ventaja: inserción/eliminación en O(1) si tienes el puntero. Desventaja: acceso por índice en O(n) porque debes recorrer desde el inicio.', 1),
('fc-5-2', 5, '¿Qué es un nodo en el contexto de estructuras de datos?', 'Un nodo es la unidad básica de estructuras enlazadas (listas, árboles, grafos). En C se implementa como una `struct` que contiene el **dato** y uno o más **punteros** a otros nodos. Ejemplo: `struct Nodo { int valor; struct Nodo *siguiente; };`. El último nodo de una lista apunta a `NULL` para indicar el fin.', 2),
('fc-5-3', 5, '¿Qué es una tabla hash y para qué se usa?', 'Una tabla hash es una estructura de datos que mapea **claves a valores** usando una función hash. Permite búsqueda, inserción y eliminación en **O(1) promedio**. Funciona convirtiendo la clave en un índice de array mediante la función hash. Es la base de los diccionarios en Python, objetos en JavaScript, y `unordered_map` en C++.', 3),
('fc-5-4', 5, '¿Qué es una función hash y qué propiedades debe tener?', 'Una función hash transforma una clave (string, número, etc.) en un índice entero para una tabla hash. Propiedades deseables: (1) **Determinista**: la misma clave siempre produce el mismo índice. (2) **Distribución uniforme**: distribuye las claves de forma pareja para minimizar colisiones. (3) **Eficiente**: rápida de calcular. No necesita ser irreversible (eso es para hashes criptográficos).', 4),
('fc-5-5', 5, '¿Qué es una colisión en una tabla hash y por qué ocurre?', 'Una colisión ocurre cuando dos claves distintas producen el mismo índice hash. Es inevitable porque el espacio de claves (infinito) se mapea a un array de tamaño finito. Por el **principio del palomar**, si hay más claves que espacios, al menos dos claves compartirán índice. Las colisiones se resuelven con técnicas como encadenamiento o sondeo lineal.', 5),
('fc-5-6', 5, '¿Qué es el encadenamiento (*chaining*) como resolución de colisiones?', 'El encadenamiento resuelve colisiones haciendo que cada posición del array de la tabla hash contenga una **lista enlazada** de todos los elementos que colisionaron en ese índice. Al buscar, se calcula el hash para encontrar la lista y luego se recorre linealmente. En el peor caso (todas las claves en un solo índice), la búsqueda es O(n), pero con buena distribución es O(1) promedio.', 6),
('fc-5-7', 5, '¿Qué es un trie y para qué tipo de datos es especialmente útil?', 'Un trie (árbol de prefijos) es una estructura de datos en forma de árbol donde cada nodo representa un **carácter**. Es especialmente útil para almacenar y buscar strings: cada camino desde la raíz hasta un nodo marcado como "fin" representa una palabra. Búsqueda en O(k) donde k es la longitud del string, independiente del número de palabras almacenadas.', 7),
('fc-5-8', 5, '¿Qué es un árbol binario y cuáles son sus variantes principales?', 'Un árbol binario es una estructura donde cada nodo tiene como máximo **dos hijos** (izquierdo y derecho). Variantes: **Árbol binario de búsqueda (BST)**: los valores del subárbol izquierdo son menores al nodo, y los del derecho son mayores; búsqueda en O(log n) si está balanceado. **Árbol AVL/Rojo-Negro**: BST auto-balanceado que garantiza O(log n). **Heap binario**: usado en priority queues.', 8)
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 6: Mario (Python)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-mario-py', 'Mario (Python)', '## El reto de Mario en Python

Implementa la versión en **Python** del problema Mario: imprime una pirámide alineada a la derecha usando `#`, de una altura especificada por el usuario.

### Especificación

- Solicita al usuario un número entero entre **1 y 8**.
- Si el input no es válido (no es entero, o está fuera del rango 1–8), vuelve a solicitar.
- Imprime la pirámide correspondiente.

### Ejemplo para altura 4:

```
   #
  ##
 ###
####
```

### Diferencias con la versión en C

- En Python, la conversión de tipos y el manejo de errores se hace con `try/except`.
- Puedes usar el método `str.rjust()` o la multiplicación de strings (`"#" * n`) para construir cada fila.
- No necesitas `scanf` ni `printf`; usa `input()` y `print()`.

### Requisitos

- Usar un bucle `while True` con `try/except ValueError` para validar el input.
- La salida debe ser idéntica a la versión en C (espacios + `#`, sin trailing spaces).', 'Fácil', 'python', 6)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-mario-py-1', 'p-mario-py', '1\n', '#\n', 0),
('tc-mario-py-2', 'p-mario-py', '4\n', '   #\n  ##\n ###\n####\n', 0),
('tc-mario-py-3', 'p-mario-py', 'abc\n3\n', '  #\n ##\n###\n', 1),
('tc-mario-py-4', 'p-mario-py', '0\n9\n8\n', '       #\n      ##\n     ###\n    ####\n   #####\n  ######\n #######\n########\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-mario-py-1', 'p-mario-py', 1, '¿Cómo validarías que el usuario ingresó un número entero válido entre 1 y 8 en Python? ¿Qué excepción lanza `int()` cuando recibe un string no numérico, y cómo la capturas con `try/except`?'),
('h-mario-py-2', 'p-mario-py', 2, 'Para construir cada fila de la pirámide, ¿cómo usarías la multiplicación de strings en Python? Si estás en la fila `i` de una pirámide de altura `h`, ¿cuántos espacios y cuántos `#` necesitas?'),
('h-mario-py-3', 'p-mario-py', 3, '¿Qué hace `print()` en Python por defecto al final de cada llamada? Si quisieras imprimir sin salto de línea, ¿qué parámetro cambiarías? ¿Y cómo te aseguras de no agregar espacios al final de cada fila?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- SEMANA 6: Cash (Python)
-- =============================================================

INSERT INTO problems (id, title, description, difficulty, language, week) VALUES
('p-cash-py', 'Cash (Python)', '## El reto de Cash en Python

Implementa la versión en **Python** del problema Cash: calcula el número mínimo de monedas necesarias para dar un cambio dado.

### Monedas disponibles

- **Quarters** (25¢)
- **Dimes** (10¢)
- **Nickels** (5¢)
- **Pennies** (1¢)

### Especificación

- Solicita al usuario la cantidad de centavos (entero no negativo).
- Si el input es negativo o no es un entero válido, vuelve a solicitar.
- Imprime el número mínimo de monedas necesarias.

### Ejemplo

Para 41 centavos: 1 quarter (25¢) + 1 dime (10¢) + 1 nickel (5¢) + 1 penny (1¢) = **4 monedas**.

### Estrategia

Usa un enfoque **greedy** (voraz): siempre usa la moneda más grande posible.

### Diferencias con la versión en C

- Usa `try/except ValueError` para validar el input.
- Python maneja enteros de tamaño arbitrario; no hay overflow.
- La división entera en Python es `//` y el módulo es `%`.', 'Fácil', 'python', 6)
ON CONFLICT(id) DO NOTHING;

INSERT INTO test_cases (id, problem_id, input_data, expected_output, is_hidden) VALUES
('tc-cash-py-1', 'p-cash-py', '41\n', '4\n', 0),
('tc-cash-py-2', 'p-cash-py', '0\n', '0\n', 0),
('tc-cash-py-3', 'p-cash-py', '-5\n100\n', '4\n', 1),
('tc-cash-py-4', 'p-cash-py', 'abc\n4\n', '4\n', 1)
ON CONFLICT(id) DO NOTHING;

INSERT INTO hints (id, problem_id, order_index, question) VALUES
('h-cash-py-1', 'p-cash-py', 1, '¿Cómo validarías que el usuario ingresó un entero no negativo en Python? ¿Qué excepción lanzaría `int("abc")` y cómo la manejarías con `try/except`? ¿Dónde agregarías la validación de que el número no sea negativo?'),
('h-cash-py-2', 'p-cash-py', 2, '¿Cómo implementarías la estrategia greedy en Python? ¿Cómo calcularías cuántas monedas de 25¢ caben en el cambio total usando el operador `//`, y cuánto queda usando `%`?'),
('h-cash-py-3', 'p-cash-py', 3, '¿Podrías almacenar los valores de las monedas en una lista `[25, 10, 5, 1]` y recorrerla con un bucle `for` en lugar de tener cuatro bloques de código repetitivos? ¿Cómo quedaría esa solución más limpia?')
ON CONFLICT(id) DO NOTHING;

-- =============================================================
-- FLASHCARDS: Semana 6
-- =============================================================

INSERT INTO flashcards (id, week, question, answer, order_index) VALUES
('fc-6-1', 6, '¿Cuáles son las diferencias clave entre Python y C?', 'Principales diferencias: (1) **Tipado**: Python es dinámico (no declaras tipos), C es estático. (2) **Compilación**: Python es interpretado, C se compila. (3) **Gestión de memoria**: Python la maneja automáticamente (garbage collector), C requiere `malloc`/`free`. (4) **Sintaxis**: Python usa indentación para bloques, C usa llaves `{}`. (5) **Velocidad**: C es mucho más rápido; Python es más lento pero más legible.', 1),
('fc-6-2', 6, '¿Qué es el tipado dinámico en Python?', 'En Python, el tipo de una variable se determina en tiempo de ejecución, no en la declaración. Puedes escribir `x = 5` y luego `x = "hola"` sin error. La variable no tiene un tipo fijo; el objeto al que apunta sí lo tiene. Ventaja: más flexible y menos código. Desventaja: errores de tipo solo se detectan al ejecutar, no al compilar.', 2),
('fc-6-3', 6, '¿Cómo funcionan las listas en Python y en qué se diferencian de los arrays de C?', 'Las listas de Python (`[]`) son dinámicas: pueden contener elementos de **tipos distintos** y crecer/encoger automáticamente. En C, los arrays tienen tamaño fijo y un solo tipo. Las listas de Python tienen métodos útiles como `.append()`, `.pop()`, `.sort()`. Internamente son arrays de punteros a objetos Python. El precio: más lentas y con mayor uso de memoria que los arrays de C.', 3),
('fc-6-4', 6, '¿Qué es un diccionario en Python y cuándo lo usarías?', 'Un diccionario (`dict`) es una colección de pares **clave-valor**: `{"nombre": "Alice", "edad": 30}`. Las claves pueden ser cualquier tipo inmutable (strings, números, tuplas). Las búsquedas son O(1) porque internamente usa una tabla hash. Se usa cuando necesitas asociar datos (como una base de datos simple) o cuando quieres buscar por nombre en vez de por índice.', 4),
('fc-6-5', 6, '¿Cómo funciona `try/except` en Python para manejo de errores?', '`try/except` captura excepciones (errores en tiempo de ejecución) para manejarlas sin que el programa se detenga. Sintaxis: `try:` contiene el código que puede fallar; `except TipoError:` maneja ese error específico. Ejemplo: `try: n = int(input())` puede lanzar `ValueError` si el input no es número, y `except ValueError: print("Error")` lo maneja. Es el equivalente de verificar errores en C pero más limpio.', 5),
('fc-6-6', 6, '¿Qué son los f-strings en Python y cuándo se usan?', 'Los f-strings (f"...") son strings con interpolación de expresiones Python directamente en el texto, precedidos por `f`. Ejemplo: `f"Hola {nombre}, tienes {edad} años"`. Son más legibles y eficientes que la concatenación con `+` o el método `.format()`. Se puede incluir cualquier expresión Python entre llaves: `f"El doble es {n * 2}"`. Disponibles desde Python 3.6.', 6),
('fc-6-7', 6, '¿Qué hace `import` en Python y cuáles son las formas de usarlo?', '`import` carga un módulo (librería) para usar sus funciones. Formas: `import math` (importa todo el módulo; se accede con `math.sqrt()`), `from math import sqrt` (importa solo `sqrt`; se usa directamente), `from math import *` (importa todo sin prefijo; no recomendado). Python tiene una biblioteca estándar enorme: `random`, `sys`, `os`, `csv`, `json`, etc.', 7),
('fc-6-8', 6, '¿Qué hace `range()` en Python y cuáles son sus formas de uso?', '`range()` genera una secuencia de números enteros. Formas: `range(n)` genera 0, 1, ..., n-1. `range(inicio, fin)` genera desde inicio hasta fin-1. `range(inicio, fin, paso)` genera con el incremento dado. Se usa principalmente en bucles `for`: `for i in range(5):` itera 5 veces. No crea una lista en memoria; es un objeto generador (eficiente para rangos grandes).', 8)
ON CONFLICT(id) DO NOTHING;
