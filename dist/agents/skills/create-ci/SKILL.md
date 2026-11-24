---
name: create-ci
description: Crea (propone) un workflow de GitHub Actions para tu proyecto con la skill `github-actions-ci`.
---

> Ask for this by name (for example: "use the `create-ci` skill"). In Claude Code it is the `/create-ci` command.

Aplica la skill `github-actions-ci` a este repositorio. Lo que la persona quiere validar: what the user asked for

1. Lee el proyecto en solo lectura (no abras `.env`). Resume en 3 líneas: lenguaje, cómo se corren las pruebas, si hay Dockerfile/compose, qué workflows existen.
2. Si lo que quiere validar es ambiguo, haz **una** pregunta corta antes de escribir nada.
3. Si ya hay un workflow que hace algo parecido, **propón ajustarlo** en vez de crear otro.
4. Propón el workflow a partir de la plantilla del lenguaje (y `ci-image.yml` si quiere validar el contenedor) y **muestra el diff antes de crear nada**. Espera confirmación.
5. Con confirmación: crea el workflow, corre **el mismo comando de pruebas en local** y `actionlint` si existe. Reporta lo que realmente salió.
6. Escribe `docs/ci.md` con la tabla de estado real. Lo que no se ejecutó en GitHub va como "solo diseñado".
7. Dile a la persona los pasos que le tocan a ella: `git add`, `git commit`, `git push`, mirar el run en la pestaña Actions (o `gh run watch`), y si quiere, activar la protección de la rama en Settings → Branches.
8. Cierra con 3 preguntas: qué lo dispara, qué prueba protege el cambio y qué impide hoy que una versión en rojo avance.

No hagas push, no toques secretos ni la configuración del repositorio.
