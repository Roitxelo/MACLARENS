#!/usr/bin/env bash
# Ejecuta las pruebas del juego. Uso: tools/run_tests.sh [rapidas|todas]
#   rapidas (por defecto): lógica headless (night_sim, economy, campaign).
#   todas: además capturas, noche completa x2 y futbolín (necesitan ventana o xvfb-run).
# Variable GODOT: ruta al ejecutable de Godot 4.7 (por defecto "godot").
set -euo pipefail
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/../game"
mode="${1:-rapidas}"
fail=0
PREFIX=()
run() { # escena  marca_ok  [extra_args]
  local scene="$1" ok="$2"; shift 2
  echo "== $scene"
  if out=$("${PREFIX[@]}" "$GODOT" "$@" "res://tests/$scene.tscn" 2>&1) && grep -q "$ok" <<<"$out"; then
    echo "   OK ($ok)"
  else
    echo "$out" | grep -E "SCRIPT ERROR|ERROR|$ok" | head -20; echo "   FALLO"; fail=1
  fi
}
"$GODOT" --headless --import . >/dev/null 2>&1 || true
run night_sim_test NIGHT_SIM_OK --headless
run economy_test ECONOMY_TEST_OK --headless
run campaign_test CAMPAIGN_TEST_OK --headless
if [[ "$mode" == "todas" ]]; then
  if [[ -z "${DISPLAY:-}" ]] && command -v xvfb-run >/dev/null; then PREFIX=(xvfb-run -a -s "-screen 0 1280x720x24"); fi
  run night_soak_test NIGHT_SOAK_OK --rendering-driver opengl3
  run night_capture NIGHT_CAPTURE_OK --rendering-driver opengl3
  run billar_test BILLAR_TEST_OK --rendering-driver opengl3
  echo "Capturas en game/tests/output/"
fi
exit $fail
