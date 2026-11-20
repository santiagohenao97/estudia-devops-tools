#!/usr/bin/env bash
# Copia las skills, agentes y comandos del curso al .claude/ de un proyecto (macOS, Linux, WSL, Git Bash).
# Úsalo si prefieres que las herramientas viajen dentro de tu repo (todo tu equipo las tiene al clonar).
# Si usas el plugin (/plugin install), NO necesitas este script.
#
# Uso:  ./instalar.sh [ruta-del-proyecto]      (por defecto, la carpeta actual)
set -euo pipefail

ORIGEN="$(cd "$(dirname "$0")" && pwd)"
DESTINO="$(cd "${1:-.}" && pwd)"

if [ "$ORIGEN" = "$DESTINO" ]; then
  echo "Indica la carpeta de TU proyecto:  ./instalar.sh ~/ruta/a/mi-proyecto" >&2
  exit 1
fi

mkdir -p "$DESTINO/.claude/skills" "$DESTINO/.claude/agents" "$DESTINO/.claude/commands"

copiados=0
for d in "$ORIGEN"/skills/*/; do
  nombre="$(basename "$d")"
  rm -rf "$DESTINO/.claude/skills/$nombre"
  cp -R "$d" "$DESTINO/.claude/skills/$nombre"
  echo "  skill    $nombre"; copiados=$((copiados+1))
done
for f in "$ORIGEN"/agents/*.md "$ORIGEN"/commands/*.md; do
  tipo="$(basename "$(dirname "$f")")"
  cp "$f" "$DESTINO/.claude/$tipo/"
  echo "  ${tipo%s}  $(basename "$f" .md)"; copiados=$((copiados+1))
done

echo
echo "Listo: $copiados piezas en $DESTINO/.claude/"
echo "Abre Claude Code en esa carpeta y escribe /empezar"
