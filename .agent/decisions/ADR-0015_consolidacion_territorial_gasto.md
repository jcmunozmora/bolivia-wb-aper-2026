# ADR-0015 — Consolidación territorial del gasto agropecuario y crosswalk municipio↔Censo

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (consolida datos territoriales nuevos, define un crosswalk por nombre y una dependencia de stack espacial externa al renv)
**Lecturas relacionadas:** [ADR-0014](ADR-0014_descomposicion_programatica_acteco.md), [`04_report/04_spending_organization.qmd`](../../04_report/04_spending_organization.qmd), [`.agent/07_FIGURAS.md`](../07_FIGURAS.md).

---

## Contexto

El capítulo 4 (Organización del gasto) tenía prosa territorial desarrollada pero sus figuras estaban **obsoletas** (tema no estándar, títulos descriptivos, BOB nominal) y **sin scripts reproducibles** en el repo (brecha de invariante 7). Además, faltaba el análisis **producción × tipo de instrumento**. El usuario pidió mejorar cinco dimensiones: gasto por departamento, top de municipios, gasto por municipio, concentración y relación producción–instrumento.

Datos disponibles (verificados): `municipal_panel.rds` (339 munis × 2012–2021, instrumentos p10/p12/p18/p32), `subnacional_panel_v2.rds` (9 depts × 2012–2021, + ENA2015 producción + PIB), `cna2013_indicadores.rds` (338 munis × 49 variables de producción, incl. `zona_agroproductiva`), `adm3_muni_con_datos_2020.rds` (geometría sf + gasto 2020). Los paneles `panel_municipal_v3` / `panel_subnacional_v2` citados en gobernanza **no existen con ese nombre**; los reales son `municipal_panel` / `subnacional_panel_v2`.

## Decisión

1. **Consolidar datos territoriales** en `02_code/02_cleaning/49_prep_territorial.R` → `territorial_muni.rds` (muni × año, instrumentos en **USD const. 2015** + producción CNA cruzada) y `territorial_dept.rds` (dept × año, gasto + PIB + ENA2015 + intensidad por hectárea). Deflactado idéntico al resto del reporte: BOB corriente → const. 2015 (CPI 2015=100 del panel subnacional) → USD (÷ 6,91).

2. **Crosswalk municipio↔Censo por nombre normalizado dentro de departamento.** Los esquemas de código son incompatibles (Jubileo `muni_code` = `1{dept_INE}{secuencial}`; CNA `cod_muni` = secuencial por provincia). El cruce normaliza (mayúsculas, sin acentos, sin paréntesis ni sufijos "del departamento de…") y alcanza **286/335 municipios (85%)**. Los no emparejados son variantes de nombre de municipios menores; el residual se declara.

3. **Cinco figuras reproducibles** (estándar [07_FIGURAS](../07_FIGURAS.md)): `fig_produccion_instrumento_zona`, `fig_concentracion_gasto_muni` (Lorenz + Gini), `fig_gasto_dept_produccion`, `fig_top20_municipios_agro`, `fig_mapa_muni_gasto_agro_2024` (ver §5 revisado). Reemplazan las figuras `fig22/25/26/27/28/29/31/32` obsoletas.

4. **Stack espacial (`sf`, `ggrepel`) desde el entorno conda `ds`, no desde renv.** El `R` activo ES el de conda `ds` (misma versión R-4.3 que la librería renv), por lo que los scripts de mapa/repel añaden la librería de conda al `.libPaths` mediante un bootstrap portable (`Sys.getenv("R_GEO_LIBPATH")` → `~/miniforge3/envs/ds/lib/R/library`). **Fix permanente recomendado: `renv::install(c("sf","ggrepel"))`** para fijarlos en el lockfile.

