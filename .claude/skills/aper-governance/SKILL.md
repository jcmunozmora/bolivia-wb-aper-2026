---
name: aper-governance
description: Activar cuando se trabaja sobre cualquier archivo del repo APER Bolivia 2026 (`04_report/`, `02_code/`, `.agent/`, `01_data/processed/`, slides/, www/) o cuando el usuario pregunta sobre el reporte, los hallazgos, la metodología, las invariantes, los gates de auditoría o los hooks. Carga el contexto canónico de gobernanza para que cualquier acción respete los 7 invariantes y el plan de capítulo. Skip si la tarea es ajena al APER (otros proyectos en el mismo workspace, ediciones a archivos personales del user, etc.).
---

# Gobernanza del APER Bolivia 2026 — contexto operativo

## Identidad del proyecto

Estás trabajando en el **Agricultural Public Expenditure Review (APER) Bolivia 2026**, un reporte técnico del Banco Mundial que actualiza el WB Informe N° 59696-BO (2011) con datos 1990–2024. Producto principal de la consultoría EAFIT–BM Bolivia (consultor: Juan Carlos Muñoz Mora, coordinación BM: Héctor Peña).

**El producto NO es:** advocacy, juicio político, plan de gobierno, paper académico.
**El producto SÍ es:** evidencia técnica reproducible para que el MEFP, con el WB, evalúe opciones de repurposing del gasto agrícola.

## Los 7 invariantes (no negociables)

1. **Trazabilidad cuantitativa** — toda cifra → `rds_path`, `script_path`, `variable`, `filter`, `period`, `raw_source`. Sin trace = `TODO_TRACE`, no se publica.
2. **Single source of truth** — panel v12 (`01_data/processed/spending_panel_v12.rds`). No v1/v10/v11.
3. **Neutralidad técnica** — vocabulario prohibido en `.agent/06_NEUTRALIDAD.md` (frases advocacy, imperativos, nombres políticos).
4. **LLM-as-writer-not-calculator** — no inventar cifras, no "recordar" benchmarks de literatura, no calcular promedios mentalmente.
5. **Bilingual parity** — ES y EN donde aplica (executive summary, slides, web).
6. **Versionamiento** — cambios sustantivos = bump (`panel_version`, `methodology_version`, `findings_version`) + ADR si rojo.
7. **Reproducibilidad** — `renv::restore() && quarto render` debe producir el book sin intervención manual.

## Mapa de gobernanza (`.agent/` — 20 docs numerados)

| Doc | Función | Cuándo consultarlo |
|-----|---------|---------------------|
| **00_MASTER_PROMPT** | Fuente única editorial. Identidad + invariantes + arquitectura + plan sección×sección + contratos JSON + gates | Antes de cualquier acción sustantiva |
| **01_METODOLOGIA** | Definiciones operativas, fórmulas, marcos OECD-PSE/FAO-MAFAP, cobertura sectorial | Para entender cómo se calcula una cifra |
| **02_INDICADORES** | Diccionario panel v12 (176 vars) | Para verificar una variable existe |
| **03_FUENTES** | Inventario fuentes crudas + licencias | Para verificar una fuente |
| **04_HALLAZGOS** | 8 findings F01–F08 con contrato JSON, ciclo de vida draft→reviewed→MEFP_validated | Para citar un finding |
| **05_ESTILO_NARRATIVO** | TEEL + superestructura WB + filtro anti-IA | Antes de redactar prosa |
| **06_NEUTRALIDAD** | Vocabulario permitido/prohibido | Al redactar/auditar |
| **07_FIGURAS** | Paleta, tipografía, grid, contratos de figura | Al generar/editar figuras |
| **08_CONTROL** | Semáforo verde/amarillo/rojo + ADRs | Antes de hacer un cambio sustantivo |
| **09_AUDITORIA** | Gates A1–A6, G1–G7, §13B gate literatura | Antes de marcar como reviewed |
| **10_RIESGOS, 11_EQUIPO, 12_REPRODUCIBILIDAD, 13_PUBLICACION, 14_CONFIDENCIALIDAD, 15_SEGURIDAD, 16_INCIDENTES, 17_GIT_WORKFLOW, 18_ONBOARDING, 19_COMUNICACION, 20_CONTENIDO_REPORTE** | Operativos por dominio | Consulta puntual |

