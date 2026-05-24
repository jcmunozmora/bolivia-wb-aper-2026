# 09_AUDITORIA.md — APER 2026 Bolivia

**Versión:** v0.1.0
**Última actualización:** 2026-05-23
**Propósito:** sistema de verificación que confirma que cada producto del APER 2026 cumple las reglas declaradas en el ecosistema de gobernanza (master prompt, AGENTS, CLAUDE, CONTROL, NEUTRALIDAD, ESTILO_NARRATIVO, METODOLOGIA cuando exista).
**Filosofía:** 08_CONTROL.md define las **reglas**; 09_AUDITORIA.md las **verifica**. Sin auditoría, las reglas son aspiracionales.
**Lecturas relacionadas:** [08_CONTROL.md](08_CONTROL.md), [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md), [06_NEUTRALIDAD.md](06_NEUTRALIDAD.md), [AGENTS.md](../AGENTS.md), [CLAUDE.md](../CLAUDE.md), [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md).

---

## 1. Principio rector

> Nada se publica sin auditoría documentada. La auditoría se firma. Los hallazgos quedan trazables. El log es inmutable.

Cuatro afirmaciones operativas:

1. **Cada artefacto publicable tiene un punto de auditoría obligatorio antes de salir.** Capítulo, sección, hallazgo, figura, slide, página web, brief, carta MEFP.
2. **La auditoría es separable de la autoría.** Quien escribió no puede ser el único auditor.
3. **El log de auditoría es append-only.** No se borra ni se reescribe. Errores se corrigen en una nueva entrada con referencia a la anterior.
4. **Una auditoría fallida bloquea publicación.** Sin excepciones operativas — solo excepciones ADR-firmadas según CONTROL §10.

---

## 2. Tipos de auditoría

Cinco tipos, escalando en cobertura:

| Tipo | Cuándo se corre | Cobertura | Auditor | Tiempo objetivo |
|---|---|---|---|---|
| **A1 — Pre-flight de prosa** | Antes de pegar prosa nueva al book/web/slides | El bloque escrito en esa sesión | Autor (autoauditoría) | 2–5 min |
| **A2 — Auditoría por sesión** | Al cierre de cada sesión sustantiva | Todo el cambio de la sesión | Autor + revisor par (asíncrono) | 10–20 min |
| **A3 — Auditoría por capítulo** | Antes de marcar un capítulo `reviewed` | Capítulo completo | Revisor del equipo APER (no autor) | 45–90 min |
| **A4 — Auditoría pre-handoff MEFP** | Antes de compartir borrador con MEFP | Bloque a entregar (capítulo, brief, slides) | Revisor senior (TTL o co-TTL) | 1–3 h |
| **A5 — Auditoría de release** | Antes de publicación pública (sitio, PDF final) | Book completo + web + slides + briefs | Comité APER + auditor externo si aplica | 1–3 días |

Una auditoría de orden superior **no exime** de las inferiores: A4 supone A3, A3 supone A2, A2 supone A1. Si una se saltó, se documenta y se completa antes de avanzar.

---

## 3. A1 — Pre-flight de prosa (autoauditoría)

Corre **siempre** antes de mostrar prosa al usuario o pegarla en el repo. Equivale al loop §3.4 de [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md).

### 3.1. Checklist A1

```text
CAPA BASE (§3.2–§3.3 de ESTILO_NARRATIVO)
[ ] cero / ≤1 de las 12 banderas rojas
[ ] cero frases NEVER WRITE (EN + ES)

CAPA EXTENDIDA (§3.11–§3.23 de ESTILO_NARRATIVO)
[ ] vocabulario IA extendido controlado (≤1 por párrafo)
[ ] sellos sintácticos LLM ausentes
[ ] sin three-bullet syndrome ni listicle creep ni headers cada 2 párrafos
[ ] cohesión hueca ausente (conectores ornamentales borrados)
[ ] andamiaje narrativo ausente ("in what follows", "having established X")
[ ] adjetivos cuantitativos con magnitud trazada
[ ] tropos narrativos ausentes ("at a crossroads", "journey toward")
[ ] auto-divulgación de modelo: cero ocurrencias
[ ] verificación anti-alucinación corrida (cifras, citas, decretos, programas)
[ ] tipografía y Unicode limpios
[ ] defensive prose / over-disclaiming ausente
[ ] tone calibration neutro (sin "encouraging", "promising")

CAPA ES (§3.24, solo si prosa en español)
[ ] cero fórmulas académicas ES de tolerancia cero (§3.24.1)
[ ] cero anglicismos sintácticos LLM (§3.24.2)
[ ] pasiva refleja sin agente conocido reescrita
[ ] subjuntivo ornamental ≤1 por sección
[ ] conectores ornamentales ES ausentes
[ ] zombies en -ción/-miento ≤3 por párrafo con verbo activo principal
[ ] tropos ES adicionales ausentes
[ ] tipografía ES correcta (coma decimal, punto miles, em dash con espacios, comillas inglesas)
[ ] registro sin "el presente / el cual / siendo + participio"

SCORING
[ ] AI-likelihood score calculado y reportado (idioma + score)
[ ] umbrales: ≤3 EN / ≤2 ES para considerarse limpio
```

