---
description: Levanta el servicio con Docker Compose, lo comprueba con una petición real y, si falla, diagnostica la causa (solo lectura, propone sin aplicar).
allowed-tools: Read, Glob, Grep, Bash(docker compose up:*), Bash(docker compose ps:*), Bash(docker compose logs:*), Bash(docker ps:*), Bash(docker inspect:*), Bash(curl:*), Bash(git diff:*), Bash(git log:*), Bash(git status:*), Bash(gh run list:*), Bash(gh run view:*)
---

Verifica el servicio en el estado actual del repositorio.

## 1. Levantar y comprobar
- Si el proyecto tiene su propio comando (`./dev`, `make up`, script en `package.json`), úsalo y dilo. Si no, `docker compose up -d --build --wait`.
- Haz una petición real al servicio (`/health` o una operación del dominio) con `curl -fsS`.
- Si todo sale bien, resume en dos líneas qué quedó **ejecutado** y qué sigue **solo diseñado**, y detente.

## 2. Si falló, diagnostica
Decide tú qué mirar y en qué orden. Fuentes permitidas: `docker compose ps`, `docker compose logs --tail 30`, `docker inspect` (solo el estado de salud: `--format '{{json .State.Health}}'`), el código, `git diff`, `git log -5`, y si existe CI: `gh run list --limit 3` y `gh run view <id> --log-failed`.

Reglas:
- **Solo lectura.** No edites archivos, no cambies de rama, no reinicies nada más. Propón, no apliques.
- No corras `docker compose config` ni `docker inspect` completo: pueden imprimir variables de `.env`. No abras `.env`.
- Cada afirmación cita la línea de evidencia que la sostiene. Si falta evidencia, dilo; no inventes.
- Etiqueta cada conclusión: ejecutado, comprobado con una muestra o solo diseñado.

Formato de respuesta:
```
Qué pasó:      <una frase>
Evidencia:     <línea exacta del log o salida>
Causa probable: <una frase>  (etiqueta)
Arreglo propuesto: <cambio mínimo, archivo:línea>
Cómo comprobar el arreglo: <comando>
```
