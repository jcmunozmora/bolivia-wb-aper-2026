# ADR-0013 — Zotero (grupo WB-APER-Bolivia) como fuente upstream canónica de la bibliografía

**Estado:** propuesto (pendiente revisión equipo APER)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: visto bueno equipo APER · firma TTL opcional — cambio amarillo, no toca cifras del panel]_
**Color de cambio:** amarillo (infraestructura de reproducibilidad + gobernanza de la cadena de evidencia; **no** modifica cifras del panel, hallazgos, ni metodología de cálculo)
**Lecturas relacionadas:** [`03_literature/README.md`](../../03_literature/README.md) §6 (flujo de incorporación), [`.agent/03_FUENTES.md`](../03_FUENTES.md) §4 (literatura y manuales), [`.agent/09_AUDITORIA.md`](../09_AUDITORIA.md) §13B (gate de citación), [`.mcp.json`](../../.mcp.json).

---

## Contexto

La bibliografía del APER 2026 se materializa en dos archivos BibTeX:

| Archivo | Entradas | Rol |
|---|---|:--:|
| `03_literature/references_master.bib` | 359 | Master del corpus auditado (una entrada por ficha) |
| `04_report/references.bib` | 373 | Bibliografía que **consume Quarto** (`_quarto.yml: bibliography: references.bib`) |

Hasta ahora ambos `.bib` se mantenían **a mano**: cada documento nuevo se ingresaba siguiendo el flujo de 7 pasos de `03_literature/README.md` §6, editando el `.bib` directamente. No existía una **fuente upstream declarada** de la metadata bibliográfica, lo que dificulta: (a) detectar duplicados/inconsistencias de citekey, (b) reconstruir el `.bib` de forma reproducible, y (c) que los agentes LLM consulten la metadata real de un documento sin abrir el PDF.

Existe ya un **grupo de trabajo Zotero compartido** que centraliza esa metadata:

```text
nombre   : WB-APER-Bolivia
group ID : 6586554
items    : 366 (incluye guías metodológicas MAFAP Vol. I/II, libro de repurposing FAO/IFPRI/WB, etc.)
acceso   : biblioteca de grupo, sincronizada localmente en la app Zotero del equipo
```

El conteo (366 ítems Zotero ≈ 359 entradas master) confirma que el grupo y el `.bib` describen el **mismo corpus**, con una pequeña divergencia operativa (ver Consecuencias).

## Decisión

1. **El grupo Zotero `WB-APER-Bolivia` (`6586554`) es la fuente upstream canónica de la metadata bibliográfica.** `references_master.bib` se trata como un **export materializado** de ese grupo, no como fuente primaria editada a mano. El orden de verdad es:

   ```
   Zotero grupo 6586554  ──export──►  03_literature/references_master.bib  ──►  04_report/references.bib  ──►  Quarto (citas [@key])
   (metadata canónica)                (corpus auditado, 1 ficha = 1 entrada)     (bib que renderiza el book)
   ```

   El `references_master.bib` sigue siendo el artefacto **versionado en git** y el que gobierna el gate de citación §13B (`audit_status` vive en la ficha `.md`, no en Zotero). Zotero aporta la metadata limpia; la **auditoría (verde/amarillo/rojo) y la trazabilidad de cifras siguen viviendo en las fichas markdown** y son las que mandan para citar.

2. **Los agentes acceden a Zotero en tiempo de ejecución vía MCP de scope proyecto.** Se versiona [`.mcp.json`](../../.mcp.json) en la raíz del repo apuntando el servidor `zotero-mcp` al grupo:

   ```json
   { "mcpServers": { "zotero": { "type": "stdio", "command": "uvx", "args": ["zotero-mcp"],
     "env": { "ZOTERO_LOCAL": "true", "ZOTERO_LIBRARY_TYPE": "group", "ZOTERO_LIBRARY_ID": "6586554" } } } }
   ```

   - Usa la **API local** de la app Zotero (`localhost:23119`): **no requiere API key** → no hay secretos en el repo, seguro de commitear (invariante de confidencialidad respetado).
   - Es scope **proyecto**: sobreescribe el server `zotero` global (que leía la biblioteca personal) **solo** dentro de este repo; otros proyectos del usuario no se ven afectados.
   - Requisito de runtime: la app Zotero de escritorio debe estar **abierta y sincronizada** con el grupo.

