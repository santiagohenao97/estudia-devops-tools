# estudia-devops-tools

Agentes, skills y comandos de **Claude Code** del curso [Estud-IA Nube · Intermedio](https://santiagohenao97.github.io/estudia-nube/) para que crees, revises y ajustes la cadena de entrega de **tu propio proyecto**: contenedor (Docker y Compose) e integración continua (GitHub Actions).

Funcionan con cualquier lenguaje (Python, Node, Java, Go u otro) y en macOS, Linux o Windows. Cada encuentro del curso agrega herramientas nuevas.

> El agente propone; tú verificas y decides. Ninguna herramienta hace push, publica imágenes ni toca secretos por ti.

## Instalar

Necesitas [Claude Code](https://docs.claude.com/en/docs/claude-code/overview). Para usar las herramientas también: [Git](https://git-scm.com/downloads), [Docker Desktop](https://docs.docker.com/get-docker/) (trae Compose) y, para los comandos de CI, [GitHub CLI](https://cli.github.com/) con `gh auth login`.

### Opción A · Plugin (recomendada)

Dentro de Claude Code, en cualquier carpeta:

```
/plugin marketplace add santiagohenao97/estudia-devops-tools
/plugin install estudia-nube@estudia
```

Queda disponible en todos tus proyectos. Para recibir lo nuevo de cada encuentro:

```
/plugin marketplace update estudia
```

### Opción B · Copiar al proyecto

Las herramientas quedan dentro de `.claude/` de tu repositorio y todo tu equipo las tiene al clonar.

```bash
git clone https://github.com/santiagohenao97/estudia-devops-tools.git
./estudia-devops-tools/instalar.sh ~/ruta/a/mi-proyecto            # macOS, Linux, WSL, Git Bash
```

```powershell
git clone https://github.com/santiagohenao97/estudia-devops-tools.git
powershell -ExecutionPolicy Bypass -File .\estudia-devops-tools\instalar.ps1 C:\ruta\a\mi-proyecto
```

Para actualizar: `git pull` en `estudia-devops-tools` y vuelve a correr el instalador.

## Empieza aquí

Abre Claude Code en la carpeta de tu proyecto y escribe:

```
/empezar
```

Revisa tu proyecto (solo lectura), te muestra qué piezas tiene y cuáles faltan, y te dice el siguiente paso.

## Herramientas por encuentro

| Encuentro | Qué cubre | Comandos | Skill |
|---|---|---|---|
| Todos | Ver dónde está tu proyecto | `/empezar` | `etiquetas-evidencia` |
| **E3** · Contenedor, configuración y entorno reproducible | Dockerfile, compose.yaml, .dockerignore, .env.example | `/crear-contenedor` · `/revisar-contenedor` · `/verificar` | `contenedor` |
| **E4** · Integración continua y validación de cambios | Workflows de GitHub Actions, runs en rojo, pruebas que no atrapan errores | `/crear-ci` · `/revisar-ci` · `/diagnosticar-ci` · `/mutante` | `ci-github-actions` |
| E5 en adelante | Próximamente | | |

Si instalaste como plugin y otro plugin usa el mismo nombre de comando, escríbelo con prefijo: `/estudia-nube:crear-ci`.

### Comandos

| Comando | Qué hace | ¿Cambia archivos? |
|---|---|---|
| `/empezar` | Diagnóstico del proyecto y siguiente paso | No |
| `/crear-contenedor [objetivo]` | Propone Dockerfile, compose, .dockerignore y .env.example; los levanta y lo demuestra | Sí, tras mostrarte el diff |
| `/revisar-contenedor [ruta]` | Revisa el contenedor contra la checklist | No |
| `/verificar` | Levanta el servicio, hace una petición real y, si falla, diagnostica | No (solo levanta contenedores) |
| `/crear-ci <qué validar>` | Propone un workflow de GitHub Actions y la ficha `docs/ci.md` | Sí, tras mostrarte el diff |
| `/revisar-ci [ruta]` | Revisa workflows: permisos, fallos ocultos, inyección, versiones | No |
| `/diagnosticar-ci [id]` | Lee el último run en rojo y encuentra el primer error real | No |
| `/mutante [archivo]` | Propone cambios pequeños para ver qué errores no atrapan tus pruebas | No |

### Agentes

| Agente | Para qué |
|---|---|
| `ingeniero-devops` | Construir y probar una pieza completa paso a paso, explicando cada decisión. Pídelo así: *"usa el agente ingeniero-devops para dockerizar mi API"*. |
| `revisor-entrega` | Revisión de solo lectura con puntaje 0-100 antes de entregar un ejercicio o abrir un pull request. |

### Skills

Se activan solas cuando trabajas en esos archivos, aunque no uses un comando.

| Skill | Se activa cuando… | Plantillas |
|---|---|---|
| `contenedor` | Escribes o arreglas un Dockerfile o compose | Python, Node, Java (Maven), Go, compose, .dockerignore, .env.example |
| `ci-github-actions` | Creas, revisas o diagnosticas un workflow | Python, Node, Java, Go, imagen + servicio sano |
| `etiquetas-evidencia` | Escribes un reporte, README o docs | — |

## Reglas que siguen todas las herramientas

- **Evidencia honesta.** Cada afirmación lleva una etiqueta: *ejecutado*, *comprobado con una muestra* o *solo diseñado*, con el comando que la prueba.
- **Nunca abren ni muestran `.env`** ni archivos de credenciales.
- **Proponen antes de escribir**: ves el diff y decides.
- **No hacen push**, no publican imágenes, no crean secretos ni cambian la configuración de GitHub. Te dan el comando y lo corres tú.
- **No borran datos**: nada de `docker compose down -v` ni `docker system prune` sin preguntarte.

## Problemas comunes

| Síntoma | Qué hacer |
|---|---|
| `/empezar` no aparece | Plugin: `/plugin` y revisa que `estudia-nube` esté habilitado; reinicia Claude Code. Opción B: confirma que existe `.claude/commands/` en la raíz del proyecto. |
| `docker: command not found` o `Cannot connect to the Docker daemon` | Instala o abre Docker Desktop y espera a que diga *running*. |
| `gh: command not found` o `gh` sin sesión | Instala GitHub CLI y corre `gh auth login`. |
| En Windows, un `.sh` falla con `\r: command not found` | Finales de línea CRLF. Agrega `*.sh text eol=lf` a `.gitattributes` y vuelve a clonar, o usa WSL. |

## Para contribuir

```bash
python3 scripts/validar.py          # estructura, frontmatter y plantillas referenciadas
claude plugin validate .            # manifiestos del plugin
```

El CI de este repositorio ([validar.yml](.github/workflows/validar.yml)) corre lo anterior más `actionlint` y `hadolint` sobre las plantillas: las mismas reglas que enseña.

Licencia [MIT](LICENSE).
