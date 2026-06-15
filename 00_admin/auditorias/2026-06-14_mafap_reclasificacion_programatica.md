# Reclasificación MAFAP desde el presupuesto programático real

**Fecha:** 2026-06-14 · **Cap. 3** · **Método:** descomposición programática MEFP (36 actividades, 2016–2024) + panel multi-agente (3 lentes + verificación adversarial).
**Reemplaza:** el proxy IDB AgriMonitor (MPS/GSSE/CSE) de la clasificación previa (m0.2.0) por gasto **devengado real** por actividad presupuestaria.
**Scripts:** `02_code/02_cleaning/18_mafap_programatico.R` (clasificación) · `02_code/04_visualization/23_fig_mafap_programatico.R` (3 figuras).
**Datos:** `gasto_agro_programatico_mefp.rds` → `gasto_agro_mafap_prog.rds`.

> **No publicar sin (a) firma TTL — gasto sensible, invariante 9; (b) decisión sobre el split de EMAPA en mesa técnica MEFP/EMAPA.**

---

## 1. Por qué es un salto metodológico

| Dimensión | Proxy AgriMonitor (antes) | **Programático MEFP (ahora)** |
|---|---|---|
| Fuente | Modelado IDB (precios) | **Devengado real por actividad** |
| B (consumidor) | `no_data` | **Medible** vía split EMAPA |
| C (otros) | `no_data` | Medible (0,1%) |
| D (bienes públicos) | =GSSE modelado | **Medible directo = 56,1%** |
| MPS-en-A (trampa) | sí (A negativo, espejo) | **resuelta** (el devengado no es MPS) |

Cobertura: **100%** (36/36 actividades clasificadas).

## 2. Resultado — CASO BASE CONSERVADOR (EMAPA split 50/50 A1/B1)

**Composición acumulada 2016–2024:** D (bienes públicos) **56,1%**, A (productor) **27,5%**, B (consumidor) **16,3%**, C 0,1%, E 0%.
**Dinámica:** D dominaba (64% en 2016) y cae a 45% (2024); el apoyo privado **A+B** sube de 36% a 55%, cruzando a D en 2022.
**Desglose de D:** riego e hidroagrícola **34,5%** (riego puro 27,1%), administración 9,8%, investigación 7,7%, sanidad 2,2%, extensión 1,9%.
**EMAPA (2.10.x) = 32,6% del gasto** — el pivote; bajo el split 50/50 aporta 16,3 pp a A y 16,3 pp a B.
**E = 0** porque el riego se clasifica como bien público sectorial (D6), no como soporte rural (E) → MAFAP narrow = full.

## 3. El pivote: clasificación de EMAPA (sensibilidad)

| Escenario | A (productor) | B (consumidor) |
|---|---:|---:|
| **A1 puro (caso base)** | 43,8% | 0,0% |
| Split 60/40 | 30,7% | 13,1% |
| Split 50/50 | 27,5% | 16,3% |

A1-puro **infla A ~13–16 pp y borra B** (falso para una empresa que subsidia al consumidor). Reportar A1-puro como **cota superior** con la sensibilidad en el mismo párrafo; **no fijar** 60/40 ó 50/50 sin estados financieros de EMAPA (viola deterministic-numbers-only). Decisión → mesa MEFP/EMAPA.

## 4. Figuras generadas (composición en %, invariante a deflación)

1. `fig_mafap_prog_recomposicion` — área 100% A vs D; A cruza a D en 2022 (35%→55% A; 64%→45% D).
2. `fig_mafap_prog_sensibilidad_emapa` — barras de escenarios; B emerge de 0% a 13–16% con el split.
3. `fig_mafap_prog_desglose_d` — los bienes públicos son sobre todo riego (27%); investigación+extensión <10%.

## 5. Lectura de política (para Cap. 6)

El problema de composición **no es ausencia de bienes públicos en el agregado** (D=56%), sino: (a) que esos bienes públicos son **casi todo riego/infraestructura**, con **investigación y extensión < 10%** (los D de mayor retorno); y (b) el **ascenso de EMAPA** (intervención de mercado, A) desplazando a D. El margen de *repurposing* está en reconvertir EMAPA y reforzar I+D/extensión, no en "falta de inversión".

## 6. Pendientes (TODO)

- [ ] Decisión split EMAPA (mesa MEFP/EMAPA).
- [ ] Firma TTL.
- [ ] Bugs de gobernanza en ADR-0010: opex EMAPA → **D9** (no D8); D6 → GSSE **D** (no I). Unificar con glosario.
- [ ] Solicitar desglose de "Multiprograma" (2.5.1 = 4,7%) y "Otros" (2.7.1) para reducir el contenedor D9.
- [ ] Migrar la lógica al pipeline canónico (decidir si 18_ reemplaza a 17_ o coexisten: programático para caps 3–4, AgriMonitor-PSE para cap 5).

## Bitácora
| Fecha | Cambio |
|---|---|
| 2026-06-14 | Reclasificación MAFAP desde descomposición programática MEFP (36 actividades). Caso base EMAPA=A1: D 56% / A 44% / C 0,1%. 3 figuras. Pendiente decisión EMAPA + firma TTL. |
| 2026-06-14 | Se adopta **caso base conservador EMAPA split 50/50 A1/B1**: D 56,1% / A 27,5% / B 16,3% / C 0,1% / E 0%. Se añade matriz 2×2 (`25_fig_mafap_matriz.R`), panorama A–E (`24_`) y **Excel de soporte metodológico** (`05_outputs/tables/MAFAP_clasificacion_programas.xlsx`, 4 hojas, `30_excel_mafap_soporte.R`). EMAPA marcada como split en la hoja de clasificación para no contradecir el resumen. Sigue pendiente decisión split EMAPA (mesa MEFP/EMAPA) + firma TTL. |
