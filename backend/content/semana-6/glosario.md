# Glosario: Semana 6 — Python

Términos clave de esta semana, explicados en contexto con comparaciones a C cuando corresponde.

---

## Interpretado vs. Compilado

**Compilado:** El código fuente se traduce a instrucciones de máquina *antes* de ejecutarse. El resultado es un binario que el CPU puede ejecutar directamente. C es un lenguaje compilado: escribes `hello.c`, lo compilas con `gcc` y obtienes un ejecutable que puedes distribuir y correr sin tener `gcc` instalado.

**Interpretado:** Un programa especial llamado *intérprete* lee el código fuente y lo ejecuta línea a línea *en tiempo de ejecución*. Python es interpretado: el intérprete CPython traduce cada instrucción al vuelo. Esto hace que Python sea más lento que C, pero permite ciclos de desarrollo mucho más rápidos: edita el archivo y ejecútalo de nuevo sin compilar.

```
C:      hello.c → [gcc] → hello (binario) → [CPU lo ejecuta]
Python: hello.py → [python/CPython] → [CPU ejecuta CPython que ejecuta tu código]
```

---

## Tipado Dinámico

Sistema de tipos en el que el tipo de una variable se determina *en tiempo de ejecución*, según el valor que se le asigna, no en tiempo de compilación. Python usa tipado dinámico:

```python
x = 5        # x es int
x = "hola"   # ahora x es str — sin error, sin redeclaración
x = [1, 2]   # ahora x es list
```

La ventaja es flexibilidad y menos código. La desventaja es que errores de tipo que en C el compilador detectaría antes de ejecutar, en Python solo aparecen cuando esa línea específica se ejecuta.

---

## Tipado Estático

Sistema de tipos en el que el tipo de cada variable debe declararse (o inferirse por el compilador) *antes* de ejecutar el programa. C usa tipado estático:

```c
int x = 5;        // x solo puede ser int para siempre
x = "hola";       // Error de compilación — tipo incompatible
```

El compilador puede detectar errores de tipo antes de que el programa corra. Esto contribuye a programas más rápidos (el CPU sabe exactamente qué operaciones usar) y más seguros (muchos bugs se detectan en compilación).

> **Nota:** Python tiene *type hints* opcionales (`x: int = 5`) que no son tipado estático real —Python los ignora al ejecutar— pero herramientas como `mypy` los usan para detectar errores antes de correr el programa.

---

## Indentación

En la mayoría de los lenguajes, la indentación (espacios o tabulaciones al inicio de una línea) es puramente cosmética. En Python, es **sintaxis obligatoria**: define la pertenencia de líneas a un bloque de código (función, if, for, while, etc.).

```python
def saludar(nombre):
    # estas líneas están DENTRO de la función (indentadas)
    mensaje = f"Hola, {nombre}"
    print(mensaje)

# esta línea está FUERA de la función (sin indentación)
saludar("Camilo")
```

La convención oficial (PEP 8) es usar **4 espacios** por nivel. Nunca mezcles espacios con tabulaciones en el mismo archivo.

---

## Lista

Estructura de datos ordenada y mutable en Python que puede contener elementos de cualquier tipo. Equivale conceptualmente a un array de C, pero con tres diferencias clave:

1. **Tamaño dinámico:** crece y encoge automáticamente sin `malloc`/`realloc`.
2. **Tipos mixtos:** puede contener enteros, strings, listas u otros objetos al mismo tiempo.
3. **Métodos integrados:** `append`, `pop`, `sort`, `reverse`, entre otros.

```python
nombres = ["Ana", "Luis", "María"]
nombres.append("Pedro")   # ["Ana", "Luis", "María", "Pedro"]
print(len(nombres))       # 4
print(nombres[0])         # "Ana"
print(nombres[-1])        # "Pedro" — índice negativo: desde el final
```

---

## Diccionario

Estructura de datos que almacena pares **clave → valor**. Equivale a una tabla hash implementada manualmente en C (como la que construiste en Speller). Python la incluye como tipo nativo con acceso promedio en tiempo constante O(1).

Las claves pueden ser cualquier tipo inmutable (strings, enteros, tuplas). Los valores pueden ser cualquier objeto Python.

```python
# Crear
agenda = {"Ana": "555-1234", "Luis": "555-5678"}

# Acceder
print(agenda["Ana"])         # "555-1234"

# Agregar / modificar
agenda["María"] = "555-9012"

# Verificar existencia
if "Luis" in agenda:
    print("Luis está en la agenda")

# Iterar
for nombre, numero in agenda.items():
    print(f"{nombre}: {numero}")
```

