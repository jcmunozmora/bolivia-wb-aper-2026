# 21_COORDINACION_STC.md — Coordinación con consultor STC (Hector Peña — OECD PSE/Repurposing)

**Versión:** v0.1.0 · **Última actualización:** 2026-05-24
**Path canónico:** `.agent/21_COORDINACION_STC.md`
**Propósito:** formalizar la integración de outputs del consultor STC (Héctor Peña — OECD PSE/Repurposing) al reporte final consolidado del APER 2026. Operacionaliza el Deliverable 5 del [`00_Tor/Main_TOR_JC.pdf`](../00_Tor/Main_TOR_JC.pdf) y los Deliverables del [`00_Tor/Secondary_TOR_Hector.pdf`](../00_Tor/Secondary_TOR_Hector.pdf).
**Lecturas relacionadas:** [`00_MASTER_PROMPT §6`](00_MASTER_PROMPT.md), [`20_CONTENIDO_REPORTE §9, §10`](20_CONTENIDO_REPORTE.md), [`11_EQUIPO`](11_EQUIPO.md), [`10_RIESGOS`](10_RIESGOS.md), [`16_INCIDENTES`](16_INCIDENTES.md), [`../00_admin/SINERGIA_ToR_PSE_Repurposing.md`](../00_admin/SINERGIA_ToR_PSE_Repurposing.md) (predecesor histórico).

---

## 1. Principio rector

> El reporte final del APER 2026 es **producto consolidado de dos consultorías paralelas WB**: JC (Agricultural Support Expenditure Specialist — MAFAP/FAO, Main TOR) + Héctor Peña (Agriculture Support Estimates Specialist — OECD-PSE, Secondary TOR). Las dos son metodológicamente **complementarias y temporalmente paralelas**; el Full Report (Deliverable 5 JC) integra ambas.

Tres reglas operativas:

1. **JC produce el Full Report** consolidado (Deliverable 5). Hector produce: análisis OECD-PSE + training OECD + repurposing fiscal cost.
2. **División por capítulos:** Caps 1–4 + Apéndices A–E producto JC (MAFAP); Cap 5 + parte Cap 6 + apéndice repurposing son **input principal de Hector** (OECD-PSE).
3. **El reporte mantiene autoría WB consolidada**; créditos individuales en agradecimientos, no autoría diferenciada por capítulo.

---

## 2. Mapeo de los dos ToR

### 2.1 Convergencias y división

| Tema | Main TOR JC | Secondary TOR Hector | Resolución en el reporte |
|---|---|---|---|
| Marco analítico | MAFAP/FAO (Group I + II) | OECD-PSE (TSE/PSE/GSSE/CSE) | MAFAP en caps 3–4; OECD-PSE en cap 5; crosswalk en apéndice D |
| Período | **2008–2024** + ext. 2025 | últimos 5 años + serie IADB | Ventana canónica 2008–2024 |
| Benchmarks | MAFAP partner countries (primary) + OECD complementary | OECD + regional averages | MAFAP partners para caps 3–4; OECD-PSE LAC para cap 5 |
| Recomendaciones | Interpretación food security + pobreza + sostenibilidad | Fiscal cost del repurposing | Cap 6 integra ambas |
| Output final | Full Report + PPT analytical + Exec Summary 4-6 pp ES | PPT IADB + Training + Repurposing Report | Full Report JC consolida |

### 2.2 División operativa del contenido

| Producto | Productor | Cap del book |
|---|:-:|---|
| Database 2008-2024 MAFAP-coded + crosswalk MEFP | **JC** | Apéndice A + D |
| PSE/GSSE/TSE Bolivia analysis | **Hector** | Cap 5 §H2.1 |
| NRP por commodity (IADB AgriMonitor) | **Hector** | Cap 5 §H2.2 |
| DEA Simar-Wilson | **JC** | Cap 5 §H2.3 + Apéndice F |
| Panel FE econométrico | **JC** | Cap 5 §H2.4 + Apéndice E |
| Composición MAFAP A–E + comparación Maputo | **JC** | Caps 3–4 + cap 0 |
| Análisis subnacional (Santa Cruz, La Paz, Cochabamba) | **JC** | Cap 4 |
| Repurposing — composición ex-ante/post (S01–S03) | **JC** | Cap 6 §H2.3 |
| Repurposing — **fiscal cost cuantitativo** | **Hector** | Cap 6 §H2.3 + apéndice |
| Foregone tariff income (Q1 Hector TOR) | **Hector** | Cap 6 §H2.3 |
| Public goods global-aligned cost (Q2 Hector TOR) | **Hector** | Cap 6 §H2.3 |
| GHG + fertilizer + land + **water productivity** | **Hector lidera** | Cap 2 + Cap 6 |
| Training OECD-PSE on-site La Paz (~2 sem) | **Hector** | NO entra al book |
| Executive Summary 4-6 pp ES + Full Report | **JC** | Cap 0 + Full Report |

