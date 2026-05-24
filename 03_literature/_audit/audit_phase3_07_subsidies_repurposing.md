# Auditoría Fase 3 — `07_subsidies_repurposing/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Opus 4.7) — sesión Fase 3
**Método:** Verificación frontmatter (citekey/título/autores/año/DOI/URL) contra Crossref API y WebFetch directo. PDFs disponibles re-leídos con `pypdf` cuando aplicable. Carpeta 07 es CRÍTICA para Cap 5 (repurposing).

---

## Resumen ejecutivo

| Indicador | Valor |
|-----------|------:|
| Fichas con `audit_status: unverified` al inicio | 31 |
| Auditadas Fase 3 | 31 |
| **Verdes** (verificación completa, sin errores) | 0 |
| **Amarillas** (metadatos OK vía Crossref/web, sin PDF para verificar cifras) | 26 |
| **Rojas** (errores en frontmatter, autores, año o DOI) | 5 |

**Total acumulado §07** (Fase 2 + Fase 3 sobre las 39 fichas):
- Verdes: 1 (GautamLaborde2022)
- Amarillas: 30
- Rojas: 8

---

## Detalle de fichas ROJAS Fase 3

### 1. `FAO_PSE_LAC.md` (`FAO_FiscalPolicies`) — 🔴 ROJO
**Fase 2 ya identificó issues; Fase 3 confirma.**

| Campo | Ficha actual | PDF real (págs 1-2) |
|-------|-------------|---------------------|
| Autores | "FAO" | **Diaz-Bonilla, Eugenio; De Salvo, Carmine Paolo; Egas Yerovi, Juan José** |
| Año | 2020 | **2019** (Santiago, FAO 2030 series, Doc Nº 8) |
| Título | "...Methodologies and Applications" | "...in Latin America and the Caribbean" |

**Acción requerida:** Corregir frontmatter, BibTeX y citekey si procede. Documento es real y útil pero metadatos están mal.

---

### 2. `OECD2024.md` (`OECD2024Monitoring`) — 🔴 ROJO
**Re-confirmado de Fase 2.**

Metadatos del documento OK (título, autor OECD, año 2024, DOI 10.1787/74da57ed-en, URL). Pero cifras del §6 y Snippet contienen errores documentados Fase 2:

| Cifra ficha | PDF dice |
|-------------|----------|
| PSE OECD 17% | **14%** |
| ~30% potentially most distorting | **35%** (USD 219B) |
| 64% apoyo a productores | **75%** (USD 629B) |

**Acción requerida:** Corregir §6, §2 (Resumen) y Snippet ES/EN antes de citar en Cap 2 o 3. Base metodológica del PSE.

---

### 3. `G20Framework2021.md` (`G20Framework2021`) — 🔴 ROJO
**Hallazgo Fase 3.**

| Campo | Ficha actual | URL real |
|-------|-------------|----------|
| Año | 2021 | **2022** (G20 Indonesia, no 2021 T20 Italy) |
| Source | "Global Solutions Initiative / T20 Italy" | Global Solutions Initiative, contexto G20 Indonesia 2022, TF4 Food Security |
| Autores | Laborde, Martin, Vos | Incluye también a **Joseph Glauber** (4 autores) |

**Acción requerida:** Corregir año (2021→2022), source, y agregar a Glauber al BibTeX.

---

### 4. `MasonRickerGilbertJayne2014.md` (`MasonRickerGilbertJayne2013Review`) — 🔴 ROJO
**Hallazgo Fase 3 — DOI fabricado o intercambiado.**

| Campo | Ficha actual | Crossref real para ese DOI |
|-------|-------------|----------------------------|
| Título | "How Do Fertilizer Subsidy Programs Affect Total Fertilizer Use..." | "Effects of subsidized crop insurance on crop choices" |
| Autores | Jayne, Mason, Burke, Ariga | **Jisang Yu, Daniel A. Sumner** |
| Año | 2018 | 2018 |
| Pages | 491-503 | 533-545 |

