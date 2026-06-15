# Auditoría Zotero — duplicados y calidad de referencias

**Fecha:** 2026-06-14
**Grupo:** Zotero `WB-APER-Bolivia` (group ID `6586554`)
**Alcance:** 324 referencias top-level (los 366 ítems incluían PDFs/notas adjuntas)
**Método:** extracción vía API local Zotero + detección de duplicados (DOI / título normalizado) + lookup de DOIs en CrossRef. **Cero invención** — DOIs solo si CrossRef los confirma.
**Relacionado:** [`ADR-0013`](../../.agent/decisions/ADR-0013_zotero_fuente_canonica_bibliografia.md), [`03_literature/README.md`](../../03_literature/README.md).

> **Cómo se ejecuta:** las fusiones se hacen en la **app de escritorio de Zotero** (panel *Elementos duplicados* → *Combinar*), única vía que **preserva los enlaces de cita en el `.docx`** del round-trip Word. Un borrado por API rompería citas ya insertadas. Para tipos/años distintos (casos 9–10) Zotero no auto-detecta → manual.

---

## A. Duplicados a fusionar (★ = master a conservar)

| # | Obra | ★ Conservar | → Quitar | Nota de ejecución |
|---|------|-------------|----------|-------------------|
| 1 | Springmann, *Options for reforming ag. subsidies* (Nature 2022) | `GED6QQJC` | `8Y9KTCEK` | DOI idéntico `10.1038/s41467-021-27645-2` |
| 2 | Grisaffi et al., *From alt. development to decolonisation* (JDS 2024) | `FZNL273Q` | `9AE4Q7DQ` | ⚠️ mismo DOI `10.1080/00220388.2024.2328035` pero el de quitar trae autores **Brombacher/Maihold** (otro paper). Verificar antes de fusionar (ver §D) |
| 3 | Simar & Wilson, *Sensitivity analysis of efficiency scores* (1998) | `QY3Z6PDW` | `FA2SGDKW` | DOI idéntico `10.1287/mnsc.44.1.49` |
| 4 | Bazile et al., *Global expansion of quinoa* (2016) | `8A22K95X` | `GBIP64DT` | el de quitar tenía año/autor errados (2015/Baudron) |
| 5 | Pernechele, *Public exp. food & agri SSA* (FAO 2021) | `M7RFPKLC` | `78Z6JCFM` | DOI idéntico `10.4060/cb4492en` |
| 6 | AGRECOL, *Beneficios de la Agroecología en Bolivia* (2017) | `W4HE4X2T` | `Y7ZQG6Z7` | misma URL = mismo doc |
| 7 | FAO, *Perfil de sistemas alimentarios Bolivia* (2022) | `QLDYBGV8` | `NPEUVN5N` | al combinar, elegir **autores de `NPEUVN5N`** (FAO+EU+CIRAD) y URL de `QLDYBGV8` |
| 8 | CIPCA/Rivero, *Políticas públicas e inversión agropecuaria* | `FUUH6385` | `554NE3YV` | misma URL = mismo doc; conservar 2018 (autora nombrada) |
| 9 | Colque et al., *Segunda Reforma Agraria* (2016) | `PFL6V682` (book) | `K7EDMXSA` (report) | **tipos distintos → Zotero no auto-detecta.** Conservar el *book* (citekey correcto `Colque2016`). Si el report no está citado en Word, eliminarlo; si lo está, cambiar su tipo a *book* y fusionar |
| 10 | Mogues et al., *The bang for the birr* | `KN3R49A8` (art. 2011) | `7UMCCEJQ` (WP IFPRI 2008) | **Decisión: consolidar a la versión publicada 2011.** Quitar el working paper 2008 |

**Efecto:** 324 → ~314 referencias. Resuelve además varias de las 14 entradas huérfanas del `references_master.bib` (ADR-0013): `mogues2011`, `simar_wilson1998` y otras eran variantes de estos duplicados.

---

## B. Correcciones de calidad — DOIs confirmados por CrossRef

