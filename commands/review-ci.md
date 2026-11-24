---
description: Revisa uno o todos los workflows de .github/workflows contra la checklist de la skill github-actions-ci (solo lectura). Uso - /review-ci [ruta]
allowed-tools: Read, Glob, Grep, Bash(actionlint:*), Bash(gh run list:*)
---

Revisa el workflow indicado ($ARGUMENTS; si está vacío, todos los de `.github/workflows/`). **Solo lectura: no edites nada.**

Sigue la checklist de la skill `github-actions-ci`, en su orden. Para cada problema, en este formato exacto:
- **Cita** la línea tal cual (archivo:línea).
- **Problema** en una frase: qué podría pasar.
- **Arreglo** propuesto, o una pregunta si falta contexto.

Si `actionlint` existe, córrelo y separa lo que encontró él de lo que encontraste tú.
Si `gh` tiene sesión, `gh run list --limit 5` para saber si el workflow ha corrido de verdad.

Cierra con: qué valida este workflow, qué no valida, y su estado real (ejecutado en GitHub / solo diseñado / no existe). No cites credenciales aunque las veas: di dónde están.
