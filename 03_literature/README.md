# `03_literature/` — Revisión Sistemática para APER 2026 Bolivia

**Última actualización:** 2026-05-23 (sesión 11 cerrada — auditoría + PDF recovery + promoción yellow→green)
**Estado:** ✅ **Corpus auditado al 100% · 250 fichas citables · 89 rojas bloqueadas por gate**
**Corpus:** **370 fichas markdown** (363 externas + 7 MDRyT) · **269 PDFs reales** (1.0 GB) · **359 entradas BibTeX únicas** en `references_master.bib`
**Auditoría:** [`_audit/AUDIT_REPORT.md`](_audit/AUDIT_REPORT.md) | [`_audit/RED_FLAGS.md`](_audit/RED_FLAGS.md) | [`_audit/_green_list_final.md`](_audit/_green_list_final.md)
**Protocolo:** PRISMA-adaptado · ver [`search_strategy.md`](search_strategy.md)
**Mapa de evidencia:** [`evidence_map.md`](evidence_map.md)
**Master prompt:** ver [`.agent/00_MASTER_PROMPT.md`](../.agent/00_MASTER_PROMPT.md) §7 (evidencia)
**Gate de citación:** ver [`.agent/09_AUDITORIA.md`](../.agent/09_AUDITORIA.md) §13B — sólo `audit_status ∈ {green, yellow}` son citables

## Estado final del corpus (post-Fase 3 + Carpeta 11 + PDF Recovery + Promoción)

| `audit_status` | # fichas | % | Citable en `04_report/`? |
|----------------|:-------:|:-:|:------------------------:|
| 🟢 `green` | **126** | **38%** | ✅ Sí — PDF leído y verificado |
| 🟡 `yellow` | 124 | 37% | ✅ Sí, con caveat — metadata OK, cifras pendientes verificar |
| 🔴 `red` | 89 | 27% | ❌ **NO — re-verificar contra PDF primero** |
| ⏳ `unverified` | 0 | 0% | — (todo auditado) |

### Progreso vs estado inicial

| | Antes recovery | Post-recovery + promoción | Δ |
|--|:----:|:----:|:----:|
| 🟢 green | 44 (13%) | **126 (38%)** | **+82** |
| 🟡 yellow | 212 (63%) | 124 (37%) | −88 |
| 🔴 red | 83 (24%) | 89 (27%) | +6 (PDFs detectados ≠ ficha) |
| PDFs reales | 186 | **269 (1.0 GB)** | **+83** |

> **Antes de citar cualquier ficha:** `grep "^audit_status:" 03_literature/<carpeta>/<citekey>.md`. Si es `red`: no citar, abrir PDF y re-verificar antes. Si es `yellow`: citar con cuidado, verificar cifra específica en el PDF si es importante para el reporte. Si es `green`: citar libremente.

### Cambios principales sesión 11

1. **Construcción del corpus** (10 agentes paralelos): 313 fichas iniciales en 10 carpetas temáticas
2. **Auditoría Fase 1** (estructural): 11 PDFs falsos en cuarentena, 0 huérfanos en cross-reference
3. **Auditoría Fase 2 + 3** (5 + 5 agentes leyeron PDFs): ~42% red, ~24% green, resto yellow
4. **Opción B** aplicada: §8 (citas verbatim fabricadas) eliminada de 289 fichas
5. **Carpeta 11 NUEVA** (Bolivia local + multilaterales): 46 fichas con protocolo estricto, **cero red**
   - Multilaterales: CAF, IICA, CAN, FAO Bolivia, IFAD, WFP, PNUD, UNODC, UE, AECID, COSUDE, GIZ-PROAGRO, GCF, GRUS, BIVICA
   - Bolivia local: INESAD, CEDLA, CIPCA, TIERRA, Milenio, IISEC-UCB, CEBEM, IBCE, CAO, AGRECOL, Solón, INE, BCB, UDAPE, EMAPA

---

## 0. Principio rector

> **Cero invención.** Cada cita en el APER 2026 debe corresponder a un documento real, descargable, verificable. La regla: si no hay PDF en `pdfs/` o URL pública estable, no puede citarse en el reporte. Cualquier afirmación que no esté respaldada por una ficha en este directorio se marca `[CITA NECESARIA]` en el reporte.

Esto se enforza vía el **gate de auditoría A2** ([`.agent/09_AUDITORIA.md`](../.agent/09_AUDITORIA.md)): cada `\cite{key}` en `04_report/` debe resolver a una entrada en `references_master.bib`.

---

## 1. Estructura del directorio

