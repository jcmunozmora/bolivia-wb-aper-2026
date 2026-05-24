# Auditoría Fase 3 — `08_institutions_programs/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Opus 4.7) — sesión Fase 3
**Método:** Verificación frontmatter contra Crossref API y WebFetch. PDFs disponibles re-leídos con `pypdf`. Carpeta 08 es CRÍTICA para Cap 4 (eficiencia institucional y programas).

---

## Resumen ejecutivo

| Indicador | Valor |
|-----------|------:|
| Fichas con `audit_status: unverified` al inicio | 21 |
| Auditadas Fase 3 | 21 |
| **Verdes** (PDF leído, datos confirmados) | 3 |
| **Amarillas** (metadatos OK vía Crossref/web, sin verificación profunda) | 13 |
| **Rojas** (errores graves en frontmatter, autores, año o cifras) | 5 |

**Total acumulado §08 (Fase 2 + Fase 3 sobre las 32 fichas):**
- Verdes: 4
- Amarillas: 18
- Rojas: 10

---

## Detalle de fichas ROJAS Fase 3

### 1. `INRA_BID2024_EvaluacionMedioTermino.md` — 🔴 ROJO (errores severos)

**Estado más serio de la Fase 3.** Lectura directa del PDF (141 pp) revela múltiples problemas:

| Campo | Ficha | PDF real |
|-------|-------|----------|
| Año | 2024 | **agosto 2022** (portada) |
| Autores | "BID / INRA" | **CONSULTORA ESTRATEGIA INC SRL** (Morales coord., Bazoberry, Salas, Ferreira, Tedesqui) |
| URL frontmatter | inra.gob.bo/wp.../2024/01/... | URL puede existir pero el PDF es del 2022 |
| "90M ha tituladas (2023)" §6 | Inventado | PDF: **meta del Programa = 24.5M ha**; presupuesto US$100M (BID US$60M) |
| "93% saneamiento (2024)" | Inventado | PDF: 93% se refiere al **personal con tareas operativas** del INRA, NO al saneamiento territorial |
| "45% tierra titulada a mujeres" | Inventado | PDF: 45% aparece en **ejecución presupuestaria** 2019, no en titulación a mujeres |
| "356.000 beneficiarios" | Posiblemente inventado | PDF tiene 356.832 en una **columna de tablero administrativo** (sin contexto verificado) |

**Acción urgente:** No citar esta ficha en el reporte hasta corrección completa. Snippet ES/EN y §6 contienen cifras alucinadas.

---

### 2. `PrudencioBohrt2024_EconomiaPolitica.md` — 🔴 ROJO

| Campo | Ficha | PDF real (p. 5) |
|-------|-------|------------------|
| Año | 2024 | **2023** |
| Editor | "IRD Éditions Marseille" | **Plural editores (La Paz) / CERES** con apoyo IRD; ISBN 978-9917-625-80-3, DL 4-1-5106-2023 |
| Autor | Prudencio Böhrt, Julio | ✅ OK |

**Acción:** Corregir año (2024→2023), publisher en BibTeX, address (Marseille → La Paz).

---

### 3. `BDP_LAJED2021_MicrocreditoBolivia.md` — 🔴 ROJO

| Campo | Ficha | LAJED real (vía WebFetch) |
|-------|-------|---------------------------|
| Año | 2021 | **2015** |
| Autores | "Revista Latinoamericana de Desarrollo Económico" (incorrecto, es nombre de la revista) | **Villarroel, Paul; Hernani-Limarino, Werner** (Fundación ARU) |
| Vol | sin indicar | **Vol. 13** |

**Acción:** Corregir frontmatter, BibTeX y citekey (que incluye año erróneo 2021).

---

### 4. `EMAPA_NuevaSociedad2016.md` — 🔴 ROJO

| Campo | Ficha | Nueva Sociedad real |
|-------|-------|---------------------|
| Autores | "Vergara, Pablo" | **Molina, Fernando** |
| Año | 2016 | ✅ correcto |
| Issue | sin indicar | **nº 262 marzo-abril 2016** |

**Acción:** Corregir autor en frontmatter y BibTeX.

---

### 5. `Painter1994_USAID_Chapare.md` — 🔴 ROJO

| Campo | Ficha | orb.binghamton real |
|-------|-------|---------------------|
| Año | 1994 | **1989** (Working Paper nº 219, Institute for Development Anthropology) |
| Autores | Painter & Rasnake | Rasnake & Painter (orden) — ambos correctos |

**Acción:** Corregir año en frontmatter, BibTeX y citekey.

---

## Detalle de fichas VERDES Fase 3

### 1. `PROAGRO_GIZ_NortePotosi.md` — ✅ VERDE
PDF de 2 páginas (brief institucional). Todas las cifras coinciden:
- ">12.000 familias" con riego ✅
- "12 cuencas hidrográficas" ✅
- Fase I 2005-2010 ✅
- Contrapartes VRHR/VDRA MDRyT ✅

(El PDF menciona también +300% incremento ingresos, no en ficha pero no contradice.)

### 2. `McKay2015_BRICSValueChain.md` — ✅ VERDE
PDF de 23 páginas. Metadatos verificados (título, Ben McKay, April 2015, Working Paper 6 BICAS series TNI). Ficha es cualitativa y descriptiva sin cifras fabricadas.

### 3. `INIAF_WorldBank2017.md` — ✅ VERDE
WebFetch al Results Brief WB confirma: 23-octubre-2017, INIAF Bolivia, 20+ innovaciones, 30.000+ productores (>11.000 mujeres), 109.000+ ton semilla certificada, 130+ org I+D, US$39M IDA. Metadatos exactos.

---

## Detalle de fichas AMARILLAS Fase 3 (resumen)