### 3.2. Salida obligatoria A1

Cada prosa nueva acompaña un microreporte de una línea cuando se hace handoff o cierre de sesión:

```text
[A1] idioma: ES | bloque: 04_report/05_spending_analysis.qmd §5.2 | score: 1/10 | banderas: ninguna
```

Si activó banderas:

```text
[A1] idioma: ES | bloque: ... | score: 4/10 | banderas: §3.24.1 (cabe destacar x2), §3.24.6 (zombies x4) | acción: regenerado
```

---

## 4. A2 — Auditoría por sesión

Corre al cierre de cada sesión sustantiva. La completa el autor y la revisa un par del equipo (asíncrono, antes de la siguiente sesión).

### 4.1. Checklist A2

```text
CLASIFICACIÓN
[ ] color del cambio declarado (verde / amarillo / rojo) — CONTROL §4
[ ] si rojo: ADR abierto y referenciado

PROSA
[ ] A1 pasado en todos los bloques de prosa nuevos
[ ] AI-likelihood promedio del cambio ≤ 3 (EN) / ≤ 2 (ES)

CIFRAS
[ ] toda cifra nueva tiene metadato de trazabilidad (RDS + script + variable + período + fuente)
[ ] cifras existentes no modificadas inadvertidamente (diff verificado)
[ ] panel_version declarada en cada figura/tabla nueva

FIGURAS / TABLAS
[ ] caption + alt-text (ES y EN si bilingüe)
[ ] script en 02_code/ que reproduce la figura
[ ] data_rds en metadato
[ ] fuente declarada

CITAS Y FUENTES
[ ] cada cita @key tiene entrada en references.bib
[ ] DOI / URL verificada
[ ] fuentes nuevas registradas en 03_FUENTES.md (cuando exista)

CONSISTENCIA
[ ] cifras del bloque coherentes con 04_HALLAZGOS.md vigente
[ ] paridad bilingüe ES ↔ EN si aplica

REPRODUCIBILIDAD
[ ] quarto render del archivo afectado pasa
[ ] sin warnings nuevos

NEUTRALIDAD
[ ] sin actores políticos nombrados (NEUTRALIDAD §2.1)
[ ] sin juicios morales (NEUTRALIDAD §2.2)
[ ] sin lenguaje prescriptivo (NEUTRALIDAD §2.3)
[ ] sin advocacy emocional (NEUTRALIDAD §2.4)
[ ] sin contrafactual político (NEUTRALIDAD §2.5)
[ ] sin adjetivos morales (NEUTRALIDAD §2.6)
[ ] sin adverbios innecesarios (NEUTRALIDAD §2.7)

GOBERNANZA
[ ] RETOMAR.md actualizado con cierre de sesión formato §8 AGENTS.md
[ ] siguiente paso declarado
```

### 4.2. Cierre A2

El bloque del formato §8 de AGENTS.md ahora incluye los campos anti-IA. Sumado a A2:

```text
## Sesión NN — YYYY-MM-DD

Resumen del cambio:
Tipo de cambio: verde | amarillo | rojo
Archivos modificados:
Cifras tocadas (con trazabilidad):
Hallazgos afectados:
Capítulos del book afectados:
Slides / web actualizadas:
Tests ejecutados:
Tests no ejecutados:
Impacto en panel:
Impacto en metodología:
Impacto en hallazgos:
Impacto en MEFP handoff:
Pre-flight anti-IA (A1): corrido sí/no
AI-likelihood score promedio: N/10 (idioma)
/quijote-writer invocado: sí/no (sobre qué secciones EN)
Banderas anti-IA activadas y resueltas:
A2 firmada por: <nombre del revisor par> — fecha
Riesgos pendientes:
ADR requerido: sí | no | número
Siguientes pasos:
```

