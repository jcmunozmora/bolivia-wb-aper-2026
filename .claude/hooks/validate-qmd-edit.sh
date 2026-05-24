#!/usr/bin/env bash
# PreToolUse hook — valida ediciones/escrituras a archivos .qmd del reporte (04_report/).
#
# Bloquea (exit 2) violaciones HARD:
#   - Referencias a panel v1/v10/v11 (Invariante 3.2 — single source v12)
#   - Frases advocacy explícitas (Invariante 3.3 — neutralidad técnica)
#   - Imperativos normativos sin reformular ("debe", "tiene que", "urge", etc.)
#   - Nombres explícitos de presidentes/ministros/partidos
#
# Warning (exit 0 con stdout) en violaciones SOFT:
#   - Primera persona plural ("encontramos", "nuestro", "creemos")
#   - Cifras sin trazabilidad aparente
#
# Fuente normativa: .agent/06_NEUTRALIDAD.md
set -euo pipefail

# Leer payload JSON del stdin → enviar a Python para procesamiento robusto
PAYLOAD=$(cat)
export CLAUDE_HOOK_PAYLOAD="$PAYLOAD"

python3 <<'PYEOF'
import json, os, re, sys

try:
    payload = json.loads(os.environ.get('CLAUDE_HOOK_PAYLOAD','{}'))
except Exception:
    sys.exit(0)  # Si no se puede parsear, no bloquear

tool_name  = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {}) or {}
file_path  = tool_input.get("file_path", "")

# Solo procesar .qmd del reporte
if not file_path.endswith(".qmd"):
    sys.exit(0)
if "04_report/" not in file_path:
    sys.exit(0)

# Obtener contenido nuevo según herramienta
if tool_name == "Edit":
    content = tool_input.get("new_string", "")
elif tool_name == "Write":
    content = tool_input.get("content", "")
elif tool_name == "MultiEdit":
    content = "\n".join(e.get("new_string", "") for e in tool_input.get("edits", []))
else:
    sys.exit(0)

if not content.strip():
    sys.exit(0)

# ─────────────────────────────────────────────────────────────────
# REGLAS HARD (exit 2 — bloquean la edición)
# ─────────────────────────────────────────────────────────────────
hard_violations = []

# 1. Panel v1/v10/v11 (debe ser v12)
bad_panel = re.findall(
    r'spending_panel(?!_v12)\.rds|panel_v(?:1\b|10\b|11\b)',
    content,
    flags=re.IGNORECASE
)
if bad_panel:
    hard_violations.append(
        f"[INVARIANTE 3.2 — SINGLE SOURCE OF TRUTH] "
        f"Referencia a panel no canónico: {set(bad_panel)}. "
        f"Usar siempre `01_data/processed/spending_panel_v12.rds`."
    )

# 2. Frases advocacy explícitas (lista exacta de NEUTRALIDAD §4)
advocacy_phrases_es = [
    r'\bse equivoc[oó]\b',
    r'\bacert[oó]\b',
    r'\bfracas[oó]\b',
    r'\bfue exitos[oa]\b',
    r'\bcomo prometi[oó]\b',
    r'\bincumpli[oó]\b',
    r'\bhonr[oó]\b',
    r'\bignor[oó]\b',
    r'\bes urgente actuar\b',
    r'\bno podemos esperar\b',
    r'\bBolivia necesita\b',
    r'\bhay que transformar\b',
    r'\besto es inaceptable\b',
]
adv_hits = []
for pat in advocacy_phrases_es:
    m = re.search(pat, content, flags=re.IGNORECASE)
    if m:
        adv_hits.append(m.group(0))
if adv_hits:
    hard_violations.append(
        f"[INVARIANTE 3.3 — NEUTRALIDAD TÉCNICA] "
        f"Frases advocacy prohibidas: {adv_hits}. "
        f"Reformular como evidencia técnica (ver .agent/06_NEUTRALIDAD.md §3)."
    )

