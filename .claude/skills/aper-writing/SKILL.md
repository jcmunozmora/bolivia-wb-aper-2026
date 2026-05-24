---
name: aper-writing
description: Activar cuando se va a redactar prosa para el APER Bolivia 2026 — capítulos del Quarto book (`04_report/*.qmd`), executive summary, slides, briefs, páginas web (`www/*.qmd`), cartas técnicas al MEFP. Carga la anatomía TEEL, la superestructura WB, las reglas de neutralidad y el filtro anti-IA pre-publicación. Skip si la tarea es editar código, datos, scripts, o gobernanza (no prosa publicable).
---

# Cómo se escribe en el APER 2026

## Voz canónica

Estás escribiendo en **voz Banco Mundial**: sobria, basada en evidencia, sin adjetivos políticos, sin advocacy. **Tercera persona impersonal** ("la evidencia muestra", "los datos indican", "se observa") — nunca primera plural ("encontramos", "nuestro", "creemos").

Lectura paralela obligatoria al redactar:
- `.agent/05_ESTILO_NARRATIVO.md` (TEEL completo + superestructura WB + §3 anti-IA)
- `.agent/06_NEUTRALIDAD.md` (vocabulario)

## La unidad mínima: párrafo TEEL

```
T  — Topic sentence (1 oración)
     UN claim cuantitativo, finding-first, con magnitud + período.
     Sin floritura ni adjetivos.

E  — Evidence (1–3 oraciones)
     Cifra(s) con trazabilidad: fig/tabla referenciada, fuente, año, unidad.
     SIN interpretación todavía.

X  — Explanation (1–3 oraciones)
     Mecanismo. Comparación con benchmark. Incertidumbre. Caveats.
     SIN advocacy.

L  — Link (1 oración)
     Puente al siguiente párrafo o hallazgo.
     ÚNICO lugar donde puede aparecer "una opción técnica sería".
```

**Longitud objetivo: 80–140 palabras.** Si >160 → casi seguro hay 2 ideas → partir en 2 TEEL.

## Superestructura WB (capítulo entero)

```
BLUF — Bottom Line Up Front (1 párrafo TEEL gigante al inicio)
  ↓
Pirámide invertida (más importante arriba, contexto/caveats abajo)
  ↓
Signposting cada sección ("Esta sección examina...", "El siguiente apartado documenta...")
  ↓
Cierre con síntesis (alimenta HALLAZGOS.md)
```

Un capítulo bien escrito es un **árbol de TEELs anidados**: sección = TEEL grande; cada párrafo = TEEL chico.

## Filtro anti-IA (no negociable — pre-publicación)

Antes de devolver cualquier prosa, escaneá y eliminá / reescribí:

| Patrón a evitar | Cómo reformular |
|-----------------|-----------------|
| "It is important to note" / "Es importante destacar" / "Cabe señalar" | Empezar finding-first con la magnitud |
| "delve into" / "navigate the complexities" / "ever-evolving" / "robust framework" | Soltar la frase |
| "puede contribuir" / "podría apoyar" / "tendría el potencial de" | Reemplazar por evidencia concreta o eliminar |
| Listas de 3 adjetivos ("comprehensive, dynamic, and inclusive") | Eliminar el tercero o reescribir |
| Primera persona plural ("encontramos", "nuestro", "creemos") | Tercera impersonal |
| Cifras sin año + unidad + fuente | Marcar `TODO_TRACE` |
| "el gobierno actual" / "la administración de X" | Periodización temporal ("en 2006–2019") |
| Conectores genéricos ("Furthermore", "Moreover", "In addition") al inicio de párrafo | Conector específico que enlaza con el párrafo previo |
| Cierre tipo "In conclusion" o "To summarize" | Eliminar — el último TEEL ya es síntesis |

## Vocabulario obligatorio cuando aplica

| En vez de... | Usar... |
|--------------|---------|
| "Bolivia debe" / "es urgente" | "una opción técnica sería" / "para consideración del MEFP" |
| "se equivocó" / "fracasó" / "fue exitoso" | "el indicador X se ubicó Y puntos por debajo del benchmark regional" / "los resultados observados muestran" |
| "el gobierno de Morales" | "en el período 2006–2019" / "durante los años fiscales 2006 a 2019" |
| "esto es inaceptable" | "la brecha frente al benchmark fue X" |
| "no podemos esperar" | "la evidencia técnica sugiere margen de repurposing" |

## Citas: gate §13B (anti-alucinación)

### Por qué este gate existe

En la auditoría sesión 11 (2026-05-23) se detectaron **42% de alucinaciones** en el corpus de literatura: autores fabricados, cifras inventadas, citas verbatim que no existen en el PDF, PDFs descargados que corresponden a otro paper. Ver `03_literature/_audit/AUDIT_REPORT.md` y `03_literature/_audit/RED_FLAGS.md`.

### Las 3 listas maestras que tenés que leer ANTES de citar nada

| Archivo | Contenido | Cuándo usar |
|---------|-----------|-------------|
| `03_literature/_audit/_green_list_final.md` | **126 fichas confirmadas** | Tu pool primario de citas |
| `03_literature/_audit/_yellow_list_final.md` | **124 fichas con caveat** | Segunda opción — leer nota antes de citar cifra específica |
| `03_literature/_audit/_red_list_final.md` | **89 fichas prohibidas** | Memorizar las que aplican a tu capítulo — nunca citar |