---

## 5. A3 — Auditoría por capítulo

Antes de marcar un capítulo como `reviewed`. La completa un revisor del equipo APER que **no** sea el autor principal.

### 5.1. Checklist A3

```text
ESTRUCTURA
[ ] abre con "Mensajes clave" (BLUF — 3–5 bullets bilingües)
[ ] cada sección abre con BLUF de 2 oraciones
[ ] orden piramidal: mensajes clave → hallazgos sustantivos → desagregaciones → caveats → puente
[ ] topic sentences leídos en orden cuentan la historia del capítulo (con asimetría §3.2 flag 10)
[ ] sección de cierre con TEEL de síntesis
[ ] puente al capítulo siguiente

ANATOMÍA DE PÁRRAFO
[ ] cada párrafo sustantivo pasa el checklist §12 de ESTILO_NARRATIVO
[ ] longitud asimétrica entre párrafos consecutivos (sin 3 seguidos del mismo largo)
[ ] ningún párrafo > 180 palabras
[ ] uno de cada tres párrafos abre con hecho/cifra/setup (no topic limpia)

PROSA (refuerzo de A1)
[ ] capa base + extendida + (ES) + score por sección, idioma reportado
[ ] /quijote-writer invocado si el capítulo tiene > 500 palabras EN o si va a handoff MEFP en EN

CIFRAS Y TRAZABILIDAD
[ ] toda cifra tiene metadato (rds_path, script_path, variable, filter, period, raw_source, methodology_version, panel_version)
[ ] no hay TODO_TRACE pendiente en el capítulo
[ ] cifras consistentes con 04_HALLAZGOS.md
[ ] cifras consistentes con executive summary

FIGURAS / TABLAS
[ ] todas tienen caption + alt-text (ES y EN si aplica)
[ ] todas tienen contrato JSON (figure schema) o equivalente en YAML del Quarto
[ ] paleta visual consistente con el resto del book

CITAS
[ ] cada @key tiene entrada en references.bib
[ ] DOI/URL verificada con `curl -I` o equivalente
[ ] sin citas a "estudios recientes" / "expertos coinciden" / "fuentes oficiales" sin nombre

HALLUCINATION GUARD
[ ] programas / iniciativas bolivianos nombrados verificados (sitio MEFP/MDRyT/INE)
[ ] decretos / leyes citados verificados en Gaceta Oficial
[ ] fechas específicas verificadas contra fuente primaria
[ ] siglas institucionales expandidas en primera aparición
[ ] números demasiado redondos (50%, 100%, 1000) trazados o reescritos

REPRODUCIBILIDAD
[ ] renv::restore() limpio
[ ] quarto render del capítulo pasa sin warnings
[ ] figuras se regeneran determinísticamente desde scripts

NEUTRALIDAD
[ ] checklist §2 de 06_NEUTRALIDAD.md completo
[ ] disclaimer técnico cierra el capítulo (§11 NEUTRALIDAD)

PARIDAD BILINGÜE (si aplica)
[ ] cada claim cuantitativo en ES y EN coincide en magnitud, período, fuente
[ ] alt-text equivalente, no traducción literal
[ ] glosario consistente (términos no traducidos según §6 NEUTRALIDAD)

ENLACES Y NAVEGACIÓN
[ ] referencias internas precisas (§X.Y, no "más adelante")
[ ] enlaces externos no rotos
[ ] anclas Quarto funcionando

ESTADO
[ ] capítulo declarado en estado: draft | reviewed | MEFP_validated
[ ] cambios sustantivos versionados; bumps registrados según CONTROL §7
```

### 5.2. Salida A3

```text
[A3] capítulo: 04_report/05_spending_analysis.qmd | versión: v0.3 | revisor: <nombre>
| fecha: YYYY-MM-DD | estado: reviewed
| A1 score promedio: 1.4/10 (ES) | A2 firmadas: 3
| banderas anti-IA: ninguna | cifras nuevas trazadas: 14/14
| paridad bilingüe: pasada | reproducibilidad: pasada
| pendientes para A4 (handoff MEFP): [lista o ninguno]
```

---

## 6. A4 — Auditoría pre-handoff MEFP

Antes de compartir cualquier borrador con el MEFP (sea capítulo, brief, slides o carta). La firma un revisor senior (TTL o co-TTL).

### 6.1. Checklist A4

