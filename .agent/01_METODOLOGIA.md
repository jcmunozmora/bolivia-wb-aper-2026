# 01_METODOLOGIA.md — APER 2026 Bolivia

**Versión:** m0.1.0
**Última actualización:** 2026-05-23
**Propósito:** documentar las **definiciones operativas**, **fórmulas**, **clasificaciones**, **supuestos** y **procedimientos** sobre los que se construyen el panel v12, los 8 hallazgos, los escenarios de repurposing y todas las cifras del APER 2026. Es la **autoridad única** para responder "¿cómo se calculó esto?".
**Lecturas relacionadas:** [04_HALLAZGOS.md](04_HALLAZGOS.md), [02_INDICADORES.md](02_INDICADORES.md), [03_FUENTES.md](03_FUENTES.md), [08_CONTROL.md](08_CONTROL.md), [09_AUDITORIA.md](09_AUDITORIA.md), [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md) §7.4, §7.5, §7.6.

---

## 1. Principio rector

> Cada definición operativa, cada fórmula y cada supuesto del APER 2026 vive acá, versionado. Si una cifra del book no puede explicarse desde una sección de este archivo, **la cifra falla auditoría**.

Reglas:

1. **01_METODOLOGIA.md es la autoridad metodológica**. 02_INDICADORES.md detalla cada variable, 03_FUENTES.md detalla cada fuente cruda, pero **01_METODOLOGIA.md** explica **por qué** las definiciones son las que son.
2. Cambios a este archivo son **ROJO** (CONTROL §4.3) salvo correcciones cosméticas. Cada cambio sustantivo requiere **ADR**.
3. La versión del archivo (`m<x.y.z>`) se cita en cada hallazgo, cada figura y cada escenario.
4. No se inventan definiciones — se importan de marcos reconocidos (OECD-PSE, FAO MAFAP, WB BOOST, INE) y se adaptan declarando explícitamente la adaptación.

---

## 2. Marcos de referencia adoptados

| Marco | Uso en el APER 2026 |
|---|---|
| **WB BOOST** | clasificación primaria del gasto agrícola desde la base BOOST 2024 release |
| **MEFP — clasificación funcional y económica** | clasificación oficial del gasto público boliviano |
| **OECD PSE/CSE Manual** (última edición consolidada) | medición de Producer / Consumer Support Estimate, adaptado a Bolivia |
| **FAO MAFAP** | benchmarking PSE para países comparables (LATAM, países andinos) |
| **WB ASTI** (Agricultural Science & Technology Indicators) | métricas de I+D agrícola |
| **USDA-ERS TFP** | Total Factor Productivity comparable internacionalmente |
| **FAOSTAT** | producción, rendimientos, comercio agrícola |
| **WDI (WB)** | macroeconomía, PIB sectorial, indicadores rurales |
| **INE** (encuestas EH, CENSO Agropecuario 2013, proyecciones de población) | datos bolivianos primarios |
| **CONPES / Plan Nacional de Desarrollo** | marco institucional boliviano (cuando aplica para contextualizar) |

Cuando dos marcos producen cifras divergentes para el mismo concepto, **se reporta el rango** y se documenta la divergencia en el apéndice metodológico (`appendix/methodological-annex.qmd`).

---

## 3. Cobertura del reporte

### 3.1. Cobertura sectorial

```text
sector: agricultura, ganadería, silvicultura, pesca (cuando hay datos
        consistentes) — alineado con clasificación CIIU sección A.

subsectores cubiertos:
  - cultivos transitorios (soya, maíz, trigo, arroz, papa, quinua, otros)
  - cultivos permanentes (café, cacao, frutales)
  - ganadería bovina, camélida, ovina, porcina, avicultura
  - silvicultura (cuando aplica al gasto público sectorial)
  - pesca y acuicultura (cobertura parcial — ver §3.4)

subsectores excluidos del análisis cuantitativo principal:
  - agroindustria post-cosecha (entra en industria, no en agricultura)
  - turismo rural (entra en servicios)
```