---

## 3. Outputs esperados de Hector

Según [`Secondary_TOR_Hector.pdf`](../00_Tor/Secondary_TOR_Hector.pdf) Deliverables:

| # | Deliverable Hector | Formato | Fecha esperada | Uso en reporte JC |
|---|---|---|---|---|
| H1 | Initial work plan | docx/pdf | 5 días post-inicio | n/a |
| H2 | **PPT IADB support estimations** Bolivia — 5 años | PPTX | _[TODO: confirmar con Hector]_ | Cap 5 §H2.1 + Cap 0 |
| H3 | **Training Session OECD** on-site La Paz | sesión presencial | _[TODO]_ | n/a directa (fortalece MEFP) |
| H4 | **Repurposing Report** — fiscal cost + LAC benchmarking | docx/pdf | _[TODO]_ | Cap 6 §H2.3 + Apéndice repurposing |

### 3.1 Lo que JC necesita de Hector

1. **Serie OECD-PSE 2008–2023 actualizada** con edición IADB feb-2026:
   - `PSE_BOB_2015`, `CSE_BOB_2015`, `GSSE_BOB_2015`, `TSE_BOB_2015`, `%PSE`, `%CSE`, `MPS_BOB_2015`, `BT_agg_BOB_2015`
   - NRP por commodity (soya, maíz, trigo, arroz)
   - **Status panel:** parcial en grupo G08 (43 vars, n=18 BOB, n=4 USD), cobertura 2006–2023
   - **Pendiente:** edición feb-2026 (riesgo R-003)

2. **Cifras repurposing fiscal cost** (Deliverable H4):
   - Q1: costo fiscal de reducir MPS + foregone tariff income
   - Q2: costo fiscal de aumentar public goods a niveles globally desired
   - Benchmarking con Colombia 2016, Perú 2020

3. **Environmental performance indicators**:
   - GHG emissions (panel actual `GHG_total_GgCO2e` n=5 — gap a llenar)
   - Fertilizer use intensity (panel solo pesticides genéricos)
   - Land use productivity (panel `lc_*` MapBiomas OK)
   - **Water productivity** — **gap actual del panel, Hector debe aportar o flag**

4. **Interpretación NRP dual** (hallazgo F03 soya −37% / maíz +46%): contexto de política comercial / restricciones a exportaciones.

### 3.2 Lo que Hector necesita de JC

1. MAFAP-coded panel (Deliverable 2 JC, May 31) → verificación consistencia OECD vs MAFAP.
2. Apéndice C glosario MAFAP bilingüe → insumo training.
3. Apéndice D crosswalk MAFAP↔OECD↔COFOG↔MEFP → insumo training.
4. Coordinación de mensajes finales para evitar contradicciones cuantitativas entre caps 3-4 (JC) y cap 5 (Hector).

---

## 4. Cronograma integrado

Combinando Main TOR (30 días, May 12–Jun 30) + Secondary TOR (20 días):

```text
Sem 1 (May 12–17)
  JC      D1 Work plan (May 17) | audit datos | diseño crosswalk
  Hector  ¿inicio? (TBC)
  Sync    mesa técnica MEFP de inicio

Sem 2 (May 18–24)
  JC      crosswalk + script MAFAP classification
  Hector  IADB feb-2026 + diseño training

Sem 3 (May 25–31)
  JC      D2 Database MAFAP-coded (May 31)
  Hector  training plan + timeline
  Sync    handoff database JC → Hector

Sem 4 (Jun 1–7)
  JC      redacción caps 3–4 (MAFAP)
  Hector  training session La Paz (sem 1)
  Sync    JC asiste opcionalmente

Sem 5 (Jun 8–14)
  JC      cap 5 §H2.3 DEA + §H2.4 regresiones
  Hector  training (sem 2) + IADB analysis
  Sync    handoff Hector → JC para cap 5 §H2.1

Sem 6 (Jun 15–21)
  JC      D3 PPT analytical (Jun 15) + integración cap 5+6
  Hector  IADB final + repurposing
  Sync    revisión mutua

Sem 7 (Jun 22–30)
  JC      D4 Exec Summary 4-6 pp ES (Jun 30) + D5 Full Report
  Hector  Repurposing report final
  Sync    handoff final Hector → JC
```

**Riesgos críticos al cronograma:**
- R-001: MEFP sin respuesta carta → afecta a ambos
- R-003: IADB feb-2026 cambia retroactivamente → Hector re-corre, JC re-procesa cap 5
- R-014 (nuevo, registrar): Output Hector llega después del D3 JC (Jun 15) → mitigación: D3 con cifras preliminares + nota "to be updated"

