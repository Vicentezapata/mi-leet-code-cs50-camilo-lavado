# Material Complementario: Cuándo Usar Cada Estructura

Conocer las estructuras de datos no basta: el verdadero desafío es elegir la correcta para cada problema. Esta guía te da heurísticas prácticas con analogías del mundo real.

---

## 1. Array — El cajón de cubiertos

Imagina un cajón de cubiertos con compartimentos numerados fijos. Sabes exactamente que el tenedor está en el compartimento 3 y la cuchara en el 4. El acceso es instantáneo.

**Úsalo cuando:**
- Conoces el tamaño de los datos en tiempo de compilación (o al iniciar el programa).
- Necesitas acceso por índice en O(1): "dame el elemento número 500".
- Los datos no cambian de tamaño frecuentemente.
- Quieres aplicar búsqueda binaria (el array debe estar ordenado).

**Evítalo cuando:**
- Necesitas insertar o eliminar elementos en el medio frecuentemente: desplazar todos los elementos cuesta O(n).
- No sabes cuántos elementos tendrás de antemano y el tamaño varía mucho.

**Ejemplo práctico:** una tabla de colores fija para una paleta de imagen, un buffer de audio de tamaño conocido.

---

## 2. Lista Enlazada — La cadena de notas Post-it

Cada nota Post-it tiene escrito un mensaje y una flecha que apunta a la siguiente nota. Puedes pegar una nota nueva al frente de la cadena en un instante, o quitar la primera nota sin tocar las demás. Pero si quieres llegar a la nota número 50, tienes que seguir todas las flechas desde el principio.

**Úsalo cuando:**
- Insertas o eliminas elementos al **frente** muy frecuentemente (O(1)).
- El tamaño de los datos es completamente impredecible y cambia en tiempo de ejecución.
- No necesitas acceso aleatorio por índice.
- Implementas una pila (stack) o una cola (queue) como estructura subyacente.

**Úsala sobre el array cuando:**
- Tienes millones de inserciones al frente: el array costaría O(n) cada vez.
- El tamaño crece y decrece impredeciblemente.

**Evítala cuando:**
- Necesitas búsqueda rápida: cada búsqueda cuesta O(n).
- La memoria es muy limitada: cada nodo cuesta 8 bytes extra de puntero.

**Ejemplo práctico:** historial de navegación (navegar atrás es O(1)), lista de tareas pendientes donde se agregan y quitan del frente.

---

## 3. Lista Doblemente Enlazada — La cadena de notas con flechas en ambos sentidos

Como la lista enlazada, pero cada nota tiene una flecha hacia adelante y otra hacia atrás. Puedes moverte en ambas direcciones. Cuesta 16 bytes extra por nodo en lugar de 8.

**Úsala sobre la lista simple cuando:**
- Necesitas recorrer la lista hacia atrás eficientemente.
- Implementas un deque (cola de doble extremo) o un editor de texto con cursor.
- Las eliminaciones son frecuentes en posiciones arbitrarias (tienes un puntero al nodo).

---

## 4. BST — El árbol genealógico del archivo

Imagina un árbol genealógico donde los apellidos están ordenados: los que van antes alfabéticamente cuelgan a la izquierda, los que van después a la derecha. Para encontrar "García", empiezas en la raíz, decides si ir a la izquierda o derecha, y en cada paso descartas la mitad de la familia. Eso es O(log n).

**Úsalo cuando:**
- Necesitas búsqueda rápida **y** orden (puedes recorrer el árbol en orden para obtener los datos ordenados).
- Los datos se insertan de forma relativamente aleatoria (para evitar árboles degenerados).
- Necesitas operaciones como "encuentra el mínimo", "encuentra el sucesor de X" o "dame todos los elementos entre A y B".

**Una tabla hash es mejor que un BST cuando:**
- Solo necesitas buscar/insertar/eliminar por clave exacta y el orden no importa.
- La velocidad es prioritaria sobre el uso de memoria.
- La clave se puede hashear fácilmente (strings, números).

**Un BST es mejor que una tabla hash cuando:**
- Necesitas los datos en orden (búsquedas de rango, recorrido ordenado).
- No puedes predecir bien la distribución de las claves para diseñar una función hash.
- Quieres garantías de tiempo en el peor caso (con BST balanceado: O(log n) garantizado vs. O(n) en el peor caso de tabla hash).

