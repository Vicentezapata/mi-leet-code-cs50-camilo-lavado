# LocalCode — CS50 en Español

> La primera plataforma self-hosted que traslada el curso completo de Harvard CS50 al español. Diseñada para que cualquier hispanohablante pueda aprender ciencias de la computación sin necesitar inglés.

---

## ¿Qué es esto?

**LocalCode** es una plataforma de aprendizaje interactiva que cubre las 12 semanas del curso **CS50 2026 de Harvard**, con:

- 📖 Contenido completo en español (transcripción + material complementario propio)
- 💻 Editor de código integrado (Monaco Editor)
- ⚙️ Motor de ejecución seguro vía Docker (C, Python, SQL, JavaScript)
- ✅ Evaluación automática de soluciones contra casos de prueba
- 💡 Pistas socráticas progresivas y soluciones de referencia desbloqueables
- 🃏 Flashcards por semana (repaso activo)
- 📊 Seguimiento de progreso con rachas y medallas

---

## Contenido del curso

| Semana | Tema | Lenguaje | Problemas |
|--------|------|----------|-----------|
| 0 | Scratch — Pensamiento computacional | Visual | — |
| 1 | C — Fundamentos | C | 4 |
| 2 | Arreglos | C | 4 |
| 3 | Algoritmos | C | 1 |
| 4 | Memoria | C | 1 |
| 5 | Estructuras de Datos | C | 1 |
| 6 | Python | Python | 2 |
| 7 | SQL | SQL | 3 |
| 8 | HTML, CSS, JavaScript | JavaScript | 3 |
| 9 | Flask | Python | 3 |
| 10 | Emoji y Unicode | — | — |
| — | Ciberseguridad | — | — |

**Total: 22 problemas** con casos de prueba visibles y ocultos.

---

## Cómo ejecutarlo — Docker Compose (recomendado)

Esta es la forma más sencilla. Solo necesitas **Docker Desktop** instalado.

### Requisito único

| Herramienta | Para qué sirve | Descarga |
|-------------|----------------|----------|
| **Docker Desktop** | Corre toda la plataforma y ejecuta tu código de forma segura | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |

> **¿Qué es Docker Desktop?** Es una aplicación que crea "cajas" aisladas (contenedores) donde corre tu código sin tocar el resto de tu sistema. En Windows, si el instalador pide activar WSL 2, acepta — es necesario. Una vez instalado, la ballena 🐳 en tu barra de tareas indica que está listo.

### Instalación en 3 comandos

```bash
git clone https://github.com/camilo-lavado/mi-leet-code-cs50.git
cd mi-leet-code-cs50
docker compose up
```

La primera vez tarda 3-5 minutos en descargar e construir las imágenes. Cuando veas:

```
frontend-1  | [notice] start worker process
```

Abre **http://localhost:5173** en tu navegador.

### Comandos útiles

```bash
docker compose up -d      # correr en segundo plano
docker compose down       # detener
docker compose logs -f    # ver logs en tiempo real
```

> Los datos (progreso, historial de envíos) se guardan en un volumen Docker persistente. Se mantienen entre reinicios. Para resetear todo: `docker compose down -v`.

---

## Cómo ejecutarlo — Forma manual (desarrollo)

Para contribuir o modificar el código fuente.

### Requisitos

