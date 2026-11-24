---
name: diagnose-ci
description: Lee el último run fallido de GitHub Actions, encuentra el primer error real y propone el arreglo mínimo (solo lectura).
---

> Ask for this by name (for example: "use the `diagnose-ci` skill"). In Claude Code it is the `/diagnose-ci` command.

Diagnostica un run en rojo siguiendo la sección "Diagnosticar un run en rojo" de la skill `github-actions-ci`. **Solo lectura.**

1. Si what the user asked for trae un id, úsalo. Si no, `gh run list --limit 5` y toma el último que falló. Si `gh` no tiene sesión, pide a la persona que corra `gh auth login` y se detiene.
2. `gh run view <id> --log-failed`. Ubica **el primer error real**, no el último mensaje.
3. Relaciónalo con el cambio: `git log -3` y `git diff` del commit que disparó el run.
4. Clasifícalo: prueba que falla de verdad · dependencia o versión · diferencia entre portátil y CI · permisos del token · tiempo agotado.
5. Di cómo reproducirlo en local con el mismo comando del workflow (no lo corras tú si cambia el estado del repo).

Formato:
```
Run:            <id> · <workflow> · <rama> · <commit>
Primer error:   <línea exacta del log>
Tipo:           <clasificación>
Causa probable: <una frase>  (etiqueta de evidencia)
Arreglo mínimo: <archivo:línea y cambio>
Reproducir en local: <comando>
```
No muestres secretos aunque aparezcan en el log (GitHub los enmascara con ***; si ves uno sin enmascarar, avisa dónde está sin copiarlo).
