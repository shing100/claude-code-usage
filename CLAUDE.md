# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a demonstration repository containing two main Claude Code configuration examples:

### claude-code-agents-1/
- Contains Claude Code settings with specialized agents
- Includes custom hooks for formatting and Python code review
- Pre/post-tool-use hooks for maintaining code quality

### claude-code-default/
- Contains a comprehensive TDD/Python development setup
- Includes detailed backend (FastAPI/Vertex AI) and frontend (React/TypeScript) technical specifications
- Uses uv for Python package management
- Follows Kent Beck's TDD methodology

## Development Commands

### Python Projects (using uv)
```bash
# Package management
uv add <package>           # Install dependencies
uv remove <package>        # Remove dependencies  
uv sync                    # Sync dependencies

# Running code
uv run <script>.py         # Run Python script
uv run pytest             # Run tests
uv run python             # Launch Python REPL

# Development workflow
make format                # Format code (uvx ruff format)
make check                 # Check code quality (ruff, typer, pyrefly)
make test                  # Run tests (uv run pytest -v)
make run                   # Start server (uvicorn)
make migrate               # Run database migrations (alembic)
```

### TDD Workflow
- Always follow Red → Green → Refactor cycle
- Write failing test first, implement minimum code to pass
- Make structural changes separately from behavioral changes
- Only commit when all tests pass and linter warnings resolved
- Use `make format && make check` before commits

## Hook Configuration

Both configurations include automated hooks:
- **Pre-tool-use**: Prevents modifications when `make check` is failing
- **Post-tool-use**: Automatically runs formatting and code review after file changes
- Hooks run format-and-check.sh and review-python.sh scripts

## Code Quality Standards

- Use uv exclusively for Python package management (never pip/poetry)
- Follow TDD principles with clear test names describing behavior
- Separate structural changes from behavioral changes
- Maintain high code quality with automated formatting and linting
- Run full test suite frequently during development

## Architecture Notes

### Backend (FastAPI + Vertex AI)
- Async-first design with FastAPI
- Google Cloud integration (Vertex AI, Speech-to-Text, Cloud Storage)
- PostgreSQL with SQLAlchemy 2.0+ async
- JWT authentication with refresh tokens
- Vector search for RAG functionality

### Frontend (React + TypeScript)
- Vite build system with TypeScript
- Zustand for state management
- shadcn/ui components with Tailwind CSS
- Audio recording with real-time transcription
- PWA capabilities for offline usage