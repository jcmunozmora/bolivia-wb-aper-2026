# ADR-0010 — Crosswalk operacional MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP funcional

**Estado:** aceptado
**Fecha:** 2026-05-23
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: pendiente firma TTL]_
**Color de cambio:** rojo (operacionaliza ADR-0009; define cómo se transforman 4 clasificaciones entre sí)

---

## Contexto

[ADR-0009](ADR-0009_mafap_narrow_full.md) adopta MAFAP narrow + full como clasificación primaria en caps 3 y 4 + OECD-PSE en cap 5. Para que esta decisión sea operacional se requiere un **crosswalk explícito** entre las cuatro clasificaciones en juego:

1. **MAFAP/FAO** (FAO 2013 Manual Vol II) — A1–A5, B1–B2, C1, D1–D8, E1–E5.
2. **OECD-PSE** — PSE (con sub-componentes MPS, BOT por tipo), GSSE (con A–H sub-categorías), CSE, TSE.
3. **COFOG 04.2** — 04.2.1 Agricultura + 04.2.2 Silvicultura + 04.2.3 Pesca y caza.
4. **Clasificación funcional MEFP/VIPFE** — codificación boliviana 31xxx (agricultura), 32xxx (silvicultura), etc. + clasificación económica (10 corriente, 20 capital).

Cada partida de gasto en BOOST o VIPFE debe poder mapearse a **una entrada en cada clasificación** (o estar declarada como "ambigua + asignación documentada"). Sin este crosswalk:

- No se pueden calcular las cifras paralelas del GAP (narrow / full / OECD-PSE / COFOG).
- No se pueden replicar análisis del cap 5 sobre clasificación primaria del cap 3.
- No es posible empalmar con APER 2011 (que usó funcional MEFP).
- No se puede coordinar con consultor STC de repurposing/PSE.

**Casos esperados de mapeo:**

- **1:1 (~60% de partidas)** — directos. E.g., subsidio fertilizantes → MAFAP A2 + OECD-PSE BOT input use + COFOG 04.2.1 + MEFP 31100 económica 28.
- **1:N (~20%)** — una partida MAFAP corresponde a varias categorías OECD. E.g., MAFAP D4 infraestructura → OECD-PSE GSSE I (infrastructure) + a veces GSSE D (inspection).
- **N:1 (~10%)** — varias partidas MAFAP A → un único OECD-PSE BOT cuando OECD agrega tipos de transferencia.
- **Ambiguos (~10%)** — requieren asignación discrecional documentada (e.g., crédito BDP subsidiado: ¿MAFAP A2 input subsidy o A5 historical entitlement? Decisión: A2 cuando el subsidio se calcula como diferencia de tasa de interés).

---

## Decisión

**Generar y mantener `01_data/processed/crosswalk_mafap_oecd_cofog.csv` como tabla maestra de equivalencias entre las cuatro clasificaciones**, con las siguientes especificaciones:

### 1. Estructura del CSV

```text
columnas (8):
  mafap_code              código MAFAP A1, A2, …, E5 (33 códigos en mafap_categories.csv)
  mafap_level             nivel 1 (categoría mayor A–E) o 2 (sub-código)
  oecd_pse_equivalent     PSE_BOT_input_use, GSSE_A_research, etc. (lista separada por ";")
  cofog_code              04.2.1, 04.2.2, 04.2.3, o "no-cofog" (e.g., E rural soporte mapea a otras divisiones COFOG)
  mefp_functional_range   rango códigos VIPFE/BOOST que típicamente caen acá (e.g., "31100-31199")
  bolivia_examples        ejemplos concretos del gasto boliviano que cae acá
  mapping_type            1:1 | 1:N | N:1 | ambiguous
  notes                   notas operativas, casos límite, decisiones discrecionales
```

### 2. Reglas de mapeo ambiguo

Cuando una partida de gasto admite múltiples asignaciones MAFAP, se aplican estas reglas en orden de prioridad:

1. **Función dominante:** si > 70% del monto corresponde a una función específica, asignar a esa función.
2. **Beneficiario directo:** seguir al beneficiario. Subsidio implícito a productor → A; subsidio implícito a consumidor → B; servicio público → D.
3. **Mercado vs. no-mercado:** transferencia que afecta precios → A1 (MPS) o A2; servicio fuera de mercado → D.
4. **Default conservador:** si dudoso entre A (productor) y D (general sector), asignar a D **solo si el beneficio es no-rival y no-excluyente** (definición clásica de bien público); de lo contrario, A.
5. **Documentar la decisión:** todo mapeo ambiguo lleva una entrada en columna `notes` con la regla aplicada.

### 3. Casos de mapeo predefinidos (Bolivia)

Decisiones operacionales para el APER 2026, registradas en el CSV maestro:

| Partida boliviana | MAFAP | OECD-PSE | Justificación |
|---|---|---|---|
| Subsidio implícito crédito BDP | **A2** input subsidy | BOT input use | Beneficio directo al productor; tasa subsidiada es subsidio implícito a insumo "capital de trabajo". |
| Compras públicas EMAPA al productor | **A1** MPS | MPS | MPS clásico: precio sostén con compras públicas. |
| Compras públicas EMAPA al consumidor | **B1** food subsidy | CSE | Cuando EMAPA vende debajo de precio de mercado. |
| Gasto operativo EMAPA | **D8** training/admin sectorial | GSSE H | Componente administrativo no transferible al productor. |
| INIAF investigación | **D1** research | GSSE A research | Mapeo directo. |
| INIAF extensión | **D2** extension | GSSE B extension | Mapeo directo. |
| SENASAG | **D3** sanidad | GSSE D inspection | Mapeo directo. |
| Riego (infraestructura) | **D4** sectoral infrastructure | GSSE I infrastructure | Si infraestructura pública no-rival. |
| Caminos rurales | **E1** rural roads | NO mapea a OECD-PSE | Solo MAFAP captura este componente; "no-pse" en CSV. |
| Electrificación rural | **E2** rural electrification | NO mapea | "no-pse" |
| Educación rural / Salud rural | **E4 / E5** | NO mapea | "no-pse" |
| Subsidio fertilizantes | **A2** | BOT input use | Mapeo directo. |
| Bonos / pagos directos productores rurales | **A5** historical entitlement o A4 area-based | BOT based on historical / area | Depende de regla de elegibilidad. |

### 4. Workflow de actualización del crosswalk

```text
descubrimiento de nuevo caso ambiguo
    → registrar en columna notes del CSV
    → si la regla de mapeo no estaba contemplada en este ADR-0010
    → bump del ADR (estado: superseded by ADR-NNNN) o ADR adicional
    → versionamiento del CSV (semver: v1.0, v1.1, …)
    → registro en bitácora del ADR
```

### 5. Verificación cuantitativa

Tras correr `11_mafap_classification.R` con el crosswalk aplicado:

- `sum(MAFAP_A + MAFAP_B + MAFAP_C + MAFAP_D + MAFAP_E)` debe ser ≥ `sum(VIPFE_inv_agro)` para cada año, dado que MAFAP captura más componentes (incluye crédito subsidiado, EMAPA, etc.).
- `sum(MAFAP_D)` debe ser ≈ `sum(OECD_GSSE)` para los años de cobertura común (2006–2023), con desvío explicable por componentes específicos.
- `sum(MAFAP narrow)` para Bolivia debe ser coherente con `speed_ag_*` del IFPRI SPEED database (cuyos años de cobertura coinciden).

---

## Alternativas consideradas

| Alternativa | Pros | Contras | Decisión |
|---|---|---|---|
| **Crosswalk maestro CSV + reglas explícitas + ADR** (escogida) | trazable; reproducible; auditable; versionable | esfuerzo inicial alto (~33 códigos × 4 columnas) | **aceptada** |
| Crosswalk inline en el script `11_mafap_classification.R` | sin archivo extra | no auditable independientemente; difícil revisar; recodificar es trabajo de programador no analista | rechazada |
| Tres crosswalks separados (MAFAP↔OECD, MAFAP↔COFOG, MAFAP↔MEFP) | desacoplamiento | inconsistencia potencial entre tablas | rechazada |
| Crosswalk solo MAFAP↔MEFP (lo mínimo para reclasificar BOOST) | mínimo esfuerzo | imposibilita reportes paralelos en cap 5 (OECD-PSE) y benchmarking COFOG | rechazada |

---

## Consecuencias

