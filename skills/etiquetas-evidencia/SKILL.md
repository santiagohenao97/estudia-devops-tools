---
name: etiquetas-evidencia
description: Reportar con honestidad qué se verificó de verdad. Cada afirmación sobre un contenedor, un workflow de CI o un despliegue lleva una etiqueta - ejecutado, comprobado con una muestra o solo diseñado - y el comando que la sostiene. Úsala al escribir README, docs/, fichas de contenedor o de CI, y al cerrar cualquier reporte de trabajo DevOps.
---

# Etiquetas de evidencia

Un verde no es una garantía. Quien lee tu reporte debe saber **qué corrió de verdad, dónde y con qué comando**.

## Las tres etiquetas

| Etiqueta | Significa | Ejemplo |
|---|---|---|
| **ejecutado** | Lo corriste completo en el entorno que importa y viste la salida. | `docker compose up --wait` terminó bien y `/salud` respondió 200. |
| **comprobado con una muestra** | Corrió, pero en un caso parcial o en un entorno equivalente, no el real. | Las pruebas pasaron en tu portátil; el workflow aún no ha corrido en GitHub. |
| **solo diseñado** | Está escrito pero nadie lo ha corrido. | El job de publicar la imagen existe en el YAML; nunca se disparó. |

## Reglas

- Cada afirmación lleva **etiqueta + comando o enlace** que la prueba (`docker compose ps`, el id del run de Actions, la línea del log).
- Si no tienes evidencia, la etiqueta es **solo diseñado**. No la subas por optimismo.
- "Equivalencia local" no es "ejecutado en CI": dilo así.
- Di también **qué no se validó**. Un límite escrito vale más que un verde callado.
- Nunca pegues secretos como evidencia. Si un log los contiene, di dónde están, no los copies.

## Formato corto para cerrar un reporte

```
| Qué | Estado | Evidencia |
|---|---|---|
| La imagen construye | ejecutado | docker build . (salida local, 18:42) |
| Las pruebas corren en CI | solo diseñado | .github/workflows/ci.yml, sin runs todavía |

No validado todavía: <lista corta>
```
