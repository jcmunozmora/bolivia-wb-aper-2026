#!/usr/bin/env bash
# Stop hook — detecta cambios sin commit + commits sin push.
#
# No ejecuta commit ni push autónomamente (los hooks deben ser informativos,
# no destructivos). Solo reporta estado y sugiere el comando exacto a correr.
#
# Reglas:
#   - Si no hay cambios y todo está pushed: silencio.
#   - Si hay cambios sin commit: lista archivos y sugiere /commit-push (slash command).
#   - Si hay commits ahead de origin: sugiere git push (con warning si rama es main).
#   - Si hay archivos sospechosos en stage (.env, *.pdf grande, *.rds grande): WARN HARD.
#
# Cierre operativo: ver MASTER_PROMPT Parte 15 y CONTROL §3 (zonas críticas).
set -euo pipefail

PAYLOAD=$(cat)
export CLAUDE_HOOK_PAYLOAD="$PAYLOAD"

python3 <<'PYEOF'
import json, os, sys, os, subprocess

try:
    payload = json.loads(os.environ.get('CLAUDE_HOOK_PAYLOAD','{}'))
except Exception:
    sys.exit(0)

# Project root: usar CLAUDE_PROJECT_DIR (set por Claude Code) o CWD como fallback
project_root = os.environ.get('CLAUDE_PROJECT_DIR') or os.getcwd()

def git(*args, check=False):
    res = subprocess.run(
        ["git", "-C", project_root] + list(args),
        capture_output=True, text=True, timeout=10
    )
    return res

# 1. ¿Es repo git?
if git("rev-parse", "--git-dir").returncode != 0:
    sys.exit(0)

# 2. Estado de archivos
status = git("status", "--porcelain").stdout.strip()
uncommitted = []
if status:
    for ln in status.splitlines():
        # Formato: "XY path" (X = index, Y = worktree)
        path = ln[3:].strip() if len(ln) > 3 else ln
        # MO XY puede tener rename arrow
        if " -> " in path:
            path = path.split(" -> ", 1)[1]
        uncommitted.append((ln[:2], path))

# 3. Branch actual + commits unpushed
branch_res = git("rev-parse", "--abbrev-ref", "HEAD")
branch = branch_res.stdout.strip() if branch_res.returncode == 0 else "(detached)"

unpushed_count = 0
unpushed_list = []
upstream_res = git("rev-parse", "--abbrev-ref", "@{u}")
if upstream_res.returncode == 0:
    upstream = upstream_res.stdout.strip()
    ahead_res = git("log", "--oneline", f"{upstream}..HEAD")
    if ahead_res.returncode == 0 and ahead_res.stdout.strip():
        unpushed_list = ahead_res.stdout.strip().splitlines()
        unpushed_count = len(unpushed_list)

# 4. Silencio si nada que hacer
if not uncommitted and unpushed_count == 0:
    sys.exit(0)

# 5. Reporte
print()
print("=" * 70)
print(f"🔧 GIT — estado al cierre de turno (branch: {branch})")
print("=" * 70)

# Detección de archivos sospechosos en stage
suspicious_patterns = (".env", "credentials", "secret", "private_key", ".pem", ".key")
big_binary = (".pdf", ".rds", ".zip", ".tar.gz", ".7z", ".dta", ".sav", ".parquet")

suspicious = []
big = []
for code, path in uncommitted:
    low = path.lower()
    if any(s in low for s in suspicious_patterns):
        suspicious.append(path)
    for ext in big_binary:
        if low.endswith(ext):
            big.append(path)
            break

if suspicious:
    print(f"\n🛑 ARCHIVOS SOSPECHOSOS detectados (posible filtración de secretos):")
    for p in suspicious:
        print(f"     {p}")
    print("   → NO commitear sin revisar. Considerar agregar a .gitignore.")

if big:
    print(f"\n⚠️  ARCHIVOS BINARIOS GRANDES en el cambio:")
    for p in big[:5]:
        # Tamaño
        full = os.path.join(project_root, p)
        size = ""
        try:
            sz = os.path.getsize(full)
            if sz > 1024 * 1024:
                size = f" ({sz / (1024*1024):.1f} MB)"
            elif sz > 1024:
                size = f" ({sz / 1024:.1f} KB)"
        except Exception:
            pass
        print(f"     {p}{size}")
    if len(big) > 5:
        print(f"     ... ({len(big)-5} más)")
    print("   → Verificar si deberían ir a .gitignore (raw data, freeze, cache).")

# Cambios sin commit
if uncommitted:
    print(f"\n📝 {len(uncommitted)} archivo(s) sin commit:")
    # Agrupar por scope (gobernanza, reporte, código, datos, ops)
    groups = {
        ".agent/":        "Gobernanza",
        ".claude/":       "Claude Code config",
        "04_report/":     "Reporte",
        "02_code/":       "Código",
        "01_data/":       "Datos",
        "00_admin/":      "Admin / bitácora",
        "03_literature/": "Literatura",
        "slides/":        "Slides",
        "www/":           "Sitio público",
        "docs/":          "Sitio renderizado",
    }
    by_group = {}
    other = []
    for code, path in uncommitted:
        matched = False
        for prefix, label in groups.items():
            if path.startswith(prefix):
                by_group.setdefault(label, []).append((code, path))
                matched = True
                break
        if not matched:
            other.append((code, path))

    shown = 0
    for label, items in by_group.items():
        print(f"\n   {label}:")
        for code, path in items[:4]:
            print(f"     {code} {path}")
            shown += 1
        if len(items) > 4:
            print(f"     ... ({len(items)-4} más en este grupo)")
            shown += 1
    if other:
        print(f"\n   Otros:")
        for code, path in other[:3]:
            print(f"     {code} {path}")

# Commits sin push
if unpushed_count > 0:
    print(f"\n📤 {unpushed_count} commit(s) sin push hacia {upstream}:")
    for ln in unpushed_list[:5]:
        print(f"     {ln}")
    if unpushed_count > 5:
        print(f"     ... ({unpushed_count-5} más)")

# Sugerencias de acción
print("\n" + "─" * 70)
print("Acciones sugeridas (revisar antes de ejecutar):")

if uncommitted and not suspicious:
    print("  • Commitear: pedir a Claude '/commit-push' (slash command del proyecto)")
    print("    o manual: git add <files> && git commit -m '...'")
elif suspicious:
    print("  • PRIMERO: resolver los archivos sospechosos arriba.")

if unpushed_count > 0:
    if branch in ("main", "master"):
        print(f"  • Push a {branch}: revisar diff antes — push directo a rama protegida.")
        print(f"    git push origin {branch}")
    else:
        print(f"  • Push: git push -u origin {branch}")

if not uncommitted and unpushed_count > 0:
    print("  • Si todo lo unpushed ya fue revisado: git push")

print("=" * 70)
print()

sys.exit(0)
PYEOF
