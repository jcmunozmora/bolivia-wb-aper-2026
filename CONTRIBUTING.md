# Guía de contribución

Gracias por tu interés en este proyecto. Esta es la guía para colaborar
en el *Bolivia Agricultural Public Expenditure Review 2026*.

## Principios del proyecto

1. **Reproducibilidad primero**: todo cambio debe mantener el pipeline ejecutable end-to-end desde raw a figuras.
2. **Datos públicos**: no usamos fuentes con restricción de acceso sin documentar cómo obtenerlas.
3. **Transparencia metodológica**: decisiones documentadas en el código y en `04_report/appendix/A_data_sources.qmd`.
4. **Idioma**: código en inglés (nombres de variables/funciones), comentarios y documentación en español.

## Setup inicial

```bash
# 1. Clonar
git clone https://github.com/jcmunozmora/bolivia-wb-aper-2026.git
cd bolivia-wb-aper-2026

# 2. Descargar datos raw (no están en el repo, ~400 MB)
bash scripts/00_download_raw.sh

# 3. Descargas manuales (ver output del script anterior):
#    - IDB Agrimonitor (91 MB) desde portal web
#    - INE PIB Departamental (30 archivos Excel)
#    - INE Estadísticas Agrícolas (3 archivos Excel)

# 4. Instalar paquetes R
Rscript -e 'install.packages("renv"); renv::restore()'

# 5. Ejecutar pipeline completo
Rscript 02_code/00_setup/00_packages.R
Rscript 02_code/01_data_collection/07_download_spatial.R
# ... (ver README.md sección "Reproducibilidad rápida")
```

## Flujo de trabajo

### Branches

- `main` — versión estable del análisis (siempre reproducible)
- `develop` — trabajo en curso
- `feature/xxx` — nuevas funcionalidades
- `data/xxx` — integración de nuevas fuentes
- `fix/xxx` — correcciones

### Commits

Formato sugerido (inspirado en [Conventional Commits](https://www.conventionalcommits.org/)):

```
<tipo>(<scope>): <asunto>

[cuerpo opcional explicando el por qué]

[footer con referencias]
```

Tipos:
- `data`: nueva fuente de datos o actualización
- `analysis`: análisis econométrico o estadístico
- `fig`: nueva figura o mejora visual
- `doc`: documentación (README, anexos)
- `refactor`: reestructuración sin cambio funcional
- `fix`: corrección de bug en pipeline
- `ci`: workflows de GitHub Actions
- `repro`: mejoras a reproducibilidad

Ejemplos:
```
data(idb): integrate Agrimonitor PSE 2006-2023 to master panel v3
analysis(dea): add Simar-Wilson bootstrap for 9 departments
fig(pse): add cross-country %PSE comparison Bolivia vs LAC
fix(mefp): handle SSL cert issue with curl -k
```

## Estándares de código

### R

- **Estilo**: seguir [tidyverse style guide](https://style.tidyverse.org/)
- **Paquetes preferidos**: `data.table` (performance) + `tidyverse` (legibilidad) + `ggplot2` + `sf`
- **No usar `setwd()`** — usar rutas relativas desde la raíz del proyecto
- **Deflactores y tipo cambio**: usar siempre los del archivo `01_data/external/inflation_deflators.csv` y `exchange_rates.csv`
- **Año base**: 2015 para BOB constantes (proyecto-wide)

### Estructura de un script nuevo

```r
# Descripción breve del script — una línea
# Detalle adicional: qué hace, inputs, outputs

library(data.table)
library(tidyverse)

# ── Rutas ────────────────────────────────────────────────────────────────────
root     <- "/path/al/proyecto"  # o aquí aquí::here() si preferido
proc_dir <- file.path(root, "01_data/processed")

# ── 1. Load ──────────────────────────────────────────────────────────────────
d <- readRDS(file.path(proc_dir, "input.rds"))

# ── 2. Process ───────────────────────────────────────────────────────────────
# ...

# ── 3. Save ──────────────────────────────────────────────────────────────────
saveRDS(result, file.path(proc_dir, "output.rds"))
cat("Guardado: output.rds\n")
```

## Cómo agregar una nueva fuente de datos

1. **Documentar en `04_report/appendix/A_data_sources.qmd`**:
   - URL exacta
   - Período cubierto
   - Granularidad
   - Licencia
   - Advertencias metodológicas
2. **Crear script en `02_code/01_data_collection/XX_<nombre>.R`**:
   - Descarga (si API) o procesamiento (si archivo manual)
   - Outputs en `01_data/processed/`
3. **Actualizar `scripts/00_download_raw.sh`** si hay descarga automática
4. **Actualizar `DATASET_INDEX.md`** con el nuevo archivo
5. **Integrar al panel maestro en `02_code/02_cleaning/08_integrate_pse.R`** (o crear `09_integrate_*.R` si amerita nuevo script)
6. **Agregar tests básicos** (completitud, rangos plausibles)
7. **Actualizar README** si es fuente crítica

## Cómo agregar una nueva figura

1. **Script de generación** en `02_code/03_analysis/` o inline si es simple
2. **Usar tema WB**: `source("02_code/04_visualization/00_wb_theme.R")`
3. **Colores principales**: `WB_BLUE`, `WB_NAVY`, `WB_TEAL`, `WB_RED`, `WB_GREY`
4. **Guardar en `05_outputs/figures/`** como `figXX_<descripcion>.png` (150 dpi)
5. **Documentar en `A_data_sources.qmd` sección "Catálogo de figuras"**

## Preguntas frecuentes

**¿Por qué no hay datos raw en el repo?**
Superan 400 MB en total (WDI 187 MB, IDB 91 MB, ENA INE 200 MB+).
GitHub tiene límite de 100 MB por archivo. Los scripts los re-descargan.

**¿Cómo verifico que mi pipeline es reproducible?**
```bash
# Desde carpeta limpia:
rm -rf 01_data/raw/ 01_data/processed/spending_panel_v3.rds
bash scripts/00_download_raw.sh
Rscript scripts/01_run_all.R  # [por crear]
```

**¿Qué hago si se actualiza una fuente con más años?**
1. Re-descargar raw (`scripts/00_download_raw.sh`)
2. Re-ejecutar parser correspondiente (ej. `15_process_idb_agrimonitor.R`)
3. Re-construir panel (`08_integrate_pse.R`)
4. Re-generar figuras afectadas
5. Commit con mensaje `data(<fuente>): update to <año>`

## Contactos

- **Mantainer principal**: Juan Carlos Muñoz Mora (jcmunozmora@gmail.com)
- **Issues/bugs**: abrir issue en GitHub
- **Datos nuevos**: contactar directamente antes de PR grandes

## Código de conducta

- Respeto en todas las interacciones
- Discusiones basadas en evidencia técnica
- Dar crédito a fuentes originales
- No incluir datos privados o confidenciales
