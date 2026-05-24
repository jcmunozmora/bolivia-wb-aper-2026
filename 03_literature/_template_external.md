---
citekey: AuthorYYYY
type: article | techreport | book | unpublished | inproceedings
title: "Título completo del documento"
authors: "Apellido, Nombre & Apellido2, Nombre2"
year: YYYY
source: "Revista / Institución"
volume: ""
issue: ""
pages: ""
doi: "10.xxxx/xxxxxxx"
url: "https://..."
pdf_path: "03_literature/pdfs/<carpeta>/AuthorYYYY.pdf"
pdf_downloaded: true | false | unavailable
evidence_level: 1 | 2 | 3 | 4 | 5 | 6 | 7
geographic_scope: "Bolivia | LAC | Andean | Global | Subsaharan | Other"
period_covered: "YYYY-YYYY"
language: "es | en | pt"
methodology: "Meta-analysis | RCT | DiD | RDD | IV | PSM | FE | DEA | Qualitative | Mixed | Descriptive | Review"
relevance_chapters: ["Cap1", "Cap2", "Cap3", "Cap4", "Cap5"]
relevance_score: "Alta | Media | Baja"
quality_score: 1 | 2 | 3
tags: ["gasto_publico", "subsidios", "productividad", "etc"]
date_read: "YYYY-MM-DD"
reviewer: "JC / equipo APER"
---

# Ficha de Lectura — [TÍTULO BREVE]

## 1. Referencia bibliográfica

> [Autor (Año). Título. Revista, Volumen(Número), pp. DOI/URL]

## 2. Resumen ejecutivo (3-5 párrafos)

[Narrativa central del documento. Qué pregunta investiga, qué método usa, qué encuentra, qué implica.]

## 3. Pregunta de investigación / objetivos

- **Pregunta principal:** [texto]
- **Sub-preguntas:** [si aplica]
- **Hipótesis:** [si aplica]

## 4. Marco teórico y conceptual

[Teorías, modelos, conceptos que usa el documento. Antecesores citados clave.]

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Tipo de estudio | [RCT / DiD / observacional / sistemática / etc.] |
| Población | [unidad de análisis] |
| N | [tamaño muestral] |
| Período | [años] |
| Geografía | [países, regiones] |
| Fuentes de datos | [encuestas, registros, etc.] |
| Método de identificación | [estrategia causal o descriptiva] |
| Software / código | [Stata, R, etc.] |
| Replicable | [Sí / No / Parcial] |

## 6. Hallazgos cuantitativos clave

- **Hallazgo 1:** [magnitud, dirección, IC 95% si aplica]
- **Hallazgo 2:** [magnitud, dirección, IC 95% si aplica]
- **Tamaño del efecto principal:** [valor + unidad + IC]
- **Heterogeneidad:** [por subgrupo si aplica]

## 7. Hallazgos cualitativos / interpretativos

[Mecanismos, narrativas, voces, hallazgos que no son cifras]

## 8. Citas directas relevantes para el APER

> "[Cita 1 verbatim]" (p. X)
>
> "[Cita 2 verbatim]" (p. X)

## 9. Aplicación al APER 2026 Bolivia

| Capítulo | Cómo se usa | Sección sugerida |
|----------|-------------|------------------|
| Cap. 1 (contexto) | [texto] | [§X.Y] |
| Cap. 2 (gasto y composición) | [texto] | [§X.Y] |
| Cap. 3 (PSE / repurposing) | [texto] | [§X.Y] |
| Cap. 4 (eficiencia) | [texto] | [§X.Y] |
| Cap. 5 (recomendaciones) | [texto] | [§X.Y] |

## 10. Limitaciones del documento

- [Validez interna]
- [Validez externa]
- [Datos]
- [Sesgos]

## 11. Vínculos con otros documentos en `03_literature/`

- Refuerza a: `[citekey1]`, `[citekey2]`
- Contradice a: `[citekey3]` (en qué punto)
- Complementario con: `[citekey4]`

## 12. Snippet listo para insertar en el reporte (ES + EN)

**ES (≤80 palabras):**
> [Texto narrativo con cita en formato [@AuthorYYYY]]

**EN (≤80 palabras):**
> [Narrative with citation [@AuthorYYYY]]

## 13. BibTeX

```bibtex
@article{AuthorYYYY,
  author  = {Last, First and Last2, First2},
  title   = {Title in sentence case},
  journal = {Journal Name},
  year    = {YYYY},
  volume  = {N},
  number  = {N},
  pages   = {XX--YY},
  doi     = {10.xxxx/xxxxxxx},
  url     = {https://...}
}
```

## 14. Status

- [ ] Metadatos completos
- [ ] PDF descargado (`pdfs/<carpeta>/AuthorYYYY.pdf`)
- [ ] Hallazgos verificados (cifras vs. PDF)
- [ ] BibTeX validado (DOI / URL funciona)
- [ ] Snippet ES + EN listos
- [ ] Cross-referenced con otras fichas
- [ ] Asignado a capítulo(s) APER
