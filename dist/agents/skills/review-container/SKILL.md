---
name: review-container
description: Revisa Dockerfile, compose.yaml, .dockerignore y .env.example contra la checklist de la skill `container` (solo lectura).
---

> Ask for this by name (for example: "use the `review-container` skill"). In Claude Code it is the `/review-container` command.

Revisa el contenedor del proyecto (what the user asked for; si está vacío, `Dockerfile`, `compose.yaml`, `.dockerignore` y `.env.example` de la raíz). **Solo lectura: no edites nada.** No abras `.env`.

Sigue la checklist de la skill `container`, en su orden. Para cada problema, en este formato exacto:
- **Cita** la línea tal cual (archivo:línea).
- **Problema** en una frase: qué podría pasar.
- **Arreglo** propuesto, o una pregunta si falta contexto.

Comprueba también:
- `git ls-files .env` no debe devolver nada (si devuelve, es **crítico**: el archivo está en el historial y hay que rotar lo que contenga).
- Si `hadolint` existe, córrelo y separa lo que encontró él de lo que encontraste tú.
- Si Docker está disponible, `docker build .` para confirmar que construye. Etiqueta el resultado.

Cierra con: qué garantiza hoy este contenedor, qué no garantiza, y su estado real (ejecutado / solo diseñado). No cites credenciales aunque las veas: di dónde están.
