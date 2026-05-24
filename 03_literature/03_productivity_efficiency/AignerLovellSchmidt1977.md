---
citekey: AignerLovellSchmidt1977
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/journal/vol/issue/pages/DOI. Sin PDF: no se verifican cifras §6."
type: article
title: "Formulation and estimation of stochastic frontier production function models"
authors: "Aigner, Dennis & Lovell, C. A. Knox & Schmidt, Peter"
year: 1977
source: "Journal of Econometrics"
volume: "6"
issue: "1"
pages: "21-37"
doi: "10.1016/0304-4076(77)90052-5"
url: "https://doi.org/10.1016/0304-4076(77)90052-5"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/AignerLovellSchmidt1977.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "1977"
language: "en"
methodology: "SFA — frontera estocástica paramétrica"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["SFA", "frontera_estocastica", "metodologia", "MLE"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Aigner, Lovell & Schmidt (1977) SFA seminal

## 1. Referencia bibliográfica

> Aigner, D., Lovell, C. A. K., & Schmidt, P. (1977). Formulation and estimation of stochastic frontier production function models. *Journal of Econometrics*, 6(1), 21–37. https://doi.org/10.1016/0304-4076(77)90052-5

## 2. Resumen ejecutivo

Junto con Meeusen & van den Broeck (1977) inaugura la rama paramétrica de la medición de eficiencia, conocida como **Stochastic Frontier Analysis (SFA)**. Propone una función de producción con **error compuesto** ε = v − u, donde v ~ N(0, σ²ᵥ) captura ruido estadístico (clima, errores de medición) y u ≥ 0 captura ineficiencia técnica (semi-normal o exponencial). El estimador es máxima verosimilitud (MLE).

La innovación clave respecto a DEA: separa **ruido** de **ineficiencia** — una propiedad crítica para agricultura, donde shocks climáticos son frecuentes y un enfoque determinístico (DEA puro) los atribuiría erróneamente a "ineficiencia". Por eso buena parte de la literatura empírica en agricultura usa SFA, especialmente con datos panel (Battese-Coelli 1995).

## 3. Pregunta de investigación / objetivos

- ¿Cómo estimar una frontera de producción que distinga ineficiencia (componente sistemático) de ruido (componente aleatorio)?

## 4. Marco teórico y conceptual

- Función de producción paramétrica (Cobb-Douglas, translog).
- Distribución compuesta: noise simétrico + inefficiency unilateral.
- Identificación vía momentos de orden superior de los residuales.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Modelo | y_i = f(x_i; β) · exp(v_i − u_i) |
| Distribuciones | v ~ N(0, σ²ᵥ), u ~ |N(0, σ²ᵤ)| (semi-normal) o exponencial |
| Estimación | MLE (alternativa: COLS, corrected OLS) |
| Aplicación ilustrativa | Manufactura EE.UU. |

## 6. Hallazgos cuantitativos clave

- Demuestra identificabilidad del modelo y propone procedimiento MLE.
- Compara empíricamente con OLS y COLS, mostrando que el SFA produce estimates de inefficiency más razonables cuando hay heterogeneidad observacional.

## 7. Hallazgos cualitativos / interpretativos

- Establece la dicotomía SFA-paramétrica (este paper) vs. DEA-no paramétrica (Charnes-Cooper-Rhodes 1978).
- Trade-off: SFA requiere supuestos distribucionales y forma funcional, pero modela ruido; DEA no requiere ninguno pero atribuye ruido a ineficiencia.

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
| Cap. 4 | Justifica usar SFA como check de robustez al DEA Simar-Wilson, dado el alto componente de shocks climáticos en Bolivia (heladas, sequías, El Niño) | §4.3 Robustness checks |

## 10. Limitaciones del documento

- Requiere distribución específica para u (sensibilidad a la especificación).
- Cross-sectional original; extensión a panel y heterocedasticidad llegaría décadas después (Battese-Coelli 1995, Greene 2008).

## 11. Vínculos con otros documentos

- Simultáneo a: `MeeusenVandenBroeck1977`.
- Extiende a panel: `BatteseCoelli1995`.
- Síntesis moderna: `Greene2008SFA`, `Coelli2005`.
- Reseña aplicada agricultura desarrollo: `BravoUretaPinheiro1993`, `BravoUreta2007MetaRegression`.

## 12. Snippet ES + EN

**ES:**
> [@AignerLovellSchmidt1977] introdujo el modelo de frontera estocástica con error compuesto que distingue ineficiencia técnica del ruido aleatorio — una distinción crítica para evaluar productividad agropecuaria en economías como la boliviana, donde el componente climático contribuye a varianza no estructural en los rendimientos.

**EN:**
> [@AignerLovellSchmidt1977] introduced the stochastic frontier model with composed error that distinguishes technical inefficiency from random noise — a critical distinction for evaluating agricultural productivity in economies such as Bolivia's, where climatic shocks contribute substantial non-structural variance to yields.

## 13. BibTeX

```bibtex
@article{AignerLovellSchmidt1977,
  author  = {Aigner, Dennis and Lovell, C. A. Knox and Schmidt, Peter},
  title   = {Formulation and estimation of stochastic frontier production function models},
  journal = {Journal of Econometrics},
  year    = {1977},
  volume  = {6},
  number  = {1},
  pages   = {21--37},
  doi     = {10.1016/0304-4076(77)90052-5}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (paywalled)
- [x] BibTeX
- [x] Snippet
- [x] Cap 4
