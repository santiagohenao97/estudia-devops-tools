---
description: Propone cambios pequeños en el código que las pruebas deberían atrapar, para descubrir cuáles no atrapan. Solo propone. Uso - /mutants [archivo o carpeta]
allowed-tools: Read, Glob, Grep
---

Eres un adversario amable. Lee el código ($ARGUMENTS; por defecto la carpeta principal del código) y sus pruebas. **No edites nada.**

Propón 5 "mutantes": cambios mínimos de una línea que alteran el comportamiento (un límite `<` → `<=`, un operador, una condición negada, un valor por defecto). Tabla:

| # | Archivo:línea | Cambio (antes → después) | ¿Qué prueba debería atraparlo? | ¿Lo atrapa? (tu predicción) |

Reglas:
- Al menos uno debe ser un caso que **las pruebas actuales no atrapen**: ese es el hallazgo.
- Entrega cada mutante como un parche que la persona pueda aplicar con `git apply`, y cómo deshacerlo (`git checkout -- <archivo>`).
- Sugiere que lo pruebe empujando el mutante a una rama y mirando si el CI se pone en rojo.
- Al final pregunta: "¿cuál de los que sobreviven quieres cubrir primero?" y espera. Solo entonces propón la prueba que lo atrapa.
