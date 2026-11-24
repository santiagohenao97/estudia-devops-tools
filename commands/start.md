---
description: Mira tu proyecto (solo lectura) y te dice qué piezas de la cadena de entrega ya tiene, cuáles faltan y cuál es el siguiente paso según el encuentro del curso.
allowed-tools: Read, Glob, Grep, Bash(git --version:*), Bash(docker info:*), Bash(git status:*), Bash(git log:*), Bash(git remote:*), Bash(ls:*), Bash(docker --version:*), Bash(docker compose version:*), Bash(gh --version:*), Bash(gh auth status:*), Bash(actionlint --version:*)
---

Haz un diagnóstico **de solo lectura** del proyecto en la carpeta actual. No edites nada. No abras `.env`.

## 1. Qué es el proyecto
En 3 líneas: lenguaje y versión, cómo se arranca, cómo se corren las pruebas (si las hay), y si guarda datos.

## 2. Qué herramientas tienes
Comprueba si están instaladas: `git`, `docker` y `docker compose`, `gh` (y si tiene sesión), `actionlint`. Para lo que falte, da el enlace de instalación oficial para el sistema operativo de la persona.

## 3. Mapa de piezas
| Pieza | Encuentro | ¿Existe? | Estado |
|---|---|---|---|
| README con alcance y pruebas de aceptación | E2 | | |
| Pruebas automatizadas | E2 | | |
| Dockerfile | E3 | | |
| compose.yaml con healthcheck y volumen | E3 | | |
| .dockerignore y .env.example (y .env ignorado en git) | E3 | | |
| Workflow de CI en .github/workflows | E4 | | |
| docs/container.md y docs/ci.md con estado real | E3 · E4 | | |

En "Estado" usa: no existe · existe sin probar · ejecutado (solo si ves evidencia).

## 4. Siguiente paso
Recomienda **una** cosa, la del encuentro más temprano que esté incompleta, y el comando del plugin que ayuda: `/create-container`, `/verify`, `/create-ci`, `/review-container`, `/review-ci`.
Si ves un riesgo serio (por ejemplo `.env` versionado en git), dilo primero.