### 3.2. Cobertura geográfica

```text
unidad nacional: Estado Plurinacional de Bolivia.
desagregación: 9 departamentos.
sub-desagregación: cuando el panel lo permite, ámbito urbano/rural y
                   zona productiva (e.g. tierras bajas vs. valles vs.
                   altiplano).
```

### 3.3. Cobertura temporal

```text
ventana principal del panel: [TODO_TRACE: confirmar — propuesta 2010-2023].
ventana base para hallazgos: 2015-2023 (cuando hay cobertura completa).
ventana extendida para tendencias: 2005-2023 (cuando hay series largas).

año base para precios reales: [TODO_TRACE: confirmar — propuesta 2015].
deflactor principal: deflactor del PIB (INE).
deflactor alternativo (sensibilidad): IPC agrícola (INE).
```

### 3.4. Cobertura institucional

```text
gobierno general:
  - administración central (MEFP, MDRyT, MMAyA cuando aplica al sector)
  - empresas estatales agrícolas (EMAPA, INIAF, SENASAG, otras)
  - gobiernos subnacionales (9 departamentales + municipales) cuando
    BOOST trae desagregación

cobertura parcial:
  - cooperación internacional (registrada en BOOST pero con cobertura
    variable; tratamiento documentado §6.5)

excluido:
  - sector privado (no es gasto público)
  - gasto militar con componente rural (no es gasto agrícola)
```

---

## 4. Definiciones operativas core

### 4.1. Gasto agrícola público (GAP)

**Definición.** Erogaciones del gobierno general (administración central + empresas estatales + gobiernos subnacionales) clasificadas funcional o económicamente como **agricultura, ganadería, silvicultura, pesca y servicios agropecuarios conexos**, ejecutadas en bolivianos corrientes y convertidas a bolivianos reales del año base con el deflactor del PIB.

**Operacionalización.**

```text
GAP_t = SUM_{entity e} SUM_{program p en sector agrícola} executed_spending(e, p, t)

donde:
  - executed_spending viene de BOOST 2024 (no devengado, sino ejecutado).
  - "sector agrícola" sigue la clasificación funcional CIIU sección A
    cruzada con clasificación funcional MEFP.
  - cruces con clasificación económica documentan transferencias vs.
    bienes y servicios vs. inversión vs. servicios de la deuda.
```

**Excepciones.**

```text
- Subsidios indirectos (combustible agrícola, fertilizantes via empresas
  estatales) entran al GAP si están registrados en BOOST con destino
  agrícola; se reportan también como "gasto cuasi-fiscal" en sensibilidad.
- Crédito agrícola subsidiado entra como costo del subsidio (no como
  monto del crédito), siguiendo OECD-PSE.
- Inversión en infraestructura rural multipropósito (e.g. caminos
  vecinales) entra prorrateada solo si BOOST trae proporción agrícola;
  en caso contrario se reporta aparte con caveat.
```

**Versión.** Definición congelada en `m0.1.0`. Cambio requiere ADR.

### 4.2. PIB agrícola

**Definición.** Valor agregado bruto del sector agropecuario en cuentas nacionales del INE, en bolivianos reales del año base.

```text
PIB_agrícola_t = INE.cuentas_nacionales.VAB.agropecuario(t)
                 deflactado por INE.deflactor_VAB_agropecuario.
```

**Caveat.** El VAB agropecuario del INE puede no coincidir con CIIU-A si Bolivia excluye o incluye subsectores no estándares; se documenta en `appendix/methodological-annex-A1.qmd`.

### 4.3. Bienes públicos agrícolas vs. transferencias privadas

Adaptación de la tipología OECD-PSE simplificada para policy report:

