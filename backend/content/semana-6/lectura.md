# Clase 6: Python

Llegaste al punto de inflexión del curso. Pasaste semanas construyendo programas en C: lidiaste con punteros, malloc, free, tipos explícitos, aritmética de memoria y compilación manual. Todo eso fue intencional. Ahora que entiendes lo que ocurre debajo del capó, puedes usar Python con criterio —sabiendo exactamente qué comodidades estás aprovechando y cuándo importa ese detalle.

---

## Tabla de equivalencias rápidas: C → Python

| Concepto | C | Python |
|---|---|---|
| Declarar variable | `int x = 5;` | `x = 5` |
| Imprimir texto | `printf("hola\n");` | `print("hola")` |
| Leer entrada del usuario | `get_int("n: ")` | `int(input("n: "))` |
| Bucle for | `for (int i = 0; i < n; i++)` | `for i in range(n):` |
| Bucle while | `while (condición) { }` | `while condición:` |
| Condicional | `if (x > 0) { }` | `if x > 0:` |
| Función | `int sumar(int a, int b) { }` | `def sumar(a, b):` |
| Array de enteros | `int nums[3] = {1, 2, 3};` | `nums = [1, 2, 3]` |
| String | `char nombre[] = "Ana";` | `nombre = "Ana"` |
| Tabla clave-valor | hash table manual | `diccionario = {}` |
| Abrir archivo | `fopen("f.txt", "r")` | `open("f.txt", "r")` |
| Manejo de errores | códigos de retorno | `try / except` |
| Librerías | `#include <stdlib.h>` | `import sys` |
| Compilar y ejecutar | `make programa && ./programa` | `python programa.py` |

---

## 1. Por qué aprender Python después de C

Python es el lenguaje más popular del mundo en ciencia de datos, inteligencia artificial, automatización y backend web. Pero aprenderlo *después de C* tiene una ventaja enorme: no lo tomas como magia.

Cuando en Python escribes `lista.append(x)`, sabes que internamente hay algo parecido a un `realloc`. Cuando usas un diccionario y obtienes acceso en tiempo constante, reconoces la tabla hash que implementaste en el problem set de Speller. Esa intuición vale más que cualquier tutorial de Python para principiantes.

La diferencia fundamental entre ambos lenguajes:

- **C** es compilado: tu código se traduce a binario antes de ejecutarse. Tienes control total sobre la memoria y máxima velocidad, pero también toda la responsabilidad.
- **Python** es interpretado: un programa llamado *intérprete* lee y ejecuta tu código línea a línea en tiempo real. No compilas nada; simplemente ejecutas `python programa.py`. Eso lo hace más lento, pero incomparablemente más rápido de escribir.

```
# C: compilar y ejecutar
gcc -o mario mario.c
./mario

# Python: solo ejecutar
python mario.py
```

---

## 2. Sintaxis básica: variables sin tipos e indentación

### 2.1 Variables sin declaración de tipo

En C, antes de usar una variable debes declarar su tipo:

```c
// C: declaración explícita de tipo
int edad = 20;
float precio = 9.99;
char inicial = 'A';
char nombre[] = "Ana";
```

En Python, el intérprete infiere el tipo automáticamente según el valor que asignas. Esto se llama **tipado dinámico**:

```python
# Python: sin tipos — el intérprete los infiere
edad = 20          # int
precio = 9.99      # float
inicial = "A"      # str (Python no tiene char separado)
nombre = "Ana"     # str
```

Puedes cambiar el tipo de una variable reasignándola (aunque hacerlo sin motivo es mala práctica):

```python
x = 5       # x es int
x = "hola"  # ahora x es str — Python lo permite sin error
```

### 2.2 Indentación obligatoria en lugar de llaves

En C, los bloques de código se delimitan con llaves `{ }`:

```c
// C: llaves definen el bloque
if (x > 0)
{
    printf("positivo\n");
    printf("mayor que cero\n");
}
```

En Python, los bloques se definen mediante **indentación** (espacios o tabulaciones). No hay llaves. No hay punto y coma al final de las líneas:

```python
# Python: la indentación define el bloque
if x > 0:
    print("positivo")
    print("mayor que cero")
```

Si desindentes una línea, saliste del bloque. El nivel de indentación no es cosmético —es sintaxis real. Un error de indentación es un error de programa:

```python
# INCORRECTO: IndentationError
if x > 0:
print("esto falla")   # falta indentación

# CORRECTO
if x > 0:
    print("esto funciona")
```