```
03_literature/
├── README.md                    ← este archivo (índice maestro)
├── search_strategy.md           ← protocolo PRISMA y cadenas de búsqueda
├── _template_external.md        ← template de ficha para literatura externa
├── references_master.bib        ← BibTeX consolidado (TODA la literatura)
├── evidence_map.md              ← mapa de evidencia consolidado
│
├── 01_systematic_reviews/       ← Nivel 1-2: meta-análisis y revisiones sistemáticas
├── 02_public_spending/          ← Gasto público agrícola (BM, BID, IFPRI, OECD)
├── 03_productivity_efficiency/  ← Productividad TFP, eficiencia DEA, Solow
├── 04_climate_food_security/    ← Cambio climático, seguridad alimentaria, resiliencia
├── 05_value_chains/             ← Soya, quinoa, coca, café, ganadería, oleaginosas
├── 06_smallholder_indigenous/   ← Agricultura familiar, pueblos indígenas, género rural
├── 07_subsidies_repurposing/    ← Subsidios distorsivos, repurposing global
├── 08_institutions_programs/    ← EMAPA, INIAF, BDP, Mi Riego, SENASAG, INRA
├── 09_methods_per_pse/          ← Metodología PER, PSE/OECD, MAFAP, DEA
├── 10_macro_growth_poverty/     ← Crecimiento rural, pobreza, Bolivia macro
│
├── pdfs/                        ← TODOS los PDFs (espejo de la estructura temática)
│   ├── 01_systematic_reviews/
│   ├── 02_public_spending/
│   └── ...
│
├── Informacion_PER/             ← Manuales PER (MAFAP, ejemplos Filipinas/SSA) ✓
└── mdryt_fichas/                ← Fichas MDRyT 2014-2024 (7 fichas creadas) ✓
```

### Convención de naming

- **Fichas:** `<citekey>.md` (e.g., `Mogues2011.md`, `WorldBank2024.md`)
- **PDFs:** `<citekey>.pdf` en `pdfs/<carpeta>/`
- **Citekey:** `LastnameYYYY` o `OrganizacionYYYY` (sin espacios, sin tildes)

---

## 2. Niveles de evidencia (jerarquía)

| Nivel | Tipo | Carpeta principal | Peso citacional |
|:-----:|------|-------------------|----------------|
| 1 | Meta-análisis | `01_systematic_reviews/` | ★★★★★ |
| 2 | Revisión sistemática narrativa | `01_systematic_reviews/` | ★★★★ |
| 3 | RCT | varia | ★★★★ |
| 4 | Cuasi-experimental (DiD, RDD, IV) | varia | ★★★ |
| 5 | Observacional Q1/Q2 | varia | ★★★ |
| 6 | Caso / cualitativo | varia | ★★ |
| 7 | Informe institucional | varia | ★★ |

---

## 3. Pregunta PICO de la revisión

| Elemento | Especificación |
|----------|---------------|
| **P**oblación | Sector agropecuario boliviano (1990-2024); LAC y países comparables como benchmarks |
| **I**ntervención | Gasto público agropecuario (transferencias, bienes públicos, I+D, subsidios, infraestructura, crédito subsidiado) |
| **C**omparador | Países de la región andina, países en desarrollo, contrafactual histórico |
| **O**utcome | Productividad (TFP, rendimientos), seguridad alimentaria, pobreza rural, resiliencia climática, eficiencia técnica |
| **S**tudy type | Meta-análisis, RCT, cuasi-experimental, DEA, descriptivo institucional |

---

## 4. Cobertura temática (sesión 11 — final)

| Tema | Carpeta | Fichas | PDFs | Tamaño | Estado |
|------|---------|:----:|:----:|:------:|:-----:|
| Revisiones sistemáticas y meta-análisis | `01_systematic_reviews/` | 23 | 20 | 87 MB | ✅ |
| Gasto público agrícola (BM/BID/IFPRI/OECD) | `02_public_spending/` | 34 | 21 | 34 MB | ✅ |
| Productividad y eficiencia técnica | `03_productivity_efficiency/` | 33 | 17 | 28 MB | ✅ |
| Cambio climático y seguridad alimentaria | `04_climate_food_security/` | 33 | 11 | 49 MB | ✅ |
| Cadenas de valor (quinoa, soya, coca, etc.) | `05_value_chains/` | 34 | 1 | 2 MB | 🟡 (poco PDF, mucha URL) |
| Pequeña agricultura e indígena | `06_smallholder_indigenous/` | 29 | 14 | 29 MB | ✅ |
| Subsidios y repurposing | `07_subsidies_repurposing/` | 39 | 10 | 61 MB | ✅ |
| Programas e instituciones bolivianas | `08_institutions_programs/` | 32 | 17 | 41 MB | ✅ |
| Métodos PER/PSE/MAFAP/DEA | `09_methods_per_pse/` | 37 | 23 | 84 MB | ✅ |
| Macro, crecimiento, pobreza Bolivia | `10_macro_growth_poverty/` | 23 | 15 | 21 MB | ✅ |
| MDRyT (Bolivia institucional, sesión previa) | `mdryt_fichas/` | 7 | 10 | — | ✅ |
| Manuales PER (MAFAP, ejemplos) | `Informacion_PER/` | 1 | 4 | — | ✅ |
| **TOTAL** | | **325** | **163** | **434 MB** | ✅ |

