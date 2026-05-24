---
citekey: AnriquezFosterOrtega2016
audit_status: green  # Promovido tras PDF read sesión 11 (pdf-recovery batch 2)
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "PDF leído y verificado sesión 11 pdf-recovery — IDB Working Paper Series Nº IDB-WP-722, 'Public Expenditures and the Performance of Latin American and Caribbean Agriculture' por Gustavo Anriquez, William Foster, Jorge Ortega, Cesar Falconi y Carmine Paolo De Salvo, IDB Environment, Rural Development and Disaster Risk Management Division, August 2016. Match completo de título, autores, año, fuente."
type: techreport
title: "Public Expenditures and the Performance of Latin American and Caribbean Agriculture"
authors: "Anríquez, Gustavo & Foster, William & Ortega, Jorge & Falconi, César & De Salvo, Carmine Paolo"
year: 2016
source: "Inter-American Development Bank (IDB-WP-722)"
doi: ""
url: "https://publications.iadb.org/en/public-expenditures-and-performance-latin-american-and-caribbean-agriculture"
pdf_path: "03_literature/pdfs/07_subsidies_repurposing/AnriquezFosterOrtega2016.pdf"
pdf_downloaded: true
evidence_level: 3
geographic_scope: "LAC"
period_covered: "1985-2014"
language: "en"
methodology: "Panel FE econometric"
relevance_chapters: ["Cap2", "Cap3", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["gasto_publico", "subsidios", "bienes_publicos", "productividad", "LAC"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Anríquez et al. (2016) IDB

## 1. Referencia
> Anríquez, G., Foster, W., Ortega, J., Falconi, C., & De Salvo, C.P. (2016). *Public Expenditures and the Performance of Latin American and Caribbean Agriculture* (IDB-WP-722). Washington, DC: IDB.

## 2. Resumen
Estudio econométrico de panel sobre 19 países LAC (1985-2014). Pregunta: ¿la **composición** del gasto público agrícola (subsidios privados vs. bienes públicos) explica diferencias en productividad? Hallazgo: aumentar la participación del gasto en bienes públicos (I+D, sanidad, extensión, infraestructura rural) eleva significativamente el valor agregado rural per cápita. Específicamente: **un aumento de 10 % en la proporción de bienes públicos genera ~+5 % en VA rural per cápita**. La displacement de bienes públicos por subsidios privados (input subsidies, soporte precios) reduce la performance sectorial.

Para Bolivia: este es el paper económico más directo para fundamentar la tesis del APER de que la composición del gasto importa más que el monto. Argumenta numéricamente el caso de repurposing en LAC.

## 3. Pregunta
- ¿Cómo afecta la composición del gasto público agrícola al desempeño del sector en LAC?

## 4. Marco
- Teoría de bienes públicos (Mundlak, Schultz).
- Hipótesis "composition matters" (Anríquez-López).

## 5. Datos y método
| Elemento | Especificación |
|----------|----------------|
| Tipo | Panel FE econometric |
| N | 19 países LAC |
| Período | 1985-2014 |
| Identificación | FE país + año, IV donde aplica |

## 6. Hallazgos
- 10 % más share bienes públicos → +5 % VA rural per cápita.
- Total spending impact es positivo pero **menor** que efecto composición.
- Composición pública-privada explica gran parte de heterogeneidad LAC.
- Bolivia identificada con share bienes públicos relativamente bajo en el periodo.

## 7. Cualitativo
- Sesgo político hacia subsidios privados (clientelismo, captura).
- Bienes públicos tienen efectos rezagados pero mayores.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER
| Cap. | Uso | Sección |
|------|-----|---------|
| Cap. 2 | Composición gasto Bolivia vs. LAC | §2.5 |
| Cap. 3 | Argumento empírico de repurposing | §3.4 |
| Cap. 5 | Magnitud potencial de ganancia | §5.2 |

## 10. Limitaciones
- Datos pre-2015.
- Algunas variables proxy débiles para Bolivia.

## 11. Vínculos
- Refuerza: `Anriquez2020`, `GautamLaborde2022`
- Complementario: `IDB_Agrimonitor`

## 12. Snippet
**ES:** Anríquez et al. (2016) muestran con datos de panel de 19 países LAC (1985-2014) que un aumento de 10 % en la participación de bienes públicos dentro del gasto agrícola eleva el valor agregado rural per cápita en aproximadamente 5 %, evidencia que la composición — no sólo el monto — del gasto agrícola determina la performance del sector [@AnriquezFosterOrtega2016].

**EN:** Anríquez et al. (2016) show with panel data on 19 LAC countries (1985-2014) that a 10% increase in the public-goods share of agricultural spending raises rural value-added per capita by about 5%, showing that the *composition* — not just the level — of agricultural spending drives sectoral performance [@AnriquezFosterOrtega2016].

## 13. BibTeX
```bibtex
@techreport{AnriquezFosterOrtega2016,
  author      = {Anr{\'i}quez, Gustavo and Foster, William and Ortega, Jorge and Falconi, C{\'e}sar and De Salvo, Carmine Paolo},
  title       = {Public Expenditures and the Performance of Latin American and Caribbean Agriculture},
  institution = {Inter-American Development Bank},
  type        = {IDB Working Paper Series},
  number      = {IDB-WP-722},
  year        = {2016},
  url         = {https://publications.iadb.org/en/public-expenditures-and-performance-latin-american-and-caribbean-agriculture}
}
```

## 14. Status
- [x] Metadatos
- [x] PDF descargado
- [x] BibTeX
- [x] Snippet
- [x] Asignado
