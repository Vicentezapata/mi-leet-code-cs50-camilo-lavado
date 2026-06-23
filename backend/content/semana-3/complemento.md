# Material Complementario: Visualizando Algoritmos de Ordenamiento

Ya conoces la teoría. Aquí vamos a dar un paso más: entender los algoritmos con imágenes mentales claras y aprender a elegir el correcto para cada situación.

---

## 1. Bubble Sort: las burbujas que suben

Imagina un acuario con bolas de distintos tamaños sumergidas. Las bolas más livianas (los números mayores) van subiendo poco a poco hacia la superficie con cada pasada del algoritmo, mientras las bolas más pesadas (los números menores) se hunden hacia el fondo.

**Visualización paso a paso con 5 elementos:**

```
Estado inicial: [5, 3, 8, 1, 4]

Pasada 1: comparo pares adyacentes
  5 > 3 → intercambio → [3, 5, 8, 1, 4]
  5 < 8 → sin cambio  → [3, 5, 8, 1, 4]
  8 > 1 → intercambio → [3, 5, 1, 8, 4]
  8 > 4 → intercambio → [3, 5, 1, 4, 8]  ← el 8 "burbujeó" hasta el final

Pasada 2:
  3 < 5 → sin cambio  → [3, 5, 1, 4, 8]
  5 > 1 → intercambio → [3, 1, 5, 4, 8]
  5 > 4 → intercambio → [3, 1, 4, 5, 8]  ← el 5 llegó a su lugar

Pasada 3:
  3 > 1 → intercambio → [1, 3, 4, 5, 8]
  3 < 4 → sin cambio  → [1, 3, 4, 5, 8]

Pasada 4 (verificación):
  Sin intercambios → ¡ya está ordenado! → terminamos
```

**La clave visual:** en cada pasada, el elemento más grande "flota" hacia el extremo derecho como una burbuja hacia la superficie del agua.

---

## 2. Selection Sort: el coleccionista paciente

Imagina que tienes un mazo de cartas desordenadas sobre la mesa. Tu estrategia: recorres todas las cartas de izquierda a derecha, anotas mentalmente cuál es la más baja que encontraste, y cuando llegas al final la colocas en la primera posición libre. Luego repites desde la segunda posición libre.

```
Estado inicial: [5, 3, 8, 1, 4]
                 ^               ← posición actual a llenar

Busco el mínimo en [5, 3, 8, 1, 4]:
  → mínimo = 1 (está en posición 3)
  → intercambio posición 0 con posición 3

Estado: [1, 3, 8, 5, 4]
            ^            ← nueva posición a llenar

Busco el mínimo en [3, 8, 5, 4]:
  → mínimo = 3 (ya está en posición correcta)
  → intercambio con sí mismo (no hay movimiento real)

Estado: [1, 3, 8, 5, 4]
               ^         ← nueva posición

Busco el mínimo en [8, 5, 4]:
  → mínimo = 4
  → intercambio

Estado: [1, 3, 4, 5, 8]  ✓
```

**La diferencia con Bubble Sort:** el coleccionista siempre busca el mínimo global del subarreglo restante antes de colocar cualquier cosa. Bubble Sort en cambio resuelve pequeños problemas locales (pares adyacentes) y el orden emerge de esos pequeños arreglos.

---

## 3. Merge Sort: divide y conquistarás

Este es el algoritmo de los generales militares: en lugar de luchar contra un ejército enorme, divides el problema en problemas más pequeños, los resuelves por separado, y luego combinas las victorias.

**Analogía con fichas de papel:**

Imagina que tienes 8 fichas desordenadas sobre una mesa. Haces lo siguiente:

1. **Divides** las fichas en dos pilas de 4.
2. **Divides** cada pila de 4 en dos pilas de 2.
3. **Divides** cada pila de 2 en dos pilas de 1.
4. Ahora tienes 8 pilas de 1 ficha cada una. Una ficha sola siempre está "ordenada".
5. **Mezclas** pares de pilas de 1 → obtienes 4 pilas de 2, ordenadas.
6. **Mezclas** pares de pilas de 2 → obtienes 2 pilas de 4, ordenadas.
7. **Mezclas** las 2 pilas de 4 → obtienes 1 pila de 8, ordenada.

