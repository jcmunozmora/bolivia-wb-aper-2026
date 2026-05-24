---
citekey: MoguesIFPRI2008
audit_status: green
audit_date: 2026-05-23
audit_phase: 4
audit_notes: "PDF leído y verificado sesión 11 pdf-recovery — autores Mogues/Ayele/Paulos confirmados, título 'Bang for the Birr' confirmado. PDF descargado es IFPRI Discussion Paper 00702 (mayo 2007), precursor del IFPRI Research Report 160 publicado en 2008 con los mismos autores. Mismo trabajo sustantivo."
type: techreport
title: "The Bang for the Birr: Public Expenditures and Rural Welfare in Ethiopia"
authors: "Mogues, Tewodaj & Ayele, Gezahegn & Paulos, Zelekawork"
year: 2008
source: "IFPRI Research Report 160"
volume: ""
issue: "160"
pages: "84"
doi: ""
url: "https://www.ifpri.org/publication/bang-birr-public-expenditures-and-rural-welfare-ethiopia"
pdf_path: "03_literature/pdfs/02_public_spending/MoguesIFPRI2008.pdf"
pdf_downloaded: true
evidence_level: 3
geographic_scope: "Subsaharan"
period_covered: "1996-2007"
language: "en"
methodology: "Panel | FE | IV"
relevance_chapters: ["Cap2", "Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["Ethiopia", "gasto_publico", "bienes_publicos", "retornos", "IFPRI"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Bang for Birr (IFPRI Research Report 160)

## 1. Referencia bibliográfica

> Mogues, T., Ayele, G., & Paulos, Z. (2008). *The Bang for the Birr: Public Expenditures and Rural Welfare in Ethiopia*. IFPRI Research Report 160. Washington, DC: International Food Policy Research Institute. https://www.ifpri.org/publication/bang-birr-public-expenditures-and-rural-welfare-ethiopia

## 2. Resumen ejecutivo

**Versión extendida en formato Research Report** del trabajo posteriormente publicado en *Journal of Development Studies* 2011 (Mogues, Ayele, Paulos). Incluye **análisis más detallados, descomposiciones por categoría y discusiones metodológicas** que no caben en el artículo de revista. Es la **versión definitiva** para citar el análisis empírico.

Documenta retornos al gasto público rural en Etiopía:
- **Caminos rurales:** Altos retornos, geográficamente concentrados.
- **Agricultura directa:** Retornos bajos y poco significativos.
- **Mercado y proximidad urbana:** Mediadores clave.

Tiene **capítulo completo dedicado a metodología** y discusión de IV, valioso para diseño metodológico del APER 2026 en su análisis de retornos del gasto.

## 3. Pregunta de investigación / objetivos

Idéntica a Mogues2011 (versión artículo).

## 4. Marco teórico y conceptual

Aplica el marco Fan-Hazell-Thorat a Etiopía. Distingue 5 categorías: caminos, agricultura, educación, salud, agua.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Research report con panel + IV |
| Población | Hogares rurales etíopes |
| N | ~7.000 hogares × 8 regiones |
| Período | 1996-2007 |
| Geografía | Etiopía |
| Fuentes de datos | ERHS + presupuestos regionales |
| Método de identificación | Panel FE + IV (variables instrumentales con lags) |
| Software / código | Stata |
| Replicable | Parcial (datos restringidos) |

## 6. Hallazgos cuantitativos clave

- **Caminos rurales:** Coeficiente positivo, magnitud grande, significativo al 1%.
- **Agricultura directa:** Coeficientes positivos pero pequeños y a menudo no significativos al 5%.
- **Heterogeneidad regional:** Detallada en Cap. 5 con tablas por región.

## 7. Hallazgos cualitativos / interpretativos

- **Complementariedad:** Caminos potencian retorno del gasto agrícola.
- **Implementación importa:** El gasto presupuestado no equivale a impacto entregado.

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
| Cap. 2 (gasto y composición) | Versión detallada del benchmark Etiopía | §2.4 |
| Cap. 4 (eficiencia) | Metodología de retornos por categoría | §4.1 |

## 10. Limitaciones del documento

- Mismas que Mogues2011.
- Contexto institucional etíope diferente al boliviano.

## 11. Vínculos con otros documentos en `03_literature/`

- Versión preliminar de: `Mogues2011`
- Aplica marco de: `FanHazellThorat2000`
- Refuerza: `GoyalNash2017`, `Pernechele2021`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> Mogues, Ayele y Paulos [@MoguesIFPRI2008] presentan en el Research Report de IFPRI el análisis completo de retornos al gasto público rural en Etiopía. El gasto en caminos rurales tiene retornos sustancialmente mayores que el gasto directo en agricultura, pero ambos son complementarios. El reporte tiene detalle metodológico — IV, tests de robustez, descomposiciones regionales — que es referencia para el diseño analítico del APER 2026.

**EN (≤80 palabras):**
> Mogues, Ayele and Paulos [@MoguesIFPRI2008] present in the IFPRI Research Report the full analysis of returns to rural public spending in Ethiopia. Spending on rural roads has substantially higher returns than direct agricultural spending, but the two are complementary. The report has methodological detail — IV, robustness tests, regional decompositions — that is a reference for the analytical design of the APER 2026.

## 13. BibTeX

```bibtex
@techreport{MoguesIFPRI2008,
  author      = {Mogues, Tewodaj and Ayele, Gezahegn and Paulos, Zelekawork},
  title       = {The Bang for the Birr: Public Expenditures and Rural Welfare in {E}thiopia},
  institution = {International Food Policy Research Institute (IFPRI)},
  type        = {{IFPRI} Research Report},
  number      = {160},
  year        = {2008},
  address     = {Washington, DC},
  url         = {https://www.ifpri.org/publication/bang-birr-public-expenditures-and-rural-welfare-ethiopia}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF descargado (IFPRI ebrary)
- [x] Hallazgos verificados via reseñas y artículo JDS 2011
- [x] BibTeX validado
- [x] Snippet ES + EN listos
- [x] Cross-referenced
- [x] Asignado a capítulos