### Workflow obligatorio al citar

```bash
# Antes de escribir [@CiteKey] en el .qmd:
ficha=$(find 03_literature -name "<CiteKey>.md" -not -path "*/_audit/*" | head -1)
grep "^audit_status:" "$ficha"
# green o yellow → citar
# red o unverified → NO citar, buscar alternativa o marcar [CITA NECESARIA — @key]
```

### Citas verbatim: PROHIBIDAS POR DEFAULT

Las citas con comillas + `(p. X)` fueron la principal fuente de alucinaciones (~50 casos en la sesión 11 — el LLM compuso "comillas plausibles" con números de página inventados).

**Default**: NO escribís citas verbatim. Usás paráfrasis con cita autor-año.

```markdown
# ❌ PROHIBIDO (verbatim sin verificación de PDF)
> "Imported fuels sold at half their international price" [@IMF2025, p. 12]

# ✅ CORRECTO (paráfrasis con cita)
El IMF [-@IMF2025] documenta que los combustibles importados se venden alrededor de la mitad del precio internacional.
```

**Excepción** — si el matiz del lenguaje original es indispensable: abrís el PDF (con Read tool), localizás la frase exacta y la página real, copiás literal (ni una sílaba cambiada). Solo entonces verbatim.

### Distinción crítica: cifra propia vs cifra de literatura

| Tipo de cifra | Cómo citarla |
|---------------|--------------|
| Cifra del **panel v12** | NO citar literatura. "(panel v12; ver `02_INDICADORES.md`)" o "(cálculo propio sobre BOOST 2024)" |
| Cifra de **un paper específico** | `[@CiteKey]` + ficha green/yellow |
| Cifra **derivada por vos** | "cálculo propio basado en [@A; @B]" |
| Cifra de **organismo institucional** (FAO, OECD, BCB, INE) | `[@OrgYYYY]` + ficha green/yellow |

Nunca atribuyas a un paper una cifra que no aparece literal en ese paper.

### Cuando dudes: marcar para el humano

Es 100x mejor un draft con 15 `[CITA NECESARIA — verificar @key]` que un draft "completo" con 3 alucinaciones que el evaluador detectará.

Si no podés verificar:
- **No inventes** una cifra plausible
- **No copies** de memoria del LLM
- Marcá `[CITA NECESARIA — verificar X contra @CiteKey, p.??]`

### Auto-chequeo antes de devolver el draft

```bash
grep -oE '@[A-Za-z][A-Za-z0-9_\-:./]*' tu_draft.qmd | sed 's/@//' | sort -u | while read ck; do
  ficha=$(find 03_literature -name "${ck}.md" -not -path "*/_audit/*" 2>/dev/null | head -1)
  if [ -z "$ficha" ]; then echo "🔴 $ck → ORPHAN"; continue; fi
  st=$(grep "^audit_status:" "$ficha" | awk '{print $2}')
  [ "$st" = "red" ] || [ "$st" = "unverified" ] && echo "🔴 $ck → $st"
done
```

Si aparece cualquier 🔴, reescribir antes de devolver al orquestador. El hook `validate-citations.sh` bloqueará la edición igual, pero es mejor pasar la auto-evaluación primero.

## Cifras: invariante 3.1

Cada cifra requiere:
- Año explícito (no "en años recientes" — "en 2023").
- Unidad explícita ("5.8%", "BOB 320 millones (2015 constantes)", "USD WDI 290 millones").
- Fuente al pie ("Fuente: cálculos propios desde panel v12 + IDB AgriMonitor 2024.").

**Si una cifra te viene a la mente sin saber su trace exacto**: marcá `TODO_TRACE: <cifra>` en vez de escribirla.

## Findings: citar por ID

Siempre que cites un hallazgo, usá el ID `F<NN>` y verificá su magnitud contra `.agent/04_HALLAZGOS.md`:
- "El gasto agropecuario nunca alcanzó la meta de Maputo (10% del presupuesto): el máximo histórico fue 3.48% en 1990 (F04)."
- NO: "Como es ampliamente sabido, Bolivia no cumplió Maputo" (sin cita, sin cifra).

## Cabecera estandarizada de output

Cuando devuelvas un draft:

```markdown
**Sección redactada:** Cap N.M — [título]
**Findings citados:** F0N, F0M
**Figuras referenciadas:** figXX, figYY
**Citas bib:** [@key1, @key2] (verificar audit_status verde/amarillo)
**TODO_TRACE pendientes:** [lista o "ninguno"]
**Longitud:** ~N palabras (target N-N pp ≈ N-N palabras)
```

## Hooks que te van a vigilar

Al hacer Edit/Write a `04_report/*.qmd`, dos hooks corren:
- `validate-qmd-edit.sh` → bloquea advocacy, imperativos, panel v1/v10/v11, nombres políticos.
- `validate-citations.sh` → bloquea citas a fichas red/unverified/orphan.

Si te bloquean, NO te resistas — leé el mensaje, reformulá, reintentá.

## Cierre

Si seguís estas reglas, el output va a pasar:
- ✅ Filtro anti-IA del §3 de ESTILO_NARRATIVO
- ✅ Vocabulario de NEUTRALIDAD
- ✅ Gate de citas §13B
- ✅ Gates A2–A3 de AUDITORIA
- ✅ Hooks de Claude Code

Si no, va a fallar al menos uno. Es preferible un párrafo menos pero limpio, que tres con TODO_TRACE.
