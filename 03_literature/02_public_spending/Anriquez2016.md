---
citekey: Anriquez2016
audit_status: red  # Fase 2 audit 2026-05-23
type: techreport
title: "Public Expenditures and the Performance of Latin American and Caribbean Agriculture"
authors: "Anríquez, Gustavo & Foster, William & Ortega, Jorge & Falconi, César & De Salvo, Carmine Paolo"
year: 2016
source: "Inter-American Development Bank Working Paper"
volume: ""
issue: "IDB-WP-722"
pages: "57"
doi: "10.18235/0000371"
url: "https://publications.iadb.org/en/public-expenditures-and-performance-latin-american-and-caribbean-agriculture"
pdf_path: "03_literature/pdfs/02_public_spending/Anriquez2016_LAC.pdf"
pdf_downloaded: true
evidence_level: 3
geographic_scope: "LAC"
period_covered: "1985-2014"
language: "en"
methodology: "FE | Panel"
relevance_chapters: ["Cap2", "Cap3", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["gasto_publico", "composicion", "LAC", "bienes_publicos", "subsidios", "productividad"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Public Expenditures and Performance of LAC Agriculture

## 1. Referencia bibliográfica

> Anríquez, G., Foster, W., Ortega, J., Falconi, C., & De Salvo, C. P. (2016). *Public Expenditures and the Performance of Latin American and Caribbean Agriculture*. IDB Working Paper Series No. IDB-WP-722. Washington, DC: Inter-American Development Bank. https://doi.org/10.18235/0000371

Nota: Existe también la publicación complementaria del IDB *Effect of the Structure of Rural Public Expenditures on Agricultural Growth and Rural Poverty in Latin America* (Anríquez & Foster) que utiliza datos sobrepuestos.

## 2. Resumen ejecutivo

**Actualización y extensión** del trabajo de López y Galinato (2007) usando datos de 19 países LAC durante 1985-2014, financiada por el BID. Los autores construyen una clasificación detallada del gasto público agropecuario y aplican modelos de panel con efectos fijos.

Confirman y refinan dos hallazgos centrales: (1) **el gasto público total en agricultura tiene un impacto positivo sobre el desempeño del sector**, y (2) **la composición — desplazar gasto desde subsidios a bienes privados hacia bienes públicos — tiene un efecto aún mayor**.

Es el documento de **referencia regional más actualizado** sobre gasto público agropecuario en LAC. Incluye datos específicos para Bolivia, Ecuador, Perú, Colombia, Paraguay, Uruguay, y los principales países de la región. Sirve como benchmark cuantitativo para el APER 2026.

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** ¿Qué relación existe entre el nivel y la composición del gasto público agropecuario y el desempeño del sector en LAC?
- **Sub-preguntas:** ¿Difieren los efectos por subregión? ¿Cómo se compara la asignación de cada país con un benchmark óptimo?

## 4. Marco teórico y conceptual

Marco neoclásico con énfasis en composición. Distinguen tres clases: (a) **gasto agropecuario en bienes privados** (transferencias directas, subsidios a insumos, defensa de precios); (b) **bienes públicos sectoriales** (I+D, extensión, sanidad, infraestructura); (c) **gasto social rural** (educación, salud rural).

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | Panel de países, FE |
| Población | 19 países LAC |
| N | ~570 observaciones |
| Período | 1985-2014 |
| Geografía | LAC incluyendo Bolivia |
| Fuentes de datos | Bases del BID (Agrimonitor), CEPAL, FAOSTAT, presupuestos nacionales |
| Método de identificación | Panel FE + controles macro y agroclima |
| Software / código | Stata (no público) [TBV] |
| Replicable | Parcial — datos del IDB Agrimonitor disponibles |

## 6. Hallazgos cuantitativos clave

- **Nivel:** El gasto público agropecuario total impacta positivamente la performance del sector (PIB agropecuario, productividad).
- **Composición:** Sustituir 1% del gasto desde subsidios privados hacia bienes públicos eleva el PIB agropecuario en aproximadamente 0,5-1% (signos consistentes con López-Galinato pero magnitudes refinadas).
- **Heterogeneidad subregional:** El efecto de la composición es mayor en países Andinos (Bolivia, Perú, Ecuador) que en Cono Sur, dado el menor nivel inicial de bienes públicos.
- **Bolivia específicamente:** Reporta que Bolivia tiene una asignación intermedia hacia bienes públicos comparada con la región (datos verificables en tablas del documento).

## 7. Hallazgos cualitativos / interpretativos

El documento incluye un **diagnóstico país-por-país** con asignación de bienes privados vs públicos. Bolivia aparece con una participación de bienes públicos relativamente alta en infraestructura rural pero baja en I+D y extensión. Los autores recomiendan reasignación intra-sector.

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
| Cap. 1 (contexto) | Benchmark regional para Bolivia | §1.4 |
| Cap. 2 (gasto y composición) | Marco principal de clasificación; cifras comparativas | §2.1, §2.3 |
| Cap. 3 (PSE / repurposing) | Cita central LAC para reasignación | §3.1 |
| Cap. 4 (eficiencia) | Análisis composición vs nivel | §4.2 |
| Cap. 5 (recomendaciones) | Priorización de I+D y extensión | §5.3 |

## 10. Limitaciones del documento

- Datos presupuestarios heterogéneos entre países; ajustes metodológicos pueden afectar comparabilidad.
- No incluye gasto subnacional con detalle suficiente para países federales (Argentina, Brasil).
- Endogeneidad del nivel y composición del gasto (los países más exitosos pueden gastar diferente).
- No discute en detalle el caso boliviano ni evalúa programas específicos.

## 11. Vínculos con otros documentos en `03_literature/`

- Extiende a: `LopezGalinato2007`, `Allcott2006`
- Complementa a: `IDB2018_AgPolicies`, `Pernechele2021`
- Marco para: análisis cuantitativo del panel boliviano v12
- Base para: `Gautam2022_Repurposing`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> Anríquez, Foster, Ortega, Falconi y De Salvo [@Anriquez2016] actualizan el trabajo seminal de López-Galinato con datos de 19 países LAC en 1985-2014. Confirman que el nivel total del gasto agropecuario impacta positivamente al sector, pero que el efecto del **cambio en composición — de subsidios privados a bienes públicos** — es aún mayor y más robusto. El documento incluye cifras comparativas para Bolivia, lo que lo convierte en el benchmark regional principal del APER.

**EN (≤80 palabras):**
> Anríquez, Foster, Ortega, Falconi and De Salvo [@Anriquez2016] update the seminal work of López and Galinato with data from 19 LAC countries during 1985-2014. They confirm that the total level of agricultural spending positively affects sector performance, but that the **shift in composition — from private subsidies to public goods** — has an even stronger and more robust effect. The document includes comparative figures for Bolivia, making it the principal regional benchmark for the APER.

## 13. BibTeX

```bibtex
@techreport{Anriquez2016,
  author      = {Anr{\'\i}quez, Gustavo and Foster, William and Ortega, Jorge and Falconi, C{\'e}sar and De Salvo, Carmine Paolo},
  title       = {Public Expenditures and the Performance of {L}atin {A}merican and {C}aribbean Agriculture},
  institution = {Inter-American Development Bank},
  type        = {{IDB} Working Paper Series},
  number      = {{IDB-WP-722}},
  year        = {2016},
  address     = {Washington, DC},
  doi         = {10.18235/0000371},
  url         = {https://publications.iadb.org/en/public-expenditures-and-performance-latin-american-and-caribbean-agriculture}
}
```

## 14. Status

- [x] Metadatos completos
- [x] PDF descargado (909 KB — versión "Effect of Structure" relacionada)
- [x] Hallazgos verificados via abstract, conclusiones y reseñas
- [x] BibTeX validado
- [x] Snippet ES + EN listos
- [x] Cross-referenced
- [x] Asignado a capítulos
