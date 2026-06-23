# Glosario: Semana 5 — Estructuras de Datos

---

### Lista enlazada (linked list)

Estructura de datos dinámica formada por **nodos** dispersos en el heap, donde cada nodo contiene un dato y un puntero al siguiente nodo. A diferencia de un array, sus elementos no necesitan estar contiguos en memoria. Permite inserción y eliminación eficiente (O(1) al frente), pero la búsqueda requiere recorrer todos los nodos: O(n).

---

### Nodo (node)

Unidad básica de muchas estructuras de datos dinámicas. En C se implementa como un `struct` que contiene el dato útil (un `int`, un `char *`, etc.) y uno o más punteros hacia otros nodos. Su tamaño en memoria incluye el dato más el espacio para los punteros (8 bytes por puntero en sistemas de 64 bits).

---

### Puntero NULL

Un puntero con valor cero que **no apunta a ninguna dirección de memoria válida**. En las estructuras de datos enlazadas, el `NULL` cumple el papel de "fin de la lista" o "este hijo no existe". Desreferenciar un puntero `NULL` (es decir, hacer `ptr->campo`) provoca un segmentation fault (error en tiempo de ejecución).

---

### Lista doblemente enlazada (doubly linked list)

Variante de la lista enlazada donde cada nodo tiene **dos punteros**: uno al nodo siguiente y otro al nodo anterior. Permite recorrer la lista en ambas direcciones y eliminar un nodo en O(1) si ya tienes un puntero a él (versus O(n) en la lista simple, que debe encontrar el nodo anterior). El costo es 8 bytes adicionales por nodo para el puntero al anterior.

---

### Árbol binario (binary tree)

Estructura de datos no lineal donde cada nodo puede tener como máximo **dos hijos**: izquierdo y derecho. Los nodos sin hijos se llaman hojas. La profundidad de un árbol con n nodos puede variar entre log₂(n) (árbol balanceado, ideal) y n (árbol degenerado, peor caso). En C, cada nodo tiene un campo de dato, un puntero `*izquierda` y un puntero `*derecha`.

---

### Árbol binario de búsqueda (BST — Binary Search Tree)

Árbol binario que cumple la **propiedad BST**: para cualquier nodo N, todos los valores del subárbol izquierdo son menores que N y todos los del subárbol derecho son mayores. Esta propiedad permite búsqueda, inserción y eliminación en O(log n) en un árbol balanceado, recuperando la eficiencia de la búsqueda binaria pero con la flexibilidad de los punteros (no requiere memoria contigua).

---

### Tabla hash (hash table)

Estructura de datos que combina un **array** (para acceso rápido por índice) con **listas enlazadas** (para manejar colisiones). Una función hash convierte la clave en un índice del array. Idealmente logra búsqueda, inserción y eliminación en O(1) promedio. En el peor caso teórico (todas las claves al mismo bucket) degrada a O(n). Es la base de los diccionarios en Python y los objetos en JavaScript.

---

### Función hash (hash function)

Algoritmo que toma una entrada (una clave: string, número, etc.) y produce un **número entero dentro de un rango fijo** (el índice en la tabla). Una buena función hash distribuye las claves uniformemente entre todos los buckets para minimizar colisiones. Ejemplo simple: `hash(nombre) = toupper(nombre[0]) - 'A'` mapea cualquier nombre a un índice de 0 a 25.

---

### Colisión (collision)

Situación que ocurre cuando dos claves distintas producen el **mismo índice** al pasarlas por la función hash. Las colisiones son inevitables cuando el número de claves posibles es mayor que el número de buckets (Principio del Palomar). La forma en que se manejan las colisiones es crítica para el rendimiento de la tabla hash.

---

### Encadenamiento (chaining)

Técnica para resolver colisiones en una tabla hash donde **cada bucket contiene una lista enlazada** de todos los elementos que produjeron ese mismo índice. Cuando hay una colisión, el nuevo elemento se agrega a la lista de ese bucket. Es la estrategia más común y flexible: no hay límite en cuántos elementos pueden colisionar en el mismo bucket, aunque demasiados colisiones en un bucket degradan el rendimiento.

---

### Trie

Árbol en el que **cada nodo es un array** de punteros (típicamente 26, uno por letra del alfabeto). Se usa para almacenar strings de forma que el tiempo de búsqueda depende solo de la longitud de la clave, no del número de elementos en la estructura. La palabra "trie" viene de "re*trie*val" (recuperación), aunque se pronuncia "try" por convención. Su ventaja es O(1) real para búsqueda; su desventaja es el alto consumo de memoria (26 × 8 bytes = 208 bytes mínimos por nodo, la mayoría en NULL).

---

### Complejidad temporal (time complexity)

Medida de cuánto **tiempo** (expresado en número de operaciones) tarda un algoritmo en función del tamaño de la entrada n. Se expresa con notación Big O: O(1) constante, O(log n) logarítmica, O(n) lineal, O(n log n) lineal-logarítmica, O(n²) cuadrática. Describe el comportamiento en el peor caso (salvo que se especifique "promedio").

---

### Complejidad espacial (space complexity)

Medida de cuánta **memoria adicional** requiere un algoritmo o estructura de datos en función del tamaño de la entrada n. Un array de enteros tiene complejidad espacial O(1) extra (no usa memoria adicional más allá de los datos). Una lista enlazada tiene O(n) extra (n punteros). Un trie puede tener O(26^k) en el peor caso. Generalmente hay un trade-off: mejorar el tiempo implica gastar más espacio.

---

### Trade-off (compensación)

Intercambio inevitable entre dos recursos o propiedades deseables. En estructuras de datos, el trade-off más común es **tiempo vs. espacio**: para ganar velocidad se gasta memoria, y para ahorrar memoria se acepta menor velocidad. Por ejemplo, un trie es más rápido que una tabla hash (O(1) garantizado vs. O(1) promedio), pero consume mucha más memoria. No existe la estructura perfecta para todos los casos; la elección depende de las restricciones específicas del problema.