5. **Serie reciente municipal vía MEFP (extensión a 2024).** Como el clasificador por instrumento de Jubileo cierra en 2021, las figuras de **concentración**, **top-municipios** y el **mapa municipal** se reconstruyen sobre `02_code/02_cleaning/50_prep_territorial_mefp.R` → `territorial_muni_mefp.rds`: gasto agropecuario **total** devengado por Gobierno Autónomo Municipal (acteco=2, MEFP), 2016–2024, deflactado a USD const. 2015, con departamento vía catálogo Jubileo (match 100%). Esto crea un **split de dos fuentes declarado** en el capítulo: magnitud/concentración/mapa recientes (MEFP, total agro, 2016–2024) vs composición por instrumento (Jubileo, p10/p12/p18/p32, 2012–2021).

   **Revisión §5 (2026-06-14): mapa municipal actualizado a 2024.** La versión inicial mantenía el mapa en 2020 (Jubileo p10) por el match débil (~76%) de la geometría adm3. Verificación posterior mostró que ese límite no era intrínseco: el RDS de geometría (`adm3_muni_con_datos_2020.rds`) traía **76 polígonos sin `muni_name` ni `dept`** (fallaron el merge con Jubileo). El nuevo script `02_code/02_cleaning/51_prep_territorial_mapa_2024.R` → `adm3_muni_gasto_agro_2024.rds` recupera el nombre desde `shapeName` y el departamento por vecino más cercano (`sf::st_nearest_feature`, 339/339), y cruza con MEFP 2024 en tres pasadas: (a) exacto por nombre normalizado + depto; (b) tabla de **alias explícita** de variantes (Villa/Puerto Mayor/sede: p. ej. "Villa Montes"→Villamontes, "Ayopaya"→Independencia, "Paria"→Soracachi); (c) **pares manuales por ID** (shapeID↔entidad_id) para homónimos resolubles. Coloca el **98,4% del gasto agropecuario municipal 2024** sobre 339 polígonos, 0 colisiones. El **mapa pasa de gasto productivo p10-2020 a gasto agro total MEFP-2024**, alineándose conceptualmente con concentración y top-municipios (la narrativa productiva p10 se conserva en `fig_produccion_instrumento_zona`). El residual irreducible (≈1,6%, 8 municipios) son **homónimos entre departamentos sin código INE** —tres "Santa Rosa" y dos "San Ignacio" en geoBoundaries, Entre Ríos Cbba/Tarija, San Javier Beni/SC— que el cruce por nombre no distingue; cerrar al 100% requiere un shapefile municipal con código INE. La figura se renombra `fig_mapa_muni_gasto_agro_2024` (script `26_fig_mapa_muni_gasto.R`).

## Consecuencias

**Positivas:** cinco análisis territoriales reproducibles y a estándar; nuevo hallazgo **producción × instrumento** (microriego en valles, productivo en la frontera oriental, caminos en los Andes); cuantificación de la **concentración** municipal (Gini ≈ 0,6 del gasto agro total, estable 2016–2024, MEFP; Gini 0,71 del gasto productivo Jubileo 2020); y del **desajuste gasto–producción** (Santa Cruz: 65% de la superficie cultivada, 7% del gasto agro municipal).

**Negativas / limitaciones declaradas:**
- Crosswalk al **85%**; los munis no emparejados quedan fuera del análisis producción×instrumento.
- El `municipal_panel` capta gasto del **gobierno municipal** (POA), no el del nivel central ni el departamental; las cifras municipales no consolidan toda la cadena.
- La producción CNA/ENA es de un corte censal (2013/2015); se usa como estructura, no como serie.
- El mapa cubre **2024** (gasto agro total MEFP) con el **98,4%** del gasto colocado; el residual ≈1,6% (8 municipios homónimos) no es asignable sin código INE. La **composición por instrumento** (p10/p12/p18/p32) sigue limitada a 2012–2021 (Jubileo).
- Dependencia de stack espacial fuera del lockfile renv (mitigada con bootstrap; pendiente `renv::install`).

## Pendientes

- [ ] Firma TTL.
- [ ] `renv::install(c("sf","ggrepel"))` y registrar en lockfile.
- [ ] Mejorar el crosswalk muni↔CNA (>90%) o resolver por código vía catálogo INE.
- [ ] Cerrar el mapa 2024 al 100%: incorporar un shapefile municipal con **código INE** para resolver los 8 municipios homónimos del residual (≈1,6% del gasto); hoy el cruce por nombre alcanza 98,4%.
- [ ] Conectar las cinco figuras en `04_spending_organization.qmd` y rellenar los `TODO_TRACE` territoriales (Gini, Santa Cruz 65/7, instrumento×zona, top munis).
- [ ] Contratos JSON de las cinco figuras en `05_outputs/figures/meta/`.
