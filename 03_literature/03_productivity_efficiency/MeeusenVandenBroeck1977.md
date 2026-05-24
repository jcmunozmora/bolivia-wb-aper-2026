---
citekey: MeeusenVandenBroeck1977
audit_status: yellow  # Fase 3 audit 2026-05-23
audit_date: 2026-05-23
audit_phase: 3
audit_notes: "Crossref confirma title/Meeusen/van den Broeck/1977/Int Econ Rev 18(2):435/DOI. Sin PDF."
type: article
title: "Efficiency estimation from Cobb-Douglas production functions with composed error"
authors: "Meeusen, Wim & van den Broeck, Julien"
year: 1977
source: "International Economic Review"
volume: "18"
issue: "2"
pages: "435-444"
doi: "10.2307/2525757"
url: "https://www.jstor.org/stable/2525757"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/MeeusenVandenBroeck1977.pdf"
pdf_downloaded: unavailable
evidence_level: 7
geographic_scope: "Global"
period_covered: "1977"
language: "en"
methodology: "SFA — frontera estocástica Cobb-Douglas"
relevance_chapters: ["Cap4"]
relevance_score: "Alta"
quality_score: 3
tags: ["SFA", "frontera_estocastica", "Cobb-Douglas", "metodologia"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Meeusen & van den Broeck (1977) SFA Cobb-Douglas

## 1. Referencia bibliográfica

> Meeusen, W., & van den Broeck, J. (1977). Efficiency estimation from Cobb-Douglas production functions with composed error. *International Economic Review*, 18(2), 435–444. https://doi.org/10.2307/2525757

## 2. Resumen ejecutivo

Paper simultáneo a Aigner-Lovell-Schmidt (1977) que también introduce el marco de **frontera estocástica con error compuesto**, aplicado específicamente a la función Cobb-Douglas. La diferencia técnica: Meeusen-van den Broeck asume distribución **exponencial** para el término de ineficiencia u (en vez de semi-normal). Ambos enfoques son considerados pilares conjuntos del nacimiento de SFA.

Su aplicación empírica usa datos de 10 sectores manufactureros franceses (1962-1969) para ilustrar la estimación de fronteras Cobb-Douglas con error compuesto y cuantificar ineficiencia técnica industrial.

## 3. Pregunta de investigación / objetivos

- ¿Cómo aplicar un modelo de frontera estocástica con error compuesto a una función Cobb-Douglas y estimar la ineficiencia técnica de manera consistente?

## 4. Marco teórico y conceptual

- Función Cobb-Douglas: ln(y) = β₀ + Σβⱼ ln(xⱼ) + v − u.
- v ~ N(0, σ²ᵥ): ruido idiosincrático.
- u ~ exponencial(λ): ineficiencia técnica unilateral no negativa.

## 5. Datos y método

| Elemento | Especificación |
|----------|----------------|
| Estudio | Aplicado a manufactura francesa |
| N | 10 sectores |
| Período | 1962-1969 |
| Forma funcional | Cobb-Douglas log-lineal |
| Estimación | MLE + comparación con MOM (method of moments) |

## 6. Hallazgos cuantitativos clave

- Estima eficiencias técnicas por sector y muestra heterogeneidad sustancial.
- Compara MLE vs. MOM, encontrando concordancia razonable.

## 7. Hallazgos cualitativos / interpretativos

- Justifica la distribución exponencial por su parsimonia (un parámetro) y por dominar sucesos extremos de ineficiencia.
- Establece junto con Aigner et al. el marco SFA que sería extendido por Battese-Coelli, Stevenson, Greene y otros.

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
| Cap. 4 | Junto con Aigner et al. (1977), cita fundacional de SFA, importante por su asunción de distribución exponencial, alternativa robustez | §4.3 Métodos paramétricos de eficiencia |

## 10. Limitaciones del documento

- Cross-sectional; supuesto exponencial fuerte.
- Solamente manufactura: traslación a agricultura llegó después.

## 11. Vínculos con otros documentos

- Simultáneo / complementario a: `AignerLovellSchmidt1977`.
- Extendido por: `BatteseCoelli1995`, `Greene2008SFA`.

## 12. Snippet ES + EN

**ES:**
> Junto con Aigner et al. (1977), [@MeeusenVandenBroeck1977] fundamentaron el método de frontera estocástica que separa ineficiencia técnica de ruido aleatorio en funciones de producción Cobb-Douglas, abriendo paso a aplicaciones empíricas extensas a agricultura en países en desarrollo.

**EN:**
> Together with Aigner et al. (1977), [@MeeusenVandenBroeck1977] established the stochastic-frontier method that separates technical inefficiency from random noise in Cobb-Douglas production functions, opening the way to extensive empirical applications to agriculture in developing countries.

## 13. BibTeX

```bibtex
@article{MeeusenVandenBroeck1977,
  author  = {Meeusen, Wim and van den Broeck, Julien},
  title   = {Efficiency estimation from {Cobb-Douglas} production functions with composed error},
  journal = {International Economic Review},
  year    = {1977},
  volume  = {18},
  number  = {2},
  pages   = {435--444},
  doi     = {10.2307/2525757}
}
```

## 14. Status

- [x] Metadatos
- [ ] PDF (paywalled)
- [x] BibTeX
- [x] Snippet
- [x] Cap 4
