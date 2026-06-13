# 23 — Round-trip MS Word ↔ Repo canónico

**Documento vivo · v0.1.0 · 2026-06-13**
**Path canónico:** `.agent/23_WORD_ROUNDTRIP.md`
**Owner:** Juan Carlos Muñoz Mora (EAFIT, consultor BM)
**Aplica a:** ciclo de revisión del Banco Mundial / MEFP sobre `04_report/` cuando la revisión ocurre en Microsoft Word.

> **Por qué existe.** El Banco Mundial trabaja la edición editorial en **MS Word**. Este documento define cómo se publica el reporte en Word y cómo se reconcilia de vuelta al repo **sin romper los 7 invariantes** (especialmente 3.1 trazabilidad, 3.2 fuente única, 3.4 LLM-no-calcula). La regla de oro: **Word es capa de revisión de prosa; el repo es la fuente de verdad de toda cifra.**

---

## 1. Modelo: dos superficies, dos puentes

Claude Code (sobre el repo) y **Claude para Word** (add-in del Banco, GA mayo 2026) son **superficies distintas del mismo Claude**. No hay sincronización en vivo. La comunicación se logra por dos puentes complementarios:

| | Puente A — Contexto compartido (lógico) | Puente B — Round-trip de archivo (físico) |
|---|---|---|
| **Qué es** | Un *Claude Project / Claude for Work* del equipo BM con el **conector de GitHub** apuntando a `jcmunozmora/bolivia-wb-aper-2026` | Export `qmd → docx`, revisión en Word con *tracked changes*, ingest `docx → qmd` |
| **Para qué** | Que Claude-en-Word "vea" los `.qmd`, `04_HALLAZGOS.md`, contratos y gobernanza al asistir al revisor | Mover el contenido editable ida y vuelta entre Banco y repo |
| **Sincronía** | Asíncrona, *pull* bajo demanda (memoria común, no socket) | Asíncrona, por archivo, una pasada por ciclo |
| **Canal técnico** | Conector GitHub (MCP) en el espacio Claude for Work del Banco | `quarto render --to docx` + `pandoc --track-changes` + conector `Microsoft 365` (MCP) para SharePoint/OneDrive |

Ambos puentes se usan a la vez: A evita que el revisor invente cifras (Claude consulta el contrato del hallazgo); B mueve el documento.

---

## 2. Roles canónicos (no negociable)

| Superficie | Rol | Puede cambiar | NO puede cambiar |
|---|---|---|---|
| **Repo / Quarto (`04_report/*.qmd`)** | Fuente única de verdad | Cifras, figuras, estructura, citas, hallazgos, metodología | — |
| **Word (`.docx`)** | Capa de revisión BM/MEFP | **Prosa, redacción, comentarios, sugerencias de framing** | Cifras, figuras, citas, IDs de hallazgo |

**Corolario (Invariante 3.1 + 3.4):** una **cifra modificada en Word es un comentario, no una edición**. Se trata bajo el contrato de comentario MEFP (`00_MASTER_PROMPT` Parte 7.4) y solo entra al `.qmd` si se traza a panel v12 + script. Si no es trazable → dossier / nota de divergencia, **nunca** merge ciego.

---

## 3. Ciclo operativo

```
   ┌─────────────────────────────────────────────────────────────────┐
   │  REPO (canónico)                                                  │
   │  04_report/*.qmd  ──(1) quarto render --to docx──►  APER_2026.docx│
   └─────────────────────────────────────────────────────────────────┘
                    │ (2) Claude Code sube vía conector M365
                    ▼
        SharePoint/OneDrive del Banco
                    │
                    ▼  (3) Banco revisa en Word + add-in Claude
        APER_2026_revisado.docx  (tracked changes nativos: aceptar/rechazar)
                    │ (4) Claude Code baja vía conector M365
                    ▼
   ┌─────────────────────────────────────────────────────────────────┐
   │  (5) pandoc --track-changes=all  →  extrae inserciones/supresiones│
   │  (6) reconciliación: PROSA → .qmd ; CIFRA/CITA/FIGURA → dossier    │
   │  (7) re-render limpio → nuevo APER_2026.docx para el siguiente ciclo│
   └─────────────────────────────────────────────────────────────────┘
```

**Regla de un solo sentido por ciclo:** nunca se edita el mismo documento vivo en ambos lados a la vez. Cada ciclo el `.docx` se **regenera desde el `.qmd`** (los cross-refs, callouts, citas y figuras de Quarto no sobreviven el viaje redondo intactos).

---

## 4. Comandos canónicos

**Export (repo → Word):**
```bash
# Libro completo a un solo .docx con plantilla del Banco
quarto render 04_report --to docx
# (salida en 05_outputs/report/)

# Un capítulo aislado (útil cuando el libro completo no compila por RDS faltante)
quarto render 04_report/06_recommendations.qmd --to docx
```

