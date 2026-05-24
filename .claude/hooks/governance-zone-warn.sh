#!/usr/bin/env bash
# PostToolUse hook — avisa cuando se editan zonas críticas de gobernanza.
#
# No bloquea (la edición ya ocurrió). Sirve como recordatorio explícito:
#   - Cambio en .agent/ → clasificar verde/amarillo/rojo (08_CONTROL §4)
#   - Cambio ROJO → requiere ADR en .agent/decisions/ + bump de versión
#   - Cambio en hallazgo → bump v<m> del finding (04_HALLAZGOS §3)
#   - Cambio en metodología → bump m<x.y> (01_METODOLOGIA)
#   - Cambio en hallazgos/metodología/indicadores → actualizar bitácora MASTER_PROMPT Parte 17
set -euo pipefail

PAYLOAD=$(cat)
export CLAUDE_HOOK_PAYLOAD="$PAYLOAD"

python3 <<'PYEOF'
import json, os, sys, os

try:
    payload = json.loads(os.environ.get('CLAUDE_HOOK_PAYLOAD','{}'))
except Exception:
    sys.exit(0)

tool_name  = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {}) or {}
file_path  = tool_input.get("file_path", "")

if tool_name not in ("Edit", "Write", "MultiEdit") or not file_path:
    sys.exit(0)

# Mapeo: ruta crítica → mensaje
critical = [
    (".agent/00_MASTER_PROMPT.md",
        ["📌 Editaste MASTER_PROMPT.",
         "   → Bump versión (footer) si cambió contenido sustantivo.",
         "   → Añadir entrada en Parte 17 (bitácora editorial)."]),
    (".agent/01_METODOLOGIA.md",
        ["🔴 Editaste METODOLOGIA. Cambio típicamente ROJO.",
         "   → Bump methodology_version (m<x.y> → m<x.y+1>).",
         "   → ADR en .agent/decisions/ADR-NNNN-<slug>.md.",
         "   → Si afecta hallazgos: bump v<m> en 04_HALLAZGOS para cada uno.",
         "   → Anotar en RETOMAR.md y en MASTER_PROMPT Parte 17."]),
    (".agent/02_INDICADORES.md",
        ["🔴 Editaste INDICADORES. Cambio en variable del panel = ROJO.",
         "   → Sincronizar con 01_data/processed/spending_panel_v12_dictionary.csv.",
         "   → ADR si cambia definición/filtro/unidad de var existente."]),
    (".agent/03_FUENTES.md",
        ["📌 Editaste FUENTES.",
         "   → Nueva fuente cruda = AMARILLO + nota; cambio de licencia/cobertura = ROJO + ADR."]),
    (".agent/04_HALLAZGOS.md",
        ["🔴 Editaste HALLAZGOS. Cambio en magnitud/dirección de un finding = ROJO.",
         "   → Bump v<m> del hallazgo afectado.",
         "   → ADR en .agent/decisions/.",
         "   → Si retiraste un finding: NO borrar, status: retired + motivo."]),
    (".agent/05_ESTILO_NARRATIVO.md",
        ["📌 Editaste ESTILO_NARRATIVO.",
         "   → Cambiar estructura TEEL canónica o §3 anti-IA = ROJO + ADR."]),
    (".agent/06_NEUTRALIDAD.md",
        ["🔴 Editaste NEUTRALIDAD. Cambio en vocabulario permitido/prohibido = ROJO + ADR.",
         "   → También actualizar el hook .claude/hooks/validate-qmd-edit.sh si añadiste frases prohibidas."]),
    (".agent/07_FIGURAS.md",
        ["📌 Editaste FIGURAS.",
         "   → Cambio en paleta/tipografía/grid = ROJO + ADR."]),
    (".agent/08_CONTROL.md",
        ["🔴 Editaste CONTROL.md (semáforo). Auto-ROJO + ADR obligatorio."]),
    (".agent/09_AUDITORIA.md",
        ["🔴 Editaste AUDITORIA. Cambio en checklists o gates = ROJO + ADR.",
         "   → Si añadiste un gate nuevo, considerar implementarlo como hook en .claude/hooks/."]),
    ("04_report/_quarto.yml",
        ["📌 Editaste _quarto.yml (config del book).",
         "   → Verificar que el book sigue compilando: cd 04_report && quarto render"]),
    ("01_data/processed/spending_panel_v12_dictionary.csv",
        ["🔴 Editaste el diccionario del panel v12.",
         "   → Sincronizar con .agent/02_INDICADORES.md.",
         "   → Bump panel_version si cambia estructura."]),
]

msgs = []
for needle, lines in critical:
    if needle in file_path:
        msgs.append((needle, lines))

if msgs:
    print("\n" + "=" * 70)
    print("🧭 ZONA CRÍTICA DE GOBERNANZA — recordatorios")
    print("=" * 70)
    for needle, lines in msgs:
        print(f"\nArchivo: {needle}")
        for ln in lines:
            print(f"  {ln}")
    print("\n→ Ver .agent/08_CONTROL.md §4 (semáforo verde/amarillo/rojo)")
    print("=" * 70 + "\n")

sys.exit(0)
PYEOF