3. **El citekey es la llave de empalme** entre las tres capas (Zotero → master → report → `.qmd`). Convención sin cambios respecto a README §«Convención de naming»: `LastnameYYYY` / `OrganizacionYYYY`, sin espacios ni tildes.

4. **Zotero NO reemplaza la auditoría.** Que un ítem exista en el grupo no lo vuelve citable: sigue rigiendo el gate §13B (sólo `audit_status ∈ {green, yellow}`). Zotero es la capa de **metadata**; la ficha `.md` es la capa de **evidencia auditada**. Un ítem en Zotero sin ficha auditada es **no citable**.

## Consecuencias

**Positivas:**
- Fuente upstream única y reproducible: `references_master.bib` deja de ser un artefacto huérfano editado a mano y pasa a ser un export reconstruible del grupo.
- Los agentes pueden resolver metadata real (`mcp__zotero__zotero_search_items` / `zotero_item_metadata` / `zotero_item_fulltext`) sin abrir PDFs, reduciendo riesgo de inventar referencias (refuerza el principio de cero invención).
- Sin secretos en el repo (API local).

**Negativas / limitaciones declaradas:**
- **Dependencia de runtime local:** el MCP sólo funciona con la app Zotero abierta y el grupo sincronizado en la máquina del operador. En entornos headless/CI el MCP no resuelve; ahí se usa el `.bib` versionado, que es y seguirá siendo la fuente de verdad para el render.
- **El export Zotero→`.bib` aún no está automatizado** (no hay script `02_code/.../export_bib.R` ni hook). Por ahora la materialización sigue siendo manual; este ADR declara la *dirección de verdad*, no automatiza el pipeline todavía.
- Zotero no almacena `audit_status` — ese campo es exclusivo de la ficha `.md`. La auditoría no migra a Zotero.

## Divergencias detectadas (2026-06-14) — a reconciliar

Auditoría rápida de los dos `.bib` al crear este ADR:

- `04_report/references.bib` (373) **⊇** `references_master.bib` (359): contiene **todas** las del master **+ 14 entradas extra**.
- Esas 14 (`cepal2023`, `fan2000`, `fao2022`, `ifpri2019`, `iica2022`, `Laborde2021_GHG`, `Ley393_2014`, `mogues2011`, `oecd_pse_manual`, `Searchinger2019_WRI`, `simar_wilson1998`, `valdes2010`, `worldbank_per_manual`, `worldbank2020`) están en el bib que renderiza el reporte **pero no en el corpus auditado** (sin ficha, sin `audit_status`).
- **Citas huérfanas: 0** — las 53 citas `[@key]` realmente usadas en `04_report/*.qmd` resuelven todas en `references.bib` (el book compila sin `?`).

> El riesgo no es de render, es de **gobernanza**: hay 14 entradas citables que esquivan el gate §13B. Algunas son legítimamente metodológicas/legales (`oecd_pse_manual`, `worldbank_per_manual`, `Ley393_2014`) y otras parecen placeholders en minúscula que duplican fichas existentes con otro citekey.

## Pendientes

- [ ] Reconciliar las 14 entradas extra: para cada una, (a) crear ficha + `audit_status` en `03_literature/`, o (b) confirmar que es manual/ley/metodología exenta y documentarla como tal, o (c) mapearla al citekey canónico ya auditado si es duplicado.
- [ ] Registrar el grupo Zotero `6586554` como fuente en `.agent/03_FUENTES.md` §4 y en `00_admin/ESTADO_DE_DATOS.md`.
- [ ] (Futuro) Automatizar el export Zotero→`references_master.bib` con un script reproducible (Better BibTeX o `zotero-mcp` → `.bib`) y un hook que falle si master y report divergen fuera de la lista blanca metodológica.
- [ ] Visto bueno del equipo APER (cambio amarillo; firma TTL no obligatoria).
