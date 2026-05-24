---
citekey: Greene2008SFA
audit_status: green  # Fase 2 audit 2026-05-23
type: inproceedings
title: "The Econometric Approach to Efficiency Analysis"
authors: "Greene, William H."
year: 2008
source: "In Fried, Lovell & Schmidt (eds.) The Measurement of Productive Efficiency and Productivity Growth, Oxford University Press"
volume: ""
issue: ""
pages: "92-250"
doi: "10.1093/acprof:oso/9780195183528.003.0002"
url: "https://pages.stern.nyu.edu/~wgreene/StochasticFrontierModels.pdf"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Greene2008SFA.pdf"
pdf_downloaded: true
evidence_level: 7
geographic_scope: "Global"
period_covered: "—"
language: "en"
methodology: "Capítulo de manual: SFA paramétrico avanzado"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["SFA", "panel", "heterogeneidad", "MLE", "metodologia", "manual"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Greene (2008) Econometric approach to efficiency

## 1. Referencia bibliográfica

> Greene, W. H. (2008). The econometric approach to efficiency analysis. In H. O. Fried, C. A. K. Lovell, & S. S. Schmidt (Eds.), *The Measurement of Productive Efficiency and Productivity Growth* (pp. 92–250). New York: Oxford University Press. PDF: https://pages.stern.nyu.edu/~wgreene/StochasticFrontierModels.pdf

## 2. Resumen ejecutivo

Capítulo extenso (158 pp.) que sintetiza el estado del arte en **SFA econométrico** hasta 2008, con énfasis en: (i) distribuciones alternativas para u (semi-normal, exponencial, truncated normal, gamma), (ii) modelos de panel con heterogeneidad observada y no observada (true fixed/random effects, Greene 2005), (iii) modelos con determinantes de la ineficiencia (Battese-Coelli 1995), (iv) latent class frontiers, (v) cost frontiers y systems.

Es la referencia metodológica avanzada en SFA. Particularmente útil para el APER porque discute estrategias para datos panel boliviano (municipios o departamentos × años) que combinan heterogeneidad observable y no observable.

## 3. Estructura (selección relevante)

| Sección | Tema |
|---------|------|
| 2 | Modelos básicos SFA y especificaciones |
| 3 | Estimación: COLS, MLE, MOM, Bayesian |
| 4 | Modelos panel: fixed effects, random effects, true F/R effects |
| 5 | Heterocedasticidad y heterogeneidad |
| 6 | Determinantes de la ineficiencia (BC-95) |
| 7 | Cost & profit frontiers |
| 8 | Latent class y mixture frontiers |

## 4. Hallazgos / contribuciones clave para el APER

- Justifica usar **true fixed effects (TFE)** para separar heterogeneidad subnacional persistente (geografía, suelo, capital social) de ineficiencia técnica.
- Documenta el sesgo de los modelos "Pitt-Lee" cuando hay heterogeneidad correlacionada.
- Provee criterios para elegir distribución de u.

## 5. Aplicación al APER 2026

| Cap. | Uso | Sección |
|------|-----|---------|
| Cap. 4 | Referencia clave para la especificación SFA panel (TFE) en el chequeo de robustez del DEA Simar-Wilson | §4.3 Robustness checks |

## 6. Limitaciones

- Capítulo largo y técnico; requiere familiaridad previa con SFA.
- 2008: extensiones posteriores (zero-inflated frontiers, sample selection — Greene 2010) no cubiertas.

## 7. Vínculos

- Extiende: `AignerLovellSchmidt1977`, `BatteseCoelli1995`.
- Manual paralelo: `Coelli2005`.

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
@incollection{Greene2008SFA,
  author    = {Greene, William H.},
  title     = {The econometric approach to efficiency analysis},
  booktitle = {The Measurement of Productive Efficiency and Productivity Growth},
  editor    = {Fried, Harold O. and Lovell, C. A. Knox and Schmidt, Shelton S.},
  publisher = {Oxford University Press},
  year      = {2008},
  pages     = {92--250}
}
```

## 10. Status

- [x] Metadatos · [x] PDF (Greene NYU mirror) · [x] BibTeX · [x] Snippet · [x] Cap 4