```text
PRECONDICIÓN
[ ] A3 firmada del bloque a entregar
[ ] sin TODO_TRACE pendientes
[ ] sin TODO de redacción en bloques que se entregan

ESTRATÉGICO
[ ] el bloque responde a la pregunta de política con la que se acordó la entrega
[ ] el equipo confirma que las cifras presentadas son las que quiere defender
[ ] divergencias internas con el panel resueltas o documentadas como nota
[ ] hallazgos en estado `reviewed` (no `draft`)

LENGUAJE Y NEUTRALIDAD
[ ] capa base + extendida + (ES) anti-IA pasada
[ ] /quijote-writer pasado si el bloque está en EN
[ ] NEUTRALIDAD §11 (frase de cierre obligatoria) presente
[ ] sin lenguaje prescriptivo
[ ] escenarios marcados como "opción técnica para consideración del MEFP"

TRAZABILIDAD REFORZADA
[ ] toda cifra reproducible desde renv::restore() + quarto render limpio
[ ] panel_version declarado por figura y consistente con la versión vigente
[ ] metodología versionada (m<x.y>) declarada en cada hallazgo del bloque

COMENTARIOS MEFP HISTÓRICOS
[ ] comentarios MEFP previos sobre el mismo bloque incorporados o documentados como divergencia
[ ] notas de divergencia (no resueltas) presentes en el appendix correspondiente
[ ] log de comentarios actualizado

COHERENCIA TRANSVERSAL
[ ] cifras del bloque coinciden con book ↔ web ↔ slides ↔ executive summary ↔ briefs
[ ] hallazgos referenciados existen en 04_HALLAZGOS.md con `status` adecuado
[ ] sin contradicciones con capítulos previos

CONFIDENCIALIDAD Y SCOPE
[ ] bloque marcado con su nivel de confidencialidad acordado con el MEFP
[ ] no se incluyen datos personales ni información clasificada
[ ] disclaimer técnico §23 master en el bloque

CIERRE
[ ] revisor senior nombrado y fecha registrada
[ ] modo de entrega definido (correo, mesa técnica, portal)
[ ] receptor MEFP nombrado (rol, no persona política)
```

### 6.2. Salida A4

```text
[A4] bloque: <capítulo / brief / slides / carta> | versión: vX.Y | TTL/revisor senior: <nombre>
| fecha: YYYY-MM-DD | receptor MEFP: <rol>
| A3 firmada: sí (link)
| modificaciones desde A3: [lista]
| status post-handoff: enviado | en mesa técnica | pendiente respuesta MEFP
| comentarios MEFP esperados: sí/no
| nota: <observaciones del revisor senior>
```

---

## 7. A5 — Auditoría de release

Antes de publicación pública del book completo, sitio web actualizado, slides finales o briefs distribuibles. La completa un comité del equipo APER, con auditoría externa opcional.

### 7.1. Checklist A5

```text
COMPLETITUD
[ ] todos los capítulos del book en estado `reviewed` o `MEFP_validated`
[ ] executive summary bilingüe presente y consistente
[ ] sitio público compila y publica desde main
[ ] slides ejecutivas en versión definitiva
[ ] briefs derivados producidos cuando aplica

REPRODUCIBILIDAD END-TO-END
[ ] renv::restore() limpio en máquina nueva (verificado por al menos 2 personas)
[ ] quarto render del book pasa
[ ] quarto render del sitio público pasa
[ ] todas las figuras se regeneran desde scripts
[ ] pipeline PSE/CSE reproducible desde script único

PANEL CANÓNICO
[ ] una sola versión del panel vigente para todo el release (e.g. v12)
[ ] sin cifras del book que provengan de panel anterior

TRAZABILIDAD FULL-BOOK
[ ] traceability audit: cada cifra publicada tiene su tupla completa (RDS + script + variable + período + fuente)
[ ] sin orphan numbers en texto
[ ] tabla de variables (02_INDICADORES.md) cubre las 176 variables del panel

ANTI-IA AGREGADO
[ ] AI-likelihood promedio por capítulo ≤ 2 (objetivo de release: prosa humana)
[ ] capa base + extendida + ES corridas y reportadas por capítulo
[ ] /quijote-writer pasado en cada capítulo EN
[ ] sin banderas residuales no resueltas

HALLAZGOS Y ESCENARIOS
[ ] los 8 hallazgos presentes en 04_HALLAZGOS.md con contrato JSON
[ ] cada hallazgo en estado `reviewed` o `MEFP_validated`
[ ] escenarios de repurposing marcados como "opciones técnicas"
[ ] notas de divergencia con MEFP documentadas

NEUTRALIDAD AGREGADA
[ ] auditoría completa de NEUTRALIDAD §2 sobre todo el book
[ ] disclaimer técnico §23 del master presente en cada producto público
[ ] versión EN del disclaimer en productos bilingües

CONSISTENCIA TRANSVERSAL
[ ] cifras y claims coherentes en book ↔ web ↔ slides ↔ executive summary ↔ briefs ↔ cartas MEFP
[ ] glosario consistente en todos los productos
[ ] paleta visual y tipografía consistentes

ADRs Y VERSIONAMIENTO
[ ] todo cambio ROJO desde el release previo tiene su ADR firmado
[ ] versionamiento de panel / metodología / hallazgos correcto y declarado
[ ] CHANGELOG general del release escrito

ACCESIBILIDAD Y APERTURA
[ ] alt-text bilingüe en todas las figuras del sitio público
[ ] PDFs accesibles (tagged, OCR si escaneados)
[ ] licencias declaradas (CC-BY-4.0 por defecto, salvo excepciones)
[ ] DOI del release asignado si aplica (Zenodo / OSF)

CIERRE
[ ] firma del comité APER (lista de nombres + fechas)
[ ] firma del TTL
[ ] auditor externo si aplica (nombre, organización, fecha)
[ ] release tag en git (`vX.Y.Z`)
```

