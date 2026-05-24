---
citekey: BatteseCoelli1995
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/Empirical Economics 20(2):325-332/DOI. Sin PDF."
type: article
title: "A model for technical inefficiency effects in a stochastic frontier production function for panel data"
authors: "Battese, George E. & Coelli, Tim J."
year: 1995
source: "Empirical Economics"
volume: "20"
issue: "2"
pages: "325-332"
doi: "10.1007/BF01205442"
url: "https://doi.org/10.1007/BF01205442"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/BatteseCoelli1995.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global (aplicado a arroz India)"
period_covered: "1975-1985"
language: "en"
methodology: "SFA panel + determinantes de inefficiency"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["SFA", "panel_data", "ineficiencia", "determinantes", "agricultura"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Battese & Coelli (1995) SFA panel + determinantes

## 1. Referencia bibliográfica

> Battese, G. E., & Coelli, T. J. (1995). A model for technical inefficiency effects in a stochastic frontier production function for panel data. *Empirical Economics*, 20(2), 325–332. https://doi.org/10.1007/BF01205442

## 2. Resumen ejecutivo

Extensión paramétrica fundamental del modelo SFA al caso panel con **determinantes endógenos de la ineficiencia**. Battese & Coelli proponen que el término u_it (ineficiencia técnica) tenga media μ_it = z_it · δ, donde z_it es un vector de variables explicativas (educación del productor, acceso a crédito, irrigación, tamaño de finca, etc.). Esto permite estimar **simultáneamente** la frontera de producción y los determinantes de la ineficiencia, evitando el sesgo del enfoque en dos etapas (estimación de eficiencias en una etapa, regresión en otra) que Simar & Wilson (2007) criticaron formalmente.

Con >6,400 citas según Google Scholar, es referencia universal en estudios SFA de agricultura. Aplicación empírica: arroz en una aldea india con 10 años de panel.

## 3. Pregunta de investigación / objetivos

- ¿Cómo modelar conjuntamente la frontera de producción y los determinantes de la ineficiencia técnica con datos panel?

## 4. Marco teórico y conceptual

- y_it = f(x_it; β) · exp(v_it − u_it)
- u_it = z_it · δ + W_it, con W_it ~ N(0, σ²) truncada en u_it ≥ 0
- Estimación conjunta MLE de (β, δ, σ²ᵥ, σ²ᵤ).

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Estudio | Panel SFA con determinantes |
| Población | Productores arroceros (aldea Aurepalle, India) |
| N | Hasta 38 productores × 10 años |
| Período | 1975-1985 |
| Inputs | Tierra, mano de obra, fertilizante, otros |
| Determinantes de ineficiencia | Edad, educación, tamaño, año |
| Software referencia | FRONTIER (Coelli) |

## 6. Hallazgos cuantitativos clave

- Eficiencia técnica media estimada en torno a 0.80 con dispersión apreciable.
- Edad y educación son determinantes significativos de menor ineficiencia (parafraseado [TBV]).

## 7. Hallazgos cualitativos / interpretativos

- Resuelve el problema metodológico de estimación en dos etapas (sesgo).
- Crítica posterior de Simar-Wilson (2007) aplica al two-stage DEA, no al modelo BC-95 que es one-stage.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Capítulo | Cómo se usa | Sección sugerida |
|----------|-------------|------------------|
| Cap. 4 | Modelo de referencia si el APER usa datos panel municipales/departamentales con determinantes (gasto público, riego, extensión, educación rural) | §4.3 Estrategia SFA panel |

## 10. Limitaciones

- Asume distribución específica para u (truncated normal).
- Aplicación original es un solo país y un solo cultivo.

## 11. Vínculos con otros documentos

- Extiende: `AignerLovellSchmidt1977`, `MeeusenVandenBroeck1977`.
- Textbook: `Coelli2005`.
- Reseña aplicada: `BravoUretaPinheiro1993`, `BravoUreta2007MetaRegression`.
- Crítica al two-stage DEA: `SimarWilson2007`.

## 12. Snippet ES + EN

**ES:**
> [@BatteseCoelli1995] propusieron un modelo SFA con datos panel que estima conjuntamente la frontera de producción y los determinantes de la ineficiencia técnica, evitando el sesgo del enfoque en dos etapas. Este marco será utilizado como check de robustez del DEA Simar-Wilson en el Capítulo 4, permitiendo incorporar el gasto público, el riego y la cobertura de extensión como determinantes endógenos.

**EN:**
> [@BatteseCoelli1995] proposed a panel-data SFA model that jointly estimates the production frontier and the determinants of technical inefficiency, avoiding the bias of two-stage approaches. This framework is used as a robustness check on the Simar-Wilson DEA in Chapter 4, allowing public spending, irrigation, and extension coverage to enter as endogenous determinants.

## 13. BibTeX

```bibtex
@article{BatteseCoelli1995,
  author  = {Battese, George E. and Coelli, Tim J.},
  title   = {A model for technical inefficiency effects in a stochastic frontier production function for panel data},
  journal = {Empirical Economics},
  year    = {1995},
  volume  = {20},
  number  = {2},
  pages   = {325--332},
  doi     = {10.1007/BF01205442}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (paywalled Springer)
- [x] BibTeX
- [x] Snippet
- [x] Cap 4
