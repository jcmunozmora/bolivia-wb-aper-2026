---
description: Arranca la redacción de una sección/capítulo del APER cargando todo el contexto editorial canónico y delegando al subagente aper-writer.
argument-hint: <NN | NN.S | path> — Ej. "02" (Cap 2), "02.3" (Cap 2 §3), "04_report/02_sector_performance.qmd"
allowed-tools: Read, Grep, Glob, Bash, Edit, Write, Task
---

# Redacción de sección del APER Bolivia 2026

**Argumento recibido:** `$ARGUMENTS`

## Tu tarea

1. **Resolver el argumento** `$ARGUMENTS` a un archivo `.qmd` específico:
   - Si es número de capítulo (ej. "02"): localizar `04_report/0$ARGUMENTS_*.qmd`.
   - Si es número.subsección (ej. "02.3"): localizar el capítulo y la subsección dentro.
   - Si es path completo: usar directo.

2. **Cargar contexto editorial obligatorio** (sin esto, no escribís):
   - `.agent/00_MASTER_PROMPT.md` Partes 1–5 (identidad, invariantes, arquitectura, estándares, 8 hallazgos)
   - `.agent/00_MASTER_PROMPT.md` Parte 6 → bloque del capítulo target
   - `.agent/05_ESTILO_NARRATIVO.md` (TEEL + WB superestructura + §3 anti-IA)
   - `.agent/06_NEUTRALIDAD.md` (vocabulario prohibido)
   - `.agent/04_HALLAZGOS.md` (findings F<NN> asignados a ese capítulo)
   - `.agent/01_METODOLOGIA.md` (definiciones de cifras a citar)
   - El `.qmd` actual del capítulo (estado borrador)

3. **Pre-flight A1 (de `.agent/09_AUDITORIA.md`)**: verificar que están disponibles:
   - Panel v12 (`01_data/processed/spending_panel_v12.rds`)
   - Datasets canónicos del capítulo (ver Parte 5.1 del MASTER_PROMPT)
   - Figuras requeridas (ver el bloque del capítulo en Parte 6)
   - Findings citados existen en `04_HALLAZGOS.md` con `status ∈ {draft, reviewed, MEFP_validated}`

4. **Si pre-flight detecta gaps** (datos faltantes, regresiones no corridas, fichas red): **PARÁ** y reportá al usuario. NO escribir prosa de relleno.

5. **Si pre-flight OK**: invocar el subagente **`aper-writer`** vía Task tool con prompt:
   ```
   Capítulo: <archivo.qmd>
   Subsección: <si aplica>
   Findings asignados: <F01, F02, ...>
   Figuras requeridas: <fig01, fig13, ...>
   Datasets: <list>
   Insumos cualitativos: <fichas green/yellow>
   Pre-flight A1: PASS
   
   Redactá la sección siguiendo TEEL + voz WB. Devolvé markdown listo para
   pegar en el .qmd con la cabecera estandarizada del aper-writer.
   ```

6. **Cuando el aper-writer devuelva el draft**:
   - Mostrar al usuario el draft.
   - Recordar que **antes de hacer Edit/Write al `.qmd`** los hooks van a validar:
     - `validate-qmd-edit.sh` (neutralidad, panel version)
     - `validate-citations.sh` (gate §13B literatura)
   - Si el draft cita `[@key]` con audit_status red/unverified, el hook bloqueará. Avisar al usuario.

7. **Tras la edición exitosa**: sugerir al usuario invocar `/audit-chapter $ARGUMENTS` antes de marcar como `reviewed`.

## Output esperado del slash command

```
🚀 /write-section $ARGUMENTS
   Archivo target: <path>
   
📚 Contexto cargado:
   ✅ MASTER_PROMPT Partes 1–5 (N tokens)
   ✅ Bloque Parte 6 del Cap N
   ✅ ESTILO_NARRATIVO, NEUTRALIDAD, HALLAZGOS, METODOLOGIA
   
🛫 Pre-flight A1:
   [PASS o lista de gaps]
   
🖊️ Delegando a aper-writer...
   [output del aper-writer]
   
📋 Siguientes pasos:
   1. Revisar draft de arriba.
   2. Editar el .qmd (los hooks validarán).
   3. Correr /audit-chapter $ARGUMENTS antes de marcar reviewed.
```

## Reglas estrictas

- **NO** escribís prosa vos directamente — delegás al aper-writer subagente. Tu rol es de orquestador.
- **NO** procedés si pre-flight A1 falla.
- **NO** ignorás los warnings de los hooks.
