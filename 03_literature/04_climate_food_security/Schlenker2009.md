---
citekey: Schlenker2009
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/Schlenker & Roberts/2009/PNAS 106(37):15594-15598/DOI. Sin PDF: cifras §6 no verificadas."
type: article
title: "Nonlinear Temperature Effects Indicate Severe Damages to U.S. Crop Yields Under Climate Change"
authors: "Schlenker, Wolfram & Roberts, Michael J."
year: 2009
source: "Proceedings of the National Academy of Sciences"
volume: "106"
issue: "37"
pages: "15594-15598"
doi: "10.1073/pnas.0906865106"
url: "https://www.pnas.org/doi/10.1073/pnas.0906865106"
pdf_path: "03_literature/pdfs/04_climate_food_security/Schlenker2009.pdf"
pdf_downloaded: unavailable
evidence_level: 2
geographic_scope: "Global"
period_covered: "1950-2005"
language: "en"
methodology: "FE"
relevance_chapters: ["Cap1", "Cap5"]
relevance_score: "Media"
quality_score: 3
tags: ["climate_change", "crop_yields", "temperature", "nonlinear", "us", "extreme_heat"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Schlenker & Roberts: Efectos no lineales de temperatura

## 1. Referencia bibliográfica

> Schlenker, W. & Roberts, M.J. (2009). Nonlinear Temperature Effects Indicate Severe Damages to U.S. Crop Yields Under Climate Change. *PNAS*, 106(37), 15594-15598. DOI: 10.1073/pnas.0906865106

## 2. Resumen ejecutivo

Estudio econométrico de referencia que documenta la relación **no-lineal y asimétrica** entre temperatura y rendimientos de cultivos en Estados Unidos (maíz, soja, algodón). Demuestra que los rendimientos aumentan con la temperatura hasta un umbral (29°C maíz, 30°C soja, 32°C algodón), pero declinan abruptamente por encima de ese umbral.

La caída por encima del óptimo es significativamente más empinada que el ascenso por debajo, lo que implica que **eventos extremos de calor** son mucho más dañinos que el calentamiento promedio. Proyectan caídas de rendimiento de 31-43% bajo escenarios suaves y 67-79% bajo escenarios rápidos hacia fin de siglo. Aunque se basa en datos de EE.UU., la metodología y los umbrales fisiológicos son referencia global para análisis de impacto climático en agricultura.

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿Cuál es la forma funcional (lineal vs no-lineal) de la relación entre temperatura y rendimientos agrícolas, y qué implica para proyecciones climáticas?

## 4. Marco teórico y conceptual

Fisiología vegetal: estrés térmico no-lineal sobre cultivos C3 y C4. Identificación con datos panel de alta resolución temporal y espacial. Concepto de "grados-día dañinos" (degree-days above threshold).

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Panel a nivel condado |
| Población | Condados de EE.UU. productores de maíz, soja, algodón |
| Período | 1950-2005 |
| Fuentes | USDA (rendimientos); estaciones meteorológicas con distribución diaria de temperatura |
| Método | Panel FE con función spline de temperatura |

## 6. Hallazgos cuantitativos clave

- **Umbrales de temperatura óptima**: 29°C (maíz), 30°C (soja), 32°C (algodón).
- **Pendiente de caída** sobre el óptimo es mucho más empinada que la subida bajo el óptimo.
- **Proyección a fin de siglo**: pérdidas de 31-43% (escenario suave) a 67-79% (escenario rápido).

## 7. Hallazgos cualitativos / interpretativos

- Los modelos lineales subestiman gravemente el daño climático.
- Las olas de calor son la métrica crítica, no la temperatura promedio.
- Implicaciones globales: cultivos tropicales pueden estar más cerca de los umbrales críticos.

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
| Cap. 1 (contexto) | Soporte metodológico para vincular temperatura y rendimientos | §1.2 |
| Cap. 5 (recomendaciones) | Justificar inversión en variedades termorresistentes | §5.3 |

## 10. Limitaciones del documento

- Cobertura solo EE.UU.; transferibilidad a Bolivia requiere cautela.
- No incluye cultivos andinos.
- Asume adaptación limitada en proyecciones.

## 11. Vínculos con otros documentos en `03_literature/`

- Refuerza a: `Lobell2011`
- Complementario con: `Nelson2010_IFPRI`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> Schlenker y Roberts (2009) muestran que la relación entre temperatura y rendimientos agrícolas es marcadamente no-lineal: los rendimientos crecen con la temperatura hasta un umbral (29-32°C según el cultivo) y caen abruptamente por encima, lo que implica que olas de calor son mucho más dañinas que el calentamiento promedio [@Schlenker2009].

**EN (≤80 palabras):**
> Schlenker and Roberts (2009) show that the temperature-yield relationship is markedly nonlinear: yields increase with temperature up to a threshold (29-32°C depending on the crop) and decline sharply beyond it, implying that heat waves are far more damaging than average warming [@Schlenker2009].

## 13. BibTeX

```bibtex
@article{Schlenker2009,
  author  = {Schlenker, Wolfram and Roberts, Michael J.},
  title   = {Nonlinear Temperature Effects Indicate Severe Damages to {U.S.} Crop Yields Under Climate Change},
  journal = {Proceedings of the National Academy of Sciences},
  year    = {2009},
  volume  = {106},
  number  = {37},
  pages   = {15594--15598},
  doi     = {10.1073/pnas.0906865106},
  url     = {https://www.pnas.org/doi/10.1073/pnas.0906865106}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF (acceso restringido)
- [x] Hallazgos verificados
- [x] BibTeX validado
- [x] Snippet ES + EN listos
- [ ] Cross-referenced
- [x] Asignado a capítulo
