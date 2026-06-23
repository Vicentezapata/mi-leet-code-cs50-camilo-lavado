# Material Complementario: Python vs C — Lo que Ganas y lo que Pagas

Cuando pasas de C a Python no estás "ascendiendo" a un lenguaje mejor. Estás cambiando de herramienta. Un martillo no es mejor que un destornillador; depende del clavo. Este material te da el criterio para elegir la herramienta correcta.

---

## 1. Velocidad vs. comodidad: la ecuación central

Python es entre **10 y 100 veces más lento** que C para tareas computacionalmente intensas. Eso no es un rumor —es la consecuencia directa de cómo funciona cada lenguaje:

| Factor | C | Python |
|---|---|---|
| Ejecución | Binario nativo — el CPU lo ejecuta directamente | Intérprete — CPython traduce cada línea en tiempo real |
| Memoria | Tú la pides (`malloc`) y tú la liberas (`free`) | El *garbage collector* la administra automáticamente |
| Tipos | Estáticos — el compilador los conoce antes de ejecutar | Dinámicos — se resuelven en tiempo de ejecución |
| Overhead por función | Mínimo | Alto — cada llamada busca el tipo, verifica el objeto |

¿Cuánto importa esa diferencia? Depende del problema:

- Un script que procesa un CSV con 10,000 filas: la diferencia es **milisegundos**. No importa.
- Un motor de videojuego procesando física en tiempo real: la diferencia es **segundos por frame**. Importa enormemente.

---

## 2. Memoria administrada vs. malloc / free

La característica más liberadora de Python para quien viene de C es no tener que pensar en memoria. Pero es útil entender lo que ocurre detrás:

### Lo que haces en C

```c
// Pides memoria explícitamente
int *lista = malloc(5 * sizeof(int));
if (lista == NULL)
{
    // manejar el error
    return 1;
}

// Usas la memoria...

// Debes liberar la memoria cuando terminas
free(lista);
lista = NULL;
```

Si olvidas `free`, tienes un **memory leak** (fuga de memoria). Si liberas dos veces, tienes **undefined behavior**. Si accedes después de liberar, tienes **use-after-free**, una vulnerabilidad de seguridad.

### Lo que ocurre en Python

```python
# Python: solo creas la lista — el intérprete pide memoria por ti
lista = [0, 0, 0, 0, 0]

# Cuando 'lista' ya no tiene referencias, el garbage collector la libera
# Tú nunca llamas a free()
```

Python usa un sistema llamado **reference counting** (conteo de referencias). Cada objeto lleva la cuenta de cuántas variables lo apuntan. Cuando el conteo llega a cero, se libera la memoria automáticamente. Para ciclos de referencias (objetos que se apuntan entre sí), hay un *garbage collector* secundario.

**Lo que ganas:** cero memory leaks, cero use-after-free, cero segmentation faults.
**Lo que pagas:** mayor uso de memoria RAM (cada objeto Python tiene ~28 bytes de overhead mínimo), y pequeñas pausas cuando el garbage collector entra en acción.

---

## 3. Cuándo C es mejor que Python

### 3.1 Sistemas embebidos y microcontroladores

Un Arduino tiene 2 KB de RAM. Un intérprete de Python no entra ahí. C es la única opción viable.

### 3.2 Sistemas operativos y drivers

El kernel de Linux está escrito en C. Los drivers de hardware, los sistemas de archivos, los protocolos de red de bajo nivel —todo lo que habla directamente con el hardware usa C (o C++). Python no puede hacer esto.

### 3.3 Procesamiento intensivo en tiempo real

Codecs de video, motores de física, simulaciones numéricas masivas, criptografía de alto rendimiento. Cuando necesitas extraer cada nanosegundo posible del CPU, C gana. Los hotspots de Python (NumPy, TensorFlow) son en realidad extensiones escritas en C.

### 3.4 Software que no puede depender de un runtime externo

Un ejecutable compilado en C funciona solo. Python requiere que el intérprete esté instalado (y la versión correcta, y las dependencias, y...). Para software empaquetado que se distribuye a usuarios finales sin entorno técnico, C puede ser más práctico.

---

## 4. Cuándo Python es mejor que C

### 4.1 Prototipado rápido

Una idea que en C tomaría 3 horas, en Python puede estar lista en 20 minutos. Si estás explorando si algo funciona —antes de invertir en optimizarlo— Python gana.

### 4.2 Ciencia de datos e inteligencia artificial

`pandas`, `numpy`, `scikit-learn`, `tensorflow`, `pytorch`. El ecosistema de datos en Python no tiene equivalente en C. Analizar datasets, entrenar modelos, visualizar resultados —Python es el estándar de la industria aquí.

### 4.3 Scripts de automatización

Renombrar 10,000 archivos, procesar un CSV gigante, hacer web scraping, enviar emails automáticos. Tareas que en C requerirían manejar strings manualmente, abrir archivos con `fopen`, liberar memoria... en Python son 5 líneas.

### 4.4 APIs y backends web

Frameworks como Flask o FastAPI permiten crear un servidor HTTP funcional en menos de 10 líneas de Python. En C necesitarías librerías de socket y un manejo manual de conexiones.