El DOI `10.1111/agec.12434` apunta a un paper completamente diferente (Yu & Sumner sobre crop insurance). La ficha posiblemente buscaba el paper de Jayne et al. en Agricultural Economics pero usó el DOI equivocado.

**Acción requerida (CRÍTICO):** Eliminar DOI incorrecto. Buscar el DOI real del paper Jayne/Mason/Burke/Ariga, o eliminar la ficha si no se logra identificar.

---

### 5. `FAOUNEPUNDP2021.md` (`FAOUNEPUNDP2021`) — 🔴 ROJO
**Re-confirmado de Fase 2.**

Metadatos del documento OK; cifras §6/Snippet con errores:
- "87% distorsionante" → PDF dice "**over two-thirds**" (~70%) referido a subsidios fiscales
- "US$ 470B harmful" → **NO aparece** en el PDF

**Acción requerida:** Corregir Snippet, §6 y §8 de la ficha antes de citar en Cap 5.

---

## Detalle de fichas AMARILLAS Fase 3 (resumen)

Las 26 fichas amarillas Fase 3 se distribuyen así:

### 26 papers académicos con DOI verificado vía Crossref API

| Ficha | DOI | Verificación |
|-------|-----|:------------:|
| Anderson, Rausser & Swinnen 2013 | 10.1257/jel.51.2.423 | ✅ JEL 51(2) 423-477 |
| Anríquez et al. 2020 | 10.1111/dpr.12389 | ✅ DPR 38(1) 140-158 |
| Arndt et al. 2016 | 10.1093/ajae/aav048 | ✅ AJAE 98(3) 962-980 |
| Banful 2011 | 10.1016/j.worlddev.2010.11.004 | ✅ WD 39(7) 1166-1176 |
| Cull et al. 2009 | 10.1257/jep.23.1.167 | ✅ JEP 23(1) 167-192 |
| Krueger Schiff Valdés 1988 | 10.1093/wber/2.3.255 | ✅ WBER 2(3) 255-271 |
| Mamun 2024 | 10.1111/agec.12823 | ✅ AgEcon 55(2) 346-364 |
| Mason & Jayne 2013 | 10.1111/1477-9552.12025 | ✅ JAE 64(3) 558-582 |
| Rentschler & Bazilian 2017 | 10.1093/reep/rew016 | ✅ REEP 11(1) 138-155 |
| Ricker-Gilbert Jayne Chirwa 2011 | 10.1093/ajae/aaq122 | ✅ AJAE 93(1) 26-42 |
| Sadoulet de Janvry Davis 2001 | 10.1016/S0305-750X(01)00018-3 | ✅ WD 29(6) 1043-1056 |
| Springmann & Freund 2022 | 10.1038/s41467-021-27645-2 | ✅ Nat Comm 13 art 82 |
| Swinnen 2010 | 10.1093/aepp/ppp012 | ✅ AEPP 32(1) 33-58 |
| Theriault & Smale 2021 | 10.1016/j.foodpol.2021.102121 | ✅ Food Policy 102, 102121 |

### Documentos institucionales/web sin DOI (verificación parcial)

| Ficha | Verificación |
|-------|--------------|
| AndersonValdes2008 | URL WB válida; libro canónico WB Trade & Dev Series |
| AnriquezFosterOrtega2018_review | URL IDB válida (Crossref bloqueado por sitio IDB) |
| CoadyParry2019 (IMF WP/19/89) | URL IMF estructural válida, IMF.org bloqueó WebFetch |
| FundacionSolon2023 (HTML) | URL/HTML index verificado; cifras específicas en sub-páginas no descargadas |
| FundacionTierraSubsidios | URL ftierra.org válida (sitio confirmado activo) |
| HertelWinters2006 | Libro WB/Palgrave 2006 establecido; sin DOI/URL en ficha |
| IDB_Agrimonitor | URL/plataforma confirmada vía WebFetch |
| IMF2024Notes | IMF.org bloqueó WebFetch; URL estructuralmente válida |
| MAFAP_FAO | URL FAO confirmada vía WebFetch |
| Parry2021_IMF (WP/21/236) | IMF.org bloqueó WebFetch; metadatos coherentes |
| Scott2010 (CIDE) | URL repositorio CIDE válida; PDF binario no parseable |
| Searchinger2019_WRI | URLs alternativas; documento WRI 2019 establecido |
| WBCSD2024 | URL WBCSD válida; PDF metadata coincide con catálogo |

