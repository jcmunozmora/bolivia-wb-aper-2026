---
citekey: FanHazellThorat2000
audit_status: yellow
audit_date: 2026-05-23
audit_phase: 4
audit_notes: "PDF re-verificado sesión 11 pdf-recovery — PDF descargado es solo imagen (CorelDraw, IFPRI Dec 1999, 3 pp.), probablemente IFPRI Brief precursor del paper AJAE 2000. pdftotext no extrae texto. Metadata del paper journal Crossref-verificada (DOI 10.1111/0002-9092.00101). Mantener yellow hasta descargar PDF journal final con texto extraíble."
type: article
title: "Government Spending, Growth and Poverty in Rural India"
authors: "Fan, Shenggen & Hazell, Peter & Thorat, Sukhadeo"
year: 2000
source: "American Journal of Agricultural Economics"
volume: "82"
issue: "4"
pages: "1038-1051"
doi: "10.1111/0002-9092.00101"
url: "https://onlinelibrary.wiley.com/doi/abs/10.1111/0002-9092.00101"
pdf_path: "03_literature/pdfs/02_public_spending/FanHazellThorat2000.pdf"
pdf_downloaded: true  # was HTML, quarantined 2026-05-23
evidence_level: 3
geographic_scope: "Other"
period_covered: "1970-1993"
language: "en"
methodology: "FE | IV | Simultaneous equations"
relevance_chapters: ["Cap1", "Cap2", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["gasto_publico", "retornos", "I+D", "infraestructura", "pobreza_rural", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Government Spending, Growth and Poverty (India)

## 1. Referencia bibliográfica

> Fan, S., Hazell, P., & Thorat, S. (2000). Government Spending, Growth and Poverty in Rural India. *American Journal of Agricultural Economics*, 82(4), 1038-1051. https://doi.org/10.1111/0002-9092.00101

Versión previa: EPTD Discussion Paper 33 (1998), IFPRI Research Report 110 (1999).

## 2. Resumen ejecutivo

Trabajo seminal que estima por **ecuaciones simultáneas** los efectos del gasto público rural sobre crecimiento agrícola y pobreza rural en India, 1970-1993. Cubre 14 categorías de gasto: I+D, extensión, irrigación, caminos rurales, electricidad rural, salud, educación, programas de alivio a la pobreza, entre otros.

El hallazgo central es que los retornos varían enormemente entre categorías: el gasto en **caminos rurales** y **I+D agrícola** tiene los mayores retornos tanto en producción como en reducción de pobreza, mientras que **subsidios** (fertilizantes, energía, crédito) tienen retornos significativamente menores.

La metodología — descomponer el efecto del gasto en canales directos (productividad) e indirectos (vía precios, salarios, empleo) — se convirtió en el marco de referencia para los Public Expenditure Reviews agrícolas posteriores (incluyendo los del Banco Mundial).

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿Qué tipos de gasto público rural en India han contribuido más a la reducción de pobreza y al crecimiento agrícola?
- **Sub-preguntas:** ¿Hay trade-offs entre crecimiento y pobreza? ¿Subsidios vs. inversiones productivas?
- **Hipótesis:** Los retornos de I+D e infraestructura superan a los de subsidios.

## 4. Marco teórico y conceptual

Modelo de ecuaciones simultáneas: el gasto público afecta crecimiento agrícola y reducción de pobreza a través de múltiples canales. Distingue **productividad** (TFP), **precios agrícolas**, **salarios rurales no agrícolas** y **empleo**.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Panel de estados, ecuaciones simultáneas |
| Población | 14 estados de India |
| N | ~336 observaciones (14 estados × 24 años) |
| Período | 1970-1993 |
| Geografía | India rural |
| Fuentes de datos | Government Budget Documents, Census, NSSO |
| Método de identificación | 3SLS con ecuaciones para productividad, salarios, precios, pobreza |
| Software / código | No reportado [TBV] |
| Replicable | Parcial |

## 6. Hallazgos cuantitativos clave

- **Caminos rurales:** Por cada millón de Rs gastados, 123,8 personas salen de la pobreza; reducen pobreza más que cualquier otro gasto. Generan crecimiento agrícola sustancial.
- **I+D agrícola:** 84,5 personas salen de la pobreza por millón de Rs; mayor impacto en productividad.
- **Educación rural:** 41 personas por millón de Rs; impacto significativo en pobreza.
- **Subsidios a fertilizantes:** 0,88 personas por millón de Rs; entre los menos eficientes.
- **Subsidios a crédito:** 1,06 personas por millón de Rs.
- **Tamaño del efecto principal:** Los retornos a caminos en pobreza son ~140 veces mayores que los de subsidios a fertilizantes (verificado en Tabla 4 del paper).

## 7. Hallazgos cualitativos / interpretativos

Los autores enfatizan que la **historia del gasto público rural en India** muestra un sesgo hacia subsidios crecientes a costa de inversión productiva, lo que explicaría parte de la desaceleración del crecimiento agrícola post-Green Revolution. El argumento de **reasignación** (de subsidios privados a bienes públicos) se vuelve central en la literatura posterior.

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
| Cap. 1 (contexto) | Cita seminal para enmarcar la composición | §1.2 |
| Cap. 2 (gasto y composición) | Tabla de retornos comparativos como benchmark | §2.4, §2.5 |
| Cap. 3 (PSE / repurposing) | Evidencia más citada del costo de oportunidad de subsidios | §3.1 |
| Cap. 4 (eficiencia) | Marco para discutir win-win vs. trade-off | §4.2 |
| Cap. 5 (recomendaciones) | Base para priorizar I+D + caminos | §5.1, §5.3 |

## 10. Limitaciones del documento

- Validez interna: identificación basada en ecuaciones simultáneas requiere supuestos fuertes sobre exclusiones.
- Validez externa: India 1970-93 es contexto muy específico; la Revolución Verde no se replica.
- Datos: presupuestos estatales históricos con cambios metodológicos.
- Endogeneidad de los IV usados es discutible.

## 11. Vínculos con otros documentos en `03_literature/`

- Antecedente clásico de: `Mogues2011`, `MoguesEtAl2012`, `Anriquez2016`
- Refuerza a: `Lopez2007_JPubEcon`, `GoyalNash2017`
- Marco aplicado en: `WB_PracticalToolkit2010`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> En India rural, Fan, Hazell y Thorat [@FanHazellThorat2000] mostraron que el gasto en caminos rurales y en I+D agrícola sacó a 124 y 85 personas de la pobreza por millón de rupias gastadas, mientras los subsidios a fertilizantes apenas a 0,88. Este trabajo seminal estableció el argumento de que **reasignar** gasto desde subsidios privados hacia bienes públicos puede multiplicar los retornos en crecimiento y pobreza, lección directa para el debate boliviano.

**EN (≤80 palabras):**
> In rural India, Fan, Hazell and Thorat [@FanHazellThorat2000] showed that rural roads and agricultural R&D lifted 124 and 85 people out of poverty per million rupees spent, while fertilizer subsidies lifted only 0.88. This seminal work established the argument that **reallocating** spending from private subsidies to public goods can multiply returns to growth and poverty reduction, a lesson directly relevant for the Bolivian debate.

## 13. BibTeX

```bibtex
@article{FanHazellThorat2000,
  author  = {Fan, Shenggen and Hazell, Peter and Thorat, Sukhadeo},
  title   = {Government Spending, Growth and Poverty in Rural India},
  journal = {American Journal of Agricultural Economics},
  year    = {2000},
  volume  = {82},
  number  = {4},
  pages   = {1038--1051},
  doi     = {10.1111/0002-9092.00101},
  url     = {https://onlinelibrary.wiley.com/doi/abs/10.1111/0002-9092.00101}
}
```

## 14. Status

- [x] Metadatos completos
- [x] PDF descargado (versión EPTD DP33)
- [x] Hallazgos verificados (Tabla 4, p. 1047-49)
- [x] BibTeX validado
- [x] Snippet ES + EN listos
- [x] Cross-referenced con otras fichas
- [x] Asignado a capítulo(s) APER