> **Lectura del estado:**
> - ✅ Corpus base completado (≥20 fichas por carpeta y BibTeX consolidado).
> - 🟡 `05_value_chains/` tiene cobertura amplia de fichas pero pocos PDFs descargados (paywalls Wiley/Elsevier). Las URLs están verificadas en cada ficha.
> - Cifras dentro de las fichas marcadas `[TBV]` (to be verified) requieren cotejo humano contra el PDF antes de citarse en el reporte final.

---

## 5. Reglas de citación en el reporte

### En `04_report/*.qmd`

```markdown
[@AuthorYYYY] dice que ...

(versus)

[@AuthorYYYY, p. 23] muestra que ...
```

### Para múltiples citas

```markdown
La evidencia consistente [@AuthorA2020; @AuthorB2021; @AuthorC2023] sugiere ...
```

### Citas institucionales

```markdown
[@WorldBank2024] / [@CEPAL2023] / [@FAO2022]
```

### Si el dato es del panel v12

NO se cita literatura — se cita el panel:

```markdown
La participación de transferencias en el gasto agrícola público alcanzó 62% en 2018-2023 (cálculo propio, panel v12; ver `02_INDICADORES.md`).
```

---

## 6. Flujo de incorporación de un nuevo documento

```
1. Identificar referencia (búsqueda sistemática o snowballing)
2. Añadir el ítem al grupo Zotero WB-APER-Bolivia (group 6586554) ← fuente upstream de metadata
3. Verificar acceso (DOI, URL público, repositorio institucional)
4. Descargar PDF → pdfs/<carpeta>/<citekey>.pdf
5. Crear ficha → <carpeta>/<citekey>.md (usar _template_external.md) ← aquí vive audit_status
6. Materializar entrada en references_master.bib (export desde Zotero; citekey = llave de empalme)
7. Si genera hallazgo nuevo → registrar en .agent/04_HALLAZGOS.md
8. Si cambia método → registrar ADR en .agent/decisions/
```

> **Zotero ↔ bib (ver [`ADR-0013`](../.agent/decisions/ADR-0013_zotero_fuente_canonica_bibliografia.md)).** El grupo Zotero `WB-APER-Bolivia` (group ID `6586554`) es la **fuente upstream canónica** de la metadata bibliográfica; `references_master.bib` es su export versionado. Los agentes lo consultan vía MCP (`.mcp.json` en la raíz, API local, sin API key). **Zotero aporta metadata, no auditoría:** el `audit_status` (verde/amarillo/rojo) vive en la ficha `.md` y es lo que rige el gate de citación §13B — un ítem en Zotero sin ficha auditada **no es citable**.

---

## 7. Reportes Wayback / repositorios institucionales

Si el PDF no se puede descargar directamente, intentar en orden:

1. **Wayback Machine:** `http://web.archive.org/web/*/<URL_origen>` (usar HTTP)
2. **Repositorios académicos:** SSRN, RePEC, NBER, IZA
3. **Repositorios institucionales:**
   - World Bank Open Knowledge: `https://openknowledge.worldbank.org/`
   - IDB Publications: `https://publications.iadb.org/`
   - FAO Repository: `https://www.fao.org/publications/`
   - CEPAL Digital: `https://repositorio.cepal.org/`
   - IFPRI: `https://www.ifpri.org/publications/`
   - OECD iLibrary: `https://www.oecd-ilibrary.org/`
4. **Última opción:** marcar `pdf_downloaded: unavailable` en el frontmatter + abrir issue para solicitud formal al MDRyT/MEFP/INE.

---

## 8. Auditoría del corpus

Comando de auditoría rápida (correr antes de cada release del reporte):

```bash
# Cuenta fichas, PDFs y entradas BibTeX
find 03_literature -name "*.md" -not -name "_*" -not -name "README*" | wc -l
find 03_literature/pdfs -name "*.pdf" | wc -l
grep -c "^@" 03_literature/references_master.bib

# Citas huérfanas en el reporte (citas sin ficha)
grep -rohE '@[A-Za-z]+[0-9]{4}' 04_report/*.qmd | sort -u > /tmp/cites_in_report.txt
grep -hE '^@[a-z]+\{[A-Za-z]+[0-9]{4}' 03_literature/references_master.bib | \
  sed -E 's/^@[a-z]+\{([A-Za-z]+[0-9]{4}).*/@\1/' | sort -u > /tmp/cites_in_bib.txt
comm -23 /tmp/cites_in_report.txt /tmp/cites_in_bib.txt  # → citas huérfanas
```

---

## 9. Próximos pasos al cierre sesión 11

1. **Completar fichas y PDFs** para los 10 temas (ver inventario §4)
2. **Generar `references_master.bib` consolidado** (~150-250 entradas esperadas)
3. **Cruzar literatura ↔ hallazgos F01-F08** en `.agent/04_HALLAZGOS.md`
4. **Activar `/write-section`** para Cap 1 (contexto sectorial), que es el más dependiente de literatura externa

---

*Mantenido por: equipo APER · Última revisión humana: pendiente · Validación cruzada con `.agent/04_HALLAZGOS.md`: pendiente*
