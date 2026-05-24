---
citekey: Laborde2021GHG
audit_status: green  # Promovido tras PDF read sesión 11 (pdf-recovery batch 2)
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "PDF leído y verificado sesión 11 pdf-recovery — 'Agricultural subsidies and global greenhouse gas emissions' por David Laborde, Abdullah Mamun, Will Martin, Valeria Piñeiro y Rob Vos (IFPRI), Nature Communications (2021)12:2601, DOI 10.1038/s41467-021-22703-1. Match completo."
type: article
title: "Agricultural subsidies and global greenhouse gas emissions"
authors: "Laborde, David & Mamun, Abdullah & Martin, Will & Piñeiro, Valeria & Vos, Rob"
year: 2021
source: "Nature Communications"
volume: "12"
issue: "2601"
pages: ""
doi: "10.1038/s41467-021-22703-1"
url: "https://www.nature.com/articles/s41467-021-22703-1"
pdf_path: "03_literature/pdfs/07_subsidies_repurposing/Laborde2021_GHG.pdf"
pdf_downloaded: true
evidence_level: 2
geographic_scope: "Global"
period_covered: "2017"
language: "en"
methodology: "CGE simulation (MIRAGRODEP)"
relevance_chapters: ["Cap3", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["subsidios", "clima", "GEI", "CGE", "repurposing"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Laborde et al. (2021) Subsidies & GHG

## 1. Referencia
> Laborde, D., Mamun, A., Martin, W., Piñeiro, V., & Vos, R. (2021). Agricultural subsidies and global greenhouse gas emissions. *Nature Communications*, 12, 2601. https://doi.org/10.1038/s41467-021-22703-1

## 2. Resumen ejecutivo

Artículo en Nature Communications que cuantifica con un modelo CGE (MIRAGRODEP) el efecto de los subsidios agrícolas globales sobre emisiones de GEI. Resultado central y contra-intuitivo: **eliminar simplemente los subsidios reduciría emisiones agrícolas en sólo 0,6 %** (~34,4 Mt CO2e), porque los subsidios coupled estimulan producción pero las barreras comerciales que coexisten reducen emisiones por desplazamiento. La conclusión clave: para mitigar emisiones agrícolas no basta eliminar subsidios — hay que **redirigirlos a I+D, eficiencia y descarbonización**.

Por subcategoría: subsidios coupled aumentan emisiones; pagos decoupled neutrales; trade interventions reducen emisiones por contracción de producción global. La interacción de instrumentos compensa parcialmente.

Relevancia Bolivia: el subsidio diesel + EMAPA precios son "coupled-like" — estimulan producción de cultivos GEI-intensivos (carne, soya). Repurposing hacia bienes públicos generaría mayor co-beneficio climático que eliminación pura.

## 3. Pregunta
- ¿En qué magnitud los subsidios agrícolas globales contribuyen a emisiones de GEI, y qué efecto tendría eliminarlos o repurpose-arlos?

## 4. Marco
- Modelo CGE MIRAGRODEP con detalle agropecuario y emisiones (FAOSTAT × IPCC).
- Distinción coupled / decoupled / general services.

## 5. Datos y método
| Elemento | Especificación |
|----------|----------------|
| Tipo | CGE global |
| Período | 2017 base, simulación contrafactual |
| Geografía | 79 países / 51 productos |
| Fuentes | OECD PSE, IDB Agrimonitor, FAOSTAT |

## 6. Hallazgos cuantitativos
- Apoyo global: ~US$ 600 mil millones/año (2017).
- Emisiones agrícolas adicionales por subsidios coupled: +34.420 kt CO2eq (+0,6 %).
- Eliminación total apoyo: -1,2 % producción global; impacto sobre pobreza heterogéneo.
- Repurposing hacia I+D verde: reducción de ~17 % de emisiones agrícolas con escenario óptimo.

## 7. Hallazgos cualitativos
- Subsidios y aranceles tienen efectos en direcciones opuestas sobre emisiones.
- Repurposing requiere combinar pull (subsidio I+D) y push (impuestos sobre prácticas contaminantes).

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER
| Capítulo | Cómo se usa | Sección |
|----------|-------------|---------|
| Cap. 3 | Evidencia sobre efectos climáticos de subsidios coupled | §3.3 |
| Cap. 5 | Justificación de redirigir y no sólo eliminar subsidios | §5.4 |

## 10. Limitaciones
- CGE supone equilibrio competitivo.
- Bolivia agrupada en "Other LAC" en el modelo.

## 11. Vínculos
- Refuerza: `GautamLaborde2022`, `WB2024_Recipe`
- Complementario: `Springmann2022`, `Damania2023`

## 12. Snippet

**ES:** Laborde et al. (2021) muestran con un modelo CGE global que la simple eliminación de los subsidios agrícolas reduciría las emisiones en apenas 0,6 % (~34 Mt CO2e), pero redirigirlos hacia I+D y prácticas sostenibles puede recortar hasta 17 % de las emisiones agrícolas globales [@Laborde2021GHG].

**EN:** Laborde et al. (2021) show with a global CGE model that simply removing agricultural subsidies would cut emissions by only 0.6% (~34 Mt CO2eq), but redirecting them to R&D and sustainable practices could reduce agricultural GHGs by up to 17% [@Laborde2021GHG].

## 13. BibTeX
```bibtex
@article{Laborde2021GHG,
  author  = {Laborde, David and Mamun, Abdullah and Martin, Will and Pi{\~n}eiro, Valeria and Vos, Rob},
  title   = {Agricultural subsidies and global greenhouse gas emissions},
  journal = {Nature Communications},
  year    = {2021},
  volume  = {12},
  number  = {2601},
  doi     = {10.1038/s41467-021-22703-1}
}
```

## 14. Status
- [x] Metadatos completos
- [x] PDF descargado
- [x] BibTeX validado
- [x] Snippet ES + EN
- [x] Asignado a Cap. 3 y Cap. 5