### 7.2. Salida A5

```text
[A5] release: APER 2026 Bolivia vX.Y.Z | fecha: YYYY-MM-DD
| comité APER: <lista de nombres>
| TTL: <nombre>
| auditor externo: <nombre o n/a>
| panel canónico: v12
| metodología: m0.5
| hallazgos: F01–F08 (todos `reviewed` o `MEFP_validated`)
| AI-likelihood promedio del book: 1.2/10
| reproducibilidad: pasada en 3 máquinas
| ADRs nuevos en este release: [lista]
| nota: <observaciones del comité>
| git tag: vX.Y.Z
| DOI: <si aplica>
```

---

## 8. Log de auditoría (append-only)

### 8.1. Ubicación

```text
00_admin/audit_log/
  audit_log_2026.md            log principal del año, append-only
  audit_log_2026_archive/      archivos cerrados de releases previos
```

### 8.2. Formato de entrada

Cada auditoría (A2 en adelante) genera una entrada con este formato:

```markdown
---
audit_id: A<level>-2026-NNNN
audit_level: A1 | A2 | A3 | A4 | A5
artifact: <ruta o producto>
artifact_version: <vX.Y.Z o commit SHA>
date: YYYY-MM-DD
auditor: <nombre, rol>
status: passed | passed_with_notes | failed | blocked
language: ES | EN | bilingual
ai_likelihood_score: N/10
flags_triggered: [lista por subsección §3.X de ESTILO_NARRATIVO]
flags_resolved: [lista]
related_session: <id de RETOMAR.md>
related_ADR: <ADR-NNNN o n/a>
---

## Resumen

<3 a 6 líneas: qué se auditó, qué se encontró, qué se firmó>

## Hallazgos

- [P0] <hallazgo crítico, si lo hubo>
- [P1] <hallazgo mayor>
- [P2] <hallazgo menor>
- [P3] <observación cosmética>

## Acciones tomadas en esta auditoría

- ...

## Acciones derivadas (a ejecutar)

- responsable: <nombre> — plazo: YYYY-MM-DD — descripción: ...

## Firma

<nombre del auditor> — <rol> — <fecha>
```

### 8.3. Regla de inmutabilidad

```text
NO se borran entradas.
NO se reescriben entradas.
Errores se corrigen en una nueva entrada que referencia la anterior:

  ---
  audit_id: A3-2026-0042
  supersedes: A3-2026-0041
  ---
  Corrección de la entrada anterior. Motivo: ...
```

### 8.4. Resumen mensual

Al cierre de cada mes calendario, el TTL o un par firma un **rollup**:

```text
[ROLLUP 2026-MM]
auditorías corridas: <conteo por nivel>
fallas: <conteo>
ADRs nuevos: <conteo>
banderas anti-IA recurrentes: <lista de las 3 más frecuentes>
recomendaciones para el mes siguiente: <lista>
```

---

## 9. Roles de auditoría

