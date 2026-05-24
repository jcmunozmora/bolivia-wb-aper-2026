---
citekey: WB_BOOST
audit_status: yellow  # Mantiene yellow tras PDF read sesión 11 — PDF es Guidance Note 2013, no portal 2025
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "PDF leído sesión 11 pdf-recovery — PDF descargado es 'BOOST GUIDANCE NOTE SERIES No 1, August 2013 — Giving a Boost to Public Expenditure Analysis: A Guidance Note for Database Development' por Igor Kheyfets (WB Governance Global Practice). La ficha cita el portal BOOST 'metodología y documentación' año 2025. Son recursos relacionados pero distintos: el PDF es un guidance note operativo de 2013, no la documentación del portal actualizada. Mantiene yellow hasta clarificar si la ficha quiere citar el portal online (URL) o el guidance note (PDF), corrigiendo año correspondiente."
type: techreport
title: "BOOST: Open Budget Portal — Methodology and Documentation"
authors: "World Bank (Macroeconomics, Trade and Investment Global Practice)"
year: 2025
source: "World Bank, Washington DC"
url: "https://www.worldbank.org/en/programs/boost-portal"
pdf_path: "03_literature/pdfs/09_methods_per_pse/WB_BOOST.pdf"
pdf_downloaded: true
evidence_level: 2
geographic_scope: "Global"
period_covered: "2010-2024"
language: "en"
methodology: "Descriptive"
relevance_chapters: ["Cap2", "Cap3"]
relevance_score: "Alta"
quality_score: 1
tags: ["boost", "open_budget", "world_bank", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / APER"
---

# Ficha — WB BOOST Open Budget Portal (Methodology)

## 1. Referencia

> World Bank (2025). *BOOST: Open Budget Portal — Methodology and Documentation*. Washington DC: World Bank.

## 2. Resumen

BOOST es la iniciativa del Banco Mundial (lanzada 2010) para producir datos de presupuesto público altamente desagregados y comparables internacionalmente. Cubre >90 países, incluyendo Bolivia. Estructura: línea-a-línea por (a) clasificación administrativa, (b) clasificación económica, (c) clasificación funcional (COFOG), (d) clasificación geográfica/territorial, (e) fuente de financiamiento. Bolivia BOOST 2024 es la fuente primaria para el APER panel v12.

## 3. Metodología

Extracción desde sistema SIGMA/SIGEP nacional → estandarización → validación → publicación en data360 o portales locales. Combina ejecución (devengado) y presupuestado para análisis de execution gap.

## 4. Aplicación APER

| Cap | Uso | Sección |
|---|---|---|
| Cap. 2 (datos) | Fuente primaria del panel v12 | §2.1 |
| Cap. 3 (mapping) | Variables BOOST → MAFAP/COFOG | §3.2 |
| Cap. 4 (ejecución) | Análisis budget execution gap | §4.5 |

## 5. Vínculos

- Convergencia con `IMF_GFSM2014` (COFOG).
- Insumo para `MAFAP2014_PEMethodGuideVolII` mapping.

## 6. BibTeX

```bibtex
@misc{WB_BOOST,
  author       = {{World Bank}},
  title        = {{BOOST: Open Budget Portal — Methodology and Documentation}},
  howpublished = {Online resource},
  year         = {2025},
  url          = {https://www.worldbank.org/en/programs/boost-portal}
}
```