**Ingest (Word → repo):** extraer los cambios marcados preservando aceptar/rechazar:
```bash
pandoc APER_2026_revisado.docx -o _ingest/revisado.md --track-changes=all
# --track-changes=all conserva <ins>/<del> + autor + fecha para reconciliar
# luego: diff de PROSA contra el .qmd; las cifras se aíslan al dossier
```

**Plantilla:** `04_report/style/reference-doc.docx` (estilos `Heading1–7`, `Title`, `BodyText`…). Personalización del Banco (navy `#14213D`, terracota `#C2410C`, tipografía) es un **one-time en Word** sobre ese archivo — ver §6.

**Conector Microsoft 365:** disponible vía MCP en sesiones Claude Code para subir/bajar el `.docx` a la carpeta SharePoint del Banco sin paso manual.

---

## 5. Clasificación del ciclo (semáforo `08_CONTROL`)

| Acción del ciclo Word | Clasificación |
|---|---|
| Export `.docx` y subida a SharePoint | 🟢 Verde |
| Ingest de cambios **solo de prosa** (typos, redacción, transiciones) | 🟢 Verde |
| Ingest que toca framing de política / neutralidad | 🟡 Amarillo (review interna) |
| Cualquier cambio de **cifra, cita, figura, hallazgo** sugerido en Word | 🔴 Rojo (contrato 7.4 + trazabilidad o nota de divergencia; **nunca** auto-merge) |

---

## 6. Checklist de merge-back (cada ingest)

1. `pandoc --track-changes=all` ejecutado; lista de `<ins>`/`<del>` por autor revisada.
2. Cada cambio clasificado: **prosa** vs **cifra/cita/figura/ID-hallazgo**.
3. Cambios de prosa: aplicados al `.qmd` correspondiente, preservando todo `TODO_TRACE` y `[@citekey]`.
4. Cambios de cifra: **NO** aplicados; registrados como comentario MEFP (7.4) → dossier; validados contra panel v12 antes de cualquier edición posterior.
5. Citas nuevas introducidas en Word: pasan gate §13B (solo `audit_status ∈ {green, yellow}`) antes de entrar.
6. Pre-flight anti-IA (`05_ESTILO_NARRATIVO §3.4`) sobre la prosa reconciliada.
7. Re-render limpio del `.docx` para el siguiente ciclo.
8. Bitácora en `00_admin/RETOMAR.md` + bump de versión si aplica.

---

## 7. Configuración inicial (one-time)

**Puente A — espacio Claude for Work del Banco:**
1. Crear un *Project* en el espacio Claude for Work (Team/Enterprise) del equipo BM Bolivia.
2. Añadir el **conector de GitHub** y seleccionar el repo `jcmunozmora/bolivia-wb-aper-2026` (rama de revisión, p. ej. `review/word`).
3. Adjuntar al *Project* los `.agent/00_MASTER_PROMPT.md`, `05_ESTILO_NARRATIVO.md`, `06_NEUTRALIDAD.md` y este doc como knowledge, para que el add-in respete los invariantes.

**Puente B — plantilla Word del Banco:**
1. Abrir `04_report/style/reference-doc.docx` en Word.
2. Modificar los **estilos** (no el texto): `Heading 1/2/3` → navy `#14213D`; acentos terracota `#C2410C`; cuerpo en la tipografía aprobada; logos WB en encabezado.
3. Guardar (mismo nombre) y commitear. Quarto lo usará en todo `--to docx`.

**Conector Microsoft 365:** autenticar una vez (`Microsoft 365` MCP) apuntando a la carpeta SharePoint del Banco donde vive el `.docx` de revisión.

---

## 8. Límites conocidos

- El add-in de Word es *document-aware* del archivo abierto; **no** sincroniza solo con el repo — el contexto del repo llega por el conector GitHub (Puente A), bajo demanda.
- Round-trip Quarto→Word→Quarto **degrada** cross-refs (`@fig-`, `@tbl-`), callouts y citas live: por eso el `.docx` es desechable y se regenera cada ciclo desde el `.qmd`.
- Las **figuras** viajan como imagen embebida; correcciones de figura se hacen en el script de `02_code/04_visualization/`, no en Word.
- Requiere **Claude for Work** (Team/Enterprise) + suscripción Microsoft 365 para los revisores del Banco.

---

## 9. Relación con otros docs

- `00_MASTER_PROMPT.md` Parte 3 (invariantes), Parte 7.4 (contrato comentario MEFP), Parte 9 (semáforo).
- `08_CONTROL.md` (clasificación de cambios), `09_AUDITORIA.md §13B` (gate de citas).
- `19_COMUNICACION.md` (mesa MEFP), `21_COORDINACION_STC.md` (insumos Hector que también llegan como cifra, no como prosa Word).
- Scripts operativos: `02_code/05_export/` (export/ingest — pendientes de crear, ver RETOMAR).