```text
BIENES PÚBLICOS AGRÍCOLAS (GSSE — General Services Support Estimate):
  - I+D agrícola (INIAF, universidades, otros centros)
  - extensión rural y asistencia técnica
  - sanidad animal y vegetal (SENASAG)
  - infraestructura de irrigación (cuando es bien público no rival)
  - infraestructura de comercialización (acopio público no rival)
  - inspección y certificación
  - educación agrícola formal y técnica
  - servicios de información de mercado

TRANSFERENCIAS PRIVADAS (PSE):
  - transferencias directas a productores (subsidios, bonos)
  - subsidios a insumos (fertilizantes, semillas, combustible agrícola)
  - subsidios a crédito agrícola
  - precio mínimo / precio sostén / compras públicas estabilizadoras
  - transferencias a empresas estatales agrícolas en su componente que
    sostiene precio o ingreso al productor

OTROS:
  - servicios administrativos del sector (overhead institucional)
  - emergencias agrícolas y desastres
```

**Regla operativa.** La clasificación funcional MEFP no siempre permite separar 1:1. Se aplica una matriz de mapping documentada en [02_INDICADORES.md](02_INDICADORES.md) §X. Casos ambiguos se reportan en sensibilidad.

### 4.4. PSE — Producer Support Estimate

Adaptado del OECD PSE Manual:

```text
PSE_t = MPS_t + BOT_t

donde:
  MPS_t = Market Price Support = (P_producer - P_reference) * Q_produced
          ajustado por costos de transporte y márgenes comerciales.

  BOT_t = Budgetary and Other Transfers
        = transferencias presupuestarias directas a productores
        + subsidios a insumos
        + subsidios al crédito
        + pagos por área plantada / cabeza de ganado
        + otros transferibles al productor identificables en BOOST.

%PSE_t = PSE_t / Gross_Farm_Receipts_t
```

**Supuestos clave.**

```text
- Precio de referencia internacional: precio FOB / CIF del commodity en
  un mercado representativo (Chicago, Rotterdam, según commodity),
  ajustado por flete a frontera boliviana.
- Tasa de cambio: tipo de cambio oficial (Bolivia mantiene tipo fijo;
  sensibilidad a tipo paralelo cuando aplica).
- Productos cubiertos: [TODO_TRACE: lista de commodities con cobertura
  MAFAP/FAO en panel v12 — propuesta inicial: soya, maíz, trigo, arroz,
  papa, quinua, carne bovina, leche].
```

**Sensibilidad.**

```text
PSE_alto = MPS calculado con precio FOB sin descuento por flete
PSE_medio = caso base (con flete)
PSE_bajo = MPS con precio CIF doméstico (i.e. asumiendo no-comercializable)

Se reporta el rango en el escenario PSE alto/medio/bajo del capítulo 05.
```

**Versión.** Metodología PSE congelada en `m0.1.0`. Cambio requiere ADR (típicamente ADR-0003 según master §21).

### 4.5. CSE — Consumer Support Estimate

```text
CSE_t = - MPS_consumer_t + Transferencias_a_consumidores_t

donde:
  MPS_consumer_t refleja la transferencia implícita de consumidores a
  productores vía precios distorsionados (signo opuesto al MPS del PSE
  para los mismos commodities).

  Transferencias_a_consumidores_t incluye programas de alimentación
  (subsidios alimentarios, comedores, transferencias condicionadas con
  componente alimentario).

%CSE_t = CSE_t / Consumption_value_t
```

### 4.6. Repurposing del gasto agrícola

**Definición.** Reasignación de la composición del gasto agrícola público dentro de un **techo fiscal constante** (en términos reales) hacia instrumentos de mayor retorno social, productivo y/o climático según evidencia internacional.

**Lo que NO es repurposing en este reporte.**

```text
- Recortar el gasto agrícola total.
- Aumentar el gasto agrícola total.
- Cambiar el techo fiscal global.
- Imponer una nueva política sin cuantificar su composición.
- Eliminar empresas estatales (es un cambio institucional distinto).
```

