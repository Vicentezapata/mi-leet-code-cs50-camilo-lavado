# Glosario Técnico: Semana 3

Definiciones precisas de los términos clave de esta semana sobre algoritmos de búsqueda, ordenamiento y análisis de eficiencia.

---

### Array (Arreglo)

Estructura de datos que almacena una colección de elementos del mismo tipo en posiciones de memoria contiguas. Se accede a cada elemento mediante un índice numérico que comienza en 0. En C se declara como `int numeros[7]`. Es la base sobre la que trabajan todos los algoritmos de esta semana.

---

### Búsqueda Lineal (Linear Search)

Algoritmo de búsqueda que recorre cada elemento de un arreglo de izquierda a derecha, uno por uno, hasta encontrar el valor buscado o llegar al final. No requiere que el arreglo esté ordenado. Complejidad: **O(n)** en el peor caso, **Ω(1)** en el mejor caso.

---

### Búsqueda Binaria (Binary Search)

Algoritmo de búsqueda que divide el arreglo por la mitad en cada paso: compara el valor buscado con el elemento central, y descarta la mitad que no puede contenerlo. **Requiere que el arreglo esté previamente ordenado.** Complejidad: **O(log n)** en el peor caso. Es fundamentalmente más eficiente que la búsqueda lineal para arreglos grandes.

---

### Bubble Sort (Ordenamiento de Burbuja)

Algoritmo de ordenamiento que compara pares de elementos adyacentes e intercambia los que estén desordenados. Repite este proceso hasta que no haya más intercambios. Los elementos de mayor valor "burbujean" hacia el final del arreglo en cada pasada. Complejidad: **O(n²)** en el peor caso, **Ω(n)** en el mejor caso (cuando la lista ya está ordenada y se usa la optimización de bandera). Es un algoritmo estable.

---

### Selection Sort (Ordenamiento por Selección)

Algoritmo de ordenamiento que en cada iteración selecciona el elemento mínimo del subarreglo no ordenado y lo coloca en la posición correcta mediante un intercambio. Siempre realiza exactamente el mismo número de comparaciones sin importar el estado inicial de los datos. Complejidad: **Θ(n²)** — tanto en el peor como en el mejor caso. Hace el mínimo posible de intercambios (n-1 como máximo).

---

### Merge Sort (Ordenamiento por Mezcla)

Algoritmo de ordenamiento basado en la estrategia "divide y vencerás": divide el arreglo recursivamente en mitades hasta tener subarreglos de un solo elemento (que trivialmente están ordenados), y luego los fusiona (*merge*) de manera ordenada. Complejidad: **Θ(n log n)** — consistente en todos los casos. Requiere memoria auxiliar proporcional a n. Es un algoritmo estable.

---

### Recursión (Recursion)

Técnica de programación en la que una función se llama a sí misma para resolver una versión más pequeña del mismo problema. Para evitar una ejecución infinita, toda función recursiva debe tener al menos un **caso base** que detenga la cadena de llamadas. Merge Sort y la búsqueda binaria son ejemplos clásicos de algoritmos recursivos.

---

### Caso Base (Base Case)

La condición de parada dentro de una función recursiva. Cuando se cumple, la función retorna un resultado directamente sin hacer más llamadas recursivas. Sin un caso base bien definido, la función se llamaría a sí misma infinitamente hasta agotar la memoria del programa (causando un *stack overflow*). Ejemplo: en Merge Sort, el caso base es cuando el subarreglo tiene 0 o 1 elementos.

---

### Big-O (Notación O Grande)

Notación matemática que describe el **límite superior** del tiempo de ejecución de un algoritmo en función del tamaño de la entrada `n`. Expresa el comportamiento en el **peor caso**. Se ignoran constantes y términos de menor orden (por ejemplo, `3n² + 5n` se simplifica a **O(n²)**) porque lo que importa es la forma de la curva cuando n crece hacia el infinito.

---

### O(n) — Complejidad Lineal

Un algoritmo es O(n) si su tiempo de ejecución crece proporcionalmente al tamaño de la entrada. Si duplicas n, el tiempo se duplica. Ejemplo: la búsqueda lineal en el peor caso toca cada uno de los n elementos exactamente una vez.

---

### O(log n) — Complejidad Logarítmica

Un algoritmo es O(log n) si en cada paso reduce el problema a la mitad (o a una fracción constante). Si duplicas n, el tiempo aumenta solo en una unidad. Ejemplo: la búsqueda binaria descarta la mitad del arreglo en cada comparación. Con 1.000.000 de elementos, solo necesita ≈ 20 comparaciones.

---

### O(n²) — Complejidad Cuadrática

Un algoritmo es O(n²) si su tiempo de ejecución crece con el cuadrado del tamaño de la entrada. Típicamente ocurre cuando hay dos bucles anidados que ambos recorren los n elementos. Ejemplo: Bubble Sort y Selection Sort. Si duplicas n, el tiempo se cuadruplica.

---

### O(n log n) — Complejidad N-log-N

Un algoritmo es O(n log n) si realiza `n` operaciones en cada uno de los `log n` niveles de un proceso de división. Es el mejor orden posible para algoritmos de ordenamiento de propósito general que comparan elementos. Ejemplo: Merge Sort. Significativamente más rápido que O(n²) para arreglos grandes.

---

### Ordenamiento Estable (Stable Sort)

Un algoritmo de ordenamiento es **estable** si preserva el orden relativo de los elementos que tienen el mismo valor de clave. Es decir, si dos elementos son "iguales" según el criterio de ordenamiento, el que aparecía primero en el arreglo original seguirá apareciendo primero en el resultado. Bubble Sort y Merge Sort son estables; Selection Sort no lo es.
