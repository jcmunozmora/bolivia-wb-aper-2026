---
citekey: CharnesCooperRhodes1978
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/authors/year/EJOR 2(6):429-444/DOI. Sin PDF."
type: article
title: "Measuring the efficiency of decision making units"
authors: "Charnes, Abraham & Cooper, William W. & Rhodes, Edwardo"
year: 1978
source: "European Journal of Operational Research"
volume: "2"
issue: "6"
pages: "429-444"
doi: "10.1016/0377-2217(78)90138-8"
url: "https://doi.org/10.1016/0377-2217(78)90138-8"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/CharnesCooperRhodes1978.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "1978"
language: "en"
methodology: "DEA (programación lineal)"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["DEA", "eficiencia_tecnica", "metodologia", "programacion_lineal"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Charnes, Cooper & Rhodes (1978) DEA seminal

## 1. Referencia bibliográfica

> Charnes, A., Cooper, W. W., & Rhodes, E. (1978). Measuring the efficiency of decision making units. *European Journal of Operational Research*, 2(6), 429–444. https://doi.org/10.1016/0377-2217(78)90138-8

## 2. Resumen ejecutivo

Paper fundacional de **Data Envelopment Analysis (DEA)**. Formaliza la propuesta conceptual de Farrell (1957) como un programa de **programación lineal** para medir la eficiencia relativa de múltiples Decision Making Units (DMUs) que usan múltiples inputs para producir múltiples outputs sin necesidad de pesos a priori. El modelo CCR (CRS, orientado al input) define el score como la razón ponderada de outputs a inputs, con pesos elegidos por cada DMU para maximizar su propio score, sujeto a que ninguna DMU exceda 1.

La virtud operativa: permite construir un benchmark empírico **sin requerir precios** ni función de producción específica, lo que lo hace ideal para sectores con outputs heterogéneos (hospitales, escuelas, fincas con diversos cultivos). Limitación clásica: trata cualquier desviación como ineficiencia (no separa ruido), motivo por el cual Simar & Wilson (1998, 2007) introdujeron procedimientos bootstrap.

## 3. Pregunta de investigación / objetivos

- **Pregunta:** ¿cómo medir la eficiencia relativa de DMUs con múltiples inputs y outputs sin imponer pesos exógenos ni función de producción paramétrica?

## 4. Marco teórico y conceptual

- Extensión operativa de Farrell (1957) vía programación lineal fraccional (linealizada por transformación de Charnes-Cooper).
- Concepto: cada DMU elige los pesos que más le favorecen, lo que produce un score relativo justo.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Método | Programación lineal (modelo CCR, retornos constantes a escala) |
| Inputs/outputs | Múltiples, no requiere precios |
| Aplicación ilustrativa | Programa Follow-Through en escuelas públicas EE.UU. |
| Replicable | Sí |

## 6. Hallazgos cuantitativos clave

- Score de eficiencia ∈ (0,1]; DMUs con score = 1 forman la frontera.
- Aplicación a 70 sitios escolares: identifica DMUs eficientes y la magnitud de mejora potencial para las ineficientes.

## 7. Hallazgos cualitativos / interpretativos

- Inaugura una literatura masiva: >40,000 citas. Extensiones posteriores incluyen BCC (retornos variables a escala, Banker-Charnes-Cooper 1984), modelos orientados al output, supereficiencia, dinámicos, network DEA, etc.

## 8. Citas directas (eliminadas — auditoría sesión 11)

> ⚠️ **Las citas verbatim de esta ficha fueron eliminadas en la auditoría 2026-05-23** porque la Fase 2 detectó que ~25 fichas de la muestra tenían citas con número de página fabricadas por el LLM. Para citar este documento en el reporte:
>
> 1. Abrir el PDF en `pdf_path` (si está disponible) o la `url` del frontmatter
> 2. Extraer la cita literal y la página real
> 3. Marcar la ficha como `audit_status: green` o `yellow` tras verificar
>
> Mientras tanto, usar **paráfrasis** (no comillas) en §12 — y si no se ha verificado, no citar en el reporte.

## 9. Aplicación al APER 2026 Bolivia

| Capítulo | Cómo se usa | Sección sugerida |
|----------|-------------|------------------|
| Cap. 4 | Cita fundacional del método DEA que se aplicará a las unidades subnacionales del gasto agropecuario boliviano (departamentos / municipios) | §4.2 Metodología DEA |

## 10. Limitaciones del documento

- Asume retornos constantes a escala (relajado en BCC-1984).
- No estocástico; sensible a outliers.
- No produce intervalos de confianza (motivó Simar-Wilson 1998).

## 11. Vínculos con otros documentos

- Extiende: `Farrell1957`.
- Inspirado el bootstrap: `SimarWilson1998`, `SimarWilson2007`.
- Textbook que sintetiza: `Coelli2005`.
- Aplicación LAC con Malmquist (DEA-based): `Ludena2010`, `NinPratt2018`.

## 12. Snippet ES + EN

**ES:**
> El método DEA, formalizado por [@CharnesCooperRhodes1978] como una extensión de programación lineal del marco de Farrell, permite comparar la eficiencia relativa de unidades productivas heterogéneas sin imponer precios ni forma funcional, lo que lo hace particularmente adecuado para evaluar el gasto público agrícola boliviano a escala departamental con cultivos múltiples.

**EN:**
> The DEA method, formalized by [@CharnesCooperRhodes1978] as a linear-programming extension of Farrell's framework, enables comparison of the relative efficiency of heterogeneous production units without requiring prices or a functional form — making it particularly suitable for evaluating Bolivian agricultural public spending at the departmental scale across multiple crops.

## 13. BibTeX

```bibtex
@article{CharnesCooperRhodes1978,
  author  = {Charnes, Abraham and Cooper, William W. and Rhodes, Edwardo},
  title   = {Measuring the efficiency of decision making units},
  journal = {European Journal of Operational Research},
  year    = {1978},
  volume  = {2},
  number  = {6},
  pages   = {429--444},
  doi     = {10.1016/0377-2217(78)90138-8}
}
```

## 14. Status

- [x] Metadatos completos
- [ ] PDF (paywalled Elsevier)
- [x] BibTeX validado
- [x] Snippet listos
- [x] Asignado a Cap 4