# 3. Imperativos normativos (deben ir como "opciones técnicas")
imperatives = []
imp_patterns = [
    (r'\b(?:el [Gg]obierno|el MEFP|el MDRy?T) debe\b',          'imperativo institucional'),
    (r'\btiene que (?:hacerse|implementarse|aprobarse)\b',      'imperativo absoluto'),
    (r'\burge (?:que|implementar|aprobar|reformar)\b',          'urgencia advocacy'),
    (r'\bes imprescindible (?:que|implementar)\b',              'imprescindible'),
    (r'\bel camino correcto es\b',                              'prescripción moral'),
]
for pat, label in imp_patterns:
    m = re.search(pat, content, flags=re.IGNORECASE)
    if m:
        imperatives.append(f"{label}: '{m.group(0)}'")
if imperatives:
    hard_violations.append(
        f"[INVARIANTE 3.3 — NEUTRALIDAD] "
        f"Imperativos normativos detectados: {imperatives}. "
        f"Reescribir como 'una opción técnica sería' / 'para consideración del MEFP'."
    )

# 4. Nombres explícitos de actores políticos (lista no exhaustiva — alta señal)
political_names = []
pol_patterns = [
    r'\b(?:Evo Morales|Jeanine Áñez|Luis Arce|Tuto Quiroga|Carlos Mesa)\b',
    r'\bgobierno de (?:Morales|Áñez|Arce|Mesa|Quiroga)\b',
    r'\badministraci[oó]n de (?:Morales|Áñez|Arce|Mesa|Quiroga)\b',
    r'\bpresidencia de (?:Morales|Áñez|Arce|Mesa|Quiroga)\b',
    r'\b(?:MAS-IPSP|CC|Creemos|Comunidad Ciudadana)\b',
]
for pat in pol_patterns:
    m = re.search(pat, content)
    if m:
        political_names.append(m.group(0))
if political_names:
    hard_violations.append(
        f"[INVARIANTE 3.3 — NEUTRALIDAD] "
        f"Nombres políticos prohibidos: {political_names}. "
        f"Usar periodización temporal: 'en 2006–2019', 'durante el periodo fiscal 2019–2025'."
    )

# Si hay HARD → bloquear
if hard_violations:
    print("\n🛑 HOOK BLOQUEÓ EDICIÓN A " + file_path, file=sys.stderr)
    print("=" * 70, file=sys.stderr)
    for v in hard_violations:
        print(f"\n• {v}", file=sys.stderr)
    print("\n" + "=" * 70, file=sys.stderr)
    print("Revisar .agent/06_NEUTRALIDAD.md y reformular antes de reintentar.", file=sys.stderr)
    sys.exit(2)

# ─────────────────────────────────────────────────────────────────
# REGLAS SOFT (exit 0 con warning visible)
# ─────────────────────────────────────────────────────────────────
warnings = []

# Primera persona plural (LLM tiende a usarla)
fp_plural = re.findall(
    r'\b(?:encontramos|nuestro|nuestra|creemos|pensamos|opinamos|consideramos|nos parece)\b',
    content, flags=re.IGNORECASE
)
if fp_plural:
    warnings.append(
        f"⚠️  [INVARIANTE 2.3 — VOZ] Primera persona plural: {set(fp_plural)}. "
        f"Preferir tercera impersonal: 'se observa', 'la evidencia muestra', 'los datos indican'."
    )

# Cifras sin marca de moneda/año aparente (heurística)
naked_numbers = re.findall(r'\b\d{1,3}(?:[,\.]\d{3})+(?:\.\d+)?\b', content)
if naked_numbers and not re.search(r'(?:BOB|USD|Bs|Bolivianos|\$|d[oó]lares)', content):
    warnings.append(
        f"⚠️  [INVARIANTE 3.1 — TRAZABILIDAD] Cifras grandes sin marca de moneda detectadas. "
        f"Toda cifra requiere unidad (BOB 2015 / USD WDI) y año."
    )

if warnings:
    print("\n💡 VALIDACIÓN .qmd — warnings (no bloqueantes):")
    for w in warnings:
        print(f"  {w}")
    print()

sys.exit(0)
PYEOF