### Sobre artefactos

- **Nuevo archivo canónico:** `01_data/processed/crosswalk_mafap_oecd_cofog.csv` (~33 filas + header).
- **Apéndice D del book** se vuelve renderizable (era `placeholder` por falta de este archivo).
- **Script `11_mafap_classification.R`** lee este CSV como lookup table.

### Sobre el panel v12

- Sin cambios estructurales. El crosswalk es **metadata**, no datos del panel.
- El script de clasificación produce 2 variables derivadas nuevas (`mafap_narrow_bob_2015`, `mafap_full_bob_2015`) — registradas en grupo G18.

### Sobre versionamiento

- El CSV semver propio: `crosswalk_v1.0.csv`, `crosswalk_v1.1.csv`, etc.
- Cambios cosméticos (typos en notes) son VERDE.
- Agregar fila para caso nuevo es AMARILLO.
- Cambiar el mapeo de un código existente es ROJO + ADR + bump panel si cambia cifra del GAP.

### Sobre auditoría

- Cada cifra del GAP en book/web debe poder rastrearse a:
  - `panel_v12_dictionary.csv` (variable canónica),
  - `crosswalk_mafap_oecd_cofog.csv` (definición operativa),
  - `11_mafap_classification.R` (script de cálculo).
- Test nuevo: `test_crosswalk_covers_all_boost_partidas`: verificar que el script puede asignar **toda partida BOOST de sector agropecuario** a una categoría MAFAP (cero "no-clasificable").

---

## Implementación

### Paso 1 — Crear CSV maestro

`01_data/processed/crosswalk_mafap_oecd_cofog.csv` con 33 entradas (una por código MAFAP de `mafap_categories.csv`) + ~5 entradas adicionales para "casos especiales boliviano" (e.g., crédito BDP). Schema en §1 de este ADR.

### Paso 2 — Documentar en apéndice D

`04_report/appendix/D_crosswalk_clasificaciones.qmd` renderiza el CSV con `gt` agrupado por categoría MAFAP A–E, con notas inline.

### Paso 3 — Conectar al script de clasificación

`02_code/02_classification/11_mafap_classification.R` lee el CSV y aplica las reglas. Detallado en MAFAP-1.

### Paso 4 — Tests

```text
test_crosswalk_no_orphan_codes        : todo código MAFAP tiene fila
test_crosswalk_coverage_boost         : todo partida BOOST puede asignarse
test_mafap_d_approximately_oecd_gsse  : sum(MAFAP D) ≈ sum(OECD GSSE) ±10%
test_no_double_counting               : ninguna partida cae en > 1 categoría MAFAP
test_e_no_pse                         : categorías E mapean a "no-pse" en columna OECD
```

---

## Validación

¿Cómo sabremos que la decisión fue correcta?

1. **Test inmediato:** tras correr `11_mafap_classification.R`, la cobertura de partidas BOOST asignadas es ≥ 95% sin "no-clasificable".
2. **Test cuantitativo:** la cifra MAFAP narrow para Bolivia 2018–2023 es coherente (±15%) con la del IFPRI SPEED (variable `speed_ag_*`), dado que ambos son cifras de gasto agropecuario sin rural-soporte.
3. **Test cualitativo:** un experto MAFAP (FAO Pernechele o equivalente) revisa el crosswalk en una sesión y confirma decisiones no obvias (e.g., crédito BDP → A2; EMAPA dividida entre A1/B1/D8).

---

## Referencias

- **ADR-0009** — Adopción de MAFAP narrow + full (justifica la necesidad de este crosswalk).
- **FAO MAFAP Manual Vol II** (FAO 2013) — taxonomía A–E con sub-códigos.
- **OECD PSE Manual** — categorías PSE / GSSE / CSE.
- **UN/SNA COFOG** — Classification of Functions of Government, sección 04.2.
- **MEFP Clasificadores Presupuestarios Bolivia** — codificación funcional 31xxx + económica.
- **PER SSA** (Pernechele et al. 2021) — ejemplo de aplicación MAFAP a 13 países.

---

## Firma

Autor: Juan Carlos Muñoz Mora · 2026-05-23
Revisor TTL: _[TODO_TRACE: pendiente firma]_
Estado: aceptado (pendiente firma TTL)