---

## 5. Protocolo de integración de outputs Hector

### 5.1 Recepción de outputs

```text
1. Hector → email a JC con archivo + nota de versión
2. JC guarda en 00_admin/inputs_hector/<fecha>_<deliverable>.{pptx|pdf|csv}
3. JC actualiza §3.1 con ✓ + fecha real
4. JC clasifica el cambio según 08_CONTROL §4:
   - Cifras nuevas → AMARILLO o ROJO según impacto
   - Interpretación → AMARILLO
   - Training material → VERDE
5. JC corre 09_AUDITORIA §3 (A1 pre-flight) antes de pegar
6. Si Hector y JC tienen cifras divergentes:
   - Nota de divergencia en 04_HALLAZGOS.md §8
   - NUNCA promediar
   - Reportar ambas con etiqueta de fuente y método
```

### 5.2 Coordinación de mensajes finales

Antes de D4 (Exec Summary) y D5 (Full Report):

- Reunión 1:1 JC ↔ Hector
- Acordar las 5 cifras principales del Executive Summary
- Acordar framing del Cap 6 (Hector: fiscal cost; JC: composición + interpretación)
- Decisiones de divergencia: dónde se reportan ambas vs. prevalecer una
- Lock-in: post-reunión ninguna cifra cambia salvo errata

### 5.3 Atribución y agradecimientos

En el Full Report:

- **Página de créditos**: WB como autor institucional; Katie Kennedy Freeman (TTL); **Mariángela Ramírez Díaz y Héctor Peña como co-TTLs WB**; JC lead consultant (EAFIT/CVP). Nota (2026-06-13): Héctor Peña se acredita como **co-TTL WB (ETC)**, no como consultor externo; la división operativa de trabajo de este documento sigue vigente. Ver [`11_EQUIPO.md §2.1`](11_EQUIPO.md).
- **Cap 5**: "El análisis OECD-PSE/GSSE/CSE de este capítulo se basa en estimaciones del IADB AgriMonitor (edición YYYY-MM) y en el trabajo OECD-PSE del WB conducido por Héctor Peña en mayo–junio de 2026."
- **Cap 6**: "Las estimaciones de costo fiscal del repurposing presentadas en esta sección fueron elaboradas por el equipo WB (Héctor Peña)."

---

## 6. Riesgos específicos de coordinación

A incorporar a [`10_RIESGOS.md`](10_RIESGOS.md):

| ID | Riesgo | L | I | Score | Mitigación |
|:-:|---|:-:|:-:|:-:|---|
| R-014 | Output Hector después del D3 JC (Jun 15) | 3 | 2 | 6 | D3 con preliminares + nota "to be updated"; Full Report integra versión final |
| R-015 | Cifras OECD-PSE Hector divergen del panel v12 G08 | 2 | 3 | 6 | Nota de divergencia + ambas cifras; bump v13 si metodológicamente justificado |
| R-016 | Hector no aporta water productivity / fertilizer-specific | 4 | 2 | 8 | Documentar gap en Apéndice A; reportar solo disponible con caveat |
| R-017 | Training Hector consume tiempo del cronograma JC | 3 | 1 | 3 | JC asiste opcionalmente; no bloqueador |
| R-018 | Desfase 30d JC vs 20d Hector | 3 | 2 | 6 | Sincronizar handoffs Sem 3, 5, 7 |

---

## 7. Comunicación con Hector

| Canal | Cadencia | Contenido |
|---|---|---|
| Email | semanal (lunes) | status + bloqueadores |
| Llamada 1:1 | handoffs Sem 3, 5, 7 | sincronización cifras y mensajes |
| Mesa técnica WB | quincenal | con Mariangela Ramirez + Héctor Peña + JC |
| Mesa técnica MEFP | según calendario WB | presentación conjunta cuando aplique |

**Contactos clave** (de los TORs):
- **Mariangela Ramirez** (WB) — contraparte Main TOR JC
- **Héctor Peña** (WB Bolivia Country Office) — contraparte de ambos TORs + consultor del Secondary TOR

---

## 8. Cómo modificar este archivo

`21_COORDINACION_STC.md` es **AMARILLO** ([`08_CONTROL §4.2`](08_CONTROL.md)) para cambios cosméticos / fechas / status. **ROJO** si:

- Se cambia la división operativa §2.2 (quién produce qué)
- Se cambia el protocolo §5
- Se cambian cifras canónicas atribuidas a Hector vs JC

---

## 9. Bitácora

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-24 | JCM | Versión inicial. Cross-walk de los dos ToR + división operativa §2.2 + protocolo de integración §5 + 5 riesgos R-014 a R-018 identificados para [10_RIESGOS.md](10_RIESGOS.md). |
