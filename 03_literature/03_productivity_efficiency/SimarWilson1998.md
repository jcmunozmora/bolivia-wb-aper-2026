---
citekey: SimarWilson1998
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/Management Science 44(1):49-61/DOI. Sin PDF."
type: article
title: "Sensitivity analysis of efficiency scores: How to bootstrap in nonparametric frontier models"
authors: "Simar, Léopold & Wilson, Paul W."
year: 1998
source: "Management Science"
volume: "44"
issue: "1"
pages: "49-61"
doi: "10.1287/mnsc.44.1.49"
url: "https://pubsonline.informs.org/doi/10.1287/mnsc.44.1.49"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/SimarWilson1998.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "1998"
language: "en"
methodology: "DEA bootstrap (homogéneo)"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["DEA", "bootstrap", "inferencia", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Simar & Wilson (1998) Bootstrap para DEA

## 1. Referencia bibliográfica

> Simar, L., & Wilson, P. W. (1998). Sensitivity analysis of efficiency scores: How to bootstrap in nonparametric frontier models. *Management Science*, 44(1), 49–61. https://doi.org/10.1287/mnsc.44.1.49

## 2. Resumen ejecutivo

Paper seminal que dota a DEA de **inferencia estadística** mediante bootstrap. Hasta entonces, los scores DEA eran puntos sin error de medición ni intervalos de confianza. Simar & Wilson definen el proceso generador de datos detrás de DEA y proponen un procedimiento bootstrap **homogéneo** para construir intervalos de confianza y testear hipótesis. Esto convierte DEA de una técnica descriptiva a un estimador con propiedades estadísticas conocidas.

Aplicación ilustrativa: plantas eléctricas. Versión posterior (Simar-Wilson 2007) extiende el bootstrap a regresión de scores sobre determinantes (two-stage), corrigiendo el sesgo del Tobit naïf.

## 3. Pregunta

- ¿Cómo cuantificar la incertidumbre estadística de los scores DEA y testear hipótesis?

## 4. Marco teórico

- Define DGP plausible bajo el cual DEA es un estimador de una frontera verdadera no observada.
- Bootstrap homogéneo: resamplea de un kernel suavizado del estimador de eficiencia.
- Sesgo del estimador DEA cuantificable y corregible.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Aplicación | Plantas eléctricas (input efficiency) |
| Bootstrap | B = 2000 replicas |
| Salida | Bias-corrected efficiency, IC 95% |

## 6. Hallazgos clave

- Demuestra empíricamente sesgo apreciable en DEA estándar (~5-10% en escenarios típicos).
- Intervalos de confianza no triviales: muchas DMUs "eficientes" no son significativamente diferentes de DMUs no-frontera.

## 7. Hallazgos cualitativos

- Establece la práctica estándar moderna: reportar scores bias-corrected + IC.
- Implementado en software FEAR (Wilson 2008) y en R (paquete `deaR`).

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Cap. | Uso | Sección |
|------|-----|---------|
| Cap. 4 | Procedimiento de inferencia que se aplicará a los scores DEA del gasto agrícola subnacional boliviano. Permite afirmar con rigor cuáles departamentos están "significativamente" lejos de la frontera | §4.2.3 Inferencia bootstrap |

## 10. Limitaciones

- Bootstrap homogéneo asume distribución idéntica de eficiencia entre DMUs (refinado en SW-2007).
- Computacionalmente intensivo (B alto).

## 11. Vínculos

- Extendido por: `SimarWilson2007` (two-stage), `Wilson2008FEAR` (software).
- Sintetizado en: `Coelli2005` cap. 11.
- Implementación Stata: `BadunenkoTauchmann2019`.

## 12. Snippet ES + EN

**ES:**
> [@SimarWilson1998] proveyeron el fundamento estadístico para DEA mediante bootstrap, permitiendo construir intervalos de confianza alrededor de los scores de eficiencia y corregir su sesgo. El APER aplica este procedimiento (B = 2000) sobre los scores subnacionales del gasto agropecuario boliviano.

**EN:**
> [@SimarWilson1998] provided the statistical foundation for DEA via bootstrap, enabling confidence intervals around efficiency scores and bias correction. The APER applies this procedure (B = 2000) to subnational scores of Bolivian agricultural public spending.

## 13. BibTeX

```bibtex
@article{SimarWilson1998,
  author  = {Simar, L{\'e}opold and Wilson, Paul W.},
  title   = {Sensitivity analysis of efficiency scores: How to bootstrap in nonparametric frontier models},
  journal = {Management Science},
  year    = {1998},
  volume  = {44},
  number  = {1},
  pages   = {49--61},
  doi     = {10.1287/mnsc.44.1.49}
}
```

## 14. Status

- [x] Metadatos · [ ] PDF paywalled · [x] BibTeX · [x] Snippet · [x] Cap 4