| Herramienta | Descarga |
|-------------|----------|
| **Docker Desktop** | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| **Go 1.22+** | [go.dev/dl](https://go.dev/dl/) |
| **Node.js 20+** | [nodejs.org](https://nodejs.org/) |

### Pasos

**1. Clonar**
```bash
git clone https://github.com/camilo-lavado/mi-leet-code-cs50.git
cd mi-leet-code-cs50
```

**2. Backend** (una terminal)
```bash
cd backend
go run ./cmd/server/main.go
```
Listo cuando aparece `[GIN-debug] Listening on :8080`.

**3. Frontend** (otra terminal)
```bash
cd frontend
npm install       # solo la primera vez
npm run dev
```
Abre **http://localhost:5173** cuando aparezca `Local: http://localhost:5173`.

### Descarga de imágenes Docker (solo la primera vez)

La primera ejecución de cada lenguaje descarga la imagen correspondiente:

| Lenguaje | Imagen Docker | Tamaño aprox. |
|----------|--------------|---------------|
| C | `gcc:latest` | ~1.2 GB |
| Python | `python:3.11-alpine` | ~50 MB |
| SQL | `keinos/sqlite3:latest` | ~15 MB |
| JavaScript | `node:18-alpine` | ~180 MB |

---

## Solución de problemas comunes

| Problema | Causa probable | Solución |
|----------|----------------|----------|
| `Cannot connect to Docker daemon` | Docker Desktop no está abierto | Abre Docker Desktop y espera a que la ballena deje de moverse |
| La página carga pero los problemas no aparecen | El backend no está corriendo | Verifica que el backend muestra `:8080` o usa Docker Compose |
| Error al ejecutar código en Windows | WSL 2 no activado | Docker Desktop → Settings → General → activa "Use WSL 2 based engine" |
| `go: command not found` | Go no en el PATH | Reinstala Go y reinicia la terminal |
| `npm: command not found` | Node.js no instalado | Instala desde nodejs.org |

---

## Características

| Característica | Descripción |
|----------------|-------------|
| **Pistas socráticas** | Sugerencias reflexivas paso a paso. Cuando agotes todas, se desbloquea la solución de referencia. |
| **Soluciones de referencia** | Código de ejemplo visible solo tras revelar todas las pistas. No hay atajos. |
| **Flashcards** | Tarjetas interactivas por semana para repaso activo de conceptos teóricos. |
| **Diario Feynman** | Espacio para explicar la lógica en tus propias palabras antes de enviar. |
| **Teoría completa** | Transcripciones de clases, material complementario y glosario para cada semana. |
| **Gamificación** | Rachas diarias 🔥 y medallas por completar semanas. |
| **4 lenguajes** | C, Python, SQL y JavaScript ejecutados en contenedores aislados. |

---

## Stack técnico

- **Frontend:** React 18 + Vite + TypeScript + Monaco Editor + TanStack Query
- **Backend:** Go (Gin) — Arquitectura Hexagonal + Clean Architecture
- **Base de datos:** SQLite (`modernc.org/sqlite` — sin CGO)
- **Ejecución de código:** Docker Engine API (contenedor por envío, 5s timeout, 128MB RAM)
- **Deploy:** Docker Compose con nginx como reverse proxy

---

## Documentación técnica

| Archivo | Descripción |
|---------|-------------|
| [CLAUDE.md](./CLAUDE.md) | Guía de desarrollo para Claude Code |
| [01_PRD.md](./01_PRD.md) | Requerimientos del producto |
| [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) | Arquitectura del sistema |
| [03_DOMAIN_MODEL.md](./03_DOMAIN_MODEL.md) | Modelo de dominio y esquema SQLite |
| [04_EXECUTION_ENGINE.md](./04_EXECUTION_ENGINE.md) | Motor de ejecución Docker |
| [05_API_SPECIFICATION.md](./05_API_SPECIFICATION.md) | Contratos REST API |
| [06_CONTENT_STRATEGY.md](./06_CONTENT_STRATEGY.md) | Estrategia de contenido en español |
| [07_ROADMAP.md](./07_ROADMAP.md) | Plan de desarrollo por fases |

---

## Estado actual

🟢 **Plataforma completa** — 22 problemas activos en C, Python, SQL y JavaScript. Contenido teórico para las 12 semanas (0–10 + Ciberseguridad). Docker Compose listo para instalación con un solo comando. Soluciones de referencia desbloqueables tras agotar pistas socráticas.

---

## Misión

> *"Si yo logro aprender CS50 completamente en español a través de esta plataforma, habrá cumplido su misión."*

Este proyecto nació como experimento personal. Si funciona, es un aporte para todos los hispanohablantes que quieren aprender a programar con el mejor curso gratuito del mundo.