| Rol | Quién | Qué firma |
|---|---|---|
| **Autor** | Quien escribió la prosa o construyó la figura | A1 (autoauditoría) |
| **Par del equipo APER** | Cualquier miembro del equipo distinto del autor | A2, A3 |
| **Revisor senior** | TTL o co-TTL | A4 |
| **Comité APER** | Equipo completo + TTL | A5 |
| **Auditor externo** | Persona ajena al equipo (académico, peer del WB, MEFP cuando se acuerde) | A5 opcional, ad-hoc cuando se solicite |
| **Consultor PSE/repurposing** | Cuando esté contratado | A3/A4 en capítulos 05 y 06 |
| **Auditor de neutralidad** | Persona designada del equipo (rota) | A3/A4 sobre lenguaje |

Reglas duras:

- **Quien escribió no firma A2/A3 sobre su propio bloque.** Autoauditoría A1 es aceptable; A2 en adelante requiere otro par de ojos.
- **A4 nunca la firma quien firmó A3** del mismo bloque (separación de capas).
- **A5 nunca la firma una sola persona.** Requiere al menos 2 firmas del comité APER + TTL.

---

## 10. Cómo se ejecuta una auditoría

### 10.1. Manual / asistida

Mientras los scripts de automatización (`scripts/audit_*.R`) están en desarrollo, las auditorías se ejecutan así:

```text
1. abrir el bloque a auditar en el editor.
2. abrir 08_CONTROL.md, 05_ESTILO_NARRATIVO.md (especialmente §3 y §3.24), 06_NEUTRALIDAD.md.
3. correr el checklist del nivel correspondiente (§3–§7 de este archivo).
4. anotar cada hallazgo con prioridad (P0–P3).
5. dialogar con el autor si hay P0 o P1.
6. registrar la entrada en 00_admin/audit_log/audit_log_2026.md.
7. firmar.
```

### 10.2. Automatizada (a implementar)

Scripts previstos en `scripts/`:

```text
scripts/
  audit_anti_ai.R           barre §3.2–§3.24 y produce reporte por archivo
  audit_traceability.R      verifica que toda cifra tenga su tupla
  audit_reproducibility.sh  renv restore + quarto render + diff de outputs
  audit_bilingual.R         paridad ES ↔ EN en claims, magnitudes, fuentes
  audit_citations.R         cita @key ↔ references.bib ↔ DOI/URL
  audit_unicode.sh          detección de U+200B / U+00AD / U+FEFF
  audit_neutrality.R        grep contra listas NEUTRALIDAD §2
  audit_consistency.R       book ↔ web ↔ slides ↔ briefs
  audit_panel_version.R     toda figura declara panel_version vigente
  audit_hallucination.R     programas / decretos / autores → verificación
  audit_orchestrator.R      corre todos y produce reporte agregado
```

Cada script reporta en formato compatible con §8.2 para anexarse al log.

### 10.3. Integración con CI

Cuando los scripts estén implementados, los gates §9 de 08_CONTROL.md bloquean merge basados en su salida. La auditoría humana A3/A4/A5 se mantiene como capa adicional, no sustituible por CI.

---

## 11. Protocolo de falla

Cuando una auditoría falla:

### 11.1. Falla A1

```text
acción inmediata: regenerar el bloque
sin escalada: el autor lo resuelve
sin entrada en log (es autoauditoría)
```

### 11.2. Falla A2

```text
acción: el par del equipo devuelve el bloque al autor con anotaciones
estado: la sesión queda "pendiente de fix" en RETOMAR.md
escalada: si tras 2 ciclos no se resuelve, escalar al TTL
entrada en log: sí, con status `failed` y acciones derivadas
```

### 11.3. Falla A3

```text
acción: el revisor abre observaciones (P0/P1/P2/P3) por escrito
estado: el capítulo NO pasa a `reviewed`; queda `needs_revision`
plazo recomendado: 1 semana para resolver P0/P1
escalada: si afecta hallazgo, abrir ADR según CONTROL §6
entrada en log: sí
```

### 11.4. Falla A4

```text
acción: el handoff al MEFP NO ocurre hasta resolución
estado: bloque queda `pre_mefp_blocked`
escalada: TTL convoca reunión interna para decidir alcance del fix
ADR: requerido si el motivo de falla es metodológico o cuantitativo
entrada en log: sí, con marca clara `blocked`
```

### 11.5. Falla A5