**Operacionalización en escenarios.**

```text
Cada escenario S0X especifica:
  - composición ex-ante (estado actual del gasto, derivado del panel)
  - composición ex-post (reasignación propuesta)
  - magnitud de reasignación (% del gasto agrícola total)
  - supuestos de elasticidad (de [@ifpri2023], [@fao2023], [@laborde2021],
    con calibración boliviana cuando es posible)
  - horizonte (default 5 años)
  - efectos esperados sobre indicadores (TFP, ingreso rural, emisiones,
    equidad territorial), con banda de incertidumbre.

Marcado obligatorio: "opción técnica para consideración del MEFP", no
prescripción (NEUTRALIDAD §2.3).
```

### 4.7. Brechas territoriales

Adaptación de §7.4 del master:

```text
need_score(department d, indicator i) =
    0.40 * current_gap_severity(d, i)
  + 0.25 * trend_deterioration(d, i)
  + 0.20 * affected_population(d, i)
  + 0.10 * distance_to_benchmark(d, i)
  + 0.05 * strategic_criticality(d, i)

donde los pesos son los del master §7.4 (versión congelada en m0.1.0).

indicadores usados (con cobertura departamental):
  - pobreza rural (INE EH)
  - inseguridad alimentaria (INE EH + FAO)
  - rendimiento por hectárea de cultivos clave (INE + MDRyT)
  - acceso a riego (Censo Agropecuario 2013 + actualizaciones MDRyT)
  - emisiones por hectárea (FAOSTAT GHG departamentalizado)
```

**Caveat.** El score territorial es **descriptivo**, no causal. Se usa para mapear necesidad relativa, no para predecir impacto del gasto.

---

## 5. Construcción del panel v12

### 5.1. Unidad de observación

```text
unidad mínima: (entidad ejecutora × programa × año × clasificación funcional
               × clasificación económica × territorio cuando aplica)
              .

agregación canónica para hallazgos:
  - nivel nacional × año (F01, F03, F06, F08)
  - nivel departamental × año (F04, F05)
  - nivel commodity × año (F02 cuando aplica, F06 para PSE)
```

### 5.2. Pipeline de construcción

```text
01_data/raw/                fuentes crudas inmutables
  ├─ boost_2024/
  ├─ ine_eh/
  ├─ ine_censo_agropecuario_2013/
  ├─ ine_proyecciones_poblacion/
  ├─ fao_mafap/
  ├─ fao_stat/
  ├─ wdi/
  ├─ usda_ers_tfp/
  ├─ oecd_pse/                (para benchmarks)
  └─ mefp_clasificadores/

02_code/01_ingest/          scripts de descarga / lectura
02_code/02_clean/           limpieza, normalización, validación
02_code/03_construct/       construcción del panel v12
  ├─ 01_normalize_boost.R
  ├─ 02_classify_functional_economic.R
  ├─ 03_compose_public_vs_private.R
  ├─ 04_territorialize.R
  ├─ 05_link_indicators.R
  └─ 06_build_panel_v12.R   ← produce panel_v12.rds

01_data/processed/
  └─ panel_v12.rds          single source of truth para todas las cifras
```

Cualquier cifra publicada **debe** reconstruirse corriendo `renv::restore()` + el script correspondiente sobre `01_data/raw/`.

### 5.3. Reglas de imputación y missing

```text
- Missing por no-ejecución: codificado como 0 si el programa existió
  pero no ejecutó; codificado como NA si la entidad no reportó.
- Missing por cobertura institucional: NA + flag de cobertura;
  agregados que lo incluyen reportan asterisco con nota.
- Imputación: NO se imputan cifras de gasto. Se reporta la cobertura.
- Variables derivadas con NA: se propaga el NA salvo regla explícita
  documentada en 02_INDICADORES.md.
```

### 5.4. Deflactor y precios reales

