---
citekey: Cuesta2013
audit_status: green
audit_date: 2026-05-23
audit_phase: 4
audit_notes: "PDF leído y verificado sesión 11 pdf-recovery — todo coincide en autores y contenido sustantivo: Cuesta/Edmeades/Madrigal. PDF descargado es WB Working Paper WPS5604 (2011) titulado 'Food Insecurity and Public Agricultural Spending in Bolivia', precursor del paper publicado en Food Policy 2013 (DOI 10.1016/j.foodpol.2013.01.004); título journal levemente distinto pero mismo paper sustantivo."
type: article
title: "Food Security and Public Agricultural Spending in Bolivia: Putting Money Where Your Mouth Is?"
authors: "Cuesta, Jose & Edmeades, Svetlana & Madrigal, Lucia"
year: 2013
source: "Food Policy"
volume: "40"
issue: "C"
pages: "1-13"
doi: "10.1016/j.foodpol.2013.01.004"
url: "https://www.sciencedirect.com/science/article/abs/pii/S0306919213000134"
pdf_path: "03_literature/pdfs/02_public_spending/Cuesta2013.pdf"
pdf_downloaded: true
evidence_level: 3
geographic_scope: "Bolivia"
period_covered: "1996-2008"
language: "en"
methodology: "Panel | FE"
relevance_chapters: ["Cap1", "Cap2", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["Bolivia", "gasto_publico", "seguridad_alimentaria", "municipal", "panel"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Food Security and Public Agricultural Spending in Bolivia

## 1. Referencia bibliográfica

> Cuesta, J., Edmeades, S., & Madrigal, L. (2013). Food security and public agricultural spending in Bolivia: Putting money where your mouth is? *Food Policy*, 40(C), 1-13. https://doi.org/10.1016/j.foodpol.2013.01.004

Versión previa: World Bank Policy Research Working Paper WPS5634 (2011) "Food Insecurity and Public Agricultural Spending in Bolivia".

## 2. Resumen ejecutivo

**Estudio empírico clave sobre Bolivia** publicado en *Food Policy*. Es la primera aplicación sistemática de análisis de gasto público agropecuario a nivel **municipal** en Bolivia, usando un dataset desagregado para los 327 municipios en los años 2003, 2006 y 2007. Combina indicadores compuestos de **vulnerabilidad a inseguridad alimentaria** con clasificación del gasto agropecuario en infraestructura, I+D, extensión y transferencias.

Los autores hallan que **los niveles de gasto agropecuario están positivamente asociados con vulnerabilidad alimentaria alta o muy alta** — esto refleja que el gasto se asigna **reactivamente** hacia municipios más vulnerables (selección por necesidad), no que el gasto la cause. El **gasto incremental** tiene efectos significativos pero de magnitud pequeña en el corto plazo, sugiriendo limitaciones de efectividad.

Crítico para el APER porque: (i) **único estudio empírico con datos municipales de gasto** publicado en revista de primer nivel; (ii) documenta efectos heterogéneos por departamento; (iii) deja preguntas abiertas que el APER 2026 puede responder con datos actualizados.

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿La asignación del gasto público agropecuario boliviano reduce la vulnerabilidad a inseguridad alimentaria?
- **Sub-preguntas:** ¿Qué tipo de gasto (infraestructura vs. I+D vs. extensión) es más efectivo? ¿Hay heterogeneidad departamental?

## 4. Marco teórico y conceptual

Modelo de inseguridad alimentaria multidimensional (FAO Food Insecurity Vulnerability Information Mapping Systems) cruzado con composición del gasto público a nivel municipal.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Panel municipal de Bolivia |
| Población | 327 municipios |
| N | 327 × 3 (2003, 2006, 2007) |
| Período | 1996-2008 (gasto), 2003-2007 (vulnerabilidad) |
| Geografía | Bolivia, nivel municipal |
| Fuentes de datos | INE, MEFP (presupuestos), MDRyT, ENDSA |
| Método de identificación | Panel FE + heterogeneidad departamental |
| Software / código | Stata (no público) |
| Replicable | Parcial (datos públicos pero requieren reconstrucción) |

## 6. Hallazgos cuantitativos clave

- **Asociación inicial:** Mayor gasto agropecuario asociado con mayor vulnerabilidad — interpretado como **focalización ex post** (los municipios más necesitados reciben más).
- **Gasto incremental:** Tiene impacto estadísticamente significativo en reducir vulnerabilidad, pero magnitud baja.
- **Composición:** Infraestructura agrícola e I+D/extensión muestran efectos mayores que transferencias directas.
- **Heterogeneidad departamental:** Diferencias importantes — efecto más fuerte en departamentos del Altiplano.

## 7. Hallazgos cualitativos / interpretativos

- Bolivia es **uno de los pocos países LAC con datos municipales de gasto agropecuario** suficientemente desagregados para este análisis.
- **Reto de identificación causal:** Sin estrategia de IV o experimento natural, la asociación gasto-vulnerabilidad es difícil de interpretar.
- **Llamado a mejorar focalización** y rediseñar instrumentos.

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
| Cap. 1 (contexto) | Antecedente único sobre Bolivia con datos municipales | §1.5 |
| Cap. 2 (gasto y composición) | Cifras base de composición del gasto pre-2008 | §2.2 |
| Cap. 4 (eficiencia) | Evidencia de baja efectividad relativa del gasto | §4.3 |
| Cap. 5 (recomendaciones) | Mejor focalización y rediseño | §5.5 |

## 10. Limitaciones del documento

- Identificación causal débil (sin IV creíble).
- Datos 2003-2008; muy desactualizados para conclusiones actuales.
- Composición del gasto se basa en clasificación administrativa, no funcional.
- Outcome (vulnerabilidad) es construido y heterogéneo.

## 11. Vínculos con otros documentos en `03_literature/`

- Es el ANTECEDENTE empírico principal para Bolivia
- Complementario con: `WB2021_TappingPotential`, `IDB_AnalisisBolivia2014`
- Marco regional: `LopezGalinato2007`, `Anriquez2016`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> Cuesta, Edmeades y Madrigal [@Cuesta2013], en el primer análisis empírico publicado en revista de primer nivel sobre gasto público agropecuario boliviano a nivel municipal, encuentran que el gasto se focaliza ex post hacia municipios más vulnerables pero tiene efectos pequeños en reducir vulnerabilidad alimentaria. Inversiones en infraestructura y en I+D/extensión muestran mejor desempeño que transferencias directas, con heterogeneidad importante entre departamentos. Es el antecedente cuantitativo directo del APER 2026.

**EN (≤80 palabras):**
> Cuesta, Edmeades and Madrigal [@Cuesta2013], in the first empirical study on Bolivian agricultural public spending at the municipal level published in a top journal, find that spending is allocated reactively toward vulnerable municipalities but has small effects on reducing food-insecurity vulnerability. Investment in infrastructure and in R&D/extension performs better than direct transfers, with important departmental heterogeneity. It is the direct empirical antecedent of the APER 2026.

## 13. BibTeX

```bibtex
@article{Cuesta2013,
  author  = {Cuesta, Jose and Edmeades, Svetlana and Madrigal, Lucia},
  title   = {Food security and public agricultural spending in {B}olivia: Putting money where your mouth is?},
  journal = {Food Policy},
  year    = {2013},
  volume  = {40},
  pages   = {1--13},
  doi     = {10.1016/j.foodpol.2013.01.004},
  url     = {https://www.sciencedirect.com/science/article/abs/pii/S0306919213000134}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF descargado (paywall ScienceDirect; intentar versión WPS 5634 via WB)
- [x] Hallazgos verificados via abstract y citas
- [x] BibTeX validado (DOI funciona)
- [x] Snippet ES + EN listos
- [x] Cross-referenced
- [x] Asignado a capítulos
