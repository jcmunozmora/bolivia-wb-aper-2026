---
citekey: Coelli2005
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/year/Springer/DOI. ISBN 0387242651. Sin PDF: contenidos no verificados a pagina."
type: book
title: "An Introduction to Efficiency and Productivity Analysis (2nd ed.)"
authors: "Coelli, Tim J. & Rao, D.S. Prasada & O'Donnell, Christopher J. & Battese, George E."
year: 2005
source: "Springer (New York)"
volume: ""
issue: ""
pages: "349"
doi: "10.1007/b136381"
url: "https://link.springer.com/book/10.1007/b136381"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Coelli2005.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "—"
language: "en"
methodology: "Manual de métodos: DEA, SFA, Index numbers, Average response models"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["DEA", "SFA", "Malmquist", "TFP", "metodologia", "manual"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Coelli, Rao, O'Donnell & Battese (2005)

## 1. Referencia bibliográfica

> Coelli, T. J., Rao, D. S. P., O'Donnell, C. J., & Battese, G. E. (2005). *An Introduction to Efficiency and Productivity Analysis* (2nd ed.). New York: Springer. https://doi.org/10.1007/b136381

## 2. Resumen ejecutivo

Manual de referencia que sintetiza los cuatro pilares de la medición de productividad y eficiencia: (i) **average response models** (regresiones), (ii) **index numbers** (Tornqvist, Fisher, Malmquist), (iii) **DEA** y (iv) **SFA**. Cada método se presenta con derivación teórica, ejemplos numéricos resueltos, código (FRONTIER, DEAP, TFPIP de Coelli) y aplicación empírica.

Es el manual estándar usado en cursos de posgrado en economía agrícola y desempeño productivo. Tres ventajas para el APER: (a) capítulos sobre **Malmquist productivity index** (necesario para descomponer crecimiento de TFP en cambio técnico + cambio de eficiencia), (b) discusión completa del **bootstrap** para inferencia DEA (motiva uso de Simar-Wilson), y (c) software companion gratis (DEAP/FRONTIER).

## 3. Pregunta del manual

- ¿Cómo medir empíricamente la eficiencia y la productividad de productores con métodos paramétricos y no paramétricos, y cómo descomponer el crecimiento de TFP?

## 4. Marco teórico

- Función de producción → eficiencia técnica radial.
- Función de costos → eficiencia económica/asignativa.
- Índice de Malmquist = eficiencia técnica × cambio técnico.
- Bootstrap nonparamétrico para DEA.

## 5. Estructura del libro (selección relevante APER)

| Capítulo | Tema |
|----------|------|
| 2 | Production economics review |
| 3 | Output and input price index numbers (Fisher, Tornqvist) |
| 4 | TFP index numbers (Malmquist) |
| 6 | DEA — Modelos básicos CRS / VRS |
| 7 | Extensiones DEA (orient., precios, super-eficiencia) |
| 8-9 | SFA: especificación y estimación |
| 10 | Aplicaciones a agricultura |
| 11 | Bootstrap y DEA |

## 6. Hallazgos / contribuciones clave para el APER

- Manual de "cómo se hace" para DEA y SFA en agricultura.
- Discusión rigurosa de descomposición Malmquist en cambio de eficiencia + cambio técnico.
- Ofrece código y datasets de ejemplo replicables.

## 7. Aspectos cualitativos / pedagógicos

- Estilo accesible: ejemplos pequeños (3-6 firmas) en cada capítulo.
- Cobertura balanceada DEA/SFA: pocos libros lo logran.
- Incluye discusión del trade-off determinístico (DEA) vs. estocástico (SFA).

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Capítulo APER | Cómo se usa | Sección |
|---------------|-------------|---------|
| Cap. 4 | Manual de referencia metodológica del capítulo. Citado en cada decisión metodológica (CRS vs. VRS, orientación, índice Malmquist) | §4.1, §4.2 |

## 10. Limitaciones

- 2ª edición de 2005; literatura posterior (Simar-Wilson 2007, Greene 2008, robust frontiers de Cazals-Florens-Simar 2002) tratada parcialmente.
- Aplicaciones agrícolas son ilustrativas, no exhaustivas.

## 11. Vínculos con otros documentos

- Sintetiza: `Farrell1957`, `CharnesCooperRhodes1978`, `AignerLovellSchmidt1977`, `BatteseCoelli1995`.
- Complementario con manual posterior: `Greene2008SFA` (SFA avanzado).
- Aplicaciones: `Ludena2010`, `RadaHelfand2018`, `Schling2024LandRegularization`.

## 12. Snippet ES + EN

**ES:**
> El manual de [@Coelli2005] es la referencia metodológica estándar para análisis de eficiencia y productividad agrícola, integrando DEA, SFA, índices Malmquist y bootstrap. El APER lo cita como guía operativa para las decisiones de especificación de Capítulo 4.

**EN:**
> [@Coelli2005] is the standard methodological reference for agricultural efficiency and productivity analysis, integrating DEA, SFA, Malmquist indices and bootstrap. The APER cites it as the operational guide for specification choices in Chapter 4.

## 13. BibTeX

```bibtex
@book{Coelli2005,
  author    = {Coelli, Tim J. and Rao, D. S. Prasada and O'Donnell, Christopher J. and Battese, George E.},
  title     = {An introduction to efficiency and productivity analysis},
  edition   = {2},
  publisher = {Springer},
  year      = {2005},
  isbn      = {9780387242668},
  doi       = {10.1007/b136381}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (libro paywalled)
- [x] BibTeX
- [x] Snippet
- [x] Cap 4