**Ejemplo práctico:** el índice de un sistema de archivos, el autocompletado de un sistema que también necesita rango.

---

## 5. Tabla Hash — El casillero postal de una empresa

Un edificio de oficinas tiene 100 casilleros para correspondencia, uno por empleado. El correo llega con el nombre del destinatario; el operador aplica una fórmula (función hash) para saber en qué casillero ponerlo. Para encontrar el correo de "Camila Torres", aplicas la misma fórmula y vas directamente al casillero 47. Si dos empleados cayeron en el mismo casillero, hay una pila pequeña de sobres que revisar.

**Úsalo cuando:**
- Buscas el santo grial: O(1) promedio para buscar, insertar y eliminar.
- El orden de los datos no importa.
- Tienes una buena función hash disponible para tus claves.
- La memoria adicional del array de buckets es aceptable.

**Una tabla hash es mejor que un array cuando:**
- Las claves no son índices numéricos consecutivos (nombres, palabras, IDs arbitrarios).
- Un array indexado por clave sería gigantesco y vacío (sparse).

**Un trie es mejor que una tabla hash cuando:**
- Las claves son strings y necesitas búsqueda de prefijos ("¿hay palabras que empiezan con 'pre'?").
- Necesitas O(1) verdadero, no solo promedio.
- El conjunto de claves posibles está bien definido y no es enorme.

**Cuándo las colisiones se vuelven un problema:**
Las colisiones son inevitables, pero puedes reducirlas con:
1. **Más buckets:** pasar de 26 a 676 (26²) o 17,576 (26³) reduce drásticamente las colisiones.
2. **Mejor función hash:** usar no solo la primera letra sino combinaciones de letras.

El trade-off: más buckets = menos colisiones = búsqueda más rápida, pero más memoria usada aunque los buckets estén vacíos.

**Ejemplo práctico:** el corrector ortográfico Speller de CS50, tablas de símbolos en compiladores, cachés de DNS.

---

## 6. Trie — El árbol de decisiones letra por letra

Imagina un árbol donde cada nivel representa una posición en la palabra. Para buscar "GATO", bajas por el nivel G, luego A, luego T, luego O. La profundidad del árbol es la longitud de la palabra más larga, y ese es el máximo de pasos que necesitarás sin importar cuántas palabras haya en la estructura.

**Úsalo cuando:**
- Tus claves son strings y necesitas O(k) garantizado (donde k es la longitud de la clave).
- El autocompletado es crítico: "dame todas las palabras con el prefijo 'pro'".
- Quieres verificar si una palabra es prefijo de otra.
- La memoria disponible es abundante y la velocidad es prioritaria.

**Un trie supera a una tabla hash cuando:**
- Necesitas búsqueda por prefijo eficiente (la tabla hash no puede hacer esto sin recorrer todos los buckets).
- Quieres garantías de O(1) en el peor caso (no solo promedio).
- Implementas un corrector ortográfico que también sugiere palabras similares.

**Evítalo cuando:**
- La memoria es un recurso escaso: 26 punteros × 8 bytes = 208 bytes mínimos por nodo.
- Las claves son números o datos no string (la ventaja del trie es la naturaleza secuencial de los strings).

**Ejemplo práctico:** motor de búsqueda con autocompletado, diccionario de un teclado móvil con sugerencias, DNS (Domain Name System).

---

## 7. Resumen de decisión rápida

```
¿Necesitas acceso por índice numérico en O(1)?
   → Array

¿Los datos cambian de tamaño frecuentemente y solo insertas al frente?
   → Lista enlazada

¿Necesitas búsqueda rápida Y datos en orden?
   → BST (preferiblemente balanceado)

¿Solo necesitas buscar/insertar/eliminar por clave exacta, sin importar el orden?
   → Tabla hash

¿Las claves son strings y necesitas prefijos o O(1) garantizado?
   → Trie
```

El consejo más importante: **no existe la estructura perfecta para todo**. Cada proyecto tiene sus propias restricciones de tiempo, memoria y complejidad de implementación. La habilidad del programador está en reconocer cuál trade-off puede aceptar.
