---
citekey: Coelli1996_DEAP21Guide
audit_status: green  # Fase 2 audit 2026-05-23
type: techreport
title: "A Guide to DEAP Version 2.1: A Data Envelopment Analysis (Computer) Program"
authors: "Coelli, Timothy J."
year: 1996
source: "CEPA Working Paper 96/08, Centre for Efficiency and Productivity Analysis, University of New England"
pages: "49"
url: "https://www.owlnet.rice.edu/~econ380/DEAP.PDF"
pdf_path: "03_literature/pdfs/09_methods_per_pse/Coelli1996_DEAP21Guide.pdf"
pdf_downloaded: true
evidence_level: 2
geographic_scope: "Global"
period_covered: ""
language: "en"
methodology: "DEA"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 1
tags: ["dea", "eficiencia", "frontera", "coelli", "software"]
date_read: "2026-05-23"
reviewer: "JC / APER"
---

# Ficha — Coelli (1996) DEAP 2.1 Guide

## 1. Referencia

> Coelli, T. J. (1996). *A Guide to DEAP Version 2.1: A Data Envelopment Analysis (Computer) Program*. CEPA Working Paper 96/08, University of New England.

## 2. Resumen

Manual del software DEAP, primer programa ampliamente usado para implementar DEA. Cubre: (i) modelos básicos CRS y VRS de Charnes-Cooper-Rhodes y Banker-Charnes-Cooper; (ii) input/output orientation; (iii) descomposición de eficiencia técnica, escala y pura; (iv) Malmquist Productivity Index para series temporales. Coelli es figura central en frontier methods. El manual sirve como puerta de entrada conceptual y operativa para DEA.

## 3. Marco conceptual

DEA: programación lineal no-paramétrica que construye frontera envolvente desde unidades observadas, calcula eficiencia relativa. Diferencia con SFA (estocástica paramétrica).

## 4. Métodos cubiertos

| Método | Uso |
|---|---|
| CRS (CCR) | Eficiencia técnica con retornos constantes |
| VRS (BCC) | Eficiencia técnica pura con retornos variables |
| Scale efficiency | Descomposición CRS/VRS |
| Malmquist Index | Productividad inter-temporal |
| Cost & Allocative efficiency | Con precios |

## 5. Aplicación APER

| Cap | Uso | Sección |
|---|---|---|
| Cap. 4 (eficiencia) | Base metodológica para DEA gasto agrícola sub-nacional | §4.6 |

## 6. Limitaciones

- DEAP es DOS-based; recomendable migrar a R `Benchmarking` package o Stata `dea` para reproducibilidad.

## 7. Vínculos

- Simar & Wilson (1998, 2007) corrigen limitaciones inferenciales.

## 8. BibTeX

```bibtex
@techreport{Coelli1996_DEAP21Guide,
  author      = {Coelli, Timothy J.},
  title       = {{A Guide to DEAP Version 2.1: A Data Envelopment Analysis (Computer) Program}},
  institution = {Centre for Efficiency and Productivity Analysis, University of New England},
  type        = {CEPA Working Paper},
  number      = {96/08},
  year        = {1996},
  url         = {https://www.owlnet.rice.edu/~econ380/DEAP.PDF}
}
```