13 fichas amarillas distribuidas en:

### Verificación vía Crossref
| Ficha | DOI | Estado |
|-------|-----|:------:|
| BID_OVE2020_CountryProgramEvaluation | 10.18235/0002581 | ✅ título, año; 10 autores listados (ficha atribuye a OVE) |
| Grisaffi2024_AltDevelopment | 10.1080/00220388.2024.2328035 | ✅ título, JDS 60(7) 2024; **DISCREPANCIA**: Crossref muestra Farthing & Grisaffi (2 autores), ficha agrega Ledebur |

### Verificación vía WebFetch al sitio fuente
| Ficha | Sitio | Estado |
|-------|-------|:------:|
| Bolpress2026_EMAPA | bolpress.com | ✅ verificado; pero autor real es Surco Chuquimia, no "Bolpress Redacción" |
| Cosude_AndesResilientes | andesresilientes.org | ✅ programa COSUDE/Helvetas/Avina/FAO confirmado |
| EBA_BoliviaEmprende | boliviaemprende.com | ✅ artículo sobre EBA con cifras (3800 familias, 204 comunidades) |
| Saneamiento_AVSF2023 | avsf.org | URL válida; PDF descargado pero encoding impide parsing |

### Verificación parcial (sitio existe, pero sin lectura profunda)
| Ficha | Comentario |
|-------|------------|
| BID2014_AnalisisPoliticasAgropecuarias | URL IADB válida, sitio bloqueó WebFetch |
| Colque2016_SegundaReformaAgraria | URL apunta solo a ftierra.org root (no a página específica del libro) |
| EMAPA_FundacionTIERRA | ftierra.org bloqueó artículo específico |
| IFAD_ACCESOS_Rural2024 | ifad.org bloqueó URL específica |
| PARIII_WorldBank2022_InnovationFoodSystems | WB Documents válido (procurement plan P175672) |
| SantaCruz_GAD2024 | ice.santacruz.gob.bo retornó HTTP 502 |
| SENASAG_Institucional | senasag.gob.bo confirmado (página institucional) |

---

## Cifras críticas para Cap 4 — estado de verificación

| Cifra | Fuente | Estado |
|-------|--------|:------:|
| ICR del PAR I/II (World Bank) | PAR_WorldBank2024_ICR | 🟡 (Fase 2) |
| PICAR US$ inversión | PICAR_WorldBank2021_ICR | 🔴 (Fase 2 — cifras inconsistentes) |
| INIAF: 30.000+ productores, 11.000+ mujeres | INIAF_WorldBank2017 | ✅ Fase 3 |
| CRIAR US$/familias beneficiarias | CRIAR_WB2012_PAD | 🔴 (Fase 2) |
| PROAGRO: 12.000 familias, 12 cuencas | PROAGRO_GIZ | ✅ Fase 3 |
| INRA-BID >90M ha tituladas | INRA_BID2024 | 🔴 **fabricado** Fase 3 |
| IFAD ACCESOS resultados | IFAD_ACCESOS_Rural2024 | 🟡 (sin PDF) |
| PlanVida indicadores | PlanVida_IFAD | 🔴 (Fase 2) |
| AEMP plaguicidas Bs | AEMP2024 | 🔴 (Fase 2) |
| EBA 3.800 familias, 204 comunidades | EBA_BoliviaEmprende | ✅ Fase 3 |

---

## Recomendaciones de acción

### 🔴 Crítico antes de redactar Cap 4
1. **`INRA_BID2024_EvaluacionMedioTermino`** — la ficha más grave de Fase 3. Snippet ES/EN y §6 contienen cifras inventadas. Reescribir desde cero leyendo el PDF de 2022 directamente.
2. **`PrudencioBohrt2024`** — corregir año (2023) y publisher (Plural / La Paz, no IRD Marseille). Importante porque la ficha es referencia central de Cap 1.
3. **`BDP_LAJED2021`** — corregir autores (Villarroel & Hernani-Limarino), año (2015), citekey y volumen.
4. **`EMAPA_NuevaSociedad2016`** — corregir autor (Molina, no Vergara).
5. **`Painter1994`** — corregir año (1989, no 1994).

### 🟡 Próxima sesión
- Descargar manualmente PDFs de fichas amarillas para los reportes BID_OVE 2020, BID 2014 Análisis Políticas, IFAD ACCESOS, PAR III, Santa Cruz GAD 2024 y verificar §6.
- Para `Grisaffi2024_AltDevelopment`, confirmar si Ledebur es realmente coautor (Crossref solo muestra 2).
- Para `Cosude_AndesResilientes`, decidir si el año debe ser 2021 (publicación original) o 2023 (referencia del sitio).

### 🟢 Mantener
- `PROAGRO_GIZ_NortePotosi.md`, `McKay2015_BRICSValueChain.md`, `INIAF_WorldBank2017.md` — verificados como verdes Fase 3.

---

## Fichas tras Fase 3 (status final §08)

```
green:   4   FAO_PerfilSistemasAlimentarios, PAR_IEG2018_PPAR,
              + PROAGRO_GIZ_NortePotosi, McKay2015_BRICSValueChain,
              + INIAF_WorldBank2017 (Fase 3)
red:    10   AEMP2024_PlaguicidasBolivia, CIPCA, CRIAR_WB2012_PAD,
              PICAR_WorldBank2021_ICR, PlanVida_IFAD (Fase 2)
              + BDP_LAJED2021, EMAPA_NuevaSociedad2016,
              INRA_BID2024_EvaluacionMedioTermino,
              Painter1994_USAID_Chapare, PrudencioBohrt2024 (Fase 3)
yellow: 18   (resto §08)
```

**§08 — total: 32 fichas | 5 green | 10 red | 17 yellow**