### 4.5 Cuando la velocidad de desarrollo importa más que la velocidad de ejecución

En startups y equipos pequeños, el cuello de botella raramente es la velocidad del CPU. Es la velocidad del programador. Python permite iterar mucho más rápido.

---

## 5. Pitfalls comunes al migrar de C a Python

Estos son los errores más frecuentes de quien llega de C:

### 5.1 Olvidar que la indentación es sintaxis

```python
# En C, esto sería válido (aunque mal estilo)
if x > 0:
print("positivo")   # IndentationError — falta indentación
```

La solución: desde el primer día, configura tu editor para que use 4 espacios de indentación y nunca mezcles espacios con tabulaciones en el mismo archivo.

### 5.2 Comparar strings con == en C y asumir que falla en Python

```c
// En C, == compara punteros — siempre falso para strings distintas
if (s == t)  // compara direcciones de memoria, no contenido
```

```python
# En Python, == compara contenido — funciona como esperas
if s == t:   # correcto en Python
    print("iguales")
```

Este es uno que te juega a favor: Python se comporta como esperabas que C se comportara.

### 5.3 Asumir que las listas son arrays de C

```python
# En C, un array solo puede tener un tipo
int numeros[3] = {1, 2, 3};

# En Python, una lista puede mezclar tipos (aunque rara vez es buena idea)
mezcla = [1, "dos", 3.0, True]  # Python lo permite
```

Que Python lo permita no significa que debas hacerlo. Si tu lista va a contener un solo tipo lógico, mantenla así.

### 5.4 Modificar una lista mientras la iteras

```python
numeros = [1, 2, 3, 4, 5]

# PELIGROSO: modificar la lista que estás iterando
for n in numeros:
    if n % 2 == 0:
        numeros.remove(n)   # puede saltar elementos

# CORRECTO: iterar sobre una copia
for n in numeros[:]:        # numeros[:] crea una copia
    if n % 2 == 0:
        numeros.remove(n)

# O mejor: usar list comprehension
impares = [n for n in numeros if n % 2 != 0]
```

### 5.5 Confundir = (asignación) con == (comparación)

Esto lo traes de C, pero en Python el impacto es diferente:

```python
x = 5   # asignación
x == 5  # comparación — devuelve True, pero NO asigna nada

# El error clásico:
if x = 5:   # SyntaxError en Python — C sí lo permitía (mal)
    pass
```

Python fue deliberadamente diseñado para que `=` dentro de un `if` sea un error de sintaxis, a diferencia de C donde era una trampa silenciosa.

### 5.6 No usar with al abrir archivos

```python
# MAL: si ocurre un error, el archivo nunca se cierra
f = open("datos.txt", "r")
contenido = f.read()
f.close()   # si read() falla, esta línea nunca se ejecuta

# BIEN: with garantiza el cierre aunque ocurra una excepción
with open("datos.txt", "r") as f:
    contenido = f.read()
```

### 5.7 Asumir que print no agrega \n

Viene de C, donde `printf` no agrega salto de línea a menos que lo escribas:

```c
printf("hola");  // sin \n: el cursor queda en la misma línea
```

```python
print("hola")   # SIEMPRE agrega \n al final por defecto
print("hola", end="")  # sin \n: equivalente a printf sin \n
```

---

## 6. La abstracción tiene un precio real

En ciencia de la computación, "abstracción" significa ocultar complejidad debajo de una interfaz simple. Python es una capa de abstracción encima de C (de hecho, CPython, el intérprete más común, está escrito en C).

Cada vez que Python hace algo "automáticamente" por ti, alguien tuvo que escribir el código C que lo implementa. Ese código tiene un costo en tiempo de CPU y en memoria.

Ejemplo concreto: sumar una lista de un millón de números enteros.

En C:
```c
long suma = 0;
for (int i = 0; i < 1000000; i++)
    suma += numeros[i];
```
Cada iteración: una lectura de memoria + una suma entera = ~1 nanosegundo por elemento.

En Python:
```python
suma = sum(numeros)
```
Parece más simple, pero cada elemento de la lista es un objeto Python con metadata, el bucle interno del intérprete verifica tipos en cada iteración, y el garbage collector puede interrumpir en cualquier momento. Resultado: entre 10 y 50 nanosegundos por elemento.

¿Importa? Para esta tarea probablemente no. Pero si ese bucle está dentro de otro bucle, dentro de otro bucle, la diferencia se amplifica dramáticamente.

---

## 7. Regla práctica para elegir

Usa este árbol de decisión:

```
¿Necesitas velocidad máxima o control de hardware?
├── Sí → C (o C++)
└── No → ¿Tienes que iterar rápido sobre el problema?
         ├── Sí → Python
         └── No → cualquiera de los dos funciona; elige el que mejor conoces
```

La mayoría de los programas del mundo real usan ambos: Python para la lógica de alto nivel, C/C++ para las partes críticas de rendimiento. Numpy, por ejemplo, es Python por fuera y C por dentro.

Ahora que conoces los dos, puedes hacer exactamente eso.
