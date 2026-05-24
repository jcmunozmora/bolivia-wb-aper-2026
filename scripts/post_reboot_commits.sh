#!/usr/bin/env bash
# =============================================================================
# post_reboot_commits.sh — Ejecutar los 4 commits acumulados de sesiones 10-12
# =============================================================================
# CONTEXTO:
#   Las sesiones 10, 11 y 12 dejaron ~612 archivos untracked / modified que no
#   se pudieron commitear porque el File Provider de macOS para
#   ~/Library/CloudStorage/ bloqueaba syscalls (mmap timeout, read timeout).
#
#   Solución probada: reiniciar el Mac. Tras el cold boot, ANTES de abrir
#   OneDrive ni Google Drive, ejecutar este script.
#
# REQUISITOS POST-REBOOT:
#   1. NO abrir OneDrive ni Google Drive (en System Settings → Login Items,
#      desactivarlos temporalmente si arrancan automáticamente).
#   2. Abrir Terminal directamente y ejecutar:
#      cd "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
#      bash scripts/post_reboot_commits.sh
#
# AUTOR: Juan Carlos Muñoz Mora (sesión 12, 2026-05-24)
# =============================================================================

set -euo pipefail

REPO="/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
cd "$REPO"

echo "=== Verificación pre-flight ==="

# Verificar que estamos en main
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
  echo "⚠ ATENCIÓN: estás en rama '$BRANCH', no en 'main'. Confirmá antes de continuar."
  exit 1
fi

# Verificar que no haya File Providers bloqueando
echo "Procesos cloud activos:"
ps -A | grep -iE "onedrive|googledrive|StandaloneUpdat" | grep -v grep || echo "  (ninguno — OK)"
echo ""

read -p "¿Continuar con los 4 commits? (y/n) " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

# Configuración defensiva
git config --local core.fsyncMethod batch 2>/dev/null || true
git config --local core.preloadIndex true 2>/dev/null || true

# ---- COMMIT 1: docs(gov) ----------------------------------------------------
echo "=== Commit 1/4: docs(gov) — 50 archivos gobernanza ==="

git add .gitignore .agent/ .claude/ AGENTS.md CLAUDE.md scripts/post_reboot_commits.sh

git commit -m "$(cat <<'EOF'
docs(gov): gobernanza canónica completa + 3 ADRs MAFAP

22 docs .agent/ + 3 ADRs + thin pointers root. Sesiones 10-12.

Bloques: A (00-04) B (05-07) C (08-09) D (10-19) E (20) F (21).

ADRs: 0008 Master v0.4.0, 0009 MAFAP narrow+full, 0010 Crosswalk MAFAP-OECD-COFOG-MEFP.

.gitignore: 00_Tor/ + 03_literature/pdfs/ excluidos.

[Color: ROJO | ADR-0008, ADR-0009, ADR-0010]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
)"

echo "✓ Commit 1 hecho: $(git log -1 --oneline)"
echo ""

# ---- COMMIT 2: docs(lit) ----------------------------------------------------
echo "=== Commit 2/4: docs(lit) — 470 archivos corpus literatura sesión 11 ==="

git add 03_literature/

git commit -m "$(cat <<'EOF'
docs(lit): corpus de literatura sistemático (sesión 11)

Reorganización completa del corpus de evidencia para el APER 2026.

Antes: 11 entradas BibTeX dispersas en references.bib.
Ahora: 359 entradas BibTeX en references_master.bib + 325 fichas
markdown organizadas en 11 carpetas temáticas + evidence_map + README.

11 carpetas temáticas:
01_systematic_reviews (23)  · 02_public_spending (34)
03_productivity_efficiency (33) · 04_climate_food_security (33)
05_value_chains (34) · 06_smallholder_indigenous (29)
07_subsidies_repurposing (39) · 08_institutions_programs (32)
09_methods_per_pse (38) · 10_macro_growth_poverty (23)
11_local_multilateral_bolivia (46)

