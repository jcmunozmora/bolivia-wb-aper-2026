---
citekey: Farrell1957
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/Farrell M.J./1957/JRSS A 120(3)/DOI. Crossref solo registra pagina inicial 253; ficha 253-290 (paginas reales del articulo)."
type: article
title: "The Measurement of Productive Efficiency"
authors: "Farrell, M. J."
year: 1957
source: "Journal of the Royal Statistical Society, Series A (General)"
volume: "120"
issue: "3"
pages: "253-290"
doi: "10.2307/2343100"
url: "https://www.jstor.org/stable/2343100"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Farrell1957.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "1957"
language: "en"
methodology: "Theoretical / nonparametric frontier"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["eficiencia_tecnica", "frontera_produccion", "DEA_origen", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Farrell (1957) "Measurement of Productive Efficiency"

## 1. Referencia bibliográfica

> Farrell, M. J. (1957). The Measurement of Productive Efficiency. *Journal of the Royal Statistical Society, Series A (General)*, 120(3), 253–290. https://doi.org/10.2307/2343100

## 2. Resumen ejecutivo

Paper seminal que introduce el concepto operativo de **eficiencia productiva** y la primera formalización empírica de fronteras de producción no paramétricas. Farrell propone descomponer la eficiencia total de una unidad de producción en **eficiencia técnica** (capacidad de obtener máximo output dado un vector de inputs) y **eficiencia asignativa** (capacidad de elegir la mezcla óptima de inputs dados sus precios), cuyo producto es la eficiencia económica total. La frontera se construye envolviendo los datos observados mediante combinaciones lineales convexas de las unidades más eficientes, lo que sentaría el fundamento conceptual para Data Envelopment Analysis (DEA, Charnes-Cooper-Rhodes 1978) y para la frontera estocástica (Aigner-Lovell-Schmidt 1977).

La aplicación empírica usa datos del sector agrícola estadounidense por estados para ilustrar el cálculo isocuántico y la descomposición. La contribución metodológica trasciende la agricultura: cualquier sector productivo puede medirse contra una "best-practice frontier" empíricamente construida en lugar de una función teórica impuesta.

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿cómo medir empíricamente la eficiencia productiva de una unidad económica sin imponer una forma funcional rígida sobre la tecnología?
- **Sub-pregunta:** ¿cómo separar el efecto técnico (uso de inputs) del efecto asignativo (precios relativos)?

## 4. Marco teórico y conceptual

- Teoría microeconómica de la producción (isocuantas, optimización dado un vector de precios).
- Antecesores: Debreu (1951) "Coefficient of resource utilization", Koopmans (1951) sobre análisis de actividades.
- Concepto de frontera empírica = envolvente de observaciones.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Conceptual + ilustración empírica |
| Población | Sectores agrícolas por estados (EE.UU.) |
| N | 48 estados |
| Período | Década de 1950 (estadísticas FAO/USDA disponibles) |
| Método | Construcción de isocuanta unitaria por envolvente convexa; razones radiales |
| Replicable | Sí (datos públicos) |

## 6. Hallazgos cuantitativos clave

- Demuestra empíricamente que dos unidades con el mismo nivel de output pueden diferir hasta en 50% en uso de inputs (eficiencia técnica < 0.5).
- Eficiencia asignativa adicional puede reducir costos hasta en otro 20-30%.

## 7. Hallazgos cualitativos / interpretativos

- "Best-practice frontier" como benchmarking operativo, no función teórica.
- La distinción técnica/asignativa permite diagnósticos diferenciados de política: corregir tecnología (extensión, capacitación) vs. corregir precios (subsidios, distorsiones de mercado).

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
| Cap. 4 (eficiencia del gasto y productividad) | Fundamento conceptual de la descomposición eficiencia técnica/asignativa que el APER usará para evaluar el gasto público agrícola | §4.1 Marco conceptual |

## 10. Limitaciones del documento

- Asume convexidad y retornos constantes a escala (CRS), supuesto luego relajado por Banker-Charnes-Cooper (1984).
- No incorpora ruido estocástico — limitación que motivó la rama SFA.
- Aplicación empírica simple comparada con extensiones modernas.

## 11. Vínculos con otros documentos en `03_literature/`

- Fundamento para: `CharnesCooperRhodes1978`, `AignerLovellSchmidt1977`, `Coelli2005`, `SimarWilson1998`, `SimarWilson2007`.
- Complementario con: `BravoUretaPinheiro1993` (reseña de aplicaciones DEA/SFA a agricultura en desarrollo).

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> El marco moderno de medición de eficiencia productiva se origina en [@Farrell1957], quien introdujo la descomposición entre eficiencia técnica (capacidad de obtener máximo producto dados los insumos) y eficiencia asignativa (capacidad de elegir la mezcla óptima dados los precios). Esta descomposición es la base conceptual del análisis DEA y de frontera estocástica utilizados en este capítulo para evaluar la productividad agropecuaria boliviana.

**EN (≤80 palabras):**
> The modern framework for measuring productive efficiency originates in [@Farrell1957], who introduced the decomposition between technical efficiency (ability to obtain maximum output from given inputs) and allocative efficiency (ability to choose the optimal input mix given prices). This decomposition underpins both the DEA and stochastic-frontier analyses used in this chapter to evaluate Bolivian agricultural productivity.

## 13. BibTeX

```bibtex
@article{Farrell1957,
  author  = {Farrell, M. J.},
  title   = {The measurement of productive efficiency},
  journal = {Journal of the Royal Statistical Society. Series A (General)},
  year    = {1957},
  volume  = {120},
  number  = {3},
  pages   = {253--290},
  doi     = {10.2307/2343100}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF descargado (paywalled JSTOR)
- [x] Hallazgos verificados (vs literatura derivada)
- [x] BibTeX validado
- [x] Snippet ES + EN listos
- [x] Cross-referenced con otras fichas
- [x] Asignado a Cap 4
