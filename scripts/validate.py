#!/usr/bin/env python3
"""Validate the plugin structure with no external dependencies.

- JSON manifests parse and share the same version
- every skill, agent and command has the required frontmatter fields
- every skill name matches its folder
- templates mentioned by each SKILL.md exist
- no file contains anything that looks like a secret
- dist/agents/skills is up to date (scripts/build_agents.py --check)
Usage: python3 scripts/validate.py
"""
import json
import pathlib
import re
import subprocess
import sys

RAIZ = pathlib.Path(__file__).resolve().parent.parent
errores: list[str] = []


def frontmatter(ruta: pathlib.Path) -> dict:
    texto = ruta.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", texto, re.S)
    if not m:
        errores.append(f"{ruta.relative_to(RAIZ)}: missing frontmatter")
        return {}
    campos = {}
    for linea in m.group(1).splitlines():
        if ":" in linea and not linea.startswith((" ", "-")):
            clave, valor = linea.split(":", 1)
            campos[clave.strip()] = valor.strip()
    return campos


def requerir(ruta: pathlib.Path, campos: dict, *claves: str) -> None:
    for c in claves:
        if not campos.get(c):
            errores.append(f"{ruta.relative_to(RAIZ)}: missing '{c}' in frontmatter")


plugin = json.loads((RAIZ / ".claude-plugin/plugin.json").read_text(encoding="utf-8"))
market = json.loads((RAIZ / ".claude-plugin/marketplace.json").read_text(encoding="utf-8"))
entrada = next((p for p in market["plugins"] if p["name"] == plugin["name"]), None)
if not entrada:
    errores.append("marketplace.json does not list the plugin from plugin.json")
elif entrada.get("version") != plugin["version"]:
    errores.append(f"version mismatch: plugin.json {plugin['version']} vs marketplace.json {entrada.get('version')}")
version_archivo = (RAIZ / "VERSION").read_text(encoding="utf-8").strip()
if version_archivo != plugin["version"]:
    errores.append(f"VERSION ({version_archivo}) does not match plugin.json ({plugin['version']})")

for skill in sorted((RAIZ / "skills").glob("*/SKILL.md")):
    f = frontmatter(skill)
    requerir(skill, f, "name", "description")
    if f.get("name") and f["name"] != skill.parent.name:
        errores.append(f"{skill.relative_to(RAIZ)}: name '{f['name']}' does not match the folder")
    for ref in re.findall(r"templates/([\w.\-]+)", skill.read_text(encoding="utf-8")):
        if not (skill.parent / "templates" / ref).exists():
            errores.append(f"{skill.relative_to(RAIZ)}: mentions templates/{ref}, which does not exist")

for agente in sorted((RAIZ / "agents").glob("*.md")):
    f = frontmatter(agente)
    requerir(agente, f, "name", "description")
    if f.get("name") and f["name"] != agente.stem:
        errores.append(f"{agente.relative_to(RAIZ)}: name does not match the file")

for comando in sorted((RAIZ / "commands").glob("*.md")):
    requerir(comando, frontmatter(comando), "description")

SECRETO = re.compile(r"(AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,})")
for archivo in RAIZ.rglob("*"):
    if archivo.is_file() and ".git" not in archivo.parts and archivo.suffix not in {".png", ".jpg"}:
        if SECRETO.search(archivo.read_text(encoding="utf-8", errors="ignore")):
            errores.append(f"{archivo.relative_to(RAIZ)}: contains something that looks like a secret")

generado = subprocess.run([sys.executable, str(RAIZ / "scripts" / "build_agents.py"), "--check"], capture_output=True, text=True)
if generado.returncode != 0:
    errores.append(generado.stdout.strip() or generado.stderr.strip())

n_skills = len(list((RAIZ / "skills").glob("*/SKILL.md")))
n_agentes = len(list((RAIZ / "agents").glob("*.md")))
n_comandos = len(list((RAIZ / "commands").glob("*.md")))
if errores:
    print("\n".join(f"ERROR  {e}" for e in errores))
    sys.exit(1)
print(f"OK  v{plugin['version']} · {n_skills} skills · {n_agentes} agents · {n_comandos} commands")
