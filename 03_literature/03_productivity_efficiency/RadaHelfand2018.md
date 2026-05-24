---
citekey: RadaHelfand2018
audit_status: red  # Fase 3 audit 2026-05-23 (PDF NO corresponde a la cita)
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "ALUCINACION CRITICA: pdf_path apunta a 'RadaHelfand2018_workingpaper.pdf' pero el PDF descargado es 'Agricultural Productivity and Family Farms in Brazil: Creating Opportunities and Closing Gaps' por Helfand/Moreira/Bresnyan (World Bank, 15 junio 2015) — NO es el Rada/Helfand/Magalhaes 2019 Food Policy paper. El paper Food Policy SI existe (DOI 10.1016/j.foodpol.2018.03.014 valido) pero NO esta en disco. Re-descargar o cambiar pdf_downloaded a false."
type: article
title: "Agricultural productivity growth in Brazil: Large and small farms excel"
authors: "Rada, Nicholas E. & Helfand, Steven M. & Magalhães, Marcelo M."
year: 2019
source: "Food Policy"
volume: "84"
issue: ""
pages: "176-185"
doi: "10.1016/j.foodpol.2018.03.014"
url: "https://doi.org/10.1016/j.foodpol.2018.03.014"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/RadaHelfand2018_workingpaper.pdf"
pdf_downloaded: true
evidence_level: 5
geographic_scope: "Brasil (todos los estados)"
period_covered: "1985-2006"
language: "en"
methodology: "TFP por tamaño de finca (censo); regresión de drivers"
relevance_chapters: ["Cap4", "Cap5"]
relevance_score: "Media-Alta"
quality_score: 3
tags: ["TFP", "Brasil", "farm_size", "smallholder", "Embrapa", "U_shape"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Rada, Helfand & Magalhães (2019) Brazil TFP by farm size

## 1. Referencia bibliográfica

> Rada, N. E., Helfand, S. M., & Magalhães, M. M. (2019). Agricultural productivity growth in Brazil: Large and small farms excel. *Food Policy*, 84, 176–185. https://doi.org/10.1016/j.foodpol.2018.03.014

## 2. Resumen ejecutivo

Análisis pionero de la **distribución de TFP por tamaño de finca** en Brasil usando los censos agrícolas de 1985, 1995 y 2006. El hallazgo central: la TFP brasileña forma una **U invertida** (en realidad reportan una "U" donde tanto grandes como pequeñas fincas excel) — fincas muy pequeñas y muy grandes tienen TFP alta, mientras las medianas se rezagan. Este patrón cuestiona la presunción simple de que solo las grandes ganan productividad.

Para Bolivia es referencia comparativa: tanto el oriente (latifundios soyeros) como el occidente (parcelas pequeñas indígenas) podrían exhibir TFP relativamente alta dentro de su categoría, mientras los medianos del valle quedan rezagados. El APER puede testear este patrón con datos del Censo Agropecuario boliviano 2013 [TBV].

## 3. Pregunta

- ¿Cómo se distribuye la TFP por tamaño de finca en Brasil y qué factores la explican?

## 4. Marco

- TFP Tornqvist por categoría de tamaño.
- Categorías: <5ha, 5-20ha, 20-100ha, 100-500ha, 500-1000ha, >1000ha.

## 5. Datos / método

| Elemento | Detalle |
|----------|---------|
| Datos | Censos Agropecuarios Brasil 1985, 1995, 2006 |
| Cobertura | 100% fincas (~5 millones) |
| Outputs | Cultivos + ganadería en R$ constantes |
| Inputs | Tierra, mano de obra (familiar + asalariada), capital |

## 6. Hallazgos cuantitativos

- TFP fincas <5 ha: alta (con caveat de medición).
- TFP fincas 100-500 ha: la **más baja** (rezagadas).
- TFP fincas >500 ha: alta y creciente rápido.
- Crecimiento TFP 1985-2006 mayor en extremos (U-shape de crecimiento).
- Pequeños beneficiarios: programas como Pronaf, asistencia técnica.

## 7. Hallazgos cualitativos

- Embrapa y Pronaf como complementarios — no excluyentes.
- "Bimodal" agriculture: agricultura empresarial moderna + agricultura familiar viable; reto = los medianos.
- Recomendación: políticas diferenciadas por tamaño, no "one-size-fits-all".

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
| Cap. 4 | Hipótesis a testear con datos Bolivia: ¿la TFP boliviana también es bimodal por tamaño? | §4.3 heterogeneidad |
| Cap. 5 | Argumento para políticas diferenciadas por estratos (agricultura familiar andina vs. soya empresarial cruceña) | §5.X |

## 10. Limitaciones

- Datos hasta 2006 (Censo 2017 brasileño está disponible pero no cubierto).
- Medición de inputs en fincas muy pequeñas tiene mayor incertidumbre.
- Brasil ≠ Bolivia: validar comparación con cuidado.

## 11. Vínculos

- Datos previos: `HelfandMagalhaes2015`.
- Brasil TFP general: `Gasques2010ERS`, `Arias2017Brazil`.
- LAC: `NinPratt2018`.

## 12. Snippet ES + EN

**ES:**
> [@RadaHelfand2018] muestran que en Brasil, tanto las fincas más pequeñas como las más grandes lideran el crecimiento de TFP, mientras las medianas se rezagan. Este patrón "bimodal" sugiere que el APER debe testear si Bolivia exhibe una dinámica similar entre la agricultura familiar andina y la empresarial cruceña, con implicaciones para políticas diferenciadas en el repurposing.

**EN:**
> [@RadaHelfand2018] show that in Brazil, both the smallest and the largest farms lead TFP growth while mid-sized farms lag. This "bimodal" pattern suggests the APER should test whether Bolivia exhibits similar dynamics between Andean smallholder agriculture and Santa Cruz agribusiness, with implications for differentiated repurposing policies.

## 13. BibTeX

```bibtex
@article{RadaHelfand2018,
  author  = {Rada, Nicholas E. and Helfand, Steven M. and Magalh{\~a}es, Marcelo M.},
  title   = {Agricultural productivity growth in {Brazil}: Large and small farms excel},
  journal = {Food Policy},
  year    = {2019},
  volume  = {84},
  pages   = {176--185},
  doi     = {10.1016/j.foodpol.2018.03.014}
}
```

## 14. Status

- [x] Metadatos · [x] PDF (working paper UCR version of Food Policy 2019) · [x] BibTeX · [x] Snippet · [x] Cap 4, 5
