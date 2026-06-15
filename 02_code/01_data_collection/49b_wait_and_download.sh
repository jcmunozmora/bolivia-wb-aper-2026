#!/usr/bin/env bash
# 49b_wait_and_download.sh
# Espera a que el endpoint acteco-treemap por-entidad de MEFP se recupere de la
# saturación, luego corre la descarga municipal secuencial y el parseo. Reanudable
# (el cache de JSON protege el progreso). Notifica al terminar.
set -u
REPO="/Users/jcmunoz/github_repositories/bolivia-wb-aper-2026"
RSCRIPT="/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript"
PROBE="https://abierto.economiayfinanzas.gob.bo/api/acteco-treemap?gestion=2018&entidad=1302"
cd "$REPO" || exit 1

echo "[$(date +%H:%M)] Esperando recuperación del endpoint por-entidad..."
tries=0
until curl -s -k "$PROBE" --max-time 25 -o /tmp/mefp_probe.json 2>/dev/null \
      && jq -e 'type=="array" and length>0' /tmp/mefp_probe.json >/dev/null 2>&1; do
  tries=$((tries+1))
  echo "[$(date +%H:%M)] intento $tries: aún degradado, espero 60s"
  sleep 60
  if [ "$tries" -ge 720 ]; then
    echo "[$(date +%H:%M)] ABORTADO: 720 intentos (~12 h) sin recuperación."
    exit 2
  fi
done

echo "[$(date +%H:%M)] ✓ Endpoint recuperado tras $tries intentos. Iniciando descarga."

# Hasta 4 pasadas: cada una salta lo cacheado y reintenta los pendientes.
# Si el servidor se vuelve a degradar a mitad, la siguiente pasada recupera el resto.
for pass in 1 2 3 4; do
  have=$(ls "$REPO/01_data/raw/external_gasto_2026/muni_treemap/" 2>/dev/null | wc -l | tr -d ' ')
  echo "[$(date +%H:%M)] ── pasada $pass · cacheados=$have/2940"
  if [ "$have" -ge 2930 ]; then echo "cobertura suficiente"; break; fi
  $RSCRIPT --no-init-file 02_code/01_data_collection/49_download_mefp_muni_programatico.R
  # si el endpoint volvió a morir, esperar antes de reintentar
  if ! ( curl -s -k "$PROBE" --max-time 25 -o /tmp/mefp_probe.json 2>/dev/null \
         && jq -e 'type=="array" and length>0' /tmp/mefp_probe.json >/dev/null 2>&1 ); then
    echo "[$(date +%H:%M)] endpoint degradado de nuevo; espero 120s"
    sleep 120
  fi
done

echo "[$(date +%H:%M)] Descarga terminada. Parseando..."
$RSCRIPT --no-init-file 02_code/02_cleaning/51_parse_mefp_muni_programatico.R
echo "[$(date +%H:%M)] ✓ COMPLETO."
