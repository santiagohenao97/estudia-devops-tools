#!/usr/bin/env python3
"""Generate dist/agents/skills/: the same tools as portable Agent Skills for tools that read `.agents/skills/`
(Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode, ...).

- skills/*            copied as they are
- commands/*.md       become one skill each (frontmatter reduced to name + description)
- agents/*.md         become one skill each (same)
Claude-only frontmatter (allowed-tools, model, tools) is dropped: other agents ignore it, so the
read-only rules live in the body of each file as instructions.

Usage:
  python3 scripts/build_agents.py           regenerate dist/agents/skills/
  python3 scripts/build_agents.py --check   fail if dist/ is out of date (used in CI)
"""
import pathlib
import re
import shutil
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "dist" / "agents" / "skills"
NAMES = sorted(p.stem for p in (ROOT / "commands").glob("*.md"))
SLASH = re.compile(r"(?<![\w/.])/(" + "|".join(map(re.escape, NAMES)) + r")\b")


def split(text: str) -> tuple[dict, str]:
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not m:
        raise SystemExit("file without frontmatter")
    meta = {}
    for line in m.group(1).splitlines():
        if ":" in line and not line.startswith((" ", "-")):
            k, v = line.split(":", 1)
            meta[k.strip()] = v.strip()
    return meta, m.group(2)


def portable(text: str) -> str:
    text = text.replace("$ARGUMENTS", "what the user asked for")
    return SLASH.sub(r"\1", text)


def convert(src: pathlib.Path, kind: str) -> str:
    meta, body = split(src.read_text(encoding="utf-8"))
    desc = re.sub(r"\s*Uso - /.*$", "", meta["description"]).strip()
    header = f"---\nname: {src.stem}\ndescription: {portable(desc)}\n---\n"
    note = {
        "command": "> Ask for this by name (for example: \"use the `%s` skill\"). In Claude Code it is the `/%s` command.\n\n",
        "agent": "> Ask for this role by name (for example: \"act as the `%s` skill\"). In Claude Code it is the `%s` agent.\n\n",
    }[kind] % (src.stem, src.stem)
    return header + "\n" + note + portable(body).lstrip("\n")


def build() -> dict[pathlib.Path, bytes]:
    files: dict[pathlib.Path, bytes] = {}
    for skill in sorted((ROOT / "skills").iterdir()):
        for f in sorted(skill.rglob("*")):
            if f.is_file():
                text = f.read_bytes()
                if f.name == "SKILL.md" or f.suffix in {".md"}:
                    text = portable(text.decode("utf-8")).encode("utf-8")
                files[pathlib.Path(skill.name) / f.relative_to(skill)] = text
    for kind, folder in (("command", "commands"), ("agent", "agents")):
        for f in sorted((ROOT / folder).glob("*.md")):
            files[pathlib.Path(f.stem) / "SKILL.md"] = convert(f, kind).encode("utf-8")
    return files


def main() -> None:
    files = build()
    if "--check" in sys.argv:
        current = {p.relative_to(OUT): p.read_bytes() for p in OUT.rglob("*") if p.is_file()} if OUT.exists() else {}
        if current != files:
            print("ERROR  dist/agents/skills is out of date. Run: python3 scripts/build_agents.py")
            sys.exit(1)
        print(f"OK  dist/agents/skills up to date ({len({p.parts[0] for p in files})} skills)")
        return
    if OUT.exists():
        shutil.rmtree(OUT)
    for rel, data in files.items():
        dest = OUT / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(data)
    print(f"Generated {len({p.parts[0] for p in files})} skills in {OUT.relative_to(ROOT)}")


main()
