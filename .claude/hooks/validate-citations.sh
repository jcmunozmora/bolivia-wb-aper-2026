#!/usr/bin/env bash
# PreToolUse hook — valida citas [@citekey] en ediciones a .qmd del reporte.
#
# Enforza gate §13B de .agent/09_AUDITORIA.md:
#   "Una ficha de 03_literature/ sólo puede citarse en 04_report/*.qmd
#    si su audit_status ∈ {green, yellow}."
#
# Bloquea (exit 2):
#   - citas a fichas con audit_status: red
#   - citas a fichas con audit_status: unverified
#   - citas a fichas inexistentes (orphan citations)
#
# Pasa con warning (exit 0):
#   - citas a yellow (recordatorio de leer la nota)
#   - citas a green (limpio, sin output)
set -euo pipefail

PAYLOAD=$(cat)
export CLAUDE_HOOK_PAYLOAD="$PAYLOAD"

python3 <<'PYEOF'
import json, os, re, sys, os, glob

try:
    payload = json.loads(os.environ.get('CLAUDE_HOOK_PAYLOAD','{}'))
except Exception:
    sys.exit(0)

tool_name  = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {}) or {}
file_path  = tool_input.get("file_path", "")

# Solo .qmd del reporte
if not file_path.endswith(".qmd") or "04_report/" not in file_path:
    sys.exit(0)

# Extraer contenido nuevo según herramienta
if tool_name == "Edit":
    content = tool_input.get("new_string", "")
elif tool_name == "Write":
    content = tool_input.get("content", "")
elif tool_name == "MultiEdit":
    content = "\n".join(e.get("new_string", "") for e in tool_input.get("edits", []))
else:
    sys.exit(0)

# Encontrar todas las citas [@citekey] o [@citekey;@otra] o [-@citekey]
# Patrón Pandoc: @ followed by alphanumeric / _ / - / : / . (citation key chars)
cite_keys = set(re.findall(r'@([A-Za-z][A-Za-z0-9_\-:./]*)', content))
if not cite_keys:
    sys.exit(0)

# Localizar project root (script vive en .claude/hooks/ → root = ../../)
# Project root: usar CLAUDE_PROJECT_DIR (set por Claude Code) o CWD como fallback
project_root = os.environ.get('CLAUDE_PROJECT_DIR') or os.getcwd()
lit_dir = os.path.join(project_root, "03_literature")

# Indexar fichas disponibles: citekey → (path, audit_status)
ficha_index = {}
if os.path.isdir(lit_dir):
    # Buscar en subcarpetas numeradas (01_*, 02_*, ...) y mdryt_fichas/, Informacion_PER/
    for md_path in glob.glob(os.path.join(lit_dir, "*", "*.md")) + \
                   glob.glob(os.path.join(lit_dir, "*.md")):
        # Excluir README, templates, evidence_map, audit reports
        bn = os.path.basename(md_path)
        if bn.startswith(("README", "_", "evidence_map", "search_strategy", "AUDIT")):
            continue
        try:
            with open(md_path, encoding="utf-8", errors="ignore") as f:
                head = f.read(2000)
        except Exception:
            continue
        # Frontmatter YAML
        m_key = re.search(r'^citekey:\s*(\S+)', head, flags=re.MULTILINE)
        m_st  = re.search(r'^audit_status:\s*(\w+)', head, flags=re.MULTILINE)
        if m_key:
            key = m_key.group(1).strip()
            status = m_st.group(1).strip().lower() if m_st else "unverified"
            ficha_index[key] = (md_path, status)
        else:
            # Fallback: usar filename sin .md como citekey implícito
            implicit = bn[:-3]
            if implicit not in ficha_index:
                ficha_index[implicit] = (md_path, "unverified")

# Clasificar citas
orphan = []
red = []
unverified = []
yellow = []

for k in sorted(cite_keys):
    if k not in ficha_index:
        orphan.append(k)
        continue
    _, status = ficha_index[k]
    if status == "red":
        red.append(k)
    elif status == "unverified":
        unverified.append(k)
    elif status == "yellow":
        yellow.append(k)
    # green → silent

# Reportar
hard = orphan or red or unverified

if hard:
    print("\n🛑 HOOK BLOQUEÓ CITAS NO AUTORIZADAS EN " + file_path, file=sys.stderr)
    print("=" * 70, file=sys.stderr)
    print("Gate §13B de .agent/09_AUDITORIA.md:", file=sys.stderr)
    print("  Solo se permiten citas con audit_status ∈ {green, yellow}.", file=sys.stderr)
    if orphan:
        print(f"\n• HUÉRFANAS (ficha no existe): {orphan}", file=sys.stderr)
        print("  → Crear ficha en 03_literature/<categoria>/<citekey>.md con audit_status verificado.", file=sys.stderr)
    if red:
        print(f"\n• AUDIT ROJO (alucinación detectada): {red}", file=sys.stderr)
        print("  → Ver 03_literature/_audit/RED_FLAGS.md. Re-verificar contra PDF o sustituir fuente.", file=sys.stderr)
    if unverified:
        print(f"\n• UNVERIFIED: {unverified}", file=sys.stderr)
        print("  → Abrir PDF, verificar autores/cifras/citas literales, actualizar audit_status a green/yellow.", file=sys.stderr)
    print("\n" + "=" * 70, file=sys.stderr)
    sys.exit(2)

# Soft warning para yellow
if yellow:
    print(f"\n💡 CITAS AMARILLAS (con nota de inconsistencia menor):")
    for k in yellow:
        path = ficha_index[k][0]
        rel = os.path.relpath(path, project_root)
        print(f"  • [@{k}] → {rel} — leer nota antes de usar la cita")
    print()

sys.exit(0)
PYEOF