---

## Tupla

Secuencia ordenada e **inmutable** de elementos. Es como una lista que no se puede modificar después de crearse. Se define con paréntesis en lugar de corchetes:

```python
coordenada = (40.7128, -74.0060)   # latitud y longitud de NYC
x, y = coordenada                  # desempaquetado (unpacking)
print(x)   # 40.7128
```

Se usa cuando quieres garantizar que los datos no cambien accidentalmente, o como clave de un diccionario (las listas no pueden ser claves porque son mutables).

---

## Excepción

Mecanismo de Python para manejar errores en tiempo de ejecución. Cuando algo sale mal, Python no simplemente termina el programa —lanza una excepción que puedes capturar con `try/except` y manejar de forma controlada.

```python
try:
    n = int(input("Número: "))
    resultado = 10 / n
except ValueError:
    print("Eso no es un número.")
except ZeroDivisionError:
    print("No se puede dividir entre cero.")
else:
    # se ejecuta solo si NO hubo excepción
    print(f"Resultado: {resultado}")
finally:
    # se ejecuta SIEMPRE, haya o no excepción
    print("Fin del programa.")
```

En C, el equivalente eran los códigos de retorno (`return 1`) y las verificaciones manuales. Las excepciones son más expresivas y más fáciles de propagar a través de múltiples funciones.

---

## Módulo

Archivo `.py` que contiene definiciones (funciones, clases, variables) que puedes importar y reutilizar en otros programas. Todo archivo Python es potencialmente un módulo.

```python
# archivo: matematica.py
def sumar(a, b):
    return a + b

def restar(a, b):
    return a - b
```

```python
# archivo: main.py
import matematica

print(matematica.sumar(3, 4))   # 7
```

O importar solo lo que necesitas:

```python
from matematica import sumar
print(sumar(3, 4))   # 7 — sin prefijo de módulo
```

---

## Librería Estándar

Colección de módulos que vienen incluidos con Python sin necesidad de instalar nada extra. Es una de las grandes fortalezas del lenguaje:

| Módulo | Para qué sirve |
|---|---|
| `sys` | Argumentos de línea de comandos, salida del programa, versión de Python |
| `csv` | Leer y escribir archivos CSV |
| `re` | Expresiones regulares (búsqueda de patrones en strings) |
| `os` | Interacción con el sistema operativo (rutas, variables de entorno) |
| `math` | Funciones matemáticas (`sqrt`, `floor`, `ceil`, `pi`) |
| `random` | Números aleatorios |
| `json` | Leer y escribir formato JSON |
| `datetime` | Fechas y horas |

Se importan con `import nombre_modulo` o `from nombre_modulo import función`.

---

## pip

Herramienta de línea de comandos para instalar paquetes de terceros desde el **Python Package Index** (PyPI, el repositorio público de librerías Python). Es el equivalente a un gestor de paquetes como `apt` en Linux, pero específico para Python.

```bash
# Instalar una librería externa
pip install requests      # para hacer peticiones HTTP
pip install pandas        # para análisis de datos
pip install flask         # para crear servidores web

# Ver librerías instaladas
pip list

# Guardar dependencias de un proyecto
pip freeze > requirements.txt

# Instalar todas las dependencias de un proyecto
pip install -r requirements.txt
```

La librería estándar no necesita pip. Solo necesitas pip para paquetes de terceros que no vienen con Python.

---

## Script vs. Programa Interactivo

**Script:** Archivo Python que se ejecuta de principio a fin de forma automática cuando lo llamas desde la terminal. No espera interacción continua del usuario más allá de lo que tú programes explícitamente.

```bash
python procesar_datos.py   # ejecuta todo el archivo de arriba a abajo
```

**Programa interactivo (REPL):** Modo en el que Python espera que escribas una línea a la vez, la evalúa inmediatamente y muestra el resultado. Ideal para explorar, probar ideas y depurar.

```bash
python          # abre el REPL (Read-Eval-Print Loop)
>>> 2 + 2
4
>>> "hola".upper()
'HOLA'
>>> exit()      # sale del REPL
```

La mayoría de los programas que escribirás en este curso son scripts. El REPL es útil para probar una función o expresión rápidamente sin tener que crear un archivo completo.