## Catálogo de hallazgos (memorizar IDs)

| ID | Tema | Cifra clave | Cap casa |
|----|------|-------------|:--:|
| F01 | Inversión ×10 vs TFP estancada | TFP +30% / Inv ×10 (2000–2015) | 2 |
| F02 | PSE Bolivia en LAC | 5.8% (5° puesto) | 5 |
| F03 | Patrón dual NRP | Soya −37% / Maíz +46% | 5 |
| F04 | Maputo nunca alcanzado | máx 3.48% (1990) | 3 |
| F05 | Sustitución gasto → crédito | ×11.7 (2010–2024), Ley 393 | 3 |
| F06 | Pobreza rural revierte | 55→40→45% (2012–2024) | 2 |
| F07 | PAR III subejecutado | 16% financiero 2024 | 4 |
| F08 | Frontera agropecuaria | 9.4 M ha / 64% Santa Cruz | 2 |

## Datasets canónicos (única fuente)

```
01_data/processed/spending_panel_v12.rds          ← PANEL MAESTRO (176 vars, 1990–2024)
01_data/processed/spending_panel_v12_dictionary.csv
01_data/processed/panel_subnacional_v2.rds         (9 depts × 2012–2021)
01_data/processed/panel_municipal_v3.rds           (339 munis × 2013–2023)
01_data/processed/dea_dataset.rds                  (81 DMUs × 32 vars)
01_data/processed/pse_gsse_bolivia.rds             (2006–2023)
01_data/processed/pse_nrp_extended.rds             (1991–2024 × 7 commodities)
01_data/processed/idb_agrimonitor_lac_full.rds     (1986–2024 × 10 LAC)
01_data/processed/mafap_categories.csv             (33 códigos MAFAP bilingües)
```

## Clasificación dual del gasto (decisión metodológica m0.1.0)

- **MAFAP/FAO** → Caps 3-4 (presupuestos + subnacional)
- **PSE/OECD-BID** → Cap 5 (análisis)
- **Crosswalk** documentado en Apéndice B

## Si vas a escribir prosa

Carga también el skill `aper-writing`. Ese te da TEEL + WB voice + filtro anti-IA en detalle.

## Si vas a auditar

Carga también el skill `aper-audit`. Ese te da los checklists A1–A6 + G1–G7.

## Si encuentras conflicto entre instrucciones

Orden de prioridad (de MASTER_PROMPT Parte 16):
1. Trazabilidad cuantitativa (§3.1) + fuente única (§3.2)
2. Neutralidad técnica (§3.3)
3. LLM como redactor, no calculador (§3.4)
4. Reproducibilidad (§3.7)
5. Paridad bilingüe (§3.5)
6. Versionamiento (§3.6)
7. Estructura aprobada del Quarto book
8. Estilo editorial WB
9. Preferencias visuales

## Acciones automatizadas disponibles

| Slash command | Función |
|---------------|---------|
| `/write-section <NN>` | Carga contexto + delega a `aper-writer` para redactar |
| `/audit-chapter <NN>` | Corre los 3 auditores (general, trace, citation) en paralelo |
| `/check-trace <path>` | Solo trazabilidad cuantitativa |
| `/check-citations <path>` | Solo gate §13B literatura |
| `/new-finding F<NN>` | Scaffold de un finding con contrato JSON |
| `/close-session` | Genera bloque Parte 15 → RETOMAR |
| `/commit-push` | Commit estructurado + push con safeguards |

## Hooks activos (no se desactivan)

- **PreToolUse Edit/Write a `04_report/*.qmd`**: `validate-qmd-edit.sh` (neutralidad, panel version), `validate-citations.sh` (gate §13B). Pueden BLOQUEAR.
- **PostToolUse Edit/Write a `.agent/*.md` o panel dictionary**: `governance-zone-warn.sh` (recordatorio ROJO + ADR).
- **Stop**: `session-close-prompt.sh` (recordar update RETOMAR), `git-commit-push-status.sh` (estado git).