La convención de la comunidad Python (PEP 8) es usar **4 espacios** por nivel de indentación.

### 2.3 Strings con f-strings

C usa `printf` con especificadores de formato (`%s`, `%d`, `%f`). Python tiene una sintaxis mucho más limpia llamada **f-string**:

```c
// C: printf con especificadores
char nombre[] = "Camilo";
int edad = 22;
printf("Hola, %s. Tienes %d años.\n", nombre, edad);
```

```python
# Python: f-string — prefijo f antes de las comillas
nombre = "Camilo"
edad = 22
print(f"Hola, {nombre}. Tienes {edad} años.")
```

Dentro de las llaves `{}` puedes poner cualquier expresión Python:

```python
print(f"El doble de tu edad es {edad * 2}.")
print(f"Pi aproximado: {22 / 7:.2f}")  # 2 decimales
```

---

## 3. Funciones

### 3.1 Definición y llamada

En C, debes declarar el tipo de retorno y el tipo de cada parámetro:

```c
// C: tipos explícitos en la firma
int sumar(int a, int b)
{
    return a + b;
}

int main(void)
{
    int resultado = sumar(3, 4);
    printf("%d\n", resultado);
}
```

En Python, se usa la palabra clave `def`. Sin tipos en la firma, sin tipo de retorno:

```python
# Python: sin tipos en la firma
def sumar(a, b):
    return a + b

resultado = sumar(3, 4)
print(resultado)
```

### 3.2 La función `main` y cómo llamarla

En C, `main` es el punto de entrada obligatorio del programa. En Python no existe ese requisito, pero la convención es definir una función `main` y llamarla al final del archivo:

```c
// C: main es el punto de entrada automático
int main(void)
{
    printf("hola\n");
    return 0;
}
```

```python
# Python: main es solo una función como cualquier otra
def main():
    print("hola")

# Hay que llamarla explícitamente al final
main()
```

### 3.3 Argumentos con nombre (named arguments)

Python permite pasar argumentos a una función usando su nombre, lo que hace el código más legible y permite omitir parámetros opcionales:

```python
# print tiene un parámetro 'end' que por defecto es '\n'
# Para imprimir sin salto de línea:
print("hola", end="")
print(" mundo")   # imprime en la misma línea: "hola mundo"

# Separador personalizado entre argumentos
print("uno", "dos", "tres", sep="-")   # "uno-dos-tres"
```

### 3.4 Alcance de variables (scope)

En C, una variable declarada dentro de un bloque `{ }` no existe fuera de él. En Python, una variable asignada dentro de un bucle o bloque `if` sí existe después de ese bloque:

```c
// C: n no existe fuera del while
while (true)
{
    int n = get_int("Número: ");
    if (n > 0) break;
}
// printf("%d", n);  ← ERROR: n no existe aquí
```

```python
# Python: n sí existe fuera del while
while True:
    n = int(input("Número: "))
    if n > 0:
        break
print(n)  # funciona: n existe en este alcance
```

---

## 4. Entrada del usuario y el problema de tipos

En C, `get_int` de la librería CS50 maneja por ti la conversión y la validación. En Python puro, `input()` siempre devuelve un **string** (texto), así que debes convertirlo:

```c
// C: get_int valida y convierte automáticamente
int n = get_int("Altura: ");
```

```python
# Python: input() devuelve str; hay que convertir
n = int(input("Altura: "))
```

¿Qué pasa si el usuario escribe `"gato"` en lugar de un número? Python lanza un `ValueError`. Eso nos lleva al siguiente tema.

---

## 5. Excepciones: try / except

En C, el manejo de errores se hace con códigos de retorno o con validaciones manuales caracter por caracter. Es tedioso. Python tiene un mecanismo nativo llamado **excepciones**:

```c
// C: validar manualmente que la entrada sea número
// (requería un bucle complejo con isdigit)
```

```python
# Python: try / except — intentar y capturar el error
while True:
    try:
        n = int(input("Altura: "))
        if n > 0:
            return n   # o break
    except ValueError:
        print("Eso no es un número entero.")
```

La lógica es:

1. Python intenta ejecutar el bloque `try`.
2. Si ocurre un error del tipo especificado (aquí `ValueError`), salta al bloque `except` en lugar de terminar el programa con un traceback.
3. El ciclo continúa hasta que el usuario coopere.

Esto es lo que la función `get_int` de CS50 hace internamente. Al aprender Python sin las training wheels de CS50, implementas este patrón tú mismo.

