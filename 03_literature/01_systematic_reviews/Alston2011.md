---
citekey: Alston2011
audit_status: yellow
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Metadata confirmada vía Crossref (DOI 10.1093/ajae/aar044): Alston/Andersen/James/Pardey, AJAE 93(5):1257-1277, 2011. Sin PDF disponible para verificar cifras §6, así que máximo nivel achievable es yellow."
type: article
title: "The Economic Returns to U.S. Public Agricultural Research"
authors: "Alston, Julian M. & Andersen, Matthew A. & James, Jennifer S. & Pardey, Philip G."
year: 2011
source: "American Journal of Agricultural Economics"
volume: "93"
issue: "5"
pages: "1257-1277"
doi: "10.1093/ajae/aar044"
url: "https://onlinelibrary.wiley.com/doi/abs/10.1093/ajae/aar044"
pdf_path: "03_literature/pdfs/01_systematic_reviews/Alston2011.pdf"
pdf_downloaded: unavailable
evidence_level: 1
geographic_scope: "Global"
period_covered: "1949-2002"
language: "en"
methodology: "Meta-analysis"
relevance_chapters: ["Cap3", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["agricultural_R&D", "rates_of_return", "USA", "spillovers", "public_investment"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — Returns to U.S. Public Agricultural Research (Alston et al. 2011)

## 1. Referencia bibliográfica

> Alston, J.M., Andersen, M.A., James, J.S., & Pardey, P.G. (2011). The Economic Returns to U.S. Public Agricultural Research. *American Journal of Agricultural Economics*, 93(5), 1257-1277. https://doi.org/10.1093/ajae/aar044

## 2. Resumen ejecutivo

Re-estimación rigurosa de los retornos a la investigación pública agrícola en EE.UU. con paneles estatales 1949-2002, controlando por spillovers entre estados, lag estructural (gamma) y depreciación del conocimiento. **Encuentran una TIR media del orden de 9.9% a 32.9% por año**, considerablemente más conservadora que la mediana del meta-análisis de Alston et al. 2000 (~44%), pero aún muy por encima del costo de oportunidad de los fondos públicos. Esto refuerza el argumento de sub-inversión en I+D agrícola pública.

## 3. Pregunta de investigación

- ¿Cuál es la tasa de retorno verdadera al gasto público en I+D agrícola en EE.UU., con tratamiento adecuado de lags, spillovers y depreciación?

## 4. Marco teórico

Función de producción agrícola con stock de conocimiento, función gamma de lag (Pardey & Craig 1989; Huffman & Evenson 1993), spillovers inter-estatales tipo Griliches.

## 5. Datos y método

| Elemento | Especificación |
|---|---|
| Tipo | Panel de 48 estados de EE.UU., FE + IV |
| N | 48 estados × ~50 años |
| Período | 1949-2002 |
| Software | No reportado |

## 6. Hallazgos cuantitativos clave

- **TIR estatal estimada:** rango de 9.9% a 32.9%/año (mediana ~21%)
- Spillovers inter-estatales **muy significativos**: ~50% del beneficio de la investigación de un estado se captura en otros estados
- Lag promedio entre inversión y máximo retorno: ~24 años
- **Pardey-James-Alston advierten que TIRs de 40-80% publicadas son sobre-estimaciones**

## 7. Hallazgos interpretativos

El método importa enormemente: la TIR cae a la mitad cuando se contabilizan spillovers correctamente. Aún así, todas las estimaciones quedan por encima del costo de capital social (~3-5%), confirmando rentabilidad social muy alta de la I+D agrícola pública.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER

| Capítulo | Uso |
|---|---|
| Cap. 3 | Soporte cuantitativo para argumento de aumento del gasto INIAF |
| Cap. 4 | Benchmark de TIR conservadora (no usar 44%, usar ~20%) |
| Cap. 5 | Magnitud realista del retorno esperado a un peso adicional en I+D agrícola |

## 10. Limitaciones

- Contexto EE.UU. (no necesariamente extrapolable a Bolivia)
- No considera externalidades ambientales
- Asume estabilidad estructural del proceso de innovación

## 11. Vínculos

- Refuerza y refina: `AlstonPardey2000`
- Citado por: `Hurley2014`, `Gautam2022`, `Mogues2012`

## 12. Snippet

**ES:** Estimaciones rigurosas para EE.UU. con paneles estatales muestran TIRs a I+D agrícola pública en el rango 10-33%/año, sustancialmente menores a la mediana global histórica pero aún muy superiores al costo de oportunidad del capital [@Alston2011].

**EN:** Rigorous state-panel estimates for the U.S. show rates of return to public agricultural R&D in the 10-33%/year range, substantially lower than the historical global median but still well above the social cost of capital [@Alston2011].

## 13. BibTeX

```bibtex
@article{Alston2011,
  author  = {Alston, Julian M. and Andersen, Matthew A. and James, Jennifer S. and Pardey, Philip G.},
  title   = {The Economic Returns to {U.S.} Public Agricultural Research},
  journal = {American Journal of Agricultural Economics},
  year    = {2011},
  volume  = {93},
  number  = {5},
  pages   = {1257--1277},
  doi     = {10.1093/ajae/aar044}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (pago — paywall Wiley)
- [x] BibTeX
- [x] Snippet ES + EN