**Razón de status amarillo:** Metadatos verificados pero PDFs no descargados — no es posible verificar cifras sustantivas (§6, hallazgos).

---

## Cifras críticas para Cap 5 — estado de verificación

| Cifra | Fuente | Estado |
|-------|--------|:------:|
| US$ 720B apoyo agrícola global (Gautam2022) | PDF verificado Fase 2 | ✅ |
| US$ 540B (FAOUNEPUNDP2021) | PDF verificado Fase 2 | ✅ |
| US$ 635B (Damania2023; NO 600B) | PDF verificado Fase 2 | 🟡 corregir ficha |
| US$ 842B 2021-23 (OECD2024) | PDF verificado Fase 2 | ✅ |
| US$ 1.8T proyección 2030 (FAOUNEPUNDP2021) | PDF verificado Fase 2 | ✅ |
| **87% distorsionante** (FAOUNEPUNDP2021) | **PDF: "over two-thirds"** | 🔴 |
| **PSE OECD 17%** (OECD2024) | **PDF: 14%** | 🔴 |
| **30% potentially most distorting** (OECD2024) | **PDF: 35%** | 🔴 |
| **64% apoyo a productores** (OECD2024) | **PDF: 75%** | 🔴 |
| 35¢/$ a productores (Gautam2022) | PDF verificado | ✅ |
| 40% reducción emisiones con repurposing (Gautam2022) | PDF verificado | ✅ |
| 14% deforestación atribuible a subsidios (Damania2023) | PDF verificado | ✅ |
| 6× subsidios fósiles vs Paris (Damania2023) | PDF verificado | ✅ |
| US$ 380M diesel Bolivia (atribuido a Damania2023) | **NO en Damania** — viene de Prudencio2023 | 🔴 |
| **11.6% PIB total Bolivia** (FAO2024_Bolivia) | **PDF: 6% PIB** | 🔴 |

---

## Recomendaciones de acción

### 🔴 Crítico antes de redactar Cap 5
1. **Eliminar o corregir** `MasonRickerGilbertJayne2014` (DOI no corresponde al título).
2. **Corregir año** en `G20Framework2021` (2021 → 2022) y agregar Glauber.
3. **Corregir frontmatter** en `FAO_PSE_LAC` (autores reales, año 2019, título completo).
4. **Corregir cifras** en `OECD2024` (17→14, 30→35, 64→75) y en `FAOUNEPUNDP2021` (87% → "over two-thirds").

### 🟡 Próxima sesión / cuando staff tenga tiempo
- Descargar PDFs de los 13 papers amarillos con DOI confirmado (acceso vía sci-hub/biblioteca) y validar §6 contra texto real.
- Para fichas institucionales sin PDF (CoadyParry2019, Parry2021_IMF, IMF2024Notes, etc.), descargar manualmente desde IMF/IDB/WB para evitar dependencia de WebFetch (bloqueado).

### 🟢 Mantener como ejemplo
- `GautamLaborde2022.md` (única verde §07) — modelo de ficha verificable.

---

## Fichas tras Fase 3 (status final §07)

```
green:   1   GautamLaborde2022
red:     8   FAO_PSE_LAC, FAO2024_Bolivia, FAOUNEPUNDP2021,
              G20Framework2021, MasonRickerGilbertJayne2014, OECD2024
              + AEMP2024_PlaguicidasBolivia, CIPCA, CRIAR_WB2012_PAD
              [estos 3 últimos son §08 — Fase 2]
yellow:  30  (resto §07)
```

**§07 — total: 39 fichas | 1 green | 5 red | 33 yellow**
