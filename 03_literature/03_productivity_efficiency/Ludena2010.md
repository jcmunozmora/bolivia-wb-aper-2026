---
citekey: Ludena2010
audit_status: green  # Fase 2 audit 2026-05-23
type: techreport
title: "Agricultural Productivity Growth, Efficiency Change and Technical Progress in Latin America and the Caribbean"
authors: "Ludeña, Carlos E."
year: 2010
source: "IDB Working Paper Series IDB-WP-186"
volume: ""
issue: "IDB-WP-186"
pages: "—"
doi: "10.2139/ssrn.1817296"
url: "https://publications.iadb.org/en/agricultural-productivity-growth-efficiency-change-and-technical-progress-latin-america-and"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Ludena2010.pdf"
pdf_downloaded: true
evidence_level: 7
geographic_scope: "LAC (26 países incl. Bolivia)"
period_covered: "1961-2007"
language: "en"
methodology: "DEA-Malmquist + descomposición eficiencia/tecnología"
relevance_chapters: ["Cap1", "Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["DEA", "Malmquist", "LAC", "Bolivia", "TFP", "tecnologia", "eficiencia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Ludeña (2010) Agricultural productivity LAC

## 1. Referencia bibliográfica

> Ludeña, C. E. (2010). *Agricultural Productivity Growth, Efficiency Change and Technical Progress in Latin America and the Caribbean* (IDB Working Paper No. IDB-WP-186). Inter-American Development Bank. https://doi.org/10.2139/ssrn.1817296

## 2. Resumen ejecutivo

Aplicación de **DEA-Malmquist** a 26 países LAC entre 1961-2007 para descomponer el crecimiento de TFP agrícola en **cambio técnico** (desplazamiento de la frontera) y **cambio de eficiencia** (catching-up). Es el principal antecedente regional metodológico del enfoque que el APER aplica a Bolivia subnacional.

Hallazgos LAC:
- TFP regional ~1.9%/año (entre los más altos del mundo en desarrollo).
- Crecimiento dominado por cambio técnico, no por catching-up de los rezagados.
- Países land-abundant (Brasil, Argentina) lideran; land-constrained (Centroamérica, Andinos) rezagados.
- **Bolivia**: TFP estimada ~0.6%/año, en grupo inferior, con cambio técnico negativo en algunas décadas.
- Subsectores: cultivos > no-ruminantes > ruminantes (ganadería más rezagada).

## 3. Pregunta

- ¿Cómo varía el crecimiento de TFP agrícola en LAC y qué parte se debe a cambio técnico vs. mejora de eficiencia?

## 4. Marco teórico

- DEA-Malmquist: M = (eficiencia futura/eficiencia presente) × (tecnología futura/tecnología presente).
- M > 1: TFP creció. M = EC (eff change) × TC (tech change).
- Países como DMUs; frontera = mejores prácticas regionales.

## 5. Datos y método

| Elemento | Detalle |
|----------|---------|
| Estudio | DEA-Malmquist panel países |
| N | 26 países LAC |
| Período | 1961-2007 (sub-períodos: 60s, 70s, 80s, 90s, 00s) |
| Inputs | Tierra agrícola, mano de obra, fertilizante, maquinaria, animales |
| Outputs | Cultivos + ganadería (FAOSTAT) |
| Software | DEAP / FRONTIER (probable) |

## 6. Hallazgos cuantitativos clave (selección)

- TFP LAC 1961-2007: **+1.9%/año**.
- Décadas: 60s (+1.5%), 70s (+1.7%), 80s (+1.4%), 90s (+2.4%), 00s (+2.7%).
- Bolivia: TFP ~0.6%/año; cambio técnico cercano a cero o negativo en 80s-90s; ligera mejora en 2000s.
- Top-3 LAC TFP: Brasil (~3.5%), Chile (~2.8%), Costa Rica (~2.5%).
- Bottom-3: Bolivia, Nicaragua, Haití (TFP < 1%).

## 7. Hallazgos cualitativos

- LAC se beneficia del shift global hacia países en desarrollo, pero con alta heterogeneidad.
- Países rezagados como Bolivia muestran señales de "catching-up" reciente, no de desplazamiento de la frontera.
- La frontera regional la fija Brasil; otros países se mueven respecto a ella.

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
| Cap. 1 | Benchmark regional; tabla comparativa LAC TFP | §1.3 Contexto regional |
| Cap. 4 | **Antecedente directo** del método DEA-Malmquist que el APER replica a escala subnacional boliviana. Justifica que Bolivia opera muy por debajo de la frontera regional | §4.1 Marco, §4.4 Discusión |

## 10. Limitaciones

- País como DMU agregada — no captura heterogeneidad subnacional (justifica el ejercicio del APER).
- DEA sin bootstrap (no Simar-Wilson): scores sin corrección de sesgo.
- Datos FAO con calidad heterogénea (Bolivia [TBV]).
- Cubre hasta 2007; actualizar con `Fuglie2024`.

## 11. Vínculos

- Actualización metodológica: `NinPratt2018` (mismo IDB, 2015 IDB-WP-608).
- Manual: `Coelli2005` cap. 6.
- Datos comparables: `Fuglie2024`, `AvilaEvenson2010`.
- Andes-específico: `Schling2024LandRegularization`, `Bragagnolo2021`.

## 12. Snippet ES + EN

**ES:**
> [@Ludena2010] aplica DEA-Malmquist a 26 países de América Latina y el Caribe entre 1961 y 2007 y muestra que Bolivia tuvo uno de los crecimientos de TFP agrícola más bajos de la región (~0.6%/año, frente a un promedio LAC de ~1.9%), con cambio técnico negativo en algunas décadas. El APER replica este enfoque a escala subnacional boliviana para identificar dónde dentro del país se concentra el rezago.

**EN:**
> [@Ludena2010] applies DEA-Malmquist to 26 Latin American and Caribbean countries between 1961 and 2007 and shows that Bolivia had one of the region's lowest agricultural TFP growth rates (~0.6%/year vs. an LAC average of ~1.9%), with negative technical change in some decades. The APER replicates this approach at the subnational scale within Bolivia to identify where the lag concentrates.

## 13. BibTeX

```bibtex
@techreport{Ludena2010,
  author      = {Lude{\~n}a, Carlos E.},
  title       = {Agricultural Productivity Growth, Efficiency Change and Technical Progress in {Latin America} and the {Caribbean}},
  institution = {Inter-American Development Bank},
  type        = {{IDB Working Paper}},
  number      = {{IDB-WP-186}},
  year        = {2010},
  doi         = {10.2139/ssrn.1817296}
}
```

## 14. Status

- [x] Metadatos · [x] PDF descargado · [x] BibTeX · [x] Snippet · [x] Cap 1 y 4 — **antecedente metodológico regional**