```text
deflactor principal: INE deflactor del PIB total, base 2015.
deflactor alternativo: IPC general INE, base 2016 reconvertido a 2015.
deflactor agrícola específico: deflactor del VAB agropecuario, INE.

regla: cifras de gasto agrícola se presentan en bolivianos reales 2015
con deflactor del PIB total. Sensibilidad con deflactor agrícola
específico se reporta cuando la diferencia altera el ordenamiento de
hallazgos.

conversión USD: tipo de cambio oficial promedio anual del BCB.
Sensibilidad con tipo paralelo cuando aplica.
```

### 5.5. Bumps del panel

```text
v12 → v13 ocurre cuando:
  - se incorpora una fuente cruda nueva (03_FUENTES.md update)
  - cambia una definición operativa de §4
  - cambia una regla de imputación o de deflactor
  - se corrige un error en la construcción

el bump NO ocurre por:
  - nueva figura usando variables ya existentes
  - corrección cosmética en 02_INDICADORES.md
  - nueva agregación derivada del mismo panel
```

---

## 6. Tratamientos especiales

### 6.1. Empresas estatales agrícolas

EMAPA, INIAF, otras empresas con gasto agrícola: incluidas en el GAP cuando hay reporte en BOOST 2024. Su gasto se desagrega por:

```text
- gasto operativo (overhead) → categoría "servicios administrativos"
- gasto en compras públicas estabilizadoras → categoría "transferencias
  precio-distorsionantes" (parte del MPS / BOT del PSE)
- gasto en I+D / extensión / sanidad → "bienes públicos agrícolas"
```

Cuando la desagregación no está disponible, se asigna a "transferencias a empresas estatales" como categoría agregada y se documenta en `appendix/methodological-annex-A2.qmd`.

### 6.2. Subsidios indirectos (combustible, fertilizantes)

Si el subsidio se registra en BOOST con destino agrícola: entra al GAP.
Si está implícito en precios subsidiados nacionales sin partida específica: se estima vía precio internacional vs. precio doméstico y se reporta como **subsidio cuasi-fiscal** en sensibilidad, fuera del GAP base pero dentro del PSE (componente MPS).

### 6.3. Cooperación internacional

```text
- Préstamos concesionales con ejecución vía MDRyT u otra entidad pública:
  el componente de ejecución entra al GAP; el repago entra a deuda
  (no agrícola).
- Donaciones registradas en BOOST: entran al GAP.
- Cooperación off-budget (no en BOOST): se documenta cuando hay
  registro en MDRyT u otras fuentes; reporte cualitativo con caveat.
```

### 6.4. Crédito agrícola subsidiado

Costo fiscal del subsidio implícito = diferencia entre tasa de interés del mercado de referencia y tasa subsidiada, multiplicada por el saldo promedio de cartera subsidiada. Entra al PSE como BOT, no al GAP directo (porque BOOST registra el subsidio, no el crédito).

### 6.5. Tratamiento de gasto sub-nacional

```text
gasto departamental / municipal con clasificación funcional agrícola:
  - incluido en GAP cuando BOOST lo registra
  - desagregado a departamento cuando hay código territorial
  - imputado proporcional a población rural cuando no hay código (con
    flag en panel)
```

---

## 7. Métricas y fórmulas adicionales

### 7.1. Tasa de crecimiento real

```text
g_real(t, t-k) = ( GAP_real_t / GAP_real_{t-k} )^{1/k} - 1
```

Por defecto k=1 (anual); para tendencias largas, k tomado como ventana completa con CAGR.

### 7.2. Share de un componente

```text
share_c_t = component_spending_c_t / GAP_t
```

Reportado con período de promedio cuando se cita en hallazgos (e.g. "62% promedio 2018-2023").

### 7.3. Coeficiente de focalización (asociación entre gasto y necesidad)

```text
focusing_coef = corr( log(GAP_per_capita_rural_d), need_score_d )

con corr ponderado por población rural.
```

