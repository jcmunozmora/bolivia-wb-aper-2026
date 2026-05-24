#!/usr/bin/env bash
# Stop hook — recordatorio de cierre de sesión.
#
# Si en la sesión hubo cambios en archivos relevantes y RETOMAR.md NO se
# actualizó, recuerda pegar el bloque de cierre (MASTER_PROMPT Parte 15).
#
# Heurística: si git status muestra cambios en .agent/, 04_report/, 02_code/
# o 01_data/processed/ Y RETOMAR.md NO está modificado, mostrar prompt.
set -euo pipefail

PAYLOAD=$(cat)
export CLAUDE_HOOK_PAYLOAD="$PAYLOAD"

python3 <<'PYEOF'
import json, os, sys, os, subprocess

try:
    payload = json.loads(os.environ.get('CLAUDE_HOOK_PAYLOAD','{}'))
except Exception:
    sys.exit(0)

# Script vive en .claude/hooks/ → project root = ../../
# Project root: usar CLAUDE_PROJECT_DIR (set por Claude Code) o CWD como fallback
project_root = os.environ.get('CLAUDE_PROJECT_DIR') or os.getcwd()

try:
    res = subprocess.run(
        ["git", "-C", project_root, "status", "--porcelain"],
        capture_output=True, text=True, timeout=10
    )
    if res.returncode != 0:
        sys.exit(0)
    lines = res.stdout.strip().splitlines()
except Exception:
    sys.exit(0)

if not lines:
    sys.exit(0)  # No hay cambios sin commitear; nada que recordar

# Categorías
substantive = []
retomar_touched = False
for ln in lines:
    # Formato: "XY path"
    path = ln[3:] if len(ln) > 3 else ln
    if path.startswith("00_admin/RETOMAR.md"):
        retomar_touched = True
        continue
    if any(path.startswith(p) for p in (".agent/", "04_report/", "02_code/",
                                          "01_data/processed/", ".claude/", "slides/")):
        substantive.append(path)

if substantive and not retomar_touched:
    print("\n" + "=" * 70)
    print("📝 RECORDATORIO DE CIERRE DE SESIÓN")
    print("=" * 70)
    print(f"Detectados {len(substantive)} cambios sustantivos sin entrada en RETOMAR:")
    for p in substantive[:8]:
        print(f"  • {p}")
    if len(substantive) > 8:
        print(f"  • ... ({len(substantive)-8} más)")
    print("\nAntes de cerrar la sesión, pegá el bloque estandarizado de")
    print(".agent/00_MASTER_PROMPT.md Parte 15 al inicio de 00_admin/RETOMAR.md.")
    print("\nMínimo: tipo de cambio (verde/amarillo/rojo), archivos modificados,")
    print("cifras tocadas, hallazgos afectados, tests ejecutados, siguientes pasos.")
    print("=" * 70 + "\n")

sys.exit(0)
PYEOF
