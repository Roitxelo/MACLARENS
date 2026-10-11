#!/usr/bin/env bash
# Genera McLarens_vX.zip para Windows a partir del último commit (no del
# directorio de trabajo). Necesita Godot 4.7.1 y las plantillas de exportación
# en ~/.local/share/godot/export_templates/4.7.1.stable/.
# Uso: tools/release/build_windows.sh [versión]   → builds/McLarens_v<versión>.zip
set -euo pipefail
VER="${1:-1.0}"
GODOT="${GODOT:-godot}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
git -C "$ROOT" archive HEAD game | tar -x -C "$WORK"
cp "$ROOT/tools/release/export_presets.cfg" "$WORK/game/"
mkdir -p "$WORK/out/McLarens_v$VER" "$ROOT/builds"
( cd "$WORK/game" && "$GODOT" --headless --import >/dev/null 2>&1 || true
  "$GODOT" --headless --export-release "Windows Desktop" "$WORK/out/McLarens_v$VER/McLarens.exe"
  "$GODOT" --headless --export-release "Linux" "$WORK/out/McLarens.x86_64" )
# Prueba de humo: la build de Linux lleva el mismo .pck; debe arrancar sin errores de script.
if command -v xvfb-run >/dev/null; then
  ( cd "$WORK/out" && timeout 60 xvfb-run -a -s "-screen 0 1280x720x24" ./McLarens.x86_64 --rendering-driver opengl3 --quit-after 600 > run.log 2>&1 || true
    if grep -qi "SCRIPT ERROR" run.log; then echo "La build no arranca limpia:"; cat run.log; exit 1; fi )
fi
cp "$ROOT/tools/release/LEEME.txt" "$WORK/out/McLarens_v$VER/"
( cd "$WORK/out" && python3 -c "
import zipfile,os,sys
v=sys.argv[1]; d='McLarens_v'+v
z=zipfile.ZipFile(sys.argv[2],'w',zipfile.ZIP_DEFLATED)
for f in os.listdir(d): z.write(d+'/'+f)
z.close()" "$VER" "$ROOT/builds/McLarens_v$VER.zip" )
echo "OK: builds/McLarens_v$VER.zip ($(git -C "$ROOT" rev-parse --short HEAD))"
