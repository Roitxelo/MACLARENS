# Ejecuta las pruebas del juego en Windows.
# Uso:  .\tools\run_tests.ps1            (rápidas: lógica)
#       .\tools\run_tests.ps1 -Todas     (además capturas, noche completa y futbolín; abre ventanas)
# Define $env:GODOT con la ruta a Godot_v4.7.x_win64_console.exe si no está en el PATH.
param([switch]$Todas)
$godot = if ($env:GODOT) { $env:GODOT } else { "godot" }
Push-Location (Join-Path $PSScriptRoot "..\game")
$fail = $false
function Run-Test($scene, $ok, $extra) {
    Write-Host "== $scene"
    $out = & $godot @extra "res://tests/$scene.tscn" 2>&1 | Out-String
    if ($out -match $ok) { Write-Host "   OK ($ok)" } else {
        ($out -split "`n" | Select-String "SCRIPT ERROR|ERROR|$ok" | Select-Object -First 20) | ForEach-Object { Write-Host $_ }
        Write-Host "   FALLO"; $script:fail = $true }
}
& $godot --headless --import . *> $null
Run-Test "night_sim_test" "NIGHT_SIM_OK" @("--headless")
if ($Todas) {
    Run-Test "night_soak_test" "NIGHT_SOAK_OK" @()
    Run-Test "night_capture" "NIGHT_CAPTURE_OK" @()
    Run-Test "billar_test" "BILLAR_TEST_OK" @()
    Write-Host "Capturas en game\tests\output\"
}
Pop-Location
if ($fail) { exit 1 }
