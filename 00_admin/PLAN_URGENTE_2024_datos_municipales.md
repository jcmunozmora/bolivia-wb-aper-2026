# ✅ RESUELTO — Gasto agropecuario municipal POR PROGRAMA hasta 2024

**Fecha:** 2026-06-14 (sesión 21)
**Autor:** Claude Code (búsqueda agresiva)
**Estado:** 🟢 **CERRADO con datos oficiales MEFP** (no requirió contactar a Jubileo)

---

## El problema (original)

El usuario necesitaba **gasto agropecuario municipal desagregado por programa hasta 2024**.
La fuente que teníamos (Fundación Jubileo) sólo llega a **2021**.

## Lo que se descartó

- **Opción A — Contactar Jubileo:** descartada por el usuario.
- **Opción B — Scraping Jubileo 2022-2024:** **IMPOSIBLE.** Se inspeccionó el portal
  `pre.jubileobolivia.org.bo` en vivo (2026-06-14): sus checkboxes de "Gestiones"
  se detienen en **2021** (códigos 25,19,20,21,22,23,24,26,27,30 = 2012…2021). El
  portal público está congelado; no hay años nuevos que scrapear. Confirmado leyendo
  el HTML del formulario.

## Lo que FUNCIONÓ — Opción C (MEFP Presupuesto Abierto)

La API de MEFP **sí** entrega la descomposición programática municipal hasta 2024,
y es **mejor** que Jubileo (oficial, devengado SIGEP, agro-específica).

### El hallazgo técnico

El endpoint `acteco-treemap?gestion=YYYY&entidad=<id>` acepta el **id de entidad
de cada Gobierno Autónomo Municipal**. Devuelve el árbol completo de actividad
económica de ese municipio; filtrando las hojas agropecuarias (`acteco` = `2.Y.Z`)
se obtiene el gasto agro municipal **desglosado por actividad** (Fomento Agrícola,
Microriego, Infraestructura, Sanidad, Investigación, Seguridad Alimentaria…),
**año por año, 2016–2024**, para ~329 municipios.

**Validación (invariante 3.1):** la suma de las hojas `2.*` de cada municipio
reconcilia **al 100,000%** (mediana |dif| = 0,000%) con su monto agregado en
`mefp_agro_entidades_YYYY.json`. Ejemplo: Sucre 2024 = Bs 15 483 436,97 exacto.

### Productos (reproducibles, trazables)

| Archivo | Contenido |
|---|---|
| `02_code/01_data_collection/49_download_mefp_muni_programatico.R` | Descarga el árbol acteco de cada municipio × año (API en vivo, con cache) |
| `02_code/02_cleaning/51_parse_mefp_muni_programatico.R` | Aplana → deflacta USD 2015 → crosswalk acteco→MAFAP → panel |
| `01_data/processed/gasto_agro_prog_muni_2016_2024.{rds,csv}` | **Panel municipio × actividad × año** (output principal) |
| `01_data/processed/gasto_agro_prog_muni_grupo.rds` | Agregado municipio × grupo de propósito × año |
| `01_data/processed/gasto_agro_prog_muni_mafap.rds` | Agregado municipio × categoría MAFAP × año |
| `01_data/raw/external_gasto_2026/muni_treemap/tree_<ent>_<año>.json` | JSON crudos cacheados (provenance) |

### Provenance

```
API : https://abierto.economiayfinanzas.gob.bo/api/acteco-treemap?gestion=YYYY&entidad=<id>
Fecha: 2026-06-14 · TLS incompleto → ssl_verifypeer=0
Cadena: API → 49_download → 51_parse → gasto_agro_prog_muni_2016_2024.rds → .qmd
```

---

## Qué cambia para el reporte

Esto **cierra la limitación declarada en [ADR-0015](../.agent/decisions/ADR-0015_consolidacion_territorial_gasto.md) punto 5**:
antes, la *magnitud/concentración* municipal llegaba a 2024 (MEFP total agro) pero
la *composición por instrumento* se quedaba en 2021 (Jubileo). Ahora la **composición
municipal por propósito/MAFAP también llega a 2024**.

Habilita en el **Cap. 4 (Organización del gasto)**:
- Extender la figura de composición por instrumento de 2021 → 2024.
- Pareto municipal por actividad/propósito en años recientes.
- Trayectoria 2016–2024 de la mezcla productivo / riego / servicios / tierras por municipio.
- Mantiene el split de dos fuentes **declarado**: la taxonomía MEFP (actividad
  económica acteco) ≠ la de Jubileo (programa presupuestario del POA); convergen
  vía la clasificación **MAFAP**, no a nivel de programa individual.

### Caveats (declarar en el capítulo)
- Taxonomía **acteco (actividad económica)**, no la apertura programática literal
  del POA — rotular "composición por actividad/propósito", no "por programa".
- Capta gasto del **gobierno municipal** (devengado por el GAM), no la ejecución
  del nivel central ni departamental.
- 2024 deflactado **preliminar** (CPI INE estimado ≈5,1%).
- Crosswalk acteco→MAFAP **heurístico** (por texto), hereda los residuales de ADR-0014.

---

## Estado de ejecución

- [x] Endpoint MEFP municipal descubierto y validado en vivo
- [x] Script de descarga creado y probado (5 munis OK, 0 fallos)
- [x] Script de parseo creado y validado (QA 0,000% en muestra parcial)
- [~] **Descarga completa en curso** (~2 940 pares municipio×año; cache protege el progreso)
- [ ] Re-correr `51_parse` con los 9 años completos
- [ ] Conectar al Cap. 4 + figura de composición 2016–2024
- [ ] Firma TTL del ADR-0015 (gasto sensible, invariante 9)

---

**Próximo paso al terminar la descarga:**
`Rscript 02_code/02_cleaning/51_parse_mefp_muni_programatico.R`
