# Copia las skills, agentes y comandos del curso al .claude\ de un proyecto (Windows PowerShell).
# Úsalo si prefieres que las herramientas viajen dentro de tu repo (todo tu equipo las tiene al clonar).
# Si usas el plugin (/plugin install), NO necesitas este script.
#
# Uso:  powershell -ExecutionPolicy Bypass -File .\instalar.ps1 [ruta-del-proyecto]
param([string]$Proyecto = ".")
$ErrorActionPreference = "Stop"

$Origen  = (Resolve-Path $PSScriptRoot).Path
$Destino = (Resolve-Path $Proyecto).Path

if ($Origen -eq $Destino) {
  Write-Error "Indica la carpeta de TU proyecto:  .\instalar.ps1 C:\ruta\a\mi-proyecto"
}

foreach ($sub in "skills", "agents", "commands") {
  New-Item -ItemType Directory -Force -Path (Join-Path $Destino ".claude\$sub") | Out-Null
}

$copiados = 0
Get-ChildItem -Directory (Join-Path $Origen "skills") | ForEach-Object {
  $dst = Join-Path $Destino ".claude\skills\$($_.Name)"
  if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
  Copy-Item -Recurse $_.FullName $dst
  Write-Host "  skill    $($_.Name)"; $copiados++
}
foreach ($tipo in "agents", "commands") {
  Get-ChildItem (Join-Path $Origen "$tipo\*.md") | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $Destino ".claude\$tipo\")
    Write-Host "  $($tipo.TrimEnd('s'))  $($_.BaseName)"; $copiados++
  }
}

Write-Host ""
Write-Host "Listo: $copiados piezas en $Destino\.claude\"
Write-Host "Abre Claude Code en esa carpeta y escribe /empezar"
