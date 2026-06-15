# ADR-0012 — Integración de fuentes externas de gasto agropecuario y empalme BOOST→MEFP

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (incorpora fuentes nuevas al panel y define un empalme de series con salto temporal)
**Lecturas relacionadas:** [ADR-0009](ADR-0009_mafap_narrow_full.md), [ADR-0010](ADR-0010_crosswalk_clasificaciones.md), [`00_admin/auditorias/2026-06-14_revision_gasto_agro_externo.md`](../../00_admin/auditorias/2026-06-14_revision_gasto_agro_externo.md).

---

## Contexto

El panel v12 cubría el **gasto público agropecuario total (corriente + capital)** solo con BOOST **1996–2008**; para 2009–2024 disponía únicamente de **inversión** (VIPFE/SISIN, capital). La carta de solicitud de datos al MEFP no será posible. Una búsqueda en fuentes públicas (2026-06-14) identificó datos descargables que **cierran buena parte del gap**:

| Fuente | Variable | Cobertura | Acceso |
|---|---|---|---|
| **MEFP Presupuesto Abierto** (API) | Gasto **devengado total** del sector Agropecuario (acteco=2) + por entidad + funcional COFOG 4.2 | **2016–2025** | `https://abierto.economiayfinanzas.gob.bo/api/...` (JSON) |
| **UDAPE Dossier** (c030701.xls) | Inversión pública por sector (fila Agropecuario) | 1990–2022 | Excel directo |
| **IMF GFSCOFOG** (GF0402) | Gasto funcional agricultura, gobierno general | nominal 1972–2014, **usable solo 2002–2007** | DBnomics API |

Verificación adversarial (8 agentes) confirmó las cifras contra los RDS crudos.

## Decisión

1. **Adoptar las tres fuentes como insumos canónicos trazables** del panel, parseadas por `02_code/01_data_collection/45_parse_gasto_agro_externo.R` (provenance: URL cruda + fecha de descarga en el header del script) e integradas por `02_code/02_cleaning/46_integrate_gasto_externo.R`, que añade columnas `mefp_*` / `imf_*` al panel `mafap_bolivia.rds` **por año**. Toda cifra citada en el `.qmd` referencia esa cadena (raw URL → 45_ → 46_ → panel) y satisface el invariante 3.1.

2. **Serie de gasto total por tramo (empalme):**
   - 1996–2008 → **BOOST** (`boost_presup_ejecutado_mm`), validado por IMF GF0402 (corr 0,97 en 2002–07).
   - 2009–2015 → **GAP declarado** (sin fuente de gasto total). Se reporta inversión VIPFE como **cota inferior**, etiquetada como tal. **No se interpola.**
   - 2016–2025 → **MEFP sector acteco=2** (devengado total), con el funcional COFOG 4.2 como banda de sensibilidad ±5%.

3. **El empalme BOOST→MEFP NO es directo** (8 años sin solapamiento; taxonomías distintas: BOOST presupuestario vs MEFP devengado-SIGEP). Cualquier serie "gasto total 1996–2025" se rotula explícitamente como **empalme de dos taxonomías** con discontinuidad 2008→2016.

4. **Convenciones:** montos MEFP en BOB corrientes; conversión a USD con el peg `bob_per_usd` del panel (≈6,91 post-2011), declarando el FX. Excluir siempre `year=0` de la serie sector (es el acumulado 2016–2025) y el outlier UDAPE 1997.

## Consecuencias

**Positivas:** cierra el gap de gasto total para 2016–2025; permite reportar el numerador Maputo correcto (~2,04% del gasto público total, no proxy de inversión); cuantifica la fragmentación por entidad en años recientes (EMAPA 25%→56%, MDRyT ~17%, subnacional 38%→22%); resuelve TODO_TRACE institucionales (INIAF; SENASAG no es ejecutor separado).

**Negativas / limitaciones declaradas:** gap 2009–2015 persiste; el split corriente/capital reciente se infiere (no se mide); el empalme tiene una discontinuidad metodológica; las fuentes son externas al pipeline original del panel v12 (se integran vía 46_, que debe correr **después** de 17_mafap_classification.R).

## Pendientes

- [ ] Firma TTL (gasto sensible, invariante 9).
- [ ] No numerar los hallazgos candidatos (EMAPA, gasto total ×2 inversión, recentralización) como `F-NN` definitivos hasta validación humana.
- [ ] Registrar fuentes en `00_admin/ESTADO_DE_DATOS.md`.
