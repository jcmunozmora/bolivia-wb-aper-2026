---
citekey: MAFAP2013_MethodGuideVolI
audit_status: green
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "PDF verificado. Autoría confirmada (Barreiro-Hurle & Witwer 2013), FAO MAFAP. Marco conceptual NRP/MDG/NRA coherente con TOC del PDF. Citekey correcto."
type: techreport
title: "MAFAP Methodological Implementation Guide. Volume I: Analysis of Price Incentives and Disincentives"
authors: "Barreiro-Hurlé, Jesús and Witwer, Mary"
year: 2013
source: "FAO Monitoring African Food and Agricultural Policies (MAFAP)"
pages: "100"
url: "https://openknowledge.fao.org/server/api/core/bitstreams/ef4fed92-e644-4a63-80bc-f902ee3a2e76/content"
pdf_path: "03_literature/pdfs/09_methods_per_pse/MAFAP2013_MethodGuideVolI.pdf"
pdf_downloaded: true
evidence_level: 2
geographic_scope: "Subsaharan"
period_covered: ""
language: "en"
methodology: "Descriptive"
relevance_chapters: ["Cap3", "Cap5"]
relevance_score: "Alta"
quality_score: 1
tags: ["mafap", "metodologia", "incentivos_precios", "nra", "fao"]
date_read: "2026-05-23"
reviewer: "JC / APER"
---

# Ficha — MAFAP Methodological Implementation Guide Vol I (Price Incentives)

## 1. Referencia

> Barreiro-Hurlé, J., & Witwer, M. (2013). *MAFAP Methodological Implementation Guide. Volume I: Analysis of Price Incentives and Disincentives*. FAO.

## 2. Resumen ejecutivo

Manual técnico para implementar el análisis de incentivos/desincentivos de precios bajo la metodología MAFAP de la FAO. Define cómo calcular Nominal Rate of Protection (NRP), Nominal Rate of Assistance (NRA), Market Development Gap (MDG) usando precios de referencia frontera + ajustes por margen de transporte y procesamiento, distinguiendo entre niveles de Farm Gate y Punto de Competencia (point of competition). Es la guía operativa de la metodología de MAFAP, derivada y simplificada del marco OECD PSE.

## 3. Objetivo

Estandarizar el cálculo país a país de indicadores de distorsión de precios en cadenas agrícolas clave.

## 4. Marco conceptual

Diferencia entre Observed NRP (refleja distorsiones de policy + market) y Adjusted NRP (corrige por costos de acceso al mercado evitables). NRA combina NRP con apoyo presupuestario por unidad de output.

## 5. Datos y método

| Elemento | Spec |
|---|---|
| Indicadores | NRP_obs, NRP_adj, MDG, NRA |
| Datos | Precios paridad import/export, margen acceso, FX, producción |
| Granularidad | Cadena por producto |
| Software | Excel MAFAP templates |
| Replicable | Sí |

## 6. Hallazgos clave (metodológicos)

- NRP = (Pd − Pref) / Pref, evaluado en farm gate.
- MDG = ineficiencia de mercado evitable (costos de transporte excesivos, márgenes anormales).
- Ajustes por calidad y cantidad (quality and quantity adjustments).

## 7. Aplicación APER

| Capítulo | Uso | Sección |
|---|---|---|
| Cap. 3 | Construcción NRP por commodity en Bolivia | §3.4 |
| Cap. 5 | Insumo para MPS PSE-Bolivia | §5.2 |

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. BibTeX

```bibtex
@techreport{MAFAP2013_MethodGuideVolI,
  author      = {Barreiro-Hurl\'e, Jes\'us and Witwer, Mary},
  title       = {{MAFAP Methodological Implementation Guide. Volume I: Analysis of Price Incentives and Disincentives}},
  institution = {FAO Monitoring African Food and Agricultural Policies},
  year        = {2013},
  address     = {Rome},
  url         = {https://openknowledge.fao.org/server/api/core/bitstreams/ef4fed92-e644-4a63-80bc-f902ee3a2e76/content}
}
```

## 10. Status

- [x] PDF, metadata, BibTeX
