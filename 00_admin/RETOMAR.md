# Cómo retomar el proyecto — APER Bolivia 2026

**Última sesión:** 2026-04-27 (sesión 9 cerrada)
**Estado global:** ✅ Datos consolidados · ✅ Sitio público live · 🟡 Reporte técnico pendiente · 📨 Carta MEFP lista

---

## 1. Sitio público — vivo en GitHub Pages

**🌐 https://jcmunozmora.github.io/bolivia-wb-aper-2026/**

10 páginas: index · proyecto · **avances vs 2011** · sector · gasto · eficiencia · **timeline (componente custom)** · **slides (deck embebido)** · datos · recursos.

- **40 figuras** del pipeline integradas con narrativa coherente
- **3 figuras analíticas del timeline** (densidad anual, heatmap categoría×año, distribución por gobierno)
- **Timeline custom en JS vanilla** — sin dependencias externas, paleta navy/terracota, filtros por categoría + búsqueda
- **Galería visual** con 57 cards de hitos (imágenes Wikimedia locales)
- **Deck del kickoff BM 2026-04-27** embebido (HTML 3.8 MB + PDF 630 KB)
- **15 descargas** disponibles (reportes BM, carta MEFP + 3 anexos, inventario Excel, datasets, slides)

Source en [`www/`](../www) · Renderizado en [`docs/`](../docs) · Deploy automático cada push a `main` con cambios en `docs/` (GitHub Pages nativo, no usar el workflow custom `publish-site.yml.disabled`).

---

## 2. Estado de datos al cierre

### Datos consolidados
- **Panel v12** (canónico): `01_data/processed/spending_panel_v12.rds` — 35 años × **176 vars limpias**
- **Diccionario v12**: `spending_panel_v12_dictionary.csv` (17 grupos clasificados)
- **Panel subnacional v2**: 90 × 36 (2012-2021)
- **Panel municipal v3**: 3,368 × 70
- **DEA-ready**: 81 DMUs × 32 vars
- **125 datasets RDS**, 142 MB

### Inventario código y outputs
- **43** scripts recolección + **8** análisis + **4** visualización (incluye `09_figures_timeline.R` y `10_timeline_csv_to_json.R`)
- **40 figuras** PNG en `05_outputs/figures/`
- **7 fichas MDRyT** en `03_literature/mdryt_fichas/`
- **61 hitos** timeline + **61 imágenes** locales
- **Slide kickoff BM** en `slides/2026-04-27_kickoff/` (qmd + html + pdf)

---

## 3. Próximos pasos al retomar

### Esta semana
1. **Enviar carta MEFP** — completar 5 campos `⚠` (fecha, firmante, cargo, correo, teléfono) y coordinar con oficina BM Bolivia
2. **Re-correr regresiones** sobre panel v12 corregido (`02_code/03_analysis/08_extended_regressions.R`)

### Siguientes
3. **DEA bootstrap Simar-Wilson** sobre `dea_dataset.rds` (81 DMUs ya listo)
4. **Validar anomalía PP caña 2015** (PP doméstico 261 USD/t vs ref 37 USD/t — verificar con INE)
5. **Reporte técnico formal Quarto book** — `04_report/` tiene 6 capítulos con placeholders; poblar en paralelo al sitio web público
6. **Pre-review interno con equipo BM** una vez listo el primer borrador del reporte técnico

---

## 4. Comandos rápidos

```bash
# R del proyecto
/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file

# Cargar panel canónico
Rscript --no-init-file -e 'p <- readRDS("01_data/processed/spending_panel_v12.rds"); dim(p)'

# Renderizar el sitio (usa LANG=en_US.UTF-8 para acentos)
cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render

# Estado git
git log --oneline -10

# Test local del sitio
cd docs && python3 -m http.server 8000  # → http://localhost:8000
```

---

## 5. Convenciones del proyecto (recordatorios)

- **Panel canónico actual:** v12 (176 vars). NO usar v10 ni v11 (tienen bugs).
- **Deflactor:** CPI base 2015 INE Bolivia; BOB 2015 + USD WDI.
- **Dummy estructural obligatorio:** `post_ley393` en regresiones de crédito.
- **CHIRPS:** flag `source` para distinguir interpolado vs original.
- **R con caracteres acentuados:** `Sys.setlocale("LC_ALL", "en_US.UTF-8")` antes de I/O.
- **JSON con UTF-8:** usar `jsonlite::write_json()`, NO `writeLines(toJSON(...))`.
- **MDRyT site:** bloqueado por Cloudflare — usar Wayback con HTTP (no HTTPS).
- **Workflow GitHub:** solo el nativo de Pages (Settings · Pages · Deploy from branch · main · /docs). El custom queda desactivado en `publish-site.yml.disabled`.

---

## 6. Hallazgos cuantitativos del estudio (8 para el reporte)

| # | Hallazgo | Cifra clave |
|:-:|----------|:-----------:|
| 1 | Inversión ×10 vs TFP estancada | TFP +30% / Inv ×10 (2000-2015) |
| 2 | PSE Bolivia en LAC | **5.8%** (5° puesto) |
| 3 | Patrón dual NRP | Soya −37% / Maíz +46% |
| 4 | Maputo nunca alcanzado | máx **3.48%** en 1990 |
| 5 | Sustitución gasto → crédito | Crédito ×11.7 (2010-2024), Ley 393 |
| 6 | Pobreza rural revierte | 55→40→**45%** (2012-2024) |
| 7 | PAR III subejecutado | **16%** financiero en 2024 |
| 8 | Frontera agropecuaria | **9.4 M ha** perdidas / 64% Santa Cruz |

---

## 7. Archivos clave para recuperar contexto

| Archivo | Contenido |
|---------|-----------|
| `00_admin/ESTADO_DE_DATOS.md` | Inventario completo y gaps |
| `00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx` | Resumen ejecutivo (5 hojas) |
| `01_data/processed/spending_panel_v12_dictionary.csv` | Diccionario de las 176 vars |
| `03_literature/mdryt_fichas/README.md` | Índice de las 7 fichas MDRyT |
| `01_data/timeline/README.md` | Documentación timeline |
| `slides/README.md` | Convenciones de slides |
| `www/index.qmd` | Landing del sitio público |
| **Este archivo** | Tu punto de entrada para retomar |

---

## 8. Bugs corregidos en sesión 9 (no repetir)

1. **MapBiomas nombres truncados** — `gsub("[^a-z0-9]+", ...)` antes de `tolower()` consume mayúsculas iniciales (`Natural` → `atural`). Aplicar siempre `tolower()` PRIMERO.
2. **Duplicados WDI vs OWID** — verificar correlación antes de hacer merge; los idénticos elimine, los con diff renombre por fuente (`fao_*`, `ine_*`, `wdi_*`).
3. **JSON con bytes UTF-8 escapados como texto** — `writeLines()` en locale C escapa `—` como `<e2><80><94>`. Usar `jsonlite::write_json()` directo.
4. **Dos workflows GitHub Pages compitiendo** — custom + nativo causa race conditions y failures intermitentes. Mantener solo uno.
5. **Quarto .qmd con paths absolutos `here::here()`** — funciona local pero rompe en GitHub Pages. Usar paths relativos del sitio (`figures/`, `downloads/`).

---

**Responsable:** Juan Carlos Muñoz Mora — `jcmunozmora@gmail.com`
**Repositorio:** https://github.com/jcmunozmora/bolivia-wb-aper-2026
