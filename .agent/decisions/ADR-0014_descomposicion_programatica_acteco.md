# ADR-0014 — Descomposición programática del gasto agropecuario y crosswalk actividad→MAFAP

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (incorpora una dimensión nueva del gasto al pipeline y define un crosswalk heurístico)
**Lecturas relacionadas:** [ADR-0012](ADR-0012_gasto_externo_empalme_mefp.md), [ADR-0009](ADR-0009_mafap_narrow_full.md), [ADR-0010](ADR-0010_crosswalk_clasificaciones.md), [`.agent/07_FIGURAS.md`](../07_FIGURAS.md).

---

## Contexto

[ADR-0012](ADR-0012_gasto_externo_empalme_mefp.md) incorporó el gasto agropecuario devengado del MEFP a nivel de **sector** (acteco=2), **entidad** (ejecutor) y **función** (COFOG 4.2), pero no a nivel de **programa/actividad**. El usuario solicitó analizar la **composición del gasto por programa** (Pareto de concentración).

Un sondeo de la API de MEFP Presupuesto Abierto (2026-06-14) determinó:

- El endpoint **`acteco-treemap?gestion=YYYY&entidad=0`** expone el árbol completo de **actividad económica** del sector Agropecuario: 1 sector → 7 subsectores → ~36 actividades (ej. *Seguridad y Soberanía Alimentaria*, *Construcción de Sistemas de Riego*, *Fomento a la Producción Agrícola*, *Investigación Agrícola*, *Sanidad Vegetal/Animal*, *Extensión*). Cobertura **2016–2024**, por año y por entidad.
- El endpoint `programa?codigo=N` (clasificación programática **presupuestaria literal**) existe, pero está indexado por código genérico, **cruza sectores** (ej. "47 — Acreditación de Entidades de Metrología") y no es agro-específico → descartado como base de la composición agro.
- Acceso: `curl -k` (cadena TLS incompleta del servidor); el total de actividades **reconcilia al 100%** con el total del sector (acteco=2) de ADR-0012, y deflactado reproduce exactamente las cifras de la prosa (2023 = USD 539 M; 2024 = USD 341 M const. 2015).

## Decisión

1. **Adoptar el árbol `acteco`-actividad del sector agro como base canónica de la composición programática 2016–2024.** Provenance: API MEFP → `02_code/01_data_collection/` (descarga `mefp_acteco_tree_YYYY.json`) → `02_code/02_cleaning/48_parse_acteco_programatica.R` → `01_data/processed/gasto_agro_programatico.rds`. Satisface el invariante 3.1.

2. **Deflactado idéntico a [fig 18](../../02_code/04_visualization/18_fig_gasto_ejecutores_total.R):** BOB corriente → BOB const. 2015 (CPI 2015=100 del panel; **2024 = 117,7729 × 1,051**, inflación media INE ≈5,1% **[preliminar]**) → USD const. 2015 (÷ 6,91). Convención de [valores reales](../../00_admin/RETOMAR.md) del proyecto.

3. **Crosswalk actividad→MAFAP (semilla heurística).** Cada actividad se asigna a una categoría MAFAP (A; D1 investigación; D2 extensión; D5 sanidad; D6 riego/infraestructura; D9/D10 administración/otros) y a un **grupo de propósito** de ≤4 niveles para despliegue (paleta [§6](../07_FIGURAS.md)): *Apoyo a la producción y seguridad alimentaria* · *Riego e infraestructura* · *Servicios técnicos (I+D, extensión, sanidad)* · *Tierras, multiprograma y otros*. La regla vive embebida en `48_parse_acteco_programatica.R` (por descripción + subsector), **no** en una tabla externa todavía.

4. **Figuras derivadas** (estándar [07_FIGURAS](../07_FIGURAS.md)): `fig_pareto_programas_agro` (Pareto: 8 de 36 actividades = 80%) y `fig_composicion_proposito_agro` (composición por propósito: 51% producción/seguridad alimentaria, 27% riego, 12% bienes públicos clásicos, 10% otros). Soportan el hallazgo candidato F03 (transferencias vs bienes públicos).

## Consecuencias

**Positivas:** primera descomposición del gasto agro por propósito en años recientes; cuantifica la concentración (Pareto) y el peso de la seguridad alimentaria (EMAPA, ~30% de una sola actividad) frente a los bienes públicos clásicos (~12%); intrínsecamente agrícola (sin filtrar ruido intersectorial); mapeable a MAFAP.

**Negativas / limitaciones declaradas:**
- La clasificación es de **actividad económica** (acteco), no de la apertura **programática** presupuestaria literal; el reporte debe rotularla como "composición por actividad/propósito", no "por programa presupuestario".
- El crosswalk es **heurístico** (por texto), pendiente de validación; ~15% del gasto cae en residuales ("Multiprograma", "Otros") no asignables a un propósito fino.
- 2024 es **preliminar** (CPI estimado).
- Solo 2016–2024 (la API no tiene pre-2016; ver [gap 2009–2015](ADR-0012_gasto_externo_empalme_mefp.md)).

## Pendientes

- [ ] Firma TTL (gasto sensible, invariante 9).
- [ ] Validar/externalizar el crosswalk actividad→MAFAP a `01_data/processed/` y auditar los residuales "Multiprograma".
- [ ] No numerar como `F-NN` definitivo el hallazgo de concentración hasta validación humana.
- [ ] Generar versiones EN de ambas figuras + contratos JSON `05_outputs/figures/meta/`.
- [ ] Registrar fuente en `00_admin/ESTADO_DE_DATOS.md`.
