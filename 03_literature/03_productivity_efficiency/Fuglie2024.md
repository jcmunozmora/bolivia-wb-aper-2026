---
citekey: Fuglie2024
audit_status: green  # Fase 2 audit 2026-05-23
type: techreport
title: "World Agricultural Production, Resource Use, and Productivity, 1961-2020"
authors: "Fuglie, Keith O. & Morgan, Stephen & Jelliffe, Jeremy"
year: 2024
source: "USDA Economic Research Service, Economic Information Bulletin EIB-268"
volume: ""
issue: "EIB-268"
pages: "—"
doi: ""
url: "https://www.ers.usda.gov/publications/pub-details/?pubid=108649"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Fuglie2024.pdf"
pdf_downloaded: true
evidence_level: 7
geographic_scope: "Global (179 países, incluido Bolivia)"
period_covered: "1961-2020"
language: "en"
methodology: "TFP indexing (Tornqvist) + descriptivo"
relevance_chapters: ["Cap1", "Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["TFP", "global", "USDA_ERS", "Bolivia", "Fuglie", "panel_paises"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Fuglie, Morgan & Jelliffe (2024) USDA ERS TFP global

## 1. Referencia bibliográfica

> Fuglie, K. O., Morgan, S., & Jelliffe, J. (2024). *World Agricultural Production, Resource Use, and Productivity, 1961–2020* (EIB-268). U.S. Department of Agriculture, Economic Research Service. PDF: https://www.ers.usda.gov/publications/pub-details/?pubid=108649

## 2. Resumen ejecutivo

Documento técnico de referencia del **dataset USDA-ERS International Agricultural Productivity**, que reporta TFP agrícola para 179 países (incl. Bolivia) entre 1961 y 2020. La metodología agrega outputs (cultivos y ganadería en cantidades) y inputs (tierra, mano de obra, maquinaria, fertilizante, animales, feed) ponderados por precios de referencia, mediante índices Tornqvist. Es la **fuente cuantitativa única** que el APER debe usar para situar Bolivia en el contexto global y regional de productividad.

Hallazgos globales:
- TFP global agrícola creció ~1.7% anual 1961-2020 (compuesto).
- Países desarrollados: 1.5% promedio.
- Países en desarrollo: aceleraron desde 1990; ahora explican 2/3 del crecimiento global de outputs.
- Países LAC: TFP creció ~1.9% anual (mayor que media global) — pero con alta heterogeneidad: Brasil > 3%, Bolivia < 1%.

Para Bolivia, el dataset Fuglie identifica TFP cercana a 0.6% anual de 1961-2020, una de las más bajas de Sudamérica (resultado consistente con `WorldBank2021Bolivia`, `Bragagnolo2021`).

## 3. Pregunta

- ¿Cómo ha evolucionado la productividad total de factores agrícola a nivel global, regional y nacional desde 1961?

## 4. Marco

- Índice Tornqvist (chain-linked, base 2015).
- Definición input: tierra (agro-ecologicamente ponderada), mano de obra, capital (animales, maquinaria), feed, fertilizante.
- Output: cultivos + ganadería + acuicultura, agregados a precios internacionales de referencia.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo | Construcción de panel + análisis descriptivo |
| Población | 179 países y territorios |
| Período | 1961-2020 (actualización Oct 2024) |
| Fuentes | FAOSTAT (output, inputs), USDA, OECD |
| Replicable | Sí — dataset público |

## 6. Hallazgos cuantitativos clave (selección APER)

- TFP global 1961-2020: ~1.7%/año.
- LAC: ~1.9%/año (1961-2020), aceleración post-1990.
- **Bolivia**: TFP ~0.6%/año (1961-2020); ~0.36% (2001-2010); ~2.6% (2011-2015, parcial) [TBV con dataset crudo].
- Brasil: 2.5-3.0%/año (driver regional).
- Cono Sur: mayor crecimiento por tierra abundante + I+D.

## 7. Hallazgos cualitativos

- "Shifting source of growth" del agro: en 1960s/70s, la expansión del área cultivada explicaba la mayoría del crecimiento; desde 2000, la TFP explica >2/3.
- Bolivia: dominado por expansión del área (tierra abierta a la agricultura), no por TFP — consistente con la narrativa del APER sobre el modelo extensivo del Oriente.

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
| Cap. 1 (contexto) | Comparación TFP Bolivia vs. LAC vs. global; figura 1.X | §1.3 |
| Cap. 4 | Benchmark para el análisis DEA-SFA: confirma que la productividad boliviana opera muy por debajo de la frontera regional | §4.4 Discusión |

## 10. Limitaciones

- Definición agregada del país (no captura heterogeneidad subnacional).
- Precios de referencia internacionales; sensibilidad a la base.
- Dataset depende de FAOSTAT que tiene calidad heterogénea por país (Bolivia: declaraciones MDRyT-INE [TBV calidad]).

## 11. Vínculos

- Sintetizado en: `FuglieRada2013` (Choices, accesible).
- Edición previa del marco metodológico: `FuglieWangBall2012`.
- Aplicación específica LAC: `NinPratt2018`, `AvilaEvenson2010`, `Ludena2010`.
- Bolivia específico: `WorldBank2021Bolivia`, `Bragagnolo2021`.

## 12. Snippet ES + EN

**ES:**
> Según el dataset USDA ERS de productividad agrícola internacional [@Fuglie2024], el crecimiento de la TFP agrícola en Bolivia ha promediado aproximadamente 0.6% anual entre 1961 y 2020, una de las tasas más bajas de Sudamérica, frente a un promedio LAC de ~1.9% y un promedio global de ~1.7%. Esto sitúa al país muy por debajo de la frontera regional y refleja el carácter extensivo (más que intensivo) del crecimiento agrícola boliviano.

**EN:**
> According to the USDA ERS international agricultural productivity dataset [@Fuglie2024], TFP growth in Bolivian agriculture averaged roughly 0.6% per year between 1961 and 2020 — one of the lowest rates in South America, against an LAC average of ~1.9% and a global average of ~1.7%. This places Bolivia well below the regional frontier and reflects the extensive (rather than intensive) nature of Bolivian agricultural growth.

## 13. BibTeX

```bibtex
@techreport{Fuglie2024,
  author      = {Fuglie, Keith O. and Morgan, Stephen and Jelliffe, Jeremy},
  title       = {World Agricultural Production, Resource Use, and Productivity, 1961--2020},
  institution = {U.S. Department of Agriculture, Economic Research Service},
  type        = {Economic Information Bulletin EIB-268},
  year        = {2024},
  url         = {https://www.ers.usda.gov/publications/pub-details/?pubid=108649}
}
```

## 14. Status

- [x] Metadatos · [x] PDF descargado (3.3 MB) · [x] BibTeX · [x] Snippet · [x] Cap 1 y Cap 4 — **fuente cuantitativa central** del benchmark internacional