Tipos comunes de excepciones:

| Excepción | Cuándo ocurre |
|---|---|
| `ValueError` | Conversión inválida (`int("gato")`) |
| `ZeroDivisionError` | División por cero |
| `FileNotFoundError` | Archivo que no existe |
| `IndexError` | Índice fuera del rango de una lista |
| `KeyError` | Clave que no existe en un diccionario |

---

## 6. Bucles

### 6.1 for con range

```c
// C: for clásico
for (int i = 0; i < 3; i++)
{
    printf("#\n");
}
```

```python
# Python: for con range
for i in range(3):
    print("#")
```

`range(n)` genera los números `0, 1, 2, ..., n-1`. También acepta inicio, fin y paso:

```python
range(1, 5)      # 1, 2, 3, 4
range(0, 10, 2)  # 0, 2, 4, 6, 8
```

### 6.2 for sobre una secuencia

Python permite iterar directamente sobre los elementos de una lista o string sin índices:

```c
// C: necesitas el índice
char nombre[] = "Hola";
for (int i = 0; nombre[i] != '\0'; i++)
{
    printf("%c\n", nombre[i]);
}
```

```python
# Python: iteras directamente sobre los caracteres
nombre = "Hola"
for c in nombre:
    print(c)
```

### 6.3 while True (equivalente a do-while)

C tiene `do-while` para ejecutar al menos una vez. Python no lo tiene, pero el patrón `while True` con `break` logra lo mismo:

```c
// C: do-while
int n;
do
{
    n = get_int("Altura: ");
}
while (n <= 0);
```

```python
# Python: while True + break
while True:
    n = int(input("Altura: "))
    if n > 0:
        break
```

### 6.4 Multiplicación de strings (truco Pythonic)

Para imprimir n caracteres en una sola línea sin un bucle:

```c
// C: necesitas un bucle
for (int j = 0; j < n; j++)
    printf("#");
printf("\n");
```

```python
# Python: multiplicación de string
print("#" * n)
```

---

## 7. Listas (equivalente a los arrays de C)

### 7.1 Crear y acceder

```c
// C: array de tamaño fijo
int puntajes[3] = {72, 73, 33};
printf("%d\n", puntajes[0]);
```

```python
# Python: lista de tamaño variable
puntajes = [72, 73, 33]
print(puntajes[0])   # 72
```

### 7.2 Listas dinámicas — sin malloc

La diferencia más importante: en Python no debes saber el tamaño de antemano, y la lista crece automáticamente:

```c
// C: necesitas malloc/realloc para crecer
int *lista = malloc(3 * sizeof(int));
// ... realloc para agregar más
```

```python
# Python: empieza vacío, agrega con append
puntajes = []
for i in range(3):
    p = int(input("Puntaje: "))
    puntajes.append(p)   # crece automáticamente
```

### 7.3 Funciones útiles de listas

```python
puntajes = [72, 73, 33]

len(puntajes)          # 3 — longitud
sum(puntajes)          # 178 — suma
min(puntajes)          # 33
max(puntajes)          # 73
sorted(puntajes)       # [33, 72, 73] — nueva lista ordenada
puntajes.sort()        # ordena en el lugar (modifica la original)
puntajes.append(90)    # agrega al final
puntajes.pop()         # quita y devuelve el último elemento
```

### 7.4 Promedio sin bucle

```c
// C: necesitas un bucle para sumar
int suma = 0;
for (int i = 0; i < 3; i++)
    suma += puntajes[i];
float promedio = (float) suma / 3;
```

```python
# Python: sum y len hacen el trabajo
promedio = sum(puntajes) / len(puntajes)
print(f"Promedio: {promedio:.1f}")
```

### 7.5 Slices — rebanar una lista

Python permite obtener una sublista con la notación `[inicio:fin]`:

```python
argv = ["programa.py", "Camilo", "Bogotá"]

argv[1:]      # ["Camilo", "Bogotá"] — desde el índice 1 en adelante
argv[0:2]     # ["programa.py", "Camilo"] — índices 0 y 1
argv[:2]      # igual que [0:2]
```

Esto reemplaza el trabajo manual con punteros que habrías hecho en C para saltar el primer elemento de `argv`.

### 7.6 Buscar en una lista con `in`

```c
// C: bucle de búsqueda lineal manual
for (int i = 0; i < n; i++)
    if (strcmp(nombres[i], buscado) == 0) { ... }
```