Cobertura temporal: 1957-2025 (Farrell, Schultz → IMF 2025, OECD 2025).

evidence_map.md: mapeo evidencia → 6 capítulos del APER con fuentes
ancla obligatorias por capítulo, 6 patrones transversales identificados,
10 vacíos de evidencia documentados.

PDFs (1 GB, 163 archivos) excluidos vía .gitignore — descargables vía
scripts/dl_pdfs.sh.

[Color: AMARILLO]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
)"

echo "✓ Commit 2 hecho: $(git log -1 --oneline)"
echo ""

# ---- COMMIT 3: feat(data+code) ----------------------------------------------
echo "=== Commit 3/4: feat(data+code) — panel + scripts MAFAP ==="

git add 01_data/ 02_code/

git commit -m "$(cat <<'EOF'
feat(data+code): pipeline MAFAP + datos procesados

Datos procesados canónicos:
- panel v12 (176 vars × 35 años) + dictionary + RDS/CSV gemelos
- panel subnacional v2, municipal v3
- DEA dataset, PSE/CSE/NRP, IDB AgriMonitor LAC
- crosswalk_mafap_oecd_cofog.csv (41 entradas 4-way: A:9 B:5 C:5 D:14 E:8)
  formalizado por ADR-0010

Scripts nuevos sesión 12:
- 02_code/02_cleaning/17_mafap_classification.R (270 líneas):
  lee panel v12 + crosswalk → produce mafap_bolivia.rds
  con 2 cifras paralelas del GAP (narrow + full)
  + 5 tests T1-T5 + log de cobertura
- 02_code/04_visualization/11_figures_mafap.R (243 líneas):
  produce fig18a/b/c/d + fig18_summary en SVG + PNG 600 DPI + PDF
  con paleta APER 2026 + theme institucional

Scripts pre-existentes sesiones 10-11 (BOOST, VIPFE, INE, BCB, Jubileo,
PSE-IDB, MapBiomas, Hansen, CHIRPS, FAO-MAFAP).

[Color: ROJO | ADR-0009, ADR-0010]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
)"

echo "✓ Commit 3 hecho: $(git log -1 --oneline)"
echo ""

# ---- COMMIT 4: docs(report+admin) -------------------------------------------
echo "=== Commit 4/4: docs(report+admin) — apéndice MAFAP + RETOMAR ==="

git add 04_report/ 05_outputs/ 00_admin/RETOMAR.md

git commit -m "$(cat <<'EOF'
docs(report+admin): apéndice C glosario MAFAP + RETOMAR sesión 12

Apéndice C (`04_report/appendix/C_glosario_mafap.qmd`, 171 líneas, 9
secciones C.1-C.9):
- Conceptos previos MAFAP vs OECD-PSE
- Categorías A-E con sub-códigos bilingües ES/EN
- Notas operativas Bolivia (crédito BDP, EMAPA, riego, caminos)
- Tabla equivalencias OECD-PSE
- Citación canónica

RETOMAR.md actualizado con bloque sesión 12 (Parte 15 del MASTER):
- Resumen del cambio: gobernanza completa + 6 bloqueadores MAFAP
  cerrados + corpus literatura integrado
- 3 ADRs creados (0008, 0009, 0010)
- 6 siguientes pasos: ejecutar scripts MAFAP, sync biblio, carta MEFP,
  coordinación Hector, registrar R-014-R-018, activar /write-section
  Cap 1

[Color: AMARILLO]

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF
)"

echo "✓ Commit 4 hecho: $(git log -1 --oneline)"
echo ""

# ---- PUSH ------------------------------------------------------------------
echo "=== Push a remote ==="
read -p "¿Pushear a origin/main? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git push origin main
  echo "✓ Push hecho"
fi

echo ""
echo "=== RESUMEN ==="
git log --oneline -5
echo ""
echo "✅ Todos los commits ejecutados con éxito."
