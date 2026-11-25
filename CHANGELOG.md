# Changelog

## 0.2.0 · 2026-11-25
Encounter 5 (declarative infrastructure).
- Agent: `terraform-engineer`. Describes a project's infrastructure with Terraform/OpenTofu (module, environments, inputs, outputs, state), starting with the Docker provider (no cloud), runs `fmt`, `validate` and `plan`, teaches plan reading and writes `docs/infra.md`. Never uses `-auto-approve` and never applies or destroys in a cloud.
- `/start` maps the encounter 5 pieces.

## 0.1.0 · 2026-11-20
First release, covers encounters 3 and 4.
- Skills: `container`, `github-actions-ci`, `evidence-labels`, with templates for Python, Node, Java and Go.
- Commands: `/start`, `/create-container`, `/review-container`, `/verify`, `/create-ci`, `/review-ci`, `/diagnose-ci`, `/mutants`.
- Agents: `devops-engineer`, `delivery-reviewer`.
- Install as a Claude Code plugin (`/plugin marketplace add`), by copying to `.claude/`, or for other agents to `.agents/skills/` (`install.sh --agents`, `install.ps1 -Agents`).
