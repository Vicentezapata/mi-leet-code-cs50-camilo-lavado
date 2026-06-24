# RESTful API Contracts

Todos los endpoints están bajo `/api/v1`. No hay autenticación.

---

## Problemas

### GET /api/v1/problems

Lista todos los problemas. Acepta query params opcionales `?week=N` y `?difficulty=Easy|Medium|Hard`.

```json
{
  "data": [
    {
      "id": "p-mario-c",
      "title": "Mario",
      "difficulty": "Easy",
      "language": "c",
      "week": 1
    }
  ]
}
```

### GET /api/v1/problems/:id

Devuelve un problema con sus casos de prueba visibles.

```json
{
  "data": {
    "id": "p-mario-c",
    "title": "Mario",
    "description": "...",
    "language": "c",
    "week": 1,
    "difficulty": "Easy",
    "test_cases": [
      {
        "id": "tc-mario-c-1",
        "input_data": "4",
        "expected_output": "   #\n  ##\n ###\n####\n",
        "is_hidden": false
      }
    ]
  }
}
```

### GET /api/v1/problems/:id/hints

Devuelve las pistas socráticas del problema (lista ordenada de preguntas guía).

```json
{
  "data": [
    { "id": "h-mario-c-1", "question": "¿Cuántas filas necesitas imprimir en total?" },
    { "id": "h-mario-c-2", "question": "En cada fila i, ¿cuántos espacios van antes del primer #?" }
  ]
}
```

### GET /api/v1/problems/:id/solution

Devuelve la solución de referencia del problema. Solo debe llamarse después de que el usuario haya agotado todas las pistas (el frontend lo controla).

```json
{
  "data": {
    "problem_id": "p-mario-c",
    "language": "c",
    "code": "#include <stdio.h>\nint main(void)\n{\n    int h;\n    do { scanf(\"%d\", &h); } while (h < 1 || h > 8);\n    for (int i = 1; i <= h; i++) {\n        for (int j = 0; j < h - i; j++) printf(\" \");\n        for (int k = 0; k < i; k++)     printf(\"#\");\n        printf(\"\\n\");\n    }\n}"
  }
}
```

Devuelve `404` con `{"error": "solution not found"}` si el problema no tiene solución registrada.

---

## Envíos

### POST /api/v1/submissions

Ejecuta el código contra todos los casos de prueba del problema.

**Request:**
```json
{
  "problem_id": "p-mario-c",
  "language": "c",
  "code": "#include <stdio.h>\n..."
}
```

**Response:**
```json
{
  "data": {
    "id": "sub-abc123",
    "problem_id": "p-mario-c",
    "status": "Accepted",
    "passed_tests": 3,
    "total_tests": 3,
    "submitted_at": "2026-06-24T10:00:00Z"
  }
}
```

Estados posibles: `Accepted`, `Wrong Answer`, `Compilation Error`, `Runtime Error`, `Time Limit Exceeded`.

### GET /api/v1/submissions?problem_id=:id

Historial de envíos. Si se omite `problem_id`, devuelve todos.

```json
{
  "data": [
    {
      "id": "sub-abc123",
      "problem_id": "p-mario-c",
      "status": "Accepted",
      "passed_tests": 3,
      "total_tests": 3,
      "submitted_at": "2026-06-24T10:00:00Z"
    }
  ]
}
```

---

## Contenido

### GET /api/v1/weeks/:week/flashcards

Flashcards de una semana. `:week` es un número (0–10 para semanas, 11 para Ciberseguridad).

```json
{
  "data": [
    {
      "id": "fc-1-1",
      "question": "¿Qué es un compilador?",
      "answer": "Un programa que traduce código fuente a código máquina."
    }
  ]
}
```

### GET /api/v1/content/:week

Contenido teórico en Markdown. `:week` acepta número (`"1"`) o slug (`"ciberseguridad"`).

```json
{
  "data": {
    "lectura": "## Semana 1\n...",
    "complemento": "## Material adicional\n...",
    "glosario": "## Glosario\n..."
  }
}
```

---

## Stats y progreso

### GET /api/v1/stats

Estadísticas del usuario: racha, total resueltos, medallas.

```json
{
  "data": {
    "streak": 3,
    "total_solved": 7,
    "badges": ["week-1-complete", "week-2-complete"]
  }
}
```

### GET /api/v1/progress

Estado de cada problema (resuelto / intentado / sin intentar).

```json
{
  "data": [
    {
      "problem_id": "p-mario-c",
      "status": "solved",
      "last_attempt_at": "2026-06-24T10:00:00Z"
    }
  ],
  "summary": {
    "total": 22,
    "solved": 7,
    "in_progress": 2,
    "not_attempted": 13
  }
}
```

---

## Lenguajes soportados

| Valor en API | Imagen Docker | Comando de ejecución |
|---|---|---|
| `c` | `gcc:latest` | `gcc -O3 *.c -o solution && ./solution < input.txt` |
| `python` | `python:3.11-alpine` | `python code.py < input.txt` |
| `sql` | `keinos/sqlite3:latest` | `sqlite3 db.sqlite < setup.sql && sqlite3 -separator '\|' db.sqlite < code.sql` |
| `javascript` | `node:18-alpine` | `node code.js < input.txt` |

Cada envío corre en un contenedor aislado con 5s de timeout y 128MB de RAM máximos. Sin acceso a red.
