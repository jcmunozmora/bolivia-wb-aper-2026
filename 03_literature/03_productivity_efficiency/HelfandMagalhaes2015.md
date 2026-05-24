---
citekey: HelfandMagalhaes2015
audit_status: green  # Fase 3 audit 2026-05-23 (verificado vs PDF)
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "PDF coincide: title 'Brazil's Agricultural Total Factor Productivity Growth by Farm Size', autores Helfand/Magalhaes/Rada, AAEA Annual Meeting San Francisco julio 2015, financiamiento IDB+FAPESP. Abstract y intro confirmados."
type: unpublished
title: "Brazil's Agricultural Total Factor Productivity Growth by Farm Size"
authors: "Helfand, Steven M. & Magalhães, Marcelo M. & Rada, Nicholas E."
year: 2015
source: "AAEA Annual Meeting Selected Paper, San Francisco"
volume: ""
issue: ""
pages: "82"
doi: ""
url: "https://ageconsearch.umn.edu/record/204875"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/HelfandMagalhaes2015.pdf"
pdf_downloaded: true
evidence_level: 5
geographic_scope: "Brasil"
period_covered: "1985-2006"
language: "en"
methodology: "TFP por tamaño (censo); descomposición"
relevance_chapters: ["Cap4"]
relevance_score: "Media"
quality_score: 2
tags: ["TFP", "Brasil", "farm_size", "censo", "background"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Helfand, Magalhães & Rada (2015) Brazil TFP by farm size (working paper)

## 1. Referencia bibliográfica

> Helfand, S. M., Magalhães, M. M., & Rada, N. E. (2015). *Brazil's Agricultural Total Factor Productivity Growth by Farm Size*. Selected Paper, Agricultural and Applied Economics Association Annual Meeting, San Francisco, July 2015. https://ageconsearch.umn.edu/record/204875

## 2. Resumen ejecutivo

Working paper extenso (82 pp.) que es el background del artículo publicado posteriormente en Food Policy (`RadaHelfand2018`). Contiene el detalle metodológico completo: derivación de los índices TFP por tamaño de finca, especificación del modelo de descomposición, tests de robustez, tablas exhaustivas por estado brasileño.

Útil para el APER como **referencia metodológica detallada** (más profunda que el artículo publicado) si se quiere replicar el enfoque con datos bolivianos.

## 3. Pregunta

- ¿Cómo se construye un índice TFP por categoría de tamaño de finca con datos censales y qué metodología es robusta?

## 4. Marco

- Mismo de `RadaHelfand2018` pero con más detalle metodológico.
- Categorías: 7 estratos de tamaño.

## 5. Datos / método

- Censo Agropecuario IBGE 1985, 1995, 2006.
- Construcción de input/output index por estrato y por estado.
- Software referencia: Stata, R.

## 6. Hallazgos clave

- Confirmación de los hallazgos del Food Policy paper.
- Más detalle por subgrupos regionales: Norte, Nordeste, Sudeste, Sul.

## 7. Aplicación al APER 2026 Bolivia

| Cap. | Uso |
|------|-----|
| Cap. 4 | Referencia metodológica detallada si APER replica para Bolivia |

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Snippet ES + EN

**ES:**
> [@HelfandMagalhaes2015] proveen la metodología detallada para construir índices de TFP por estrato de tamaño de finca a partir de censos agropecuarios — receta replicable para Bolivia usando el Censo Agropecuario 2013 [TBV].

**EN:**
> [@HelfandMagalhaes2015] provide the detailed methodology for constructing farm-size-stratified TFP indices from agricultural censuses — a replicable recipe for Bolivia using the 2013 Agricultural Census [TBV].

## 10. BibTeX

```bibtex
@unpublished{HelfandMagalhaes2015,
  author = {Helfand, Steven M. and Magalh{\~a}es, Marcelo M. and Rada, Nicholas E.},
  title  = {Brazil's Agricultural Total Factor Productivity Growth by Farm Size},
  note   = {Selected paper, AAEA Annual Meeting, San Francisco, July 2015},
  year   = {2015},
  url    = {https://ageconsearch.umn.edu/record/204875}
}
```

## 11. Status

- [x] Metadatos · [x] PDF descargado · [x] BibTeX · [x] Snippet · [x] Cap 4
