# Bolivia Agricultural Public Expenditure Review 2026

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![R version](https://img.shields.io/badge/R-%E2%89%A5%204.3-blue.svg)](https://www.r-project.org/)
[![Panel](https://img.shields.io/badge/panel-v12_(176_vars,_1990--2024)-green.svg)](./01_data/processed/spending_panel_v12.rds)
[![Site](https://img.shields.io/badge/site-GitHub_Pages-002244.svg)](https://jcmunozmora.github.io/bolivia-wb-aper-2026)
[![Reproducible](https://img.shields.io/badge/reproducible-yes-brightgreen.svg)](./www/replicacion.qmd)

**Cliente:** World Bank — Bolivia Country Office
**Antecedente:** Actualiza el [APER 2011 (Informe N.° 59696-BO)](./01_data/raw/wb_reports/WB_APER_2011_Spanish.pdf)
**Periodo de análisis:** 1990-2024 (nacional) / 2012-2024 (subnacional / municipal)
**Estado:** Datos consolidados (panel v12, 176 vars) · Sitio público publicado · Reporte técnico en validación

## 🌐 Sitio público

Sitio web que reúne hallazgos, datos, una línea de tiempo de política y la guía de reproducción:

**👉 [https://jcmunozmora.github.io/bolivia-wb-aper-2026](https://jcmunozmora.github.io/bolivia-wb-aper-2026)**

Source en [`www/`](./www) · Renderizado en [`docs/`](./docs) · Auto-deploy vía GitHub Actions ([.github/workflows/publish-site.yml](./.github/workflows/publish-site.yml))

## Quickstart

```bash
# 1. Clonar el repo
git clone https://github.com/jcmunozmora/bolivia-wb-aper-2026.git
cd bolivia-wb-aper-2026

# 2. Restaurar el entorno de paquetes R
Rscript -e 'renv::restore()'

# 3. (Opcional) Descargar datos raw (~400 MB, no incluidos en el repo)
bash scripts/00_download_raw.sh

# 4. Construir el panel maestro v12
Rscript scripts/01_run_all.R

# 5. (Opcional) Renderizar el reporte / sitio / slides
quarto render 04_report/
cd www && quarto render && cd ..
```

> Guía de reproducción completa, paso a paso y con trazabilidad: **[www/replicacion.qmd](./www/replicacion.qmd)**.

---

## Descripción

Análisis del gasto público agropecuario para Bolivia siguiendo metodologías OCDE
(PSE), MAFAP-FAO (clasificación por destinatario), IFPRI-SPEED (benchmark fiscal)
y DEA con bootstrap de Simar-Wilson (eficiencia subnacional). Actualiza el
*Agricultural Public Expenditure Review* (WB, 2011) con datos hasta 2024.

**Preguntas centrales:**
1. ¿Cuánto gasta Bolivia en el sector agropecuario y cómo se compara con la región?
2. ¿A quién beneficia el gasto (composición MAFAP) y qué productos reciben apoyo o tasación implícita?
3. ¿Es eficiente el gasto (DEA Simar-Wilson departamental)?
4. ¿Se asocia con productividad (TFP), pobreza y seguridad alimentaria?

---

## Estructura del proyecto

```
00_admin/             Documentos administrativos (ToR, cartas, bitácora RETOMAR.md)
01_data/
├── raw/              Originales inmutables (~1.3 GB, no versionados)
├── processed/        126 datasets limpios (.rds/.csv) — incluye panel v12
└── external/         Shapefiles, clasificadores, deflactores
02_code/              ~107 scripts R del pipeline
├── 00_setup/         Configuración, constantes, paquetes
├── 01_data_collection/   39 scripts — descarga y parseo
├── 02_cleaning/      24 scripts — integración y panel maestro
├── 03_analysis/      11 scripts — PSE, DEA, regresiones, MAFAP
└── 04_visualization/ 33 scripts — tema WB ggplot2
03_literature/        Revisión PRISMA + fichas
04_report/            Quarto Book (6 capítulos + 9 apéndices A–I)
05_outputs/
├── figures/          ~73 figuras WB-theme (PNG/SVG)
└── tables/           Tablas de resultados
www/                  Sitio público (Quarto website)
slides/               Presentaciones (Reveal.js, tema WB)
```

---

## Panel maestro (archivo canónico)

**`01_data/processed/spending_panel_v12.rds`** — 35 años (1990–2024) × 176 variables en 17 grupos temáticos.

| Grupo | Cobertura | Fuente |
|-------|-----------|--------|
| Inversión pública agropecuaria | 1990-2024 | MEFP Informe Fiscal / VIPFE |
| Descomposición programática (MAFAP) | 2016-2024 | MEFP Presupuesto Abierto (`acteco`) |
| PSE / MPS / GSSE / TSE (OCDE) | 1986-2024 | IDB AgriMonitor |
| Gasto detallado por categoría | 1996-2008 | WB BOOST / APER 2011 |
| Crédito agropecuario | 2010-2024 | BCB Boletín Estadístico |
| TFP + outputs + inputs | 1961-2023 | USDA ERS |
| Uso del suelo / deforestación | 1985-2024 | MapBiomas Col. 3 / Hansen GFC |
| Clima (precipitación) | 1981-2024 | CHIRPS |
| Pobreza / seguridad alimentaria | 2012-2024 | INE EH / FAOSTAT FIES |
| Deflactores CPI 2015 | — | Derivado INE/WDI |

> Diccionario completo: [`spending_panel_v12_dictionary.csv`](./01_data/processed/spending_panel_v12_dictionary.csv).
> Estado de cada fuente y gaps: [`00_admin/ESTADO_DE_DATOS.md`](./00_admin/ESTADO_DE_DATOS.md).

---

## Hallazgos centrales (F01–F08)

1. **F01 — Inversión ×10, TFP +30 %.** La inversión pública agropecuaria se multiplicó por diez (2000–2015), pero la TFP creció apenas 30 %; Bolivia avanza más lento que sus pares andinos.
2. **F02 — PSE 5,8 % (2018).** Quinto nivel de apoyo al productor entre los países LAC monitoreados por el IDB AgriMonitor.
3. **F03 — Patrón dual de protección (NRP).** Tasa los exportables (soya −37 %, arroz −33 %) y protege la seguridad alimentaria (maíz +46 %, trigo +28 %).
4. **F04 — Maputo nunca alcanzado.** Máximo histórico 3,48 % del gasto público total (1990); meta del 10 % nunca lograda.
5. **F05 — Sustitución por crédito (Ley 393/2014).** La cartera agropecuaria se multiplicó por ×7,1 real (USD 385 → 2 725 M constantes 2015; ×11,7 nominal), sustituyendo parcialmente la inversión pública.
6. **F06 — Reversión social.** Pobreza rural a 45 % (2024) tras bajar a 40 % (2021); inseguridad alimentaria FIES de 49 % (2019) a 74 % (2024).
7. **F07 — Ejecución subnacional limitada.** Capacidad de ejecución heterogénea; programas subnacionales con baja ejecución acumulada.
8. **F08 — Frontera agropecuaria.** 9,4 M ha de cobertura natural perdidas (1985–2024); 64 % de la expansión antrópica en Santa Cruz.

**Composición MAFAP (2016–2024):** 56 % del gasto a bienes públicos (D) —riego 27 %, I+D, sanidad, extensión—, en retroceso de 64 % (2016) a 45 % (2024) frente al avance del apoyo a productores/consumidores (EMAPA 25 % → 42 %).

**Eficiencia DEA (2012–2020):** eficiencia media corregida 0,60; gradiente Pando 0,85 … Potosí 0,27; la precipitación es un determinante significativo (parte de la brecha es agroecológica).

> Contratos completos de cada hallazgo (cifra, evidencia, script, fuente): [`.agent/04_HALLAZGOS.md`](./.agent/04_HALLAZGOS.md).

---

## Metodología

| Método | Capítulo | Implementación |
|--------|----------|----------------|
| **PSE / NRP** (OCDE) | Cap. 3 | IDB AgriMonitor + NRP propio (FAOSTAT PP vs WB Pink Sheet) |
| **MAFAP** (FAO) | Cap. 2–3 | Descomposición programática MEFP (`acteco`), 36 actividades → A–E |
| **DEA + Bootstrap Simar-Wilson** | Cap. 3 | 9 deptos × 2012-2020 (81 pares), VRS, B=2000, 2ª etapa truncada |
| **Panel FE** (fixest) | Cap. 3 | TFP / pobreza ~ gasto (exploratorio; asociación no robusta, ADR-0017) |
| **Benchmark LAC** | Cap. 1–3 | USDA TFP + IDB PSE + IFPRI SPEED |

---

## Convenciones del proyecto

- **Año base deflactores:** 2015 (USD/BOB constantes de 2015).
- **Tema visual:** World Bank (`#002244` navy, `#009FDA` azul) — coherente entre reporte, sitio y slides.
- **Idioma del reporte:** Español.
- **Sistema de código:** R + Quarto (no Python).
- **Gobernanza:** ver [`.agent/`](./.agent) (master prompt, invariantes, ADRs) y [`AGENTS.md`](./AGENTS.md).

> **Nota de reproducibilidad:** los paquetes del DEA (`Benchmarking`, `truncreg`, `ggrepel`) aún no están congelados en `renv.lock` (pendiente `renv::snapshot()`); instálense manualmente para re-correr `03_dea_efficiency.R`.

---

## Contactos

| Rol | Persona |
|-----|---------|
| Investigador principal | Juan Carlos Muñoz Mora (jcmunozmora@gmail.com) |
| Institución | Universidad EAFIT, Medellín |
| Cliente | World Bank — Bolivia Country Office |

---

*Última actualización: 2026-06-14*
