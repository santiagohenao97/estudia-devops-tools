---
name: create-container
description: Crea (propone) Dockerfile, compose.yaml, .dockerignore y .env.example para tu proyecto con la skill `container`, y lo demuestra levantándolo.
---

> Ask for this by name (for example: "use the `create-container` skill"). In Claude Code it is the `/create-container` command.

Aplica la skill `container` a este proyecto. Lo que la persona quiere lograr: what the user asked for

1. Lee el proyecto en solo lectura (no abras `.env`). Resume en 3 líneas: lenguaje, arranque, puerto, si guarda datos, si ya hay Dockerfile o compose.
2. Si falta algo esencial (puerto, comando de arranque, dónde escribe), haz **una** pregunta corta.
3. Si ya existe un Dockerfile o compose, **no lo reescribas**: propón ajustes concretos sobre el existente.
4. Propón los archivos a partir de la plantilla del lenguaje y **muestra el diff antes de crear nada**. Espera confirmación.
5. Con confirmación: créalos, verifica con `git check-ignore .env` que `.env` esté ignorado (si no, propón la línea para `.gitignore`), y demuéstralo:
   - `docker build -t <proyecto>:local .`
   - `docker compose up -d --build --wait`
   - una petición real (`curl -fsS http://localhost:<puerto>/health`)
   - `docker compose down` y `up` otra vez (sin `-v`) para comprobar que los datos siguen.
6. Si algo falla, lee los logs (`docker compose logs --tail 30`), explica la causa con la línea de evidencia y propone el arreglo.
7. Escribe `docs/container.md` con la tabla de estado real.
8. Cierra con 3 preguntas que la persona debe poder responder: dónde vive la configuración, dónde viven los datos y qué comprueba exactamente el chequeo de salud.

No hagas push, no publiques la imagen, no uses `down -v` sin preguntar.
