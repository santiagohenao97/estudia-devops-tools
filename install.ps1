# Copies the course tools into a project (Windows PowerShell).
# Use it if you prefer the tools to live inside your repo (your whole team gets them on clone).
# If you use the Claude Code plugin (/plugin install) you do NOT need this script.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 [project-path]            Claude Code  -> .claude\
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 -Agents [project-path]    Other agents -> .agents\skills
#                                                (Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode, ...)
param(
  [switch]$Agents,
  [Parameter(Position = 0)][string]$Project = "."
)
$ErrorActionPreference = "Stop"

$Src  = (Resolve-Path $PSScriptRoot).Path
$Dest = (Resolve-Path $Project).Path

if ($Src -eq $Dest) {
  Write-Error "Give the folder of YOUR project:  .\install.ps1 [-Agents] C:\path\to\my-project"
}

$count = 0
if ($Agents) {
  $target = Join-Path $Dest ".agents\skills"
  New-Item -ItemType Directory -Force -Path $target | Out-Null
  Get-ChildItem -Directory (Join-Path $Src "dist\agents\skills") | ForEach-Object {
    $dst = Join-Path $target $_.Name
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $_.FullName $dst
    Write-Host "  skill  $($_.Name)"; $count++
  }
  Write-Host ""
  Write-Host "Done: $count skills in $target"
  Write-Host 'Open your agent in that folder and ask: "use the start skill"'
} else {
  foreach ($sub in "skills", "agents", "commands") {
    New-Item -ItemType Directory -Force -Path (Join-Path $Dest ".claude\$sub") | Out-Null
  }
  Get-ChildItem -Directory (Join-Path $Src "skills") | ForEach-Object {
    $dst = Join-Path $Dest ".claude\skills\$($_.Name)"
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $_.FullName $dst
    Write-Host "  skill    $($_.Name)"; $count++
  }
  foreach ($kind in "agents", "commands") {
    Get-ChildItem (Join-Path $Src "$kind\*.md") | ForEach-Object {
      Copy-Item $_.FullName (Join-Path $Dest ".claude\$kind\")
      Write-Host "  $($kind.TrimEnd('s'))  $($_.BaseName)"; $count++
    }
  }
  Write-Host ""
  Write-Host "Done: $count pieces in $Dest\.claude\"
  Write-Host "Open Claude Code in that folder and type /start"
}