```python
# Python: el operador 'in' hace búsqueda lineal automáticamente
if "Hermione" in nombres:
    print("Encontrada")
else:
    print("No encontrada")
```

---

## 8. Diccionarios

Un diccionario en Python es exactamente lo que implementaste con esfuerzo en C: una tabla hash. La diferencia es que Python la incluye en el lenguaje y tiene tiempo de acceso prácticamente constante de forma transparente para ti.

### 8.1 Crear un diccionario

```c
// C: no hay equivalente nativo — implementaste
//     una tabla hash en problem set Speller
```

```python
# Python: dos formas equivalentes
agenda = dict()       # función constructora
agenda = {}           # forma más común (equivalente)

# Diccionario con valores iniciales
agenda = {
    "Carter": "+1-617-495-1000",
    "David":  "+1-949-468-2750"
}
```

### 8.2 Acceder a valores

El índice de un diccionario no es un número entero, sino la **clave** (cualquier tipo inmutable, usualmente un string):

```python
numero = agenda["David"]      # "+1-949-468-2750"
print(f"Número: {numero}")
```

### 8.3 Buscar si una clave existe

```python
nombre = input("¿A quién buscas? ")
if nombre in agenda:
    print(f"Número: {agenda[nombre]}")
else:
    print("No está en la agenda.")
```

### 8.4 Agregar y modificar entradas

```python
agenda["Hermione"] = "+1-800-HOGWARTS"   # agrega si no existe; modifica si existe
```

### 8.5 Iterar sobre un diccionario

```python
# Iterar sobre claves
for nombre in agenda:
    print(nombre)

# Iterar sobre pares clave-valor
for nombre, numero in agenda.items():
    print(f"{nombre}: {numero}")
```

---

## 9. Strings en Python

En C, un string es un `char[]` terminado en `\0`. En Python, los strings son **objetos** con métodos integrados:

```c
// C: convertir a mayúsculas es un bucle con toupper()
for (int i = 0; s[i] != '\0'; i++)
    s[i] = toupper(s[i]);
```

```python
# Python: método .upper() en el string directamente
s = "hola mundo"
print(s.upper())       # "HOLA MUNDO"
print(s.lower())       # "hola mundo"
print(s.capitalize())  # "Hola mundo" — solo la primera letra
print(s.strip())       # elimina espacios al inicio y al final
print(s.replace("hola", "adiós"))  # "adiós mundo"
```

Comparar strings:

```c
// C: strcmp — comparar punteros da resultado incorrecto
if (strcmp(s, t) == 0) { ... }
```

```python
# Python: == compara contenido directamente
if s == t:
    print("son iguales")
```

Intercambiar variables (sin variable temporal):

```c
// C: necesitas variable temporal
int tmp = x;
x = y;
y = tmp;
```

```python
# Python: intercambio en una línea
x, y = y, x
```

---

## 10. Manejo de archivos

### 10.1 Abrir y cerrar

```c
// C: fopen y fclose
FILE *f = fopen("datos.txt", "w");
fprintf(f, "hola\n");
fclose(f);
```

```python
# Python: open y close
f = open("datos.txt", "w")
f.write("hola\n")
f.close()
```

### 10.2 La forma Pythonica: with

El bloque `with` cierra el archivo automáticamente al terminar el bloque indentado, incluso si ocurre un error. Es la forma preferida:

```python
# Python (forma recomendada): with open
with open("datos.txt", "w") as f:
    f.write("hola\n")
# aquí el archivo ya está cerrado automáticamente
```

Modos de apertura:

| Modo | Significado |
|---|---|
| `"r"` | Leer (read) — error si no existe |
| `"w"` | Escribir (write) — sobreescribe si existe |
| `"a"` | Agregar al final (append) |
| `"r+"` | Leer y escribir |

### 10.3 Leer un archivo completo

```python
with open("nombres.txt", "r") as f:
    contenido = f.read()    # todo el archivo como un string
    print(contenido)
```

O línea a línea:

```python
with open("nombres.txt", "r") as f:
    for linea in f:
        print(linea.strip())   # strip() elimina el \n al final
```

---

## 11. La librería csv

Los archivos CSV (Comma-Separated Values) son hojas de cálculo en texto plano. La librería estándar `csv` de Python los maneja sin esfuerzo:

### 11.1 Escribir un CSV

```python
import csv

with open("agenda.csv", "a") as f:
    # writer clásico: escribe listas
    writer = csv.writer(f)
    writer.writerow(["Carter", "+1-617-495-1000"])
```

