# Execution Engine Adapter Specification

### 1. Responsibility
The DockerExecutor fulfills the CodeExecutor port. It takes a CodeSnippet and a TestCase, runs it in an isolated Docker container via the Docker SDK for Go, and returns an ExecutionResult.

### 2. Execution Flow
1. Receive code string and language target.
2. Write code + `input.txt` + common assets (`assets/common/`) + problem-specific assets (`assets/problems/<id>/`) into a tar archive.
3. Create an ephemeral Docker container from the language image.
4. Copy the tar archive into `/workspace` inside the container.
5. Execute the compile/run command.
6. Wait for completion (5 second hard timeout via `context.WithTimeout`).
7. Capture stdout, stderr, and exit code from container logs.
8. Destroy the container (`defer ContainerRemove`).

### 3. Container Constraints (Security limits via Docker SDK)
- `NetworkDisabled: true` — sin acceso a red
- `Memory: 128MB`
- `Timeout: 5s` — via `context.WithTimeout`
- `AutoRemove: false` — limpieza manual con `defer ContainerRemove(Force: true)`

### 4. Environments

#### C Environment
- **Image:** `gcc:latest`
- **File:** `code.c`
- **Command:** `sh -c "gcc -O3 -I/workspace *.c -o solution && ./solution < input.txt"`
- **Nota:** `-I/workspace` permite `#include <cs50.h>` cuando `cs50.h` y `cs50.c` están en `assets/common/`

#### Python Environment
- **Image:** `python:3.11-alpine`
- **File:** `code.py`
- **Command:** `sh -c "python code.py < input.txt"`

#### SQL Environment
- **Image:** `keinos/sqlite3:latest`
- **File:** `code.sql`
- **Command:** `sh -c "sqlite3 /workspace/db.sqlite < /workspace/setup.sql && sqlite3 -separator '|' /workspace/db.sqlite < /workspace/code.sql < input.txt"`
- **Assets requeridos:** `setup.sql` en `assets/problems/<problem_id>/`

#### JavaScript Environment
- **Image:** `node:18-alpine`
- **File:** `code.js`
- **Command:** `sh -c "node code.js < input.txt"`

---

### 5. Normalización de datos de test

Los `input_data` y `expected_output` en SQLite se almacenan con `\n` literal (backslash-n) porque SQL no interpreta secuencias de escape en strings. El use case `SubmitCodeUseCase` normaliza ambos campos antes de usarlos:

```go
// submit_code.go
tc.InputData = strings.ReplaceAll(tc.InputData, "\\n", "\n")           // antes de ejecutar
expectedNormalized := strings.ReplaceAll(tc.ExpectedOutput, "\\n", "\n") // antes de comparar
```

Sin esta normalización, `int(input())` en Python recibe `"42\n"` literal y lanza `ValueError`.

---

### 6. Subtareas pendientes

#### Robustez
- [ ] Verificar que contenedores huérfanos se limpian (test: matar proceso Go mientras corre un container)
- [ ] Agregar límite de tamaño de código (max 100KB) para evitar ataques de compresión
- [ ] Agregar stderr en el resultado del executor para feedback al usuario

#### Métricas
- [ ] Leer memoria real usada por el contenedor (no solo el límite), exponerla en `ExecutionMetrics`

#### Testing
- [ ] Test: código C que compila pero hace `while(1)` → debe terminar por timeout
- [ ] Test: código Python que intenta `import os; os.system('rm -rf /')` → debe fallar por seguridad
- [ ] Test: 5 submissions concurrentes → todas deben completar sin deadlock