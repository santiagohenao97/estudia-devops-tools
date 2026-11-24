#!/usr/bin/env bash
# Copies the course tools into a project (macOS, Linux, WSL, Git Bash).
# Use it if you prefer the tools to live inside your repo (your whole team gets them on clone).
# If you use the Claude Code plugin (/plugin install) you do NOT need this script.
#
# Usage:
#   ./install.sh [project-path]            Claude Code  -> <project>/.claude/{skills,agents,commands}
#   ./install.sh --agents [project-path]   Other agents -> <project>/.agents/skills
#                                          (Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode, ...)
# Default project path: the current folder.
set -euo pipefail

MODE=claude
if [ "${1:-}" = "--agents" ]; then MODE=agents; shift; fi

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$(cd "${1:-.}" && pwd)"

if [ "$SRC" = "$DEST" ]; then
  echo "Give the folder of YOUR project:  ./install.sh [--agents] ~/path/to/my-project" >&2
  exit 1
fi

count=0
if [ "$MODE" = "agents" ]; then
  mkdir -p "$DEST/.agents/skills"
  for d in "$SRC"/dist/agents/skills/*/; do
    name="$(basename "$d")"
    rm -rf "$DEST/.agents/skills/$name"
    cp -R "$d" "$DEST/.agents/skills/$name"
    echo "  skill  $name"; count=$((count+1))
  done
  echo
  echo "Done: $count skills in $DEST/.agents/skills/"
  echo "Open your agent in that folder and ask: \"use the start skill\""
else
  mkdir -p "$DEST/.claude/skills" "$DEST/.claude/agents" "$DEST/.claude/commands"
  for d in "$SRC"/skills/*/; do
    name="$(basename "$d")"
    rm -rf "$DEST/.claude/skills/$name"
    cp -R "$d" "$DEST/.claude/skills/$name"
    echo "  skill    $name"; count=$((count+1))
  done
  for f in "$SRC"/agents/*.md "$SRC"/commands/*.md; do
    kind="$(basename "$(dirname "$f")")"
    cp "$f" "$DEST/.claude/$kind/"
    echo "  ${kind%s}  $(basename "$f" .md)"; count=$((count+1))
  done
  echo
  echo "Done: $count pieces in $DEST/.claude/"
  echo "Open Claude Code in that folder and type /start"
fi
