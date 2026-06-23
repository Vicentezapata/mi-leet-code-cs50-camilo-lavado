# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**LocalCode** is a self-hosted LeetCode-style platform for learning C and Python through Harvard's CS50 curriculum in Spanish. It features a Monaco code editor, Docker-based sandboxed code execution, Socratic hints, flashcards, and a gamification/stats system.

## Repository Structure

```
backend/   # Go API server (Gin + SQLite + Docker executor)
frontend/  # React + TypeScript + Vite SPA
```

## Commands

### Backend (from `backend/`)

```bash
go run ./cmd/server/main.go   # Start server on :8080
go build ./cmd/server/...     # Build binary
go vet ./...                   # Lint
go test ./...                  # Run tests
```

> **Requires Docker running** — the code executor spins up `gcc:latest` and `python:3.11-alpine` containers.

> **Working directory matters** — the executor uses relative paths (`assets/common/`, `assets/problems/<id>/`) resolved from where the server process starts. Always run from `backend/`.

### Frontend (from `frontend/`)

```bash
npm run dev      # Dev server on :5173 (proxies /api/v1 to backend :8080)
npm run build    # TypeScript check + Vite production build
npm run lint     # ESLint
npm run preview  # Preview production build
```

## Architecture

### Backend — Clean Architecture in Go

The backend follows strict layer separation:

- **`domain/entities.go`** — Pure Go structs: `Problem`, `TestCase`, `Submission`, `Hint`, `Flashcard`, `Progress`, `UserStats`, `Badge`. No dependencies.
- **`application/ports/ports.go`** — Repository and executor interfaces (`ProblemRepository`, `CodeExecutor`, etc.).
- **`application/usecases/`** — One file per use case. Each use case depends only on port interfaces.
- **`infrastructure/sqlite/`** — SQLite implementations of all repository interfaces (uses `modernc.org/sqlite`, pure Go, no CGO).
- **`infrastructure/docker/executor.go`** — `CodeExecutor` implementation: creates an isolated Docker container per submission, copies code + `input.txt` + common assets (`assets/common/`) and per-problem assets (`assets/problems/<problem_id>/`) via tar, runs with 5s timeout and 128MB RAM limit, no network.
- **`infrastructure/http/`** — Gin router + handlers wiring use cases to HTTP.
- **`cmd/server/main.go`** — Composition root: opens DB, runs `schema.sql` + `seed.sql` on every start, wires everything together.

### Database

SQLite file at `backend/localcode.db`. Schema is idempotent (`CREATE TABLE IF NOT EXISTS`). Seed uses `ON CONFLICT(id) DO NOTHING`, so existing data is never overwritten on restart. To reset all data, delete `localcode.db` and restart.

Content for `TheoryPage` is read from markdown files in `backend/content/semana-<N>/` (not from the DB).

### REST API

All routes are under `/api/v1`:

| Method | Path | Description |
|--------|------|-------------|
| GET | `/problems` | List all problems |
| GET | `/problems/:id` | Get single problem |
| GET | `/problems/:id/hints` | Get Socratic hints |
| POST | `/submissions` | Submit code for execution |
| GET | `/submissions` | Get submission history |
| GET | `/weeks/:week/flashcards` | Get flashcards for a week |
| GET | `/stats` | Get user stats (streak, badges) |
| GET | `/content/:week` | Get theory content for a week |
| GET | `/progress` | Get problem completion progress |

### Frontend — React SPA

- **Routing**: `App.tsx` defines three routes: `/` (CatalogPage), `/problems/:id` (ProblemPage), `/weeks/:weekStr` (TheoryPage).
- **Data fetching**: All server state via `@tanstack/react-query`. Custom hooks in `src/hooks/` wrap API calls from `src/api/` (which all hit `/api/v1`).
- **API client**: `src/api/client.ts` — thin `fetch` wrapper. No auth, no interceptors.
- **ProblemPage layout**: Split panel — left (40%) shows problem description + visible test cases + hint button; right (60%) has Monaco editor with Feynman technique textarea, language selector, submit button, and execution console.

### Supported Languages

| Language | Docker image | Execution |
|----------|-------------|-----------|
| `c` | `gcc:latest` | `gcc -O3 *.c -o solution && ./solution < input.txt` |
| `python` | `python:3.11-alpine` | `python code.py < input.txt` |
| `sql` | `keinos/sqlite3:latest` | Schema loaded from `setup.sql`, query from `code.sql` |
| `javascript` | `node:18-alpine` | `node code.js < input.txt` |

Language support is in `infrastructure/docker/executor.go`. The `SubmitCode` handler validates against the same set.

### Content System

Theory content lives in `backend/content/` as markdown files, served by `GET /api/v1/content/:slug`.

- **Numeric slug** (`"1"` … `"10"`) → maps to `content/semana-N/` directory
- **Named slug** (`"ciberseguridad"`) → maps to `content/<slug>/` directory directly

Each directory has three files: `lectura.md`, `complemento.md`, `glosario.md`.

All weeks 0–10 and `ciberseguridad` are populated. The `TheoryPage` at `/weeks/:weekStr` accepts both numeric and named slugs.

The `CatalogPage` has a "Teoría del curso" panel with direct links to all weeks regardless of whether they have problems in the DB.

## Adding Content

- **New problems**: Insert into `db/seed.sql` (`problems`, `test_cases`, `hints`, `flashcards` tables) using `ON CONFLICT(id) DO NOTHING`. IDs are plain text slugs (e.g., `p-mario-c`).
- **Problem-specific assets** (e.g., `.bmp` files): Place in `backend/assets/problems/<problem_id>/` — they are auto-copied into the container.
- **Theory content**: Add/edit markdown files under `backend/content/semana-<N>/` or `backend/content/<slug>/`.
- **New named module** (e.g., a new topic): Create `backend/content/<slug>/` with the three `.md` files and add a link in the `ALL_WEEKS` array in `frontend/src/pages/CatalogPage.tsx`.