Reportado como descriptivo, no causal. Valor positivo indica focalización en necesidad; valor cercano a cero indica focalización aleatoria.

### 7.4. Índice de concentración (Gini de gasto territorial)

```text
gini_territorial = Gini( GAP_per_capita_rural_d, populations = pop_rural_d )
```

Comparable con Gini de pobreza para identificar mismatch.

### 7.5. Bandas de incertidumbre para escenarios

```text
para cada escenario S0X:
  - estimación central: con elasticidades de literatura central
  - banda baja: elasticidades del cuartil inferior de la literatura
  - banda alta: elasticidades del cuartil superior
  - el reporte presenta SIEMPRE las tres, no solo la central
```

---

## 8. Tratamiento de la incertidumbre

```text
NIVEL BAJA      datos primarios con cobertura completa; definiciones
                estandarizadas (e.g. PIB sectorial del INE).

NIVEL MEDIA     datos primarios con cobertura parcial o que requieren
                normalización; o derivación con supuestos pequeños
                (e.g. PSE base sobre commodities con buena cobertura
                FAO/MAFAP).

NIVEL ALTA      datos secundarios, imputaciones, o derivación con
                elasticidades estimadas en otros contextos productivos
                (e.g. escenarios de repurposing).
```

Cada hallazgo y cada escenario declara su `uncertainty.level` (§4 contrato de 04_HALLAZGOS.md). Hallazgos con `uncertainty: alta` requieren:

```text
- banda numérica reportada (no solo punto central)
- caveat explícito en el claim
- análisis de sensibilidad en apéndice
- NEUTRALIDAD §3.16 (sin teatralidad cuantitativa): adjetivos como
  "significativo" requieren la cifra.
```

---

## 9. Glosario operativo

```text
APER           Agricultural Public Expenditure Review (este reporte)
GAP            Gasto Agrícola Público (definido §4.1)
PSE            Producer Support Estimate (§4.4)
CSE            Consumer Support Estimate (§4.5)
MPS            Market Price Support (componente del PSE, §4.4)
BOT            Budgetary and Other Transfers (§4.4)
GSSE           General Services Support Estimate (componente del TSE
               OECD; aproximadamente nuestro "bienes públicos agrícolas")
TSE            Total Support Estimate (PSE + GSSE + transferencias al
               consumidor; total del apoyo público al sector)
TFP            Total Factor Productivity (productividad total de factores)
VAB            Valor Agregado Bruto
CIIU           Clasificación Industrial Internacional Uniforme
BOOST          base de datos del WB de ejecución presupuestaria
MAFAP          Monitoring and Analysing Food and Agricultural Policies (FAO)
ASTI           Agricultural Science & Technology Indicators (WB/IFPRI)
WDI            World Development Indicators (WB)
INE            Instituto Nacional de Estadística (Bolivia)
EH             Encuesta de Hogares (INE)
MEFP           Ministerio de Economía y Finanzas Públicas (Bolivia)
MDRyT          Ministerio de Desarrollo Rural y Tierras (Bolivia)
INIAF          Instituto Nacional de Innovación Agropecuaria y Forestal
SENASAG        Servicio Nacional de Sanidad Agropecuaria e Inocuidad
               Alimentaria
EMAPA          Empresa de Apoyo a la Producción de Alimentos (estatal)
techo fiscal   restricción de gasto total sectorial constante en
               términos reales (supuesto base de repurposing)
repurposing    reasignación de composición del gasto bajo techo fiscal
               constante (§4.6)
```

Glosario obligatorio en cada producto público (alineado con NEUTRALIDAD §4).

---

## 10. Plantillas

### 10.1. Para una definición operativa nueva

```markdown
### N.M. <nombre del concepto>

**Definición.** <una frase precisa>

**Operacionalización.**

```text
fórmula o pseudo-código
```

**Excepciones.** <casos límite y cómo se tratan>

**Marco de referencia.** <OECD-PSE / FAO MAFAP / propio>

**Caveats.** <qué no captura, sensibilidades>

**Versión.** Congelada en `m<x.y.z>`. Cambio requiere ADR.
```