| Key | Referencia | Acción | Valor a aplicar |
|-----|-----------|--------|-----------------|
| `IG35IPKB` | *Do irrigation programs make poor rural communities… less vulnerable…* (LAJED 2015) | añadir DOI | `10.35319/lajed.20152468` · verificar autores (CrossRef: Andersen, Cardona, Romero) |
| `6D3TZQIR` | *The Bolivian organic quinoa in the fairtrade market…* (2024) | añadir DOI | `10.56369/tsaes.5814` |
| `C5EUB3R2` | Bebbington, *Reinventing NGOs and rethinking alternatives in the Andes* (1997) | añadir DOI | `10.1177/0002716297554001008` |
| `VG4MYZLG` | *Evaluando el impacto de microcréditos en Bolivia…* (LAJED) | DOI + **año 2021→2015** + autores → Villarroel & Hernani-Limarino (hoy figura el nombre de la revista como autor) | `10.35319/lajed.20150377` |
| `ULVYUJEN` | Gasques et al., *Total factor productivity in Brazilian agriculture* | DOI + **añadir año 2012** + tipo report→capítulo de libro (CABI) | `10.1079/9781845939212.0145` |
| `YM3GRC9S` | *Reconfiguring agrarian relations through agroecology… Cochabamba* (2026) | DOI + **añadir autores** McKay & Catacora-Vargas (hoy sin autor) | `10.1080/21683565.2026.2617503` |

## B-bis. DOI candidato — VERIFICAR antes de aplicar

| Key | Referencia | Alerta |
|-----|-----------|--------|
| `E56SS5B8` | *Seguros agrícolas basados en índices climáticos: estudio de caso Bolivia* (2014) | CrossRef devuelve `10.23881/idupbo.014.1-1e` con **título idéntico pero otros autores/journal** (Nogales Carvajal vs. los Vidaurre/Lindenberg de la ficha). Podrían ser dos artículos distintos. **No aplicar sin confirmar** cuál es el correcto |

---

## C. Cambios de tipo (no son journalArticle, no llevan DOI)

| Key | Referencia | Acción |
|-----|-----------|--------|
| `CLWXMHNM` | *EMAPA, ¿cerrarla o transformarla?* (Bolpress) | tipo `journalArticle` → `blogPost`/`webpage`; revisar fecha (figura **2026-04**, dudosa) |
| `4SYVFQNY` | *Empresa Boliviana de Almendras: líder en comercio amazónico…* (Bolivia Emprende) | tipo `journalArticle` → `webpage`/`blogPost` |

---

## D. Sin DOI — legítimo, NO inventar

Referencias reales pero en revistas locales/pre-digitales o documentos de trabajo sin DOI. Dejar el campo DOI vacío; verificar que el `itemType` sea el correcto.

| Key | Referencia | Razón |
|-----|-----------|-------|
| `AQEXTD4Z` | Schejtman & Berdegué, *Desarrollo territorial rural* (2004) | documento de trabajo RIMISP — sin DOI de journal |
| `KMKZVT3I` | Albó, *El retorno del indio* (Revista Andina, 1991) | revista pre-digital |
| `MP369L6T` | Soruco, *…EMAPA* (Umbrales, 2012) | revista local CIDES-UMSA |
| `JPLM4QJN` | Vergara, *El experimento de EMAPA en Bolivia* (Nueva Sociedad, 2016) | revista sin DOI |
| `SSH4U5UK` | Wanderley, *Desafíos de la economía plural en Bolivia* (Tinkazos, 2014) | revista PIEB sin DOI |
| `Q6VGPZA6` | Fuglie & Wang, *Productivity growth in global agriculture shifting to developing countries* (Choices, 2013) | magazine AAEA — verificar; usualmente sin DOI |

### Caso 2 — verificación pendiente
`9AE4Q7DQ` tiene el DOI de Grisaffi pero autores **Brombacher & Maihold**. O es metadata corrupta (un dupe) o es una fuente Brombacher/Maihold real cargada con el DOI equivocado. Confirmar antes de fusionar para no perder una referencia válida.

---

## Pendiente tras ejecución
- [ ] Fusionar casos 1–8 en Zotero (usuario).
- [ ] Resolver casos 9–10 (Colque cross-type; Mogues consolidar a 2011).
- [ ] Aplicar DOIs §B y cambios de tipo §C.
- [ ] Verificar §B-bis y caso 2.
- [ ] Re-exportar grupo → `03_literature/references_master.bib` y reconciliar citekeys (JCM, lado repo).
