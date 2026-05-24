---
citekey: BadunenkoTauchmann2019
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/Stata Journal 19(4):950-988/DOI. Sin PDF: cifras §6 no verificadas."
type: article
title: "Simar and Wilson two-stage efficiency analysis for Stata"
authors: "Badunenko, Oleg & Tauchmann, Harald"
year: 2019
source: "The Stata Journal"
volume: "19"
issue: "4"
pages: "950-988"
doi: "10.1177/1536867X19893640"
url: "https://journals.sagepub.com/doi/10.1177/1536867X19893640"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/BadunenkoTauchmann2019.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "2019"
language: "en"
methodology: "Software: módulo Stata simarwilson"
relevance_chapters: ["Cap4"]
relevance_score: "Media-Alta"
quality_score: 3
tags: ["DEA", "Stata", "two_stage", "simarwilson", "bootstrap", "implementacion"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Badunenko & Tauchmann (2019) `simarwilson` Stata

## 1. Referencia bibliográfica

> Badunenko, O., & Tauchmann, H. (2019). Simar and Wilson two-stage efficiency analysis for Stata. *The Stata Journal*, 19(4), 950–988. https://doi.org/10.1177/1536867X19893640

## 2. Resumen ejecutivo

Paper de documentación del **módulo Stata `simarwilson`** que implementa los algoritmos #1 y #2 de Simar-Wilson (2007). Sintaxis cómoda, automatiza la corrección de sesgo y el doble bootstrap. Para usuarios Stata, es la implementación de referencia. Equivalente funcional a FEAR (R) de Wilson (2008).

Crítica útil al naïve Tobit two-stage: documenta empíricamente la sobreidentificación del Tobit cuando se compara con SW-2007 en Monte Carlo, replicando los hallazgos teóricos del paper original.

## 3. Funcionalidad

| Comando | Funcionalidad |
|---------|---------------|
| `simarwilson` | DEA + truncated regression + doble bootstrap |
| Opciones | `algorithm(1|2)`, `reps()`, `dgp()`, `rc(bias-corrected)` |

## 4. Tabla comparativa de métodos (replicada del paper)

| Método | Sesgo | Cobertura IC 95% |
|--------|-------|------------------|
| OLS (naïve) | Alto | Sub-nominal |
| Tobit two-stage | Medio | Sub-nominal |
| SW-2007 Algoritmo #1 | Bajo | ~95% |
| SW-2007 Algoritmo #2 | Mínimo | ~95% |

## 5. Aplicación al APER 2026

| Capítulo | Uso | Sección |
|----------|-----|---------|
| Cap. 4 | Alternativa Stata para implementar la estrategia DEA Simar-Wilson | §4.2 Estrategia empírica |

## 6. Limitaciones

- Solamente cross-sectional / agrupado, no panel dinámico.
- Reps altos (≥ 2000) son lentos para muestras grandes.

## 7. Vínculos

- Implementa: `SimarWilson1998`, `SimarWilson2007`.
- Alternativa R: `Wilson2008FEAR`.

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
@article{BadunenkoTauchmann2019,
  author  = {Badunenko, Oleg and Tauchmann, Harald},
  title   = {Simar and {Wilson} two-stage efficiency analysis for {Stata}},
  journal = {The Stata Journal},
  year    = {2019},
  volume  = {19},
  number  = {4},
  pages   = {950--988},
  doi     = {10.1177/1536867X19893640}
}
```

## 10. Status

- [x] Metadatos · [ ] PDF (Sage paywalled; econstor copia disponible vía wayback) · [x] BibTeX · [x] Snippet · [x] Cap 4
