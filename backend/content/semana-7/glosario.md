# Glosario: Semana 7 — SQL y Bases de Datos Relacionales

---

## base de datos relacional

Un sistema organizado para almacenar y gestionar grandes cantidades de datos estructurados en **tablas** con filas y columnas. Se llama "relacional" porque las tablas pueden relacionarse entre sí a través de claves. Los sistemas más populares son SQLite, MySQL, PostgreSQL, SQL Server y Oracle.

**Ejemplo del mundo real:** La base de datos de IMDB almacena millones de películas, personas, calificaciones y géneros en tablas separadas que se relacionan entre sí.

---

## tabla

La unidad de almacenamiento principal en una base de datos relacional. Una tabla es similar a una hoja de cálculo: tiene un nombre, columnas que definen la estructura, y filas que contienen los datos. Cada tabla almacena información de un solo tipo de entidad (por ejemplo, una tabla de `peliculas` y otra de `actores`).

```sql
-- Definir una tabla
CREATE TABLE peliculas (
    id     INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    anio   INTEGER
);
```

---

## fila (row)

Una fila, también llamada **registro** o **tupla**, es una entrada individual dentro de una tabla. Contiene un valor para cada columna de la tabla. En la tabla `peliculas`, cada fila representa una película específica.

**Sinónimos:** registro, tupla, entrada, record.

---

## columna

Una columna, también llamada **campo** o **atributo**, define un tipo específico de datos que se almacena en una tabla. Todas las filas tienen el mismo conjunto de columnas. Por ejemplo, la tabla `peliculas` puede tener las columnas `id`, `titulo` y `anio`.

**Sinónimos:** campo, atributo, field.

---

## clave primaria (PRIMARY KEY)

Una columna (o combinación de columnas) que **identifica de forma única cada fila** dentro de una tabla. No puede haber dos filas con el mismo valor de clave primaria, y tampoco puede ser `NULL`.

Por convención, las claves primarias suelen ser columnas llamadas `id` con valores enteros que se incrementan automáticamente.

```sql
CREATE TABLE usuarios (
    id    INTEGER PRIMARY KEY,  -- identifica cada usuario de forma única
    email TEXT NOT NULL UNIQUE
);
```

---

## clave foránea (FOREIGN KEY)

Una columna en una tabla que almacena la **clave primaria de otra tabla**, creando así una relación entre las dos tablas. Garantiza la **integridad referencial**: no puedes tener una clave foránea que apunte a una fila que no existe.

```sql
-- pelicula_id en la tabla 'calificaciones' apunta a 'id' en la tabla 'peliculas'
CREATE TABLE calificaciones (
    pelicula_id INTEGER,
    calificacion REAL,
    votos INTEGER,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id)
);
```

---

## SELECT

El comando SQL para **consultar (leer) datos** de una o más tablas. Es la operación más común en SQL y corresponde a la "R" de CRUD (Create, Read, Update, Delete).

```sql
-- Seleccionar todas las columnas de todos los registros
SELECT * FROM peliculas;

-- Seleccionar columnas específicas con un filtro
SELECT titulo, anio FROM peliculas WHERE anio > 2010;

-- Contar registros
SELECT COUNT(*) AS total FROM peliculas;
```

---

## WHERE

Una cláusula opcional del `SELECT` (y de `UPDATE`/`DELETE`) que filtra las filas según una condición. Solo se devuelven las filas para las que la condición es verdadera. Funciona como un `if` que selecciona qué datos incluir.

```sql
-- Solo películas del año 2005
SELECT titulo FROM peliculas WHERE anio = 2005;

-- Múltiples condiciones con AND / OR
SELECT titulo FROM peliculas
WHERE anio > 2000 AND calificacion > 8.0;

-- Búsqueda con patrón (% = cualquier secuencia de caracteres)
SELECT titulo FROM peliculas WHERE titulo LIKE 'The%';
```

---

## JOIN

Un mecanismo para **combinar filas de dos o más tablas** basándose en una columna que tienen en común, generalmente una clave foránea y su clave primaria correspondiente. Sin `JOIN`, no podrías cruzar información entre tablas.

```sql
-- Combinar películas con sus calificaciones
SELECT peliculas.titulo, calificaciones.calificacion
FROM peliculas
JOIN calificaciones ON peliculas.id = calificaciones.pelicula_id;
```

