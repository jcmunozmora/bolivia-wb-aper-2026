---
citekey: Wilson2008FEAR
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/Wilson PW/2008/Socio-Economic Planning Sciences 42(4):247-254/DOI. Sin PDF."
type: article
title: "FEAR: A software package for frontier efficiency analysis with R"
authors: "Wilson, Paul W."
year: 2008
source: "Socio-Economic Planning Sciences"
volume: "42"
issue: "4"
pages: "247-254"
doi: "10.1016/j.seps.2007.02.001"
url: "https://doi.org/10.1016/j.seps.2007.02.001"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Wilson2008FEAR.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "2008"
language: "en"
methodology: "Software DEA + bootstrap"
relevance_chapters: ["Cap4"]
relevance_score: "Media"
quality_score: 2
tags: ["DEA", "software", "R", "FEAR", "bootstrap", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Wilson (2008) FEAR R package

## 1. Referencia bibliográfica

> Wilson, P. W. (2008). FEAR: A software package for frontier efficiency analysis with R. *Socio-Economic Planning Sciences*, 42(4), 247–254. https://doi.org/10.1016/j.seps.2007.02.001

## 2. Resumen ejecutivo

Paper de documentación del paquete **FEAR (Frontier Efficiency Analysis with R)**, que implementa los algoritmos de Simar-Wilson (1998, 2007) incluyendo bootstrap, bias correction, scores robustos, Malmquist y truncated regression. FEAR es la **implementación canónica** del enfoque Simar-Wilson; el APER lo usará (o `simarwilson` Stata) para producir los resultados de Capítulo 4.

## 3. Pregunta

- ¿Cómo automatizar el cómputo de scores DEA bias-corrected y la inferencia bootstrap?

## 4. Funcionalidad clave

- `dea()`: scores DEA (CRS/VRS, input/output orientation).
- `boot.sw98()` y `boot.dea()`: bootstrap Simar-Wilson 1998.
- Funciones para truncated regression con doble bootstrap (Algoritmo #2 SW-2007).
- Malmquist productivity index.

## 5. Performance

- Mucho más rápido que implementaciones puras en R (uso de Fortran subyacente).
- Robusto a tamaños B ≥ 2000.

## 6. Aplicación al APER

| Capítulo | Uso |
|----------|-----|
| Cap. 4 | Software a usar para producir scores y regresiones del capítulo |

## 7. Limitaciones

- Documentación dispersa; usuarios suelen complementar con `deaR` (CRAN) o el módulo Stata `simarwilson` (Badunenko-Tauchmann 2019), más amigable.
- No incluye DEA dinámico ni network DEA.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Snippet ES + EN

**ES:**
> Para implementar el enfoque Simar-Wilson, el APER utilizará el paquete FEAR de [@Wilson2008FEAR] en R, que provee los algoritmos de bootstrap, corrección de sesgo y truncated regression de manera computacionalmente eficiente.

**EN:**
> To implement the Simar-Wilson approach, the APER uses the FEAR R package [@Wilson2008FEAR], which provides the bootstrap, bias-correction and truncated-regression algorithms in a computationally efficient form.

## 10. BibTeX

```bibtex
@article{Wilson2008FEAR,
  author  = {Wilson, Paul W.},
  title   = {{FEAR}: A software package for frontier efficiency analysis with {R}},
  journal = {Socio-Economic Planning Sciences},
  year    = {2008},
  volume  = {42},
  number  = {4},
  pages   = {247--254},
  doi     = {10.1016/j.seps.2007.02.001}
}
```

## 11. Status

- [x] Metadatos · [ ] PDF paywalled · [x] BibTeX · [x] Snippet · [x] Cap 4
