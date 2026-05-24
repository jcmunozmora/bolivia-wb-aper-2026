---
citekey: SimarWilson2007_TwoStageDEA
audit_status: yellow
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Sin PDF pero metadata verificada vía Crossref (DOI 10.1016/j.jeconom.2005.07.009): Simar & Wilson, J of Econometrics 136(1):31-64, 2007. Confirmado. Uso metodológico estándar."
type: article
title: "Estimation and Inference in Two-Stage, Semi-Parametric Models of Production Processes"
authors: "Simar, Léopold; Wilson, Paul W."
year: 2007
source: "Journal of Econometrics"
volume: "136"
issue: "1"
pages: "31-64"
doi: "10.1016/j.jeconom.2005.07.009"
pdf_path: ""
pdf_downloaded: unavailable
evidence_level: 2
geographic_scope: "Global"
period_covered: ""
language: "en"
methodology: "DEA"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 1
tags: ["dea", "two_stage", "truncated_regression", "simar_wilson"]
date_read: "2026-05-23"
reviewer: "JC / APER"
---

# Ficha — Simar & Wilson (2007) Two-Stage Semi-Parametric DEA

## 1. Referencia

> Simar, L., & Wilson, P. W. (2007). Estimation and Inference in Two-Stage, Semi-Parametric Models of Production Processes. *Journal of Econometrics*, 136(1), 31-64.

## 2. Resumen

Paper que demuestra los problemas de la regresión OLS o Tobit estándar de scores DEA contra covariables (procedimiento popular pero sesgado). Propone: (1) DEA en primera etapa; (2) Truncated regression con double-bootstrap en segunda etapa. Implementado en Stata `simarwilson` (Badunenko & Tauchmann 2019). Hoy estándar para análisis de determinantes de eficiencia.

## 3. Aplicación APER

| Cap | Uso | Sección |
|---|---|---|
| Cap. 4 (eficiencia) | Análisis determinantes de eficiencia municipal/departamental | §4.6 |

## 4. BibTeX

```bibtex
@article{SimarWilson2007_TwoStageDEA,
  author  = {Simar, L\'eopold and Wilson, Paul W.},
  title   = {{Estimation and Inference in Two-Stage, Semi-Parametric Models of Production Processes}},
  journal = {Journal of Econometrics},
  year    = {2007},
  volume  = {136},
  number  = {1},
  pages   = {31--64},
  doi     = {10.1016/j.jeconom.2005.07.009}
}
```
