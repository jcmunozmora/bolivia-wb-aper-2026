---
citekey: SimarWilson2007
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/J Econometrics 136(1):31-64/DOI. Sin PDF."
type: article
title: "Estimation and inference in two-stage, semi-parametric models of production processes"
authors: "Simar, Léopold & Wilson, Paul W."
year: 2007
source: "Journal of Econometrics"
volume: "136"
issue: "1"
pages: "31-64"
doi: "10.1016/j.jeconom.2005.07.009"
url: "https://doi.org/10.1016/j.jeconom.2005.07.009"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/SimarWilson2007.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "2007"
language: "en"
methodology: "Two-stage DEA bootstrap + truncated regression"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["DEA", "two_stage", "bootstrap", "truncated_regression", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Simar & Wilson (2007) Two-stage DEA

## 1. Referencia bibliográfica

> Simar, L., & Wilson, P. W. (2007). Estimation and inference in two-stage, semi-parametric models of production processes. *Journal of Econometrics*, 136(1), 31–64. https://doi.org/10.1016/j.jeconom.2005.07.009

## 2. Resumen ejecutivo

**Paper de referencia metodológica del Capítulo 4 del APER**. Crítica formal y solución estadísticamente fundada al enfoque común de "two-stage DEA": (i) estimar scores DEA en primera etapa, (ii) regresarlos sobre variables explicativas con Tobit (porque están truncados en 1).

Simar & Wilson demuestran que: (a) la regresión Tobit es **inconsistente** porque los scores DEA están serialmente correlacionados (la frontera depende de todas las DMUs), (b) la inferencia estándar es inválida, y (c) el modelo correcto involucra **truncated regression** + **doble bootstrap** (algoritmos #1 y #2 del paper).

La solución: Algoritmo #1 usa scores DEA originales + truncated regression + bootstrap simple. Algoritmo #2 usa scores bias-corrected (vía Simar-Wilson 1998) + truncated regression + doble bootstrap para inferencia. El algoritmo #2 es el estándar moderno.

Citado >10,000 veces. Implementado en R (FEAR, `simarwilson`) y Stata (`simarwilson` Badunenko-Tauchmann 2019).

## 3. Pregunta

- ¿Cómo regresar consistentemente scores DEA sobre determinantes ambientales sin sesgo ni inferencia inválida?

## 4. Marco teórico

- Truncated regression: u_i = z_i · β + ε_i, donde ε_i ~ N(0, σ²) **truncado** en u_i ≥ 1 (o ≥ 0 si se modela inefficiency directa).
- Doble bootstrap: primer bootstrap para corregir sesgo de scores DEA; segundo bootstrap para inferencia sobre β.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Estudio | Metodológico + simulación Monte Carlo |
| Aplicación ilustrativa | Hospitales franceses |
| Algoritmos | #1 (simple bootstrap) y #2 (doble bootstrap con bias correction) |
| Replicación | L = 100, B = 2000 (recomendado) |

## 6. Hallazgos clave (Monte Carlo)

- Tobit two-stage produce coeficientes con sesgo y rechazos espurios.
- Algoritmo #2 produce IC con cobertura nominal correcta.
- La eficiencia de hospitales se asocia significativamente con tamaño, especialización y ownership; el Tobit produce conclusiones distintas en magnitud.

## 7. Hallazgos cualitativos

- Marca un antes y un después: literatura moderna ya no usa Tobit two-stage como estándar.
- Implementación accesible vía FEAR (R) y `simarwilson` (Stata).

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Capítulo | Uso | Sección |
|----------|-----|---------|
| Cap. 4 | **Método central del capítulo**: estima scores DEA bias-corrected de la productividad agrícola subnacional y los regresa sobre determinantes (gasto público per cápita, % gasto en bienes públicos, riego, extensión, vías) mediante algoritmo #2 | §4.2 Estrategia empírica DEA Simar-Wilson |

## 10. Limitaciones

- Computacionalmente costoso (doble bootstrap, B alto).
- Requiere exogeneidad de los z_i respecto al error.
- Asume separabilidad entre la frontera y los determinantes.

## 11. Vínculos

- Extiende: `SimarWilson1998`.
- Implementaciones: `Wilson2008FEAR`, `BadunenkoTauchmann2019`.
- Aplicación a salud: literatura hospitalaria.
- Aplicación agrícola: numerosas, ej. `Bragagnolo2021` (sustancia SFA pero comparable).

## 12. Snippet ES + EN

**ES:**
> [@SimarWilson2007] establecieron el estándar moderno para regresar scores DEA sobre determinantes ambientales: scores con corrección de sesgo y **truncated regression con doble bootstrap**. El APER aplica el Algoritmo #2 del paper para identificar los correlatos del gasto público agrícola con la eficiencia técnica departamental boliviana.

**EN:**
> [@SimarWilson2007] established the modern standard for regressing DEA scores on environmental determinants: bias-corrected scores combined with **truncated regression and a double bootstrap**. The APER applies Algorithm #2 of the paper to identify how Bolivian departmental technical efficiency correlates with agricultural public spending.

## 13. BibTeX

```bibtex
@article{SimarWilson2007,
  author  = {Simar, L{\'e}opold and Wilson, Paul W.},
  title   = {Estimation and inference in two-stage, semi-parametric models of production processes},
  journal = {Journal of Econometrics},
  year    = {2007},
  volume  = {136},
  number  = {1},
  pages   = {31--64},
  doi     = {10.1016/j.jeconom.2005.07.009}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (paywalled Elsevier)
- [x] BibTeX
- [x] Snippet
- [x] Cap 4 — **método central**