### 10.2. Para un escenario de repurposing nuevo

```markdown
### S0X — <nombre>

**Composición ex-ante.** <tabla con la composición actual del gasto>
**Composición ex-post.** <tabla con la reasignación propuesta>
**Magnitud de reasignación.** <% del GAP total>
**Supuestos.** <techo fiscal constante; elasticidades de [@cita]; horizonte 5 años>
**Efectos esperados.** <tabla con TFP, ingreso rural, emisiones, equidad — central + banda>
**Incertidumbre.** <nivel + razón>
**Estado.** technical_option_for_MEFP_discussion
```

---

## 11. Cómo modificar este archivo

`01_METODOLOGIA.md` es zona crítica (CONTROL §3). Reglas duras:

| Tipo de cambio | Color | Requisitos |
|---|---|---|
| Llenar un `[TODO_TRACE]` con cifra o referencia trazada en sección no operativa | AMARILLO | A2 + verificación de fuente |
| Agregar un caveat o sensibilidad nueva | AMARILLO | A2 |
| Cambiar año base, deflactor, tipo de cambio default | ROJO | ADR + bump `m<x.y>` + bump panel cuando aplica |
| Cambiar definición operativa de GAP, PSE, CSE, bienes públicos | ROJO | ADR + bump `m<x.y>` (típicamente major) + regeneración de figuras |
| Agregar marco de referencia nuevo (§2) | ROJO | ADR |
| Cambiar reglas de imputación (§5.3) | ROJO | ADR + bump panel |
| Cambiar tratamiento de empresas estatales / cooperación internacional / subsidios indirectos | ROJO | ADR |
| Cambiar el glosario operativo | AMARILLO si agrega; ROJO si cambia definición de un término que ya circula en el book |

ADRs típicos:

```text
ADR-0001 — Panel v12 como fuente canónica (CONTROL §6 plantilla)
ADR-0002 — Los 8 hallazgos como unidades versionadas
ADR-0003 — Metodología PSE/CSE (este archivo §4.4 y §4.5)
ADR-0004 — Escenarios de repurposing como opciones técnicas (§4.6)
```

---

## 12. Estado del archivo y TODOs

Esta es la versión **m0.1.0**, esqueleto inicial. Pendientes para próximas sesiones:

```text
[TODO §3.3] confirmar ventana temporal del panel (propuesta 2010-2023)
[TODO §3.3] confirmar año base de precios reales (propuesta 2015)
[TODO §4.4] cerrar la lista de commodities con cobertura PSE en panel v12
[TODO §5.2] auditar que los scripts 02_code/03_construct/*.R existen y
            corresponden al pipeline declarado
[TODO §6.1] documentar cobertura de reporte de EMAPA, INIAF y otras
            empresas estatales con datos disponibles
[TODO §6.3] inventariar cooperación internacional registrada en BOOST 2024
[TODO §7.3] decidir si el coeficiente de focalización va con corr Pearson,
            Spearman o un índice tipo Suits
[TODO §10.2] poblar S01, S02, S03 (mínimo) como escenarios base
[TODO general] enlazar este archivo con 02_INDICADORES.md (cuando exista)
              vía referencias §X.Y por variable
[TODO general] enlazar con 03_FUENTES.md (cuando exista) por fuente cruda
```

---

## 13. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| m0.1.0 | 2026-05-23 | Versión inicial: marcos de referencia adoptados, cobertura, definiciones operativas GAP/PIB agrícola/bienes públicos/PSE/CSE/repurposing/brechas territoriales, construcción del panel v12, tratamientos especiales (empresas estatales, subsidios indirectos, cooperación internacional, crédito subsidiado, sub-nacional), métricas adicionales, manejo de incertidumbre, glosario, plantillas, TODOs |
