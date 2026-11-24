---
name: github-actions-ci
description: Diseñar, revisar, ajustar y diagnosticar workflows de GitHub Actions (integración continua) para cualquier proyecto - correr pruebas, construir la imagen Docker, validar que el servicio arranca - con permisos mínimos y fallos que sí fallan. Úsala cuando se pida crear o mejorar un workflow en .github/workflows, entender por qué un run está en rojo, o explicar qué valida y qué no un CI. Encuentro 4 del curso Estud-IA Nube.
---

# Skill: workflow de CI honesto

Objetivo: que el workflow compruebe algo real y que quien lo lea sepa **qué valida, qué no y qué impide que un cambio en rojo avance**.
El agente propone; quien estudia verifica y decide. Nunca presentes un verde como garantía.

## Procedimiento para crear o ajustar

1. **Leer el proyecto (solo lectura)**: lenguaje, cómo se corren las pruebas (`package.json`, `pyproject.toml`, `pom.xml`, `go.mod`, `Makefile`), si hay `Dockerfile` o `compose.yaml`, qué hay en `.github/`. No abras ni muestres `.env` ni archivos de credenciales.
2. **Elegir una cosa que validar**, bien entendida: pruebas de código, construcción de la imagen, o que el servicio arranque sano. Si es ambiguo, **una** pregunta corta. No añadas escaneos hasta que la persona sepa leer su salida.
3. **Partir de la plantilla** de `templates/` (`ci-python.yml`, `ci-node.yml`, `ci-java.yml`, `ci-go.yml`, `ci-image.yml`) y adaptarla. Un archivo por propósito en `.github/workflows/`.
4. **El CI corre el mismo comando que tu portátil.** Si el proyecto tiene `make test`, `npm test` o `./dev ...`, el workflow llama a eso; no reimplementa la lógica en YAML.
5. **Validar antes de subir**: corre el comando de pruebas en local y, si existe, `actionlint`. Informa el resultado real; lo que no se pudo correr, dilo.
6. **Mostrar el diff y esperar confirmación** antes de crear archivos.
7. **Ficha** `docs/ci.md` con el formato de abajo y las etiquetas de `evidence-labels`. Lo que no corrió en GitHub es "solo diseñado" o "comprobado con una muestra (local)".

## Reglas que no se rompen

- **Permisos mínimos** al inicio: `permissions: contents: read`. Más permisos solo en el job que los necesita y con la razón escrita.
- **Un fallo debe fallar**: nada de `|| true`, ni `continue-on-error: true` sobre pruebas, ni scripts que se traguen el código de salida. Con `tee`, `set -o pipefail`.
- **Cero secretos** en el código o impresos en el log. Si el flujo necesita uno: nombra cuál y para qué, y pide a la persona que lo cree en *Settings → Secrets*. **Nunca pidas ni leas credenciales.**
- **No interpolar datos del evento dentro de `run:`** (`github.event.*.title`, `github.head_ref`, cuerpos de PR, inputs). Pásalos por `env:` y usa `"$VAR"`.
- **No usar `pull_request_target`** con checkout del código del PR.
- **Acciones con versión**: oficiales con la versión mayor (`actions/checkout@v4`); de terceros, idealmente fijadas por SHA. Nunca `@main`. Dependabot las mantiene al día.
- **Siempre `timeout-minutes`.** `concurrency` para cancelar runs viejos de la misma rama (en despliegues: `cancel-in-progress: false`).
- **`needs`**: construir o publicar depende de que las pruebas pasen.
- **Evidencia al fallar**: `if: failure()` muestra logs (`docker compose logs`); `if: always()` limpia y sube artefactos de salida.
- **Nombres para humanos** en jobs y pasos: es lo primero que se lee en un run rojo.
- **Caché** de dependencias con la opción `cache:` de las acciones `setup-*`.
- No hagas push, no configures protección de ramas, no crees secretos ni variables. Eso lo hace la persona.

## Diagnosticar un run en rojo

1. `gh run list --limit 5` → id del run que falló.
2. `gh run view <id> --log-failed` → solo los pasos que fallaron.
3. Ubica **el primer error real** (no el último mensaje: suele ser la consecuencia).
4. Clasifícalo: prueba que falla de verdad · dependencia o versión · diferencia entre portátil y CI (ruta, mayúsculas, finales de línea, variable faltante, servicio no levantado) · permisos del token · tiempo agotado.
5. Reprodúcelo en local con el mismo comando del workflow. Si en local pasa, la diferencia de entorno **es** el hallazgo.
6. Propón el arreglo mínimo con la línea de evidencia que lo justifica. No edites sin confirmación.

## Checklist de revisión (la usa `/review-ci`)

En este orden: disparadores (¿corre en `pull_request`?), `permissions`, fallos ocultos (`|| true`, `continue-on-error`, `tee` sin `pipefail`), datos del evento dentro de `run:`, secretos impresos, acciones sin versión o con `@main`, `pull_request_target`, artefactos que suben de más (no `.env`, no carpetas completas), `timeout-minutes`, `concurrency`, `needs`, y qué impide que un cambio en rojo avance (¿hay protección de rama?).

## Formato de la ficha `docs/ci.md`

```
# Qué valida el CI
Disparador: …   Comprobación: <comando>   Permisos: …   Artefactos: …

## Estado real
| Qué | Estado | Evidencia |
|---|---|---|
| <comprobación> | ejecutado / comprobado con una muestra / solo diseñado | id del run o comando |
| Bloqueo de la rama si falla | pendiente / configurado | Settings → Branches |
| Publicación o despliegue | no existe / simulado / configurado | … |

## Qué NO valida todavía
- …
## Qué falta demostrar
- (por ejemplo: que corre solo en cada PR, en una máquina limpia)
```
