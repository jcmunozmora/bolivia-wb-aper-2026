#!/usr/bin/env bash
# =============================================================================
# 00_download_raw.sh
# Descarga todos los datos raw necesarios para reproducir el proyecto desde
# cero. URLs verificadas al 2026-04-21. Tamaño total: ~400 MB.
# =============================================================================
# Uso:
#   bash scripts/00_download_raw.sh
# =============================================================================

set -u
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15"
CURL_OPTS=(-L -k -s -A "$UA" --max-time 180 --retry 2 --retry-delay 5)

say()   { printf "\n\033[1;34m[%s]\033[0m %s\n" "$(date +%H:%M:%S)" "$*"; }
ok()    { printf "  \033[1;32m✓\033[0m %s\n" "$*"; }
fail()  { printf "  \033[1;31m✗\033[0m %s\n" "$*"; }

dl() {
  local url="$1" out="$2"
  mkdir -p "$(dirname "$out")"
  if [ -f "$out" ] && [ -s "$out" ]; then
    ok "SKIP existente: $(basename "$out") ($(du -h "$out" | cut -f1))"
    return 0
  fi
  local code=$(curl "${CURL_OPTS[@]}" -o "$out" -w "%{http_code}" "$url")
  local sz=$(stat -f%z "$out" 2>/dev/null || echo 0)
  if [ "$code" = "200" ] && [ "$sz" -gt 1000 ]; then
    ok "$(basename "$out") ($((sz/1024)) KB, HTTP $code)"
  else
    fail "$(basename "$out") HTTP $code — revisar URL"
    return 1
  fi
}

# =============================================================================
say "1/6  USDA ERS International Agricultural Productivity (17 MB)"
# =============================================================================
dl "https://www.ers.usda.gov/media/5403/machine-readable-and-long-format-file-of-tfp-indices-and-components-for-countries-regions-countries-grouped-by-income-level-and-the-world-1961-2023.csv?v=73658" \
   "01_data/raw/usda_ers/usda_ers_tfp_international.csv"

# =============================================================================
say "2/6  World Bank APER Bolivia 1996-2008 (26 MB)"
# =============================================================================
dl "https://databank.worldbank.org/data/download/Bolivia-APER.xlsx" \
   "01_data/raw/boost/WB_Bolivia_APER.xlsx"

# =============================================================================
say "3/6  WDI Bulk CSV (~267 MB)"
# =============================================================================
WDI_ZIP="01_data/raw/wdi/WDI_CSV.zip"
dl "https://databank.worldbank.org/data/download/WDI_CSV.zip" "$WDI_ZIP"
if [ -f "$WDI_ZIP" ] && [ ! -f "01_data/raw/wdi/WDICSV.csv" ]; then
  say "  Extrayendo WDI ZIP..."
  unzip -o "$WDI_ZIP" -d "01_data/raw/wdi/" > /dev/null
  ok "WDI extraído"
fi

# =============================================================================
say "4/6  MEFP — Boletines fiscales (ssl bypass -k)"
# =============================================================================
dl "https://www.economiayfinanzas.gob.bo/sites/default/files/2025-08/Boletin%20Economico_Informe%20Fiscal%202024.pdf" \
   "01_data/raw/mefp/Informe_Fiscal_2024.pdf"
dl "https://www.economiayfinanzas.gob.bo/sites/default/files/2023-09/BOLETIN%20ECONOMICO%20DE%20ESTADISTICAS%20FISCALES%20DE%20LAS%20ETA%20Y%20UP%202022.pdf" \
   "01_data/raw/mefp/boletin_eef_eta_2022.pdf"
dl "https://www.economiayfinanzas.gob.bo/sites/default/files/2024-11/Boletin%20Economico_Informe%20Fiscal%202023.pdf" \
   "01_data/raw/mefp/Informe_Fiscal_2023.pdf"
