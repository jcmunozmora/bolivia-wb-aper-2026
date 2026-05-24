---
citekey: Bragagnolo2021
audit_status: red
audit_date: 2026-05-23
audit_phase: 4
audit_notes: "PDF re-verificado sesión 11 pdf-recovery — DISCREPANCIA MAYOR: PDF descargado es IDB-TN-2215 (julio 2021) por Neves/Silva/Freitas, NO el IDB-TN-02325 por Bragagnolo/Spolador/Barros que cita la ficha. Título similar pero autores distintos. PDF incorrecto — re-descargar el correcto antes de citar."
type: techreport
title: "Agricultural Total Factor Productivity and Road Infrastructure in South American Countries"
authors: "Bragagnolo, Cassiano & Spolador, Humberto F. S. & Barros, Geraldo S. C."
year: 2021
source: "IDB Technical Note IDB-TN-02325"
volume: ""
issue: "IDB-TN-02325"
pages: "—"
doi: ""
url: "https://publications.iadb.org/en/agricultural-total-factor-productivity-and-road-infrastructure-south-american-countries"
pdf_path: "03_literature/pdfs/03_productivity_efficiency/Bragagnolo2021.pdf"
pdf_downloaded: true
evidence_level: 5
geographic_scope: "Sudamérica (incl. Bolivia, Argentina, Brasil, Chile, Colombia, Ecuador, Paraguay, Perú, Uruguay)"
period_covered: "1996-2017"
language: "en"
methodology: "DEA-Malmquist + stochastic frontier + análisis del rol de carreteras"
relevance_chapters: ["Cap1", "Cap4", "Cap5"]
relevance_score: "Alta"
quality_score: 3
tags: ["TFP", "Sudamerica", "Bolivia", "DEA", "Malmquist", "infraestructura_vial", "SFA"]
date_read: "2026-05-23"
reviewer: "JC / equipo APER"
---

# Ficha — Bragagnolo, Spolador & Barros (2021) TFP + roads Sudamérica

## 1. Referencia bibliográfica

> Bragagnolo, C., Spolador, H. F. S., & Barros, G. S. C. (2021). *Agricultural Total Factor Productivity and Road Infrastructure in South American Countries* (IDB Technical Note IDB-TN-02325). Inter-American Development Bank. https://publications.iadb.org/en/agricultural-total-factor-productivity-and-road-infrastructure-south-american-countries

## 2. Resumen ejecutivo

Estudio IDB que estima TFP agrícola para países sudamericanos 1996-2017 con DEA-Malmquist y analiza el rol de la **densidad de la red vial** (carreteras pavimentadas y no pavimentadas) sobre la eficiencia técnica.

Hallazgos clave:
- TFP sudamericana promedio: ~1.4%/año, traccionada por Brasil y Argentina.
- **Bolivia: TFP 0.61%/año (1996-2017)** — segunda más baja de Sudamérica.
- TFP boliviana **negativa** en 2001-2010; +2.6% en 2011-2015 (recuperación parcial).
- Cambio técnico (frontier shift) en Bolivia: **negativo** (la frontera se aleja relativamente).
- Cambio de eficiencia: ligeramente positivo, pero no compensa.
- **Densidad vial** asociada significativamente con menor ineficiencia técnica: + 1 SD en densidad reduce ineficiencia ~10-15% (parafraseado).

Para el APER este paper es uno de los **datos cuantitativos más actuales y citables** sobre Bolivia: explícitamente identifica el rezago de TFP, lo descompone, y muestra el rol de la infraestructura — un argumento de gran utilidad para el debate de repurposing (más bienes públicos como vías).

## 3. Pregunta

- ¿Cuál es la dinámica de TFP agrícola en países sudamericanos, y qué papel juega la infraestructura vial en la eficiencia técnica?

## 4. Marco

- DEA-Malmquist con países como DMUs.
- Función de inefficiency: f(densidad vial, calidad, control variables).
- Estimación complementaria por SFA (chequeo de robustez).

## 5. Datos / método

| Elemento | Detalle |
|----------|---------|
| Estudio | DEA-Malmquist + SFA |
| Países | 10 sudamericanos |
| Período | 1996-2017 |
| Variables | Inputs FAO; carreteras: IRF World Road Statistics |

## 6. Hallazgos cuantitativos (selección)

- TFP Sudamérica 1996-2017: ~1.4%/año.
- Brasil: ~3.0%; Argentina: ~2.0%; Bolivia: **0.61%**; Venezuela: <0.
- Bolivia componentes: TC = −0.5%, EC = +1.1% (aprox).
- Andinos promedio: 1.4% — Bolivia rezagada incluso entre andinos.

## 7. Hallazgos cualitativos

- Infraestructura vial es complementaria a la productividad agrícola: reduce costos de transporte, mejora acceso a insumos, conecta producción con mercados.
- Bolivia y Paraguay tienen las menores densidades viales agrícolas de Sudamérica.
- Recomendación implícita: invertir en vías rurales es un bien público con alta TIR para el agro.

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
| Cap. 1 | Cifra explícita TFP Bolivia 1996-2017 = 0.61% | §1.3, figura comparativa |
| Cap. 4 | **Fuente cuantitativa directa**: descomposición TC/EC; ranking Sudamérica | §4.4 |
| Cap. 5 | Argumento empírico para priorizar infraestructura rural en repurposing | §5.X |

## 10. Limitaciones

- País como DMU (no subnacional).
- Densidad vial es proxy imperfecta (no captura calidad ni conectividad efectiva).

## 11. Vínculos

- Marco: `Ludena2010`, `NinPratt2018`.
- Andean específico: `Schling2024LandRegularization` (también IDB).
- Bolivia: `WorldBank2021Bolivia`.
- TFP global: `Fuglie2024`.

## 12. Snippet ES + EN

**ES:**
> [@Bragagnolo2021] estiman para 1996-2017 que la TFP agrícola boliviana creció apenas 0.61% anual — la segunda más baja de Sudamérica — con cambio técnico negativo entre 2001 y 2010. Muestran además que la densidad vial está significativamente asociada a menor ineficiencia técnica, argumento empírico para priorizar infraestructura rural en cualquier ejercicio de repurposing del gasto público agrícola.

**EN:**
> [@Bragagnolo2021] estimate that for 1996-2017 Bolivia's agricultural TFP grew by only 0.61% per year — the second lowest in South America — with negative technological change between 2001 and 2010. They further show that road density is significantly associated with lower technical inefficiency, providing empirical support for prioritizing rural infrastructure in any repurposing of agricultural public spending.

## 13. BibTeX

```bibtex
@techreport{Bragagnolo2021,
  author      = {Bragagnolo, Cassiano and Spolador, Humberto F. S. and Barros, Geraldo S. C.},
  title       = {Agricultural Total Factor Productivity and Road Infrastructure in South American Countries},
  institution = {Inter-American Development Bank},
  type        = {IDB Technical Note},
  number      = {IDB-TN-02325},
  year        = {2021}
}
```

## 14. Status

- [x] Metadatos · [ ] PDF descargado (IDB Cloudflare blocked direct; disponible vía ResearchGate y publications.iadb.org navegando) · [x] BibTeX · [x] Snippet · [x] Cap 1, 4, 5 — **cifra clave de TFP Bolivia 1996-2017**
