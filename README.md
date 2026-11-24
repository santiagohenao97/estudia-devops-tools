# estudia-devops-tools

Agentes, skills y comandos de **Claude Code** del curso [Estud-IA Nube · Intermedio](https://santiagohenao97.github.io/estudia-nube/) para que crees, revises y ajustes la cadena de entrega de **tu propio proyecto**: contenedor (Docker y Compose) e integración continua (GitHub Actions).

Funcionan con cualquier lenguaje (Python, Node, Java, Go u otro) y en macOS, Linux o Windows. **Si no usas Claude Code**, también se instalan como skills en `.agents/skills/` para Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode y otros (ver [Opción C](#opción-c--otros-agentes-agents)). Cada encuentro del curso agrega herramientas nuevas.

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
./estudia-devops-tools/install.sh ~/ruta/a/mi-proyecto            # macOS, Linux, WSL, Git Bash
```

```powershell
git clone https://github.com/santiagohenao97/estudia-devops-tools.git
powershell -ExecutionPolicy Bypass -File .\estudia-devops-tools\install.ps1 C:\ruta\a\mi-proyecto
```

Para actualizar: `git pull` en `estudia-devops-tools` y vuelve a correr el instalador.

### Opción C · Otros agentes (`.agents/`)

Para herramientas que no son Claude Code. Copia las skills a `.agents/skills/` de tu proyecto, la carpeta que leen Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode y otros agentes.

```bash
git clone https://github.com/santiagohenao97/estudia-devops-tools.git
./estudia-devops-tools/install.sh --agents ~/ruta/a/mi-proyecto            # macOS, Linux, WSL, Git Bash
```

```powershell
git clone https://github.com/santiagohenao97/estudia-devops-tools.git
powershell -ExecutionPolicy Bypass -File .\estudia-devops-tools\install.ps1 -Agents C:\ruta\a\mi-proyecto
```

Sin scripts: copia a mano el contenido de [`dist/agents/skills/`](dist/agents/skills/) en `.agents/skills/` de tu proyecto.

Qué cambia respecto a Claude Code:
- No hay comandos con `/`: los comandos y los agentes llegan como **skills** con el mismo nombre. Pídelas por nombre: *"usa la skill `start`"*, *"usa la skill `create-ci` para validar mis pruebas"*.
- La carpeta `.agents/skills/` es el estándar común, pero algunas herramientas usan la suya (por ejemplo `.cursor/skills/` o `.gemini/skills/`). Si tu agente no las ve, copia ahí la misma carpeta; revisa su documentación.
- Otros agentes **no aplican** la lista `allowed-tools` de los comandos de solo lectura. Las reglas ("no edites", "no abras `.env`", "no hagas push") siguen escritas en cada skill como instrucciones, pero no hay un bloqueo técnico: revisa lo que te propongan antes de aceptar.

## Empieza aquí

Abre Claude Code en la carpeta de tu proyecto y escribe (en otros agentes: *"usa la skill `start`"*):

```
/start
```

Revisa tu proyecto (solo lectura), te muestra qué piezas tiene y cuáles faltan, y te dice el siguiente paso.

## Herramientas por encuentro

| Encuentro | Qué cubre | Comandos | Skill |
|---|---|---|---|
| Todos | Ver dónde está tu proyecto | `/start` | `evidence-labels` |
| **E3** · Contenedor, configuración y entorno reproducible | Dockerfile, compose.yaml, .dockerignore, .env.example | `/create-container` · `/review-container` · `/verify` | `container` |
| **E4** · Integración continua y validación de cambios | Workflows de GitHub Actions, runs en rojo, pruebas que no atrapan errores | `/create-ci` · `/review-ci` · `/diagnose-ci` · `/mutants` | `github-actions-ci` |
| E5 en adelante | Próximamente | | |

Si instalaste como plugin y otro plugin usa el mismo nombre de comando, escríbelo con prefijo: `/estudia-nube:create-ci`.

### Comandos

| Comando | Qué hace | ¿Cambia archivos? |
|---|---|---|
| `/start` | Diagnóstico del proyecto y siguiente paso | No |
| `/create-container [objetivo]` | Propone Dockerfile, compose, .dockerignore y .env.example; los levanta y lo demuestra | Sí, tras mostrarte el diff |
| `/review-container [ruta]` | Revisa el contenedor contra la checklist | No |
| `/verify` | Levanta el servicio, hace una petición real y, si falla, diagnostica | No (solo levanta contenedores) |
| `/create-ci <qué validar>` | Propone un workflow de GitHub Actions y la ficha `docs/ci.md` | Sí, tras mostrarte el diff |
| `/review-ci [ruta]` | Revisa workflows: permisos, fallos ocultos, inyección, versiones | No |
| `/diagnose-ci [id]` | Lee el último run en rojo y encuentra el primer error real | No |
| `/mutants [archivo]` | Propone cambios pequeños para ver qué errores no atrapan tus pruebas | No |

### Agentes

| Agente | Para qué |
|---|---|
| `devops-engineer` | Construir y probar una pieza completa paso a paso, explicando cada decisión. Pídelo así: *"usa el agente devops-engineer para dockerizar mi API"*. |
| `delivery-reviewer` | Revisión de solo lectura con puntaje 0-100 antes de entregar un ejercicio o abrir un pull request. |

### Skills

Se activan solas cuando trabajas en esos archivos, aunque no uses un comando.

| Skill | Se activa cuando… | Templates |
|---|---|---|
| `container` | Escribes o arreglas un Dockerfile o compose | Python, Node, Java (Maven), Go, compose, .dockerignore, .env.example |
| `github-actions-ci` | Creas, revisas o diagnosticas un workflow | Python, Node, Java, Go, imagen + servicio sano |
| `evidence-labels` | Escribes un reporte, README o docs | — |

## Reglas que siguen todas las herramientas

- **Evidencia honesta.** Cada afirmación lleva una etiqueta: *ejecutado*, *comprobado con una muestra* o *solo diseñado*, con el comando que la prueba.
- **Nunca abren ni muestran `.env`** ni archivos de credenciales.
- **Proponen antes de escribir**: ves el diff y decides.
- **No hacen push**, no publican imágenes, no crean secretos ni cambian la configuración de GitHub. Te dan el comando y lo corres tú.
- **No borran datos**: nada de `docker compose down -v` ni `docker system prune` sin preguntarte.

## Problemas comunes

| Síntoma | Qué hacer |
|---|---|
| `/start` no aparece | Plugin: `/plugin` y revisa que `estudia-nube` esté habilitado; reinicia Claude Code. Opción B: confirma que existe `.claude/commands/` en la raíz del proyecto. |
| `docker: command not found` o `Cannot connect to the Docker daemon` | Instala o abre Docker Desktop y espera a que diga *running*. |
| `gh: command not found` o `gh` sin sesión | Instala GitHub CLI y corre `gh auth login`. |
| En Windows, un `.sh` falla con `\r: command not found` | Finales de línea CRLF. Agrega `*.sh text eol=lf` a `.gitattributes` y vuelve a clonar, o usa WSL. |

## Para contribuir

```bash
python3 scripts/build_agents.py      # regenera dist/agents/skills/ (commitea el resultado)
python3 scripts/validate.py          # estructura, frontmatter, templates referenciados y dist/ al día
claude plugin validate .            # manifiestos del plugin
```

El CI de este repositorio ([validate.yml](.github/workflows/validate.yml)) corre lo anterior más `actionlint` y `hadolint` sobre los templates: las mismas reglas que enseña.

Licencia [MIT](LICENSE).