### 11.2 DictWriter — escritura robusta con nombres de columnas

```python
import csv

with open("agenda.csv", "a") as f:
    # DictWriter: escribe diccionarios — resiste cambios de orden de columnas
    writer = csv.DictWriter(f, fieldnames=["nombre", "numero"])
    writer.writerow({"nombre": "David", "numero": "+1-949-468-2750"})
```

### 11.3 Leer un CSV

```python
import csv

with open("agenda.csv", "r") as f:
    reader = csv.DictReader(f)
    for fila in reader:
        print(f"{fila['nombre']}: {fila['numero']}")
```

---

## 12. La librería sys

`sys` da acceso a funcionalidades del sistema operativo y del intérprete:

### 12.1 Argumentos de línea de comandos

En C, los argumentos se reciben en `main(int argc, char *argv[])`. En Python están en `sys.argv`:

```c
// C
int main(int argc, char *argv[])
{
    if (argc == 2)
        printf("Hola, %s\n", argv[1]);
}
```

```python
# Python
import sys

if len(sys.argv) == 2:
    print(f"Hola, {sys.argv[1]}")
else:
    print("Hola, mundo")
```

`sys.argv[0]` contiene el nombre del script (`"saludo.py"`). `sys.argv[1]` en adelante contiene los argumentos del usuario.

### 12.2 Salir con código de error

```c
// C
exit(1);   // algo salió mal
```

```python
# Python
import sys
sys.exit(1)    # salida con error
sys.exit(0)    # salida exitosa
```

Ejemplo completo que valida argumentos:

```python
import sys

if len(sys.argv) != 2:
    print("Uso: python saludo.py <nombre>")
    sys.exit(1)

print(f"Hola, {sys.argv[1]}")
```

---

## 13. La librería re (expresiones regulares)

Las expresiones regulares permiten buscar patrones dentro de strings de forma muy potente:

```python
import re

# Verificar si un email tiene formato válido
email = input("Email: ")
if re.search(r"^\S+@\S+\.\S+$", email):
    print("Formato válido")
else:
    print("Formato inválido")
```

Patrones comunes:

| Patrón | Significado |
|---|---|
| `\d` | Un dígito (0-9) |
| `\w` | Un carácter de palabra (letra, dígito o `_`) |
| `\s` | Un espacio en blanco |
| `+` | Uno o más del anterior |
| `*` | Cero o más del anterior |
| `^` | Inicio del string |
| `$` | Final del string |

```python
# Extraer todas las palabras de un texto
texto = "hola mundo 123 python"
palabras = re.findall(r"\w+", texto)
# ["hola", "mundo", "123", "python"]
```

---

## 14. Mario en Python — comparación completa

Para cerrar, veamos el problema Mario implementado en ambos lenguajes:

### Versión C

```c
#include <stdio.h>
#include <cs50.h>

int get_height(void);

int main(void)
{
    int n = get_height();
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
            printf("#");
        printf("\n");
    }
}

int get_height(void)
{
    int n;
    do
    {
        n = get_int("Altura: ");
    }
    while (n <= 0);
    return n;
}
```

### Versión Python

```python
def main():
    n = get_height()
    for i in range(n):
        print("#" * n)   # sin bucle interno


def get_height():
    while True:
        try:
            n = int(input("Altura: "))
            if n > 0:
                return n
        except ValueError:
            print("Eso no es un número entero.")


main()
```

Observa las diferencias:

- Sin tipos. Sin `void`. Sin punto y coma. Sin llaves.
- `print("#" * n)` reemplaza el bucle interno completo.
- `try/except` reemplaza la validación manual de caracteres.
- `return n` dentro del `while` sale del bucle y de la función al mismo tiempo.
- Se llama `main()` explícitamente al final.

---

## 15. Resumen de lo aprendido

Python no es "C fácil". Es un lenguaje diferente con filosofía diferente. Pero haberlo aprendido primero te da perspectiva: sabes que detrás de cada lista hay memoria dinámica, detrás de cada diccionario hay una tabla hash, y detrás de cada `import` hay código que alguien escribió para ti.

El objetivo de esta semana es que puedas:

1. Traducir lógica de C a Python con fluidez.
2. Usar listas, diccionarios, archivos y excepciones de forma natural.
3. Aprovechar las librerías `csv`, `sys` y `re` para resolver problemas reales.
4. Resolver las versiones Python de Mario, Cash, Readability y DNA.