---

## INNER JOIN

El tipo más común de `JOIN`. Devuelve solo las filas que tienen **coincidencia en ambas tablas**. Si una fila de la tabla izquierda no tiene correspondencia en la tabla derecha (o viceversa), esa fila no aparece en el resultado.

```sql
SELECT p.titulo, c.calificacion
FROM peliculas AS p
INNER JOIN calificaciones AS c ON p.id = c.pelicula_id
WHERE p.titulo = 'Breaking Bad';
```

---

## LEFT JOIN

Un tipo de `JOIN` que devuelve **todas las filas de la tabla izquierda**, más las filas coincidentes de la tabla derecha. Si no hay coincidencia en la tabla derecha, las columnas de esa tabla aparecen con valor `NULL`.

Útil cuando quieres incluir todos los registros de una tabla aunque algunos no tengan datos relacionados en la otra.

```sql
-- Todas las películas, con su calificación si existe (o NULL si no tiene)
SELECT peliculas.titulo, calificaciones.calificacion
FROM peliculas
LEFT JOIN calificaciones ON peliculas.id = calificaciones.pelicula_id;
```

---

## índice

Una estructura de datos auxiliar (internamente un árbol B) que la base de datos construye para **acelerar las búsquedas** en una columna específica. Funciona como el índice al final de un libro: en lugar de leer todo el libro para encontrar un tema, consultas el índice y vas directo a la página.

Los índices aceleran las consultas (`SELECT`, `JOIN`, `ORDER BY`) pero ralentizan las escrituras (`INSERT`, `UPDATE`, `DELETE`) porque el índice también debe actualizarse.

```sql
-- Crear un índice en la columna titulo
CREATE INDEX idx_titulo ON peliculas (titulo);

-- Ver el plan de consulta (¿usa el índice?)
EXPLAIN QUERY PLAN SELECT * FROM peliculas WHERE titulo = 'Inception';
```

---

## inyección SQL

Un tipo de ataque de seguridad donde un usuario malicioso inserta código SQL dentro de los campos de entrada de una aplicación, con el objetivo de manipular las consultas que se ejecutan en la base de datos. Puede usarse para robar datos, modificarlos, o incluso eliminar tablas enteras.

**Ejemplo vulnerable:**

```python
# PELIGROSO: el usuario puede inyectar SQL malicioso
nombre = input("Nombre: ")
db.execute(f"SELECT * FROM usuarios WHERE nombre = '{nombre}'")
# Si nombre = "'; DROP TABLE usuarios; --", ¡se borra la tabla!
```

**Solución:** usar marcadores de posición (`?`) en lugar de concatenar strings:

```python
# SEGURO: la biblioteca sanitiza el input automáticamente
db.execute("SELECT * FROM usuarios WHERE nombre = ?", nombre)
```

---

## SQLite

Un sistema de gestión de bases de datos relacional **ligero, sin servidor y de código abierto**. A diferencia de MySQL o PostgreSQL, SQLite no requiere un proceso de servidor separado: la base de datos completa se almacena en un único archivo `.db`. Es el motor de base de datos más utilizado en el mundo, presente en smartphones (iOS y Android), browsers, aplicaciones de escritorio y proyectos de aprendizaje como CS50.

**Ventajas:** sin configuración, portable, rápido para proyectos pequeños y medianos.
**Limitaciones:** no está diseñado para múltiples escrituras concurrentes a gran escala; en ese caso se usan MySQL o PostgreSQL.

---

## esquema

La **definición de la estructura** de una base de datos: qué tablas existen, qué columnas tiene cada una, sus tipos de datos y restricciones. El esquema no contiene datos, sino la "forma" que deben tener los datos.

En SQLite puedes ver el esquema de una base de datos con el comando:

```sql
.schema
```

O consultar la tabla interna `sqlite_master`:

```sql
SELECT sql FROM sqlite_master WHERE type = 'table';
```

**Ejemplo de esquema:**

```sql
CREATE TABLE canciones (
    id      INTEGER PRIMARY KEY,
    titulo  TEXT NOT NULL,
    artista TEXT NOT NULL,
    duracion INTEGER,           -- duración en segundos
    popularidad INTEGER CHECK(popularidad BETWEEN 0 AND 100)
);
```
