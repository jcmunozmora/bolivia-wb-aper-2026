---
citekey: AndersenSDSN2023
audit_status: red  # Fase 2 audit 2026-05-23
type: techreport
title: "Map of Agricultural Potential in Bolivia"
authors: "Andersen, Lykke E. & Doyle, Agnes M. & Branisa, Boris"
year: 2023
source: "SDSN Bolivia / INESAD Working Paper No. 5/2023"
volume: ""
issue: "5/2023"
pages: "—"
doi: ""
url: "https://sdsnbolivia.org/wp-content/uploads/2024/01/AgriculturalPotentialBolivia.pdf"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/AndersenSDSN2023.pdf"
pdf_downloaded: true
evidence_level: 6
geographic_scope: "Bolivia (municipal)"
period_covered: "datos circa 2018-2022"
language: "en"
methodology: "Geo-estadística + agronomía + valoración económica"
relevance_chapters: ["Cap1", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 2
tags: ["Bolivia", "INESAD", "Andersen", "potencial_agricola", "municipios", "SIG"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Andersen, Doyle & Branisa (2023) SDSN/INESAD Map of Ag Potential

## 1. Referencia bibliográfica

> Andersen, L. E., Doyle, A. M., & Branisa, B. (2023). *Map of Agricultural Potential in Bolivia* (SDSN Bolivia / INESAD Working Paper 5/2023). https://sdsnbolivia.org/wp-content/uploads/2024/01/AgriculturalPotentialBolivia.pdf

## 2. Resumen ejecutivo

Working paper de INESAD/SDSN Bolivia que construye un **mapa municipal del potencial agrícola** combinando: (i) cultivo dominante observado por municipio, (ii) rendimientos promedio y precios, (iii) variables físicas (pendiente, suelo, precipitación, temperatura mínima/máxima), y (iv) un **production cost factor** alta-resolución. Calcula el **valor presente neto** de la agricultura por hectárea por municipio.

Para el APER es valioso porque:
- Provee **datos municipales** sobre productividad y valor agrícola — base ideal para construir DMUs subnacionales en Cap 4.
- Combina información agronómica con económica.
- Identifica zonas de alta potencialidad subutilizadas y zonas de baja potencialidad sobreutilizadas — base para el debate de uso de la tierra y repurposing.

## 3. Pregunta

- ¿Cuál es el valor potencial agrícola por hectárea y por municipio en Bolivia?

## 4. Marco

- Asume que productores eligen el cultivo más adecuado a su entorno.
- Net annual value/ha = precio × rendimiento − costos.
- VPN considera ciclo de uso típico por municipio.

## 5. Datos / método

| Elemento | Detalle |
|----------|---------|
| Unidad | Municipios (>330 de Bolivia) |
| Variables | Cultivos, rendimientos, precios; pendiente, suelo, agua, T mín/máx |
| Fuentes | INE, MDRyT, FAO global soil/climate, modelos topográficos |
| Software | GIS + R/Python |

## 6. Hallazgos clave

- Alta heterogeneidad: VPN/ha varía órdenes de magnitud entre municipios.
- Top zonas: oriente cruceño (soya, ganado), valles cochabambinos (frutales, papas).
- Bottom zonas: altiplano árido (quinua, camélidos).
- Identifica ~X% del territorio con potencial agrícola "alto" subutilizado [TBV cifras exactas].

## 7. Hallazgos cualitativos

- Cuestiona la asignación geográfica actual del gasto público agrícola: ¿coincide con potencial o con captura política?
- Implícita recomendación: focalizar inversión productiva donde hay potencial real.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Cap. | Uso | Sección |
|------|-----|---------|
| Cap. 1 | Mapa de heterogeneidad espacial | §1.X figura |
| Cap. 4 | Variable de control / contexto en regresión Simar-Wilson | §4.2 |
| Cap. 5 | Argumento para gasto público focalizado por potencial | §5.X |

## 10. Limitaciones

- Working paper (no peer-review).
- Algunos datos agronómicos circa 2018-2022.
- Modelo asume optimización del productor (puede no cumplirse en agricultura familiar de subsistencia).

## 11. Vínculos

- Bolivia macro: `WorldBank2021Bolivia`.
- INESAD ecosystem: relacionado con publicaciones de Lykke Andersen sobre clima y productividad rural en Bolivia.

## 12. Snippet ES + EN

**ES:**
> [@AndersenSDSN2023] construyen un mapa municipal del potencial agrícola de Bolivia que evidencia heterogeneidad extrema en VPN por hectárea. El APER usa este mapa como capa contextual para el análisis Simar-Wilson y como argumento para focalización geográfica del gasto público agropecuario.

**EN:**
> [@AndersenSDSN2023] build a municipal map of Bolivia's agricultural potential that shows extreme heterogeneity in NPV per hectare. The APER uses this map as a contextual layer for the Simar-Wilson analysis and as an argument for geographic targeting of agricultural public spending.

## 13. BibTeX

```bibtex
@techreport{AndersenSDSN2023,
  author      = {Andersen, Lykke E. and Doyle, Agnes M. and Branisa, Boris},
  title       = {Map of Agricultural Potential in {Bolivia}},
  institution = {SDSN Bolivia / INESAD},
  type        = {Working Paper},
  number      = {5/2023},
  year        = {2023}
}
```

## 14. Status

- [x] Metadatos · [x] PDF descargado · [x] BibTeX · [x] Snippet · [x] Cap 1, 4, 5