dl "https://www.economiayfinanzas.gob.bo/sites/default/files/2023-08/Clasificadores_Presupuestarios_Gestion_2023.pdf" \
   "01_data/raw/mefp/clasificadores_2023.pdf"

# =============================================================================
say "5/6  Our World in Data — FAOSTAT proxies (~3 MB total)"
# =============================================================================
OWID_BASE="https://ourworldindata.org/grapher"
for pair in \
  "cereal_yield:cereal-yield" \
  "maize_yield:maize-yields" \
  "potato_yield:potato-yields" \
  "soya_production:soybean-production" \
  "arable_land:agricultural-land" \
  "agr_land:agricultural-land-per-person" \
  "food_supply_kcal:daily-per-capita-caloric-supply" \
  "undernourishment:prevalence-of-undernourishment"
do
  name="${pair%%:*}"
  slug="${pair##*:}"
  dl "${OWID_BASE}/${slug}.csv?v=1&csvType=full" \
     "01_data/raw/faostat/owid_${name}.csv"
done

# =============================================================================
say "6/6  Otros: WB reports, UDAPE, DS 28168"
# =============================================================================
dl "https://documents1.worldbank.org/curated/en/739681617168032843/pdf/Tapping-the-Potential-of-Bolivia-s-Agriculture-and-Food-Systems-to-Support-Inclusive-and-Sustainable-Growth.pdf" \
   "01_data/raw/wb_reports/WB_Tapping_Potential_2021.pdf"
dl "https://documents1.worldbank.org/curated/en/686201467997891993/pdf/596960ESW0p1120SPANISH0Bolivia0APER.pdf" \
   "01_data/raw/wb_reports/WB_APER_2011_Spanish.pdf"
dl "https://www.udape.gob.bo/wp-content/uploads/Colecciones/Diagnosticos/diagnostico2023/documentos/agropecuario.pdf" \
   "01_data/raw/mefp/udape_agropecuario_2023.pdf"
dl "https://www.planificacion.gob.bo/uploads/normativa/decreto_supremo_28168.pdf" \
   "01_data/raw/mefp/DS_28168_acceso_informacion.pdf"

# =============================================================================
# NOTA SOBRE DATOS MANUALES
# =============================================================================
cat <<'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DESCARGAS MANUALES REQUERIDAS (no automáticas):

1. IDB Agrimonitor (91 MB) — requiere click en portal web:
     URL: https://data.iadb.org/dataset/idb-agrimonitor-producer-support-estimates-pse-agricultural-policy-monitori
   Descargar ZIP completo y descomprimir en:
     01_data/raw/idb_agrimonitor/

2. INE Bolivia — Estadísticas Agrícolas (Excel, ~1.5 MB):
     Producción: https://nube.ine.gob.bo/index.php/s/V7sVhYgtH9GT2fd/download
     Rendimiento: https://nube.ine.gob.bo/index.php/s/9Th8JQ7vyccdEO7/download
     Superficie: https://nube.ine.gob.bo/index.php/s/PnEqp7IopHEJDBu/download
   Guardar como:
     01_data/raw/ine_bolivia/agro_stats/agro_{produccion,rendimiento,superficie}_depto.xlsx

3. INE PIB Departamental (30 archivos, ~3 MB total):
     https://www.ine.gob.bo/referencia2017/pib_departamental.html
   Descargar D.1.2.1.xlsx hasta D.10.2.2.xlsx en:
     01_data/raw/ine_bolivia/pib_dept/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

say "Completado. Resumen de espacio:"
du -sh 01_data/raw/*/ 2>/dev/null | sort -hr

say "Próximo paso: Ejecutar pipeline R"
echo "  Rscript 02_code/00_setup/00_packages.R"
echo "  Rscript 02_code/01_data_collection/07_download_spatial.R"
echo "  Rscript 02_code/01_data_collection/15_process_idb_agrimonitor.R"
echo "  ... (ver README.md para orden completo)"
