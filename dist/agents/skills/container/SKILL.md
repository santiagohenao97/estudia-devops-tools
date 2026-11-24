---
name: container
description: Crear, revisar y ajustar el contenedor de un proyecto - Dockerfile, compose.yaml, .dockerignore y .env.example - para cualquier lenguaje (Python, Node, Java, Go u otro). Imagen con versión fija, usuario sin privilegios, chequeo de salud real, configuración fuera de la imagen y datos en volumen. Úsala cuando se pida dockerizar un proyecto, escribir o mejorar un Dockerfile o un compose, o entender por qué un contenedor no arranca. Encuentro 3 del curso Estud-IA Nube.
---

# Skill: contenedor reproducible

Una imagen es una promesa: **cualquier persona puede correr exactamente esto**, en cualquier máquina, con un solo comando.
El agente propone; quien estudia verifica y decide.

## Procedimiento

1. **Leer el proyecto (solo lectura).** Lenguaje y versión, gestor de dependencias, comando de arranque, puerto, si guarda datos (archivo, SQLite, carpeta de subidas), si hay un endpoint de salud. No abras ni muestres `.env` ni archivos de credenciales.
2. **Si algo esencial es ambiguo** (puerto, comando de arranque, dónde escribe), haz **una** pregunta corta antes de escribir.
3. **Partir de la plantilla** de `templates/` que corresponda al lenguaje y adaptarla. Si el lenguaje no está, sigue las mismas reglas.
4. **Proponer el diff** y esperar confirmación antes de crear o cambiar archivos.
5. **Demostrar que funciona**:
   - `docker build -t <proyecto>:local .`
   - `docker compose up -d --build --wait` (espera al chequeo de salud)
   - una petición real al servicio (por ejemplo `curl -fsS http://localhost:<puerto>/health`)
   - recrear el contenedor (`docker compose down` y `up` de nuevo, **sin** `-v`) y comprobar que los datos siguen ahí.
6. **Romperlo una vez a propósito** (puerto ocupado, variable faltante, salud que falla) y leer el error con la persona.
7. **Escribir la ficha** `docs/container.md` con el formato de abajo y etiquetas de la skill `evidence-labels`.

## Reglas que no se rompen

- **Imagen base con versión fija** (`python:3.12-slim`, `node:22-alpine`). Nunca `:latest`.
- **Usuario sin privilegios**: créalo, da permisos solo a la carpeta donde escribe, y `USER`.
- **`HEALTHCHECK` que pruebe algo real**: el endpoint de salud de la app, por convención `GET /health` (en Spring Boot, `/actuator/health`), idealmente uno que toque la base de datos. "El proceso existe" no es salud.
- **Configuración fuera de la imagen**: variables de entorno vía Compose y `.env`. `.env` nunca se sube a git; `.env.example` siempre (con valores falsos o vacíos).
- **Datos persistentes en un volumen con nombre**, montado en una sola ruta (`/data`).
- **`.dockerignore`** excluye `.git`, `.env`, dependencias locales (`node_modules`, `.venv`, `target`), pruebas y documentos que la imagen no necesita.
- **Capas en buen orden**: primero el archivo de dependencias, instalar, y después copiar el código (la caché se reutiliza).
- **Multi-etapa** cuando hay compilación (Java, Go, frontend): la imagen final no lleva compiladores.
- **Identifica la imagen**: `ARG APP_VERSION` → `ENV` y etiqueta OCI, para que la app y `docker inspect` digan la misma versión.
- **Un solo comando** para levantar todo (`docker compose up`), el mismo en tu portátil y en el CI.
- **Puertos**: escucha en `0.0.0.0` dentro del contenedor. Publica solo el puerto que se necesita.
- Nada de secretos en `ENV`, `ARG` ni `COPY .env`.

## Errores comunes y qué significan

| Síntoma | Causa típica |
|---|---|
| `connection refused` desde fuera, pero la app dice "listening" | La app escucha en `127.0.0.1`, no en `0.0.0.0`. |
| `permission denied` al escribir | `USER` sin permisos sobre la carpeta; falta el `chown` de `/data`. |
| `port is already allocated` | Otro proceso o contenedor usa ese puerto del host; cambia `PORT` en `.env`. |
| Contenedor `unhealthy` | El chequeo apunta a una ruta o puerto equivocado, o la imagen no tiene la herramienta que usa (curl). |
| Los datos desaparecen al recrear | No hay volumen, o se usó `docker compose down -v`. |
| Funciona en Mac/Linux y no en Windows | Finales de línea CRLF en scripts `.sh`; añade `.gitattributes` con `*.sh text eol=lf`. |
| Build lento en cada cambio | Se copia todo el código antes de instalar dependencias. |

## Checklist de revisión (la usa `review-container`)

1. Base con versión fija y adecuada (slim/alpine/distroless).
2. Orden de capas y caché de dependencias.
3. Multi-etapa si compila.
4. Usuario sin privilegios.
5. `HEALTHCHECK` real y la herramienta que usa existe en la imagen.
6. Configuración por entorno; `.env` ignorado; `.env.example` presente y sin secretos.
7. Volumen con nombre para datos.
8. `.dockerignore` completo.
9. Puerto y escucha en `0.0.0.0`.
10. Secretos en `ENV`/`ARG`/`COPY`, o impresos en logs.
11. Compose: `depends_on` con `condition: service_healthy` si hay varios servicios; nada de `privileged`.

## Formato de la ficha `docs/container.md`

```
# Contenedor
Imagen base: …   Usuario: …   Puerto: …   Salud: /health   Datos: <volumen> en <ruta>
Levantar: docker compose up -d --build --wait

## Estado real
| Qué | Estado | Evidencia |
|---|---|---|
| La imagen construye | ejecutado / solo diseñado | comando |
| El servicio queda healthy | … | docker compose ps |
| Los datos sobreviven a recrear el contenedor | … | … |

## Qué NO valida todavía
- …
```

Plantillas: `templates/Dockerfile.python`, `Dockerfile.node`, `Dockerfile.java`, `Dockerfile.go`, `compose.yaml`, `dockerignore`, `env.example`.
