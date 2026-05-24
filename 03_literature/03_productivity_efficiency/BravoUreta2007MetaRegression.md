---
citekey: BravoUreta2007MetaRegression
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/6 autores (Bravo-Ureta, Solis, Moreira Lopez, Maripani, Thiam, Rivas)/JPA 27(1):57-72/DOI. Sin PDF: cifras meta-regresion no verificadas."
type: article
title: "Technical efficiency in farming: a meta-regression analysis"
authors: "Bravo-Ureta, Boris E. & Solís, Daniel & Moreira López, Víctor H. & Maripani, José F. & Thiam, Abdourahmane & Rivas, Teodoro"
year: 2007
source: "Journal of Productivity Analysis"
volume: "27"
issue: "1"
pages: "57-72"
doi: "10.1007/s11123-006-0025-3"
url: "https://doi.org/10.1007/s11123-006-0025-3"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/BravoUreta2007MetaRegression.pdf"
pdf_downloaded: unavailable
evidence_level: 1
geographic_scope: "Global (167 estudios)"
period_covered: "1979-2005"
language: "en"
methodology: "Meta-regresión sobre estudios SFA/DEA"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["meta_analisis", "SFA", "DEA", "eficiencia_tecnica", "agricultura", "Bravo-Ureta"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Bravo-Ureta et al. (2007) Meta-regression of farming TE

## 1. Referencia bibliográfica

> Bravo-Ureta, B. E., Solís, D., Moreira López, V. H., Maripani, J. F., Thiam, A., & Rivas, T. (2007). Technical efficiency in farming: a meta-regression analysis. *Journal of Productivity Analysis*, 27(1), 57–72. https://doi.org/10.1007/s11123-006-0025-3

## 2. Resumen ejecutivo

**Meta-regresión** sistemática que integra 167 estudios de eficiencia técnica agrícola (SFA + DEA) publicados 1979-2005, abarcando países desarrollados y en desarrollo. Examina cómo la mean technical efficiency (MTE) reportada varía según: método (SFA vs. DEA), tipo de datos (panel vs. cross-section), tipo de producción (cultivo vs. ganadería), nivel de desarrollo, distribución asumida para u, y otros moderadores.

Hallazgos centrales:
- MTE promedio reportado: ~0.72 (a través de los 167 estudios).
- **SFA produce MTE más bajas** que DEA (parametric pone más en inefficiency).
- **Panel data produce MTE más altas** que cross-section.
- **Ganadería** muestra MTE > cultivos.
- **Países en desarrollo** muestran MTE similar a desarrollados (no hay convergencia automática implícita).

Para el APER, este meta-análisis es **calibración de expectativas**: el APER puede esperar MTE bolivianas en rango 0.65-0.80, con SFA produciendo estimados más conservadores.

## 3. Pregunta

- ¿Qué explica la variación en la MTE reportada en estudios empíricos de eficiencia agrícola?

## 4. Marco

- Meta-regresión: MTE_i = α + Σβⱼ · moderador_j_i + ε_i.
- 167 estudios → ~400 estimaciones (algunos estudios reportan múltiples).

## 5. Datos / método

| Elemento | Detalle |
|----------|---------|
| Estudios | 167 (cubriendo cultivos y ganadería) |
| Período de los estudios | 1979-2005 |
| Países | 38 desarrollados + en desarrollo |
| Método | OLS, GLM con codificación de moderadores |

## 6. Hallazgos cuantitativos

- MTE promedio: ~0.72.
- DEA vs. SFA: DEA ~+0.08 (MTE más alta).
- Panel vs. cross-section: panel ~+0.05.
- Ganadería vs. cultivos: ganadería ~+0.05.

## 7. Aplicación al APER 2026 Bolivia

| Cap. | Uso | Sección |
|------|-----|---------|
| Cap. 4 | **Calibración de expectativas**: rango plausible de MTE bolivianas (0.65-0.80); justificación de reportar tanto DEA como SFA | §4.4 Discusión |

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Vínculos

- Predecesor narrativo: `BravoUretaPinheiro1993`.
- Marco metodológico: `Coelli2005`.

## 10. Snippet ES + EN

**ES:**
> [@BravoUreta2007MetaRegression] meta-analizan 167 estudios de eficiencia técnica agrícola y encuentran una MTE promedio de ~0.72, con DEA produciendo estimados más altos que SFA. Esto provee el rango plausible (0.65-0.80) contra el cual el APER calibra sus resultados de eficiencia subnacional boliviana.

**EN:**
> [@BravoUreta2007MetaRegression] meta-analyze 167 agricultural technical-efficiency studies and find an average MTE of ~0.72, with DEA producing higher estimates than SFA. This provides the plausible range (0.65-0.80) against which the APER calibrates its Bolivian subnational efficiency estimates.

## 11. BibTeX

```bibtex
@article{BravoUreta2007MetaRegression,
  author  = {Bravo-Ureta, Boris E. and Solis, Daniel and Moreira L{\'o}pez, V{\'i}ctor H. and Maripani, Jos{\'e} F. and Thiam, Abdourahmane and Rivas, Teodoro},
  title   = {Technical efficiency in farming: A meta-regression analysis},
  journal = {Journal of Productivity Analysis},
  year    = {2007},
  volume  = {27},
  number  = {1},
  pages   = {57--72},
  doi     = {10.1007/s11123-006-0025-3}
}
```

## 12. Status

- [x] Metadatos · [ ] PDF paywalled Springer · [x] BibTeX · [x] Snippet · [x] Cap 4 — **calibración**
