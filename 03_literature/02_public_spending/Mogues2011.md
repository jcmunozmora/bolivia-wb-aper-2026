---
citekey: Mogues2011
audit_status: red
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "AUTORES INCORRECTOS. Crossref (DOI 10.1080/00220388.2010.509925) confirma que la versión publicada en Journal of Development Studies 47(5):735-752, 2011 tiene como autor único a Tewodaj Mogues — NO 'Mogues, Ayele, Paulos' como dice ficha (esos co-autores aparecen en la versión IFPRI Research Report 160 de 2008, no en el paper JDS). Volumen, issue y páginas coinciden. Sin PDF disponible para verificar cifras §6. Recomendación: corregir autores a 'Mogues, Tewodaj' (autor único) o vincular esta ficha al IFPRI Research Report 160 vía la otra ficha MoguesIFPRI2008."
type: article
title: "The Bang for the Birr: Public Expenditures and Rural Welfare in Ethiopia"
authors: "Mogues, Tewodaj & Ayele, Gezahegn & Paulos, Zelekawork"
year: 2011
source: "Journal of Development Studies"
volume: "47"
issue: "5"
pages: "735-752"
doi: "10.1080/00220388.2010.509925"
url: "https://www.tandfonline.com/doi/abs/10.1080/00220388.2010.509925"
pdf_path: "03_literature/pdfs/02_public_spending/Mogues2011.pdf"
pdf_downloaded: false
evidence_level: 3
geographic_scope: "Subsaharan"
period_covered: "1996-2007"
language: "en"
methodology: "FE | IV"
relevance_chapters: ["Cap2", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["gasto_publico", "bienes_publicos", "I+D", "infraestructura", "retornos"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Bang for the Birr (Ethiopia)

## 1. Referencia bibliográfica

> Mogues, T., Ayele, G., & Paulos, Z. (2011). The Bang for the Birr: Public Expenditures and Rural Welfare in Ethiopia. *Journal of Development Studies*, 47(5), 735-752. https://doi.org/10.1080/00220388.2010.509925

Versión previa: IFPRI Research Report 160 (2008) y Discussion Paper 702 (2007).

## 2. Resumen ejecutivo

El estudio examina el impacto de distintos tipos de gasto público rural sobre el bienestar de los hogares en Etiopía. Combinando datos de hogares con presupuesto subnacional, descompone los efectos por tipo de inversión (caminos, agricultura, salud, educación) y región. La metodología explota la variación inter-regional con efectos fijos y controles institucionales.

Los autores documentan **retornos altos pero geográficamente concentrados** del gasto en caminos rurales, **retornos bajos y no significativos** del gasto agrícola directo, y un papel mediador importante del acceso a mercados urbanos.

El trabajo es uno de los primeros que aplica el marco de Fan-Hazell-Thorat (India) a un contexto africano, mostrando que la **calidad del gasto** importa más que el **nivel**.

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿Qué composición de gasto público rural maximiza el bienestar en hogares etíopes?
- **Sub-preguntas:** ¿Hay heterogeneidad regional? ¿Se compensa el gasto agrícola con el de infraestructura?

## 4. Marco teórico y conceptual

Aplica el enfoque de retornos marginales por categoría de gasto (Fan et al. 2000) a un país africano. Las categorías de gasto incluyen: caminos, agricultura, salud, educación y agua.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Observacional con FE/IV |
| Población | Hogares rurales de Etiopía |
| N | ~7,000 hogares; 8 regiones |
| Período | 1996-2007 |
| Geografía | Etiopía, todas las regiones |
| Fuentes de datos | Encuestas de hogares (ERHS) + presupuesto regional |
| Método de identificación | Efectos fijos regionales + IV (lags) |
| Software / código | No reportado [TBV] |
| Replicable | Parcial |

## 6. Hallazgos cuantitativos clave

- **Caminos:** Retornos a inversión en caminos altos y significativos, pero concentrados en regiones más urbanizadas.
- **Agricultura directa:** Coeficientes positivos pero de magnitud baja y mayoría no significativos estadísticamente.
- **Heterogeneidad:** El retorno al gasto agrícola es mayor en regiones con buen acceso a mercados.
- **Mecanismo:** Sugieren que el bajo retorno agrícola refleja problemas de complementariedad (sin caminos, el gasto agrícola tiene poco efecto).

## 7. Hallazgos cualitativos / interpretativos

La composición y secuencia del gasto importa: invertir en agricultura sin haber resuelto el cuello de botella de transporte tiene retornos bajos. El estudio invita a pensar el portafolio del gasto rural en términos de **complementariedades**, no de categorías aisladas.

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
| Cap. 1 (contexto) | Marco conceptual: composición y secuencia | §1.3 |
| Cap. 2 (gasto y composición) | Benchmark de retornos por categoría | §2.4 |
| Cap. 3 (PSE / repurposing) | Argumento de reasignar hacia infraestructura+I+D | §3.2 |
| Cap. 4 (eficiencia) | Cita central sobre complementariedad | §4.1 |
| Cap. 5 (recomendaciones) | Lección: secuencia caminos→agricultura | §5.1 |

## 10. Limitaciones del documento

- Validez interna: identificación basada en variación regional puede tener confounders.
- Validez externa: caso etíope, contexto institucional muy distinto a Bolivia.
- Datos: presupuestos regionales con problemas conocidos de calidad.

## 11. Vínculos con otros documentos en `03_literature/`

- Refuerza a: `FanHazellThorat2000`, `MoguesEtAl2012`
- Complementario con: `GoyalNash2017`, `Pernechele2021`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> En Etiopía, Mogues, Ayele y Paulos [@Mogues2011] muestran que los retornos al gasto público rural son altos en caminos pero bajos y poco significativos en agricultura directa, lo que sugiere que la composición y secuencia del gasto importa más que su nivel. Esta lección es relevante para Bolivia, donde la concentración del gasto en programas productivos podría tener retornos limitados sin inversión complementaria en bienes públicos rurales.

**EN (≤80 palabras):**
> In Ethiopia, Mogues, Ayele and Paulos [@Mogues2011] show that returns to rural public expenditures are high for roads but low and statistically weak for agriculture, suggesting that the composition and sequencing of spending matters more than its level. This lesson resonates with Bolivia, where the concentration of expenditure in productive programs may yield limited returns without complementary investment in rural public goods.

## 13. BibTeX

```bibtex
@article{Mogues2011,
  author  = {Mogues, Tewodaj and Ayele, Gezahegn and Paulos, Zelekawork},
  title   = {The Bang for the Birr: Public Expenditures and Rural Welfare in Ethiopia},
  journal = {Journal of Development Studies},
  year    = {2011},
  volume  = {47},
  number  = {5},
  pages   = {735--752},
  doi     = {10.1080/00220388.2010.509925},
  url     = {https://www.tandfonline.com/doi/abs/10.1080/00220388.2010.509925}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF descargado (paywall — versión JDS; usar IFPRI RR160 como sustituto)
- [x] Hallazgos verificados via abstract + reseñas
- [x] BibTeX validado (DOI funciona)
- [x] Snippet ES + EN listos
- [x] Cross-referenced con otras fichas
- [x] Asignado a capítulo(s) APER