```text
acción: el release NO se publica
estado: release queda `release_blocked` en git (sin tag)
escalada: comité APER + TTL definen plan de remediación
plazo: definido caso por caso, comunicado al MEFP si el delay afecta compromisos
ADR: requerido para cualquier remediación que toque zona crítica
entrada en log: sí, con marca `blocked`
```

---

## 12. Periodicidad

| Nivel | Frecuencia |
|---|---|
| A1 | continua — cada vez que se escribe prosa |
| A2 | cierre de sesión sustantiva (típicamente semanal o sub-semanal) |
| A3 | cada vez que un capítulo cierra una versión `reviewed` |
| A4 | cada handoff al MEFP (mesa técnica, carta, brief) |
| A5 | cada release público |

Adicionalmente:

- **Auditoría sorpresa mensual** sobre un capítulo elegido al azar: la corre el TTL o un par; entrada en log.
- **Auditoría retrospectiva trimestral**: revisar los rollups mensuales y ajustar reglas si una bandera anti-IA reaparece > 3 veces.

---

## 13. Métricas del sistema de auditoría

Métricas a reportar en el rollup mensual:

```text
- N de auditorías corridas (por nivel)
- N de fallas (por nivel)
- AI-likelihood promedio del book (ponderado por capítulo)
- top 5 banderas anti-IA disparadas
- N de ADRs nuevos
- N de notas de divergencia con MEFP abiertas / cerradas
- tiempo promedio entre A3 fallida y A3 pasada (lead time de remediación)
- conteo de TODO_TRACE abiertos / cerrados
- conteo de cifras sin trazabilidad detectadas / corregidas
```

---

## 13B. Gate de literatura externa (añadido sesión 11 — 2026-05-23)

**Motivación:** la auditoría Fase 2 de la sesión 11 detectó que ~42% de las fichas auditadas en `03_literature/` contenían alucinaciones críticas (autores fabricados, cifras inventadas, citas verbatim que no existen en el PDF, PDFs que no corresponden al paper de la ficha). Ver [`03_literature/_audit/AUDIT_REPORT.md`](../03_literature/_audit/AUDIT_REPORT.md) y [`03_literature/_audit/RED_FLAGS.md`](../03_literature/_audit/RED_FLAGS.md).

### 13B.1. Regla

> **Una ficha de `03_literature/` sólo puede citarse en `04_report/*.qmd` si su `audit_status` ∈ {`green`, `yellow`}.** Las fichas con `audit_status: red` o `unverified` requieren **re-verificación contra PDF + actualización de `audit_status`** antes de que su cita aparezca en el reporte.

### 13B.2. Cómo verificar `audit_status`

```bash
# Ver status de una ficha específica
grep "^audit_status:" 03_literature/<carpeta>/<citekey>.md

# Listar todas las rojas
grep -rE "^audit_status:\s*red" 03_literature/

# Listar fichas verde+yellow (citables)
grep -rE "^audit_status:\s*(green|yellow)" 03_literature/ | wc -l
```

### 13B.3. Workflow al redactar el reporte

Cuando un agente de redacción (`/write-section`, `/quijote-wb-*`) vaya a citar `[@AuthorYYYY]`:

1. Localiza la ficha en `03_literature/<carpeta>/AuthorYYYY.md`
2. Verifica `audit_status` en el frontmatter
3. Si `green` o `yellow`: cita libremente; si `yellow`, lee la nota de inconsistencia y ajusta el texto
4. Si `red`: **STOP**. No citar. Avisar al humano para re-verificar o sustituir por otra fuente
5. Si `unverified`: **STOP**. Abre el PDF, verifica las cifras/autores que vas a citar, actualiza `audit_status` a `green` (todo limpio) o `yellow` (con caveat), y procede

### 13B.4. Re-verificación de una ficha

Para mover una ficha de `unverified` o `red` a `green`/`yellow`:

1. Abrir el PDF en `03_literature/pdfs/<carpeta>/<citekey>.pdf`
2. Confirmar contra el PDF:
   - Frontmatter (`title`, `authors`, `year`, `source`, `doi`, `volume/issue/pages`)
   - Cifras en sección 6 (cada una con localización: "p. X" o "Tabla Y")
   - Citas verbatim en sección 8 (cada una literal del PDF; si no, eliminar comillas y convertir a paráfrasis)
   - Snippets ES/EN en sección 12 (paráfrasis fiel)