```
[7, 2, 5, 4, 1, 6, 0, 3]         ← arreglo original

División:
[7, 2, 5, 4]    [1, 6, 0, 3]

[7, 2] [5, 4]   [1, 6] [0, 3]

[7][2] [5][4]   [1][6] [0][3]    ← caso base: listas de 1 elemento

Mezclas hacia arriba:
[2, 7] [4, 5]   [1, 6] [0, 3]

[2, 4, 5, 7]    [0, 1, 3, 6]

[0, 1, 2, 3, 4, 5, 6, 7]         ← resultado final
```

**La magia del paso de mezcla:** como ambas mitades ya están ordenadas, nunca necesitas volver atrás. Los dos punteros avanzan de izquierda a derecha comparando el frente de cada pila. Esto garantiza que el paso de mezcla sea O(n).

---

## 4. ¿Por qué O(n log n) es tan bueno?

Pongamos números concretos para entender la diferencia entre O(n²) y O(n log n):

| n (elementos) | n² operaciones | n log₂(n) operaciones |
|---------------|----------------|----------------------|
| 10 | 100 | ~33 |
| 100 | 10.000 | ~664 |
| 1.000 | 1.000.000 | ~9.966 |
| 1.000.000 | 1.000.000.000.000 | ~19.931.568 |

Para un millón de elementos, Merge Sort hace alrededor de 20 millones de operaciones. Bubble Sort haría **un billón**. Si cada operación toma 1 nanosegundo:

- **Bubble Sort:** ~16 minutos
- **Merge Sort:** ~0,02 segundos

Esa es la diferencia entre O(n²) y O(n log n) en el mundo real.

---

## 5. ¿Cuándo usar cada algoritmo?

La respuesta siempre depende del contexto. Aquí hay una guía práctica:

### Usa búsqueda lineal cuando:
- El arreglo **no está ordenado** y solo buscas una vez.
- El arreglo es muy pequeño (menos de ~20 elementos).
- Ordenar primero costaría más que buscar linealmente.

### Usa búsqueda binaria cuando:
- El arreglo **ya está ordenado**.
- Necesitas buscar **muchas veces** en el mismo arreglo (el costo de ordenar se amortiza).

### Usa Bubble Sort cuando:
- El arreglo es pequeño (decenas de elementos).
- Sospechas que el arreglo **ya está casi ordenado** (gracias a la optimización con bandera, termina rápido).
- El código simple es prioritario sobre la velocidad.

### Usa Selection Sort cuando:
- El arreglo es pequeño.
- El número de **escrituras en memoria** importa más que el número de comparaciones (Selection Sort hace el mínimo de intercambios posibles: exactamente n-1).

### Usa Merge Sort cuando:
- El arreglo es mediano o grande (cientos o miles de elementos).
- Necesitas garantía de rendimiento sin importar el estado inicial de los datos.
- Tienes memoria adicional disponible.

---

## 6. La trampa de "ordenar para buscar"

Un patrón muy común: ¿conviene ordenar el arreglo antes de buscar?

**Depende de cuántas búsquedas harás:**

- Si buscas **una sola vez**: probablemente no vale la pena ordenar. La búsqueda lineal O(n) es más rápida que ordenar O(n log n) + buscar O(log n).
- Si buscas **muchas veces**: sí conviene. Ordenas una vez con O(n log n) y cada búsqueda posterior cuesta solo O(log n).

Es la misma lógica de Google: no buscan linealmente en su base de datos cada vez que alguien escribe una consulta. Mantienen los datos organizados de forma inteligente para que cada búsqueda sea rapidísima.

---

## 7. Ordenamiento estable vs. inestable

Un algoritmo de ordenamiento es **estable** si cuando dos elementos tienen el mismo valor, mantienen su orden relativo original.

**Ejemplo:** ordena personas por apellido. Si "García, Juan" y "García, María" están en ese orden antes del sort, un algoritmo estable los mantendrá así después (asumiendo que los apellidos son iguales).

| Algoritmo | ¿Estable? |
|-----------|-----------|
| Bubble Sort | Sí |
| Selection Sort | No (los intercambios pueden cambiar el orden relativo) |
| Merge Sort | Sí (la condición `<=` en la mezcla preserva el orden) |

La estabilidad importa cuando ordenas por múltiples criterios: por ejemplo, primero por apellido y luego por nombre. Si usas un algoritmo estable, puedes hacerlo en dos pasadas.