3. Editar la ficha corrigiendo errores
4. Cambiar `audit_status:` a `green` (todo confirmado) o `yellow` (con caveat documentado en `audit_notes:`)
5. Añadir línea: `audit_date: YYYY-MM-DD` y `auditor: <nombre>`

### 13B.5. Excepción

Si una ficha **roja** o **unverified** es indispensable y no puede re-verificarse a tiempo, **no citar** sino marcar el espacio en el reporte con `[CITA NECESARIA — verificar @AuthorYYYY]` y registrar la deuda en `00_admin/RETOMAR.md`.

### 13B.6. Detección automática (CI)

Comando para detectar citas problemáticas en el reporte:

```bash
# Extrae citas del reporte
grep -rohE '@[A-Za-z]+[0-9]{4}' 04_report/*.qmd | sed 's/@//' | sort -u > /tmp/cited.txt

# Cruza con lista de rojas/unverified
while read citekey; do
  ficha=$(find 03_literature -name "${citekey}.md" -not -path "*/_audit/*" 2>/dev/null | head -1)
  if [ -n "$ficha" ]; then
    status=$(grep "^audit_status:" "$ficha" | awk '{print $2}')
    if [ "$status" = "red" ] || [ "$status" = "unverified" ]; then
      echo "🔴 $citekey ($ficha) — status=$status — NO CITAR sin re-verificar"
    fi
  fi
done < /tmp/cited.txt
```

Este chequeo debe correr como parte de A3 (auditoría por capítulo) antes de marcar un capítulo `reviewed`.

---

## 14. Integración con el ecosistema

| Archivo | Relación |
|---|---|
| [08_CONTROL.md](08_CONTROL.md) | define reglas; este archivo verifica cumplimiento |
| [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md) | aporta §3.4 loop y checklists §12 §13 que se invocan en A1–A3 |
| [06_NEUTRALIDAD.md](06_NEUTRALIDAD.md) | aporta checklist §2 que se invoca en A2–A5 |
| [AGENTS.md](../AGENTS.md) | §8 formato de cierre de sesión integra los outputs de A1 y A2 |
| [CLAUDE.md](../CLAUDE.md) | guía a los LLM a invocar A1 antes de mostrar prosa |
| [04_HALLAZGOS.md](04_HALLAZGOS.md) (pendiente) | cada hallazgo pasa por A3 antes de `reviewed` y por A4 antes de `MEFP_validated` |
| [01_METODOLOGIA.md](01_METODOLOGIA.md) (pendiente) | cambios disparan ROJO en CONTROL, A3 obligatoria, ADR |
| [02_INDICADORES.md](02_INDICADORES.md) (pendiente) | igual |
| [03_FUENTES.md](03_FUENTES.md) (pendiente) | igual |
| RETOMAR.md | bitácora de sesiones; A2 cierra acá |
| `00_admin/audit_log/` | repositorio del log append-only de A2–A5 |
| `scripts/audit_*.R` | implementación automatizada futura |
| `.github/workflows/` | CI gates basados en los scripts (cuando existan) |

---

## 15. Plantilla mínima de reporte de auditoría

Para uso directo, copiar y pegar:

```markdown
---
audit_id: A<level>-2026-NNNN
audit_level: A<1|2|3|4|5>
artifact:
artifact_version:
date:
auditor:
status: passed | passed_with_notes | failed | blocked
language: ES | EN | bilingual
ai_likelihood_score:
flags_triggered: []
flags_resolved: []
related_session:
related_ADR:
---

## Resumen



## Hallazgos

- [P0]
- [P1]
- [P2]
- [P3]

## Acciones tomadas en esta auditoría

-

## Acciones derivadas

- responsable:  — plazo:  — descripción:

## Firma

  —   —
```

---

## 16. Cómo modificar este archivo

`09_AUDITORIA.md` es zona crítica (CONTROL §3). Modificarlo es **ROJO** y requiere ADR.

Cambios típicos que disparan ROJO sobre `09_AUDITORIA.md`:

- agregar / quitar un nivel (A1–A5) o cambiar su cobertura;
- cambiar la regla de inmutabilidad del log;
- cambiar quién firma cada nivel;
- cambiar los protocolos de falla §11.

Cambios cosméticos (typos, ejemplos adicionales, mejor wording) son AMARILLO.

---

## 17. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: 5 niveles A1–A5, checklists por nivel, log append-only, protocolo de falla, integración con 08_CONTROL.md y 05_ESTILO_NARRATIVO.md §3 + §3.24, scripts de auditoría previstos |
