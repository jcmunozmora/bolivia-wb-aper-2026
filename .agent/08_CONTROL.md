# 08_CONTROL.md — APER 2026 Bolivia

**Versión:** v0.1.0
**Última actualización:** 2026-05-23
**Propósito:** clasificar cambios sobre el repositorio en tres niveles de riesgo (verde / amarillo / rojo), definir qué requiere cada nivel y cómo se ejecuta el protocolo de cambio.
**Documento maestro:** [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md) §14.
**Lecturas relacionadas:** [AGENTS.md](../AGENTS.md), [CLAUDE.md](../CLAUDE.md), [01_METODOLOGIA.md](01_METODOLOGIA.md), [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md), [06_NEUTRALIDAD.md](06_NEUTRALIDAD.md), [09_AUDITORIA.md](09_AUDITORIA.md).

---

## 1. Principio rector

Cada modificación al repositorio se clasifica antes de ejecutarse. La clasificación determina:

- qué tests corren;
- qué documentación se actualiza;
- qué revisión humana se requiere;
- si exige un ADR;
- si exige bump de versión (panel, metodología, hallazgos).

> **Regla maestra**: si dudás entre dos colores, **subís** el color. Un cambio amarillo tratado como verde puede contaminar el panel; un verde tratado como amarillo solo cuesta diez minutos extra de revisión.

---

## 2. Cómo clasificar un cambio

Antes de ejecutar, responder en este orden:

```text
1. ¿El cambio toca una zona crítica (§3)? → ROJO automático.
2. ¿El cambio afecta una cifra publicada? → ROJO.
3. ¿El cambio altera lenguaje policy o un hallazgo? → ROJO o AMARILLO según §5.
4. ¿El cambio agrega contenido nuevo (figura, párrafo, página) sin cambiar cifras? → AMARILLO.
5. ¿El cambio es cosmético o documentación no metodológica? → VERDE.
6. Si dudás → subir un nivel.
```

Si el cambio combina niveles (e.g., agrega párrafo nuevo Y cambia una cifra), **prevalece el más alto**.

---

## 3. Zonas críticas del repositorio

Tocar cualquier archivo o ruta de esta lista es **ROJO automático**:

```text
01_data/processed/panel_v12.rds            (y sucesores del panel)
02_code/03_construct/*                     construcción del panel
02_code/07_pse/*                           cálculo PSE/CSE
02_code/08_scenarios/*                     escenarios de repurposing
04_HALLAZGOS.md                               los 8 hallazgos
01_METODOLOGIA.md                             definiciones, fórmulas, supuestos
02_INDICADORES.md                             diccionario del panel (176 vars)
03_FUENTES.md                                 fuentes crudas + licencias
06_NEUTRALIDAD.md                             reglas de lenguaje (vocabulario)
05_ESTILO_NARRATIVO.md §3 y §3.24             anti-IA + capa ES
.agent/policies/*.yml                      policy-as-code
.agent/decisions/ADR-*.md                  decisiones congeladas
04_report/05_spending_analysis.qmd         si cambia una cifra del PSE
04_report/06_recommendations.qmd           si cambia un escenario
appendix/methodological-annex-*.qmd        notas metodológicas
00_admin/cartas_MEFP/*                     correspondencia oficial
```

---

## 4. Semáforo

### 4.1. VERDE

**Definición.** Cambios cosméticos, de documentación no metodológica, refactor sin cambio de comportamiento, o pruebas adicionales.

**Tipos:**

```text
typo / corrección ortográfica
ajuste de redacción que NO cambia el claim cuantitativo
mejora de alt-text que NO cambia la lectura técnica
reformateo visual (Quarto, CSS, layout)
notas marginales / comentarios en código
agregar referencias bibliográficas a entradas ya citadas
ajustes de bibliografía sin cambiar la cita en texto
refactor de scripts sin cambiar outputs
agregar tests adicionales (sin cambiar tests existentes)
mejorar mensajes de error de scripts
actualizar README.md (sección no metodológica)
actualizar CONTRIBUTING.md
```

**Requisitos.**

```text
[ ] commit con mensaje descriptivo
[ ] render quarto pasa (si se tocó archivo del book o web)
[ ] sin nueva entrada en HALLAZGOS / METODOLOGIA / INDICADORES
```

**Pruebas mínimas.**

```text
- render local del archivo modificado
- linter de markdown si aplica
- pre-flight anti-IA §3 si se modificó prosa (incluso si es cosmética)
```

**ADR.** No requerido.

**Revisor.** Auto-aprobación es aceptable. Recomendado: una segunda lectura antes del push si la prosa cambió.

---

### 4.2. AMARILLO

**Definición.** Cambios que **agregan** capacidad, contenido o conexión sin modificar definiciones, ponderadores, filtros, hallazgos ni cifras publicadas.

**Tipos:**

```text
nueva figura o tabla a partir de panel v12 existente
nueva tabla calculada con variables del panel ya documentadas
nuevo párrafo TEEL sustantivo en un capítulo existente
nueva sección dentro de un capítulo (sin cambiar el outline aprobado)
nueva referencia bibliográfica con cita nueva en texto
nuevo slide en deck existente
nueva página en el sitio público (que no cambia claims existentes)
nueva variante TEEL documentada en §8 de ESTILO_NARRATIVO
nuevo ejemplo en ESTILO_NARRATIVO §11
ampliación de lista NEVER WRITE (§3.3 o §3.24.1) sin remover entradas
ampliación de lista de tropos / anglicismos / zombies
ampliación de tests automáticos
nuevo callout metodológico en capítulo (con cita verificada)
nuevo brief ejecutivo derivado del book
ajuste de captions / alt-text que mejora precisión sin cambiar claim
incorporación de fuente bibliográfica revisada por pares ya conocida
agregar carpeta de outputs derivados (PDFs, imágenes exportadas)
agregar archivos a 00_admin/ (actas internas, agendas)
ajustes a CLAUDE.md / AGENTS.md que no cambien invariantes
```

**Requisitos.**

```text
[ ] commit con mensaje descriptivo y referencia a hallazgo/capítulo si aplica
[ ] render quarto del book + web pasa
[ ] pre-flight anti-IA §3 corrido y reportado en el cierre de sesión
[ ] AI-likelihood score ≤ 3 (EN) o ≤ 2 (ES) — ver ESTILO §3.10 y §3.24.11
[ ] toda cifra nueva con trazabilidad (RDS + script + variable + período + fuente cruda)
[ ] toda figura nueva con caption + alt-text (ES y EN si bilingüe)
[ ] toda cita nueva con entrada en references.bib y DOI/URL verificada
[ ] enlaces internos verificados
[ ] update de RETOMAR.md con la sesión cerrada
```

**Pruebas mínimas.**

```text
- render local + render CI del archivo afectado
- pre-flight anti-IA (§3.4 de ESTILO_NARRATIVO)
- verificación anti-alucinación (§3.19 de ESTILO_NARRATIVO):
    cifras → RDS, citas → bib, programas → fuente oficial
- bilingual parity si el cambio toca contenido bilingüe
- checklist por párrafo (§12 de ESTILO_NARRATIVO) en cada párrafo nuevo
```

**ADR.** No requerido salvo que el agregado sea recurrente y vaya a convertirse en patrón (entonces sí, para fijar el patrón).

**Revisor.** Una persona del equipo APER (no el autor del cambio) revisa antes del push. Tipo de revisión: lectura completa del bloque modificado + checklist §12.

---

### 4.3. ROJO

**Definición.** Cambios que afectan **definiciones, ponderadores, filtros, fórmulas, hallazgos, escenarios, neutralidad, anonimización conceptual, seguridad de datos, acceso a originales, o cualquier cifra ya publicada**.

**Tipos:**

```text
cambio en definición de variable del panel
cambio en construcción del panel (nuevo filtro, nuevo merge, nueva fuente)
nueva variable en el panel
versionamiento del panel (v12 → v13)
cambio en metodología PSE/CSE
cambio en ponderadores, elasticidades, supuestos de escenarios
cambio en fórmula de cualquier indicador
adición, modificación o retiro de un hallazgo
cambio en escenario de repurposing (composición, supuestos, banda)
incorporación de fuente nueva no revisada previamente
cambio en 06_NEUTRALIDAD.md (vocabulario)
cambio en ESTILO_NARRATIVO §3 (banderas anti-IA) o §3.24 (capa ES)
cambio en estructura TEEL canónica (§2 de ESTILO)
cambio en lenguaje de cierre de capítulo / disclaimer obligatorio
cambio en cualquier cifra ya publicada en book, web, slides o briefs
cambio en alcance del reporte (qué países, qué años, qué sectores)
cambio en outline de capítulos
cambio en interpretación de un hallazgo (no la magnitud, el "qué significa")
incorporación de comentario MEFP que afecta cifras o claims
cambio en política de acceso a datos
cambio en 08_CONTROL.md mismo (este archivo)
cambio en AGENTS.md sobre invariantes o zonas críticas
cambio en lista de archivos críticos (§3 de este 08_CONTROL.md)
```

**Requisitos.**

```text
[ ] ADR en .agent/decisions/ADR-NNNN_<titulo>.md (ver §6)
[ ] update de 01_METODOLOGIA.md / 04_HALLAZGOS.md / 02_INDICADORES.md / 03_FUENTES.md según aplique
[ ] bump de versión del panel y/o metodología y/o hallazgo afectado (ver §7)
[ ] revisión humana de al menos UN revisor senior (TTL o equivalente)
[ ] registro en 09_AUDITORIA.md (cuando exista) o nota de cambio en RETOMAR.md
[ ] tests críticos pasan (ver pruebas mínimas)
[ ] toda figura/tabla/slide derivada regenerada y verificada
[ ] consistencia book ↔ web ↔ slides ↔ briefs verificada después del cambio
[ ] sección de cambio en el handoff MEFP si aplica
[ ] disclaimer técnico revisado si el cambio afecta el alcance del reporte
```

**Pruebas mínimas.**

```text
- pre-flight anti-IA (§3.4 completo)
- AI-likelihood score reportado por idioma
- reproducibility test: renv::restore() limpio + quarto render del book completo
- traceability audit completo (cada cifra del capítulo afectado)
- consistency audit: cifras book ↔ web ↔ slides ↔ briefs
- bilingual parity completo (ES ↔ EN) en executive summary y en bloque afectado
- sensitivity check si el cambio toca PSE/CSE o escenarios
- revisión humana documentada (con nombre del revisor y fecha)
- diff revisado línea por línea por el revisor
- verificación anti-alucinación reforzada para cifras nuevas
```

**ADR.** **Obligatorio.** Plantilla en §6.

**Revisor.** Al menos un revisor senior del equipo APER (TTL o co-TTL). Para cambios que afectan PSE/CSE o escenarios de repurposing: revisión adicional del consultor PSE cuando ya esté en el equipo.

**Bump de versión.** Ver §7.

---

## 5. Casos límite y desambiguación

Tres preguntas para resolver clasificaciones ambiguas:

### 5.1. "¿Esto cambia una cifra publicada?"

- **Sí, aunque el cambio sea de definición que no altera el número final**: ROJO. (El reproducer es distinto, el lineage cambia.)
- **No, pero agrega una cifra nueva**: AMARILLO.
- **No, es solo redacción alrededor de la cifra**: VERDE si no cambia el claim; AMARILLO si lo matiza.

### 5.2. "¿Esto cambia un hallazgo?"

- **Cambia la magnitud, la dirección o la interpretación**: ROJO.
- **Cambia solo el wording sin cambiar el claim ni la magnitud**: AMARILLO.
- **Cambia solo el alt-text bilingüe del hallazgo**: VERDE si la lectura técnica se mantiene.

### 5.3. "¿Esto toca el panel?"

- **Construye nuevas variables o filtros**: ROJO.
- **Lee del panel sin alterarlo, para una nueva figura**: AMARILLO.
- **Solo lee con el mismo filtro ya usado en otra figura**: AMARILLO bajo (revisión rápida).

### 5.4. Tabla de casos frecuentes

| Caso | Clasificación |
|---|---|
| Reescribir un párrafo TEEL existente, misma cifra | VERDE (si solo prosa) |
| Reescribir el mismo párrafo y agregar caveat metodológico | AMARILLO |
| Reescribir el párrafo y descubrir que la cifra cambia al recalcular | ROJO |
| Agregar figura nueva con script nuevo sobre panel v12 | AMARILLO |
| Agregar figura nueva que requiere variable nueva en panel | ROJO (toca construct) |
| Cambiar el deflactor del gasto real (e.g., IPC → PIB-deflactor) | ROJO + ADR |
| Cambiar el año base de comparación (2015 → 2018) | ROJO + ADR |
| Agregar una entrada a NEVER WRITE de ESTILO §3.3 | AMARILLO |
| Quitar una entrada de NEVER WRITE | ROJO (afecta gating) |
| Incorporar comentario MEFP que ajusta wording sin cambiar cifras | AMARILLO |
| Incorporar comentario MEFP que ajusta cifras | ROJO |
| Documentar nota de divergencia con MEFP en appendix | AMARILLO |
| Cambiar el orden de los capítulos del book | ROJO + ADR (afecta outline) |
| Renumerar secciones dentro de un capítulo | AMARILLO |
| Agregar idioma EN a una sección que estaba solo en ES | AMARILLO + paridad bilingüe |
| Cambiar el disclaimer técnico obligatorio (§23 master) | ROJO + ADR |
| Renombrar `panel_v12.rds` o moverlo de carpeta | ROJO (rompe scripts) |
| Agregar columna de metadato a un RDS sin tocar valores | AMARILLO |
| Cambiar la paleta de colores institucional de las figuras | AMARILLO |
| Cambiar el template Quarto del book | AMARILLO si no cambia layout sustantivo; ROJO si afecta numeración |

---

## 6. Plantilla de ADR

Todo cambio ROJO genera un ADR en `.agent/decisions/ADR-NNNN_<titulo>.md` con esta plantilla:

```markdown
# ADR-NNNN — <título corto>

**Estado:** propuesto | aceptado | rechazado | superseded by ADR-MMMM
**Fecha:** YYYY-MM-DD
**Autor(es):** <nombre, rol>
**Revisor(es):** <nombre, rol>
**Color de cambio:** rojo

## Contexto

¿Qué problema, oportunidad o restricción motiva esta decisión? ¿Qué se sabía
antes del cambio? ¿Qué cambió en el entorno?

## Decisión

Declaración explícita de lo que se decide. Una a tres frases.

## Alternativas consideradas

- Alternativa A — pros / contras
- Alternativa B — pros / contras
- Alternativa C — pros / contras (puede ser "no hacer nada")

## Consecuencias

- Sobre el panel: ...
- Sobre la metodología: ...
- Sobre los hallazgos: ...
- Sobre el handoff MEFP: ...
- Sobre la reproducibilidad: ...
- Sobre la trazabilidad: ...

## Implementación

- Archivos modificados: ...
- Tests añadidos / modificados: ...
- Bump de versión: panel v12 → v13 / metodología m0.4 → m0.5 / hallazgo F03 v1 → v2
- Plazo: ...

## Validación

¿Cómo sabremos que la decisión fue correcta? ¿Qué métrica, qué revisión,
qué fecha de re-evaluación?

## Referencias

- Issue / sesión que originó el cambio
- Literatura / fuentes
- ADRs relacionados
```

---

## 7. Política de versionamiento

| Artefacto | Esquema | Cuándo se bumpea |
|---|---|---|
| Panel | `v<n>` (v12, v13, …) | cambio en construcción, filtros, nueva variable, nueva fuente |
| Metodología | `m<major>.<minor>` (m0.4, m0.5, m1.0) | minor: ajuste a fórmula o supuesto; major: cambio de marco metodológico (e.g., adopción de nueva referencia OECD) |
| Hallazgos | `F<NN>` con `v<m>` interno | bump del `v` cuando cambia magnitud, dirección, o interpretación; el F sigue siendo el mismo |
| Escenarios | `S<NN>` con `v<m>` interno | igual que hallazgos |
| ESTILO_NARRATIVO | semver `vX.Y.Z` | Z: typo; Y: nueva subsección o lista; X: cambio estructural (e.g., reemplazo de TEEL) |
| NEUTRALIDAD | semver `vX.Y.Z` | igual |
| Master Prompt | semver `vX.Y.Z` | igual |

**Reglas duras:**

- El panel **nunca** se sobrescribe sin bump. `panel_v12.rds` y `panel_v13.rds` coexisten hasta que el ADR de migración cierre.
- Cualquier figura publicada lleva en su metadato (§7.2 contrato de figura del master) el `panel_version` y `methodology_version` con los que se construyó.
- Recompilar un capítulo con una versión nueva del panel **es ROJO** porque cambian cifras publicadas, aunque el código no haya cambiado.

---

## 8. Protocolo operativo por color

### 8.1. Flujo VERDE

```text
1. clasificar.
2. ejecutar cambio.
3. correr render local / linter / pre-flight anti-IA si tocó prosa.
4. commit + push.
5. (opcional) anotación corta en RETOMAR.md si la sesión cerró.
```

### 8.2. Flujo AMARILLO

```text
1. clasificar.
2. (opcional) plan corto: qué se va a agregar, dónde, con qué fuente.
3. ejecutar cambio.
4. trazabilidad de cifras nuevas (RDS + script + variable + período + fuente).
5. pre-flight anti-IA §3.4 completo.
6. render + tests mínimos AMARILLO (§4.2).
7. revisión de un par del equipo.
8. commit + push.
9. cierre de sesión en RETOMAR.md con bloque del formato §8 de AGENTS.md.
```

### 8.3. Flujo ROJO

```text
1. clasificar.
2. preflight: leer RETOMAR.md, 01_METODOLOGIA.md, 04_HALLAZGOS.md afectados.
3. abrir ADR en estado "propuesto" en .agent/decisions/.
4. discutir / iterar el ADR con el revisor senior antes de tocar código.
5. ejecutar cambio en una rama dedicada `red/ADR-NNNN-<slug>`.
6. bump de versión del artefacto afectado (panel, metodología, hallazgo).
7. regenerar TODAS las figuras/tablas/slides/web dependientes.
8. consistency audit book ↔ web ↔ slides ↔ briefs.
9. pre-flight anti-IA completo + AI-likelihood score por idioma.
10. tests críticos ROJO (§4.3).
11. revisor senior firma el ADR (estado "aceptado").
12. merge a main.
13. cierre de sesión en RETOMAR.md con bloque y enlace al ADR.
14. notificación al equipo APER y, si aplica, nota para el MEFP.
```

---

## 9. Bloqueos automáticos (CI gates a implementar)

Cuando se monten los workflows de CI, los siguientes gates **bloquean merge**:

```text
red_change_without_ADR:
  - condición: diff toca archivo de §3 (zona crítica) y no hay ADR nuevo en .agent/decisions/
  - acción: bloquear merge

figure_without_metadata:
  - condición: figura nueva sin contrato JSON (§7.2 master)
  - acción: bloquear merge

citation_without_bib:
  - condición: cita @key en texto sin entrada en references.bib
  - acción: bloquear merge

ai_likelihood_too_high:
  - condición: AI-likelihood score reportado ≥ 4 (EN) o ≥ 3 (ES)
  - acción: bloquear merge

unicode_hygiene_violation:
  - condición: detección de U+200B / U+00AD / U+FEFF en archivos del book
  - acción: bloquear merge

bilingual_parity_break:
  - condición: claim cuantitativo del executive summary ES ≠ EN
  - acción: bloquear merge

panel_version_mismatch:
  - condición: figura referencia panel_version != versión del último RDS publicado
  - acción: warning (no bloquea, pero requiere ADR si es deliberado)
```

---

## 10. Excepciones

Excepciones a este 08_CONTROL.md requieren ADR específico con justificación.

Excepciones razonables que pueden surgir:

- **Hotfix urgente** antes de presentación al MEFP: se puede ejecutar como AMARILLO con compromiso de ADR retrospectivo dentro de 48h.
- **Errata tipográfica en cifra publicada**: ROJO obligatorio incluso si parece menor, porque la cifra publicada cambia. ADR retrospectivo permitido si el equipo lo decide.
- **Renombre masivo de archivos por reorganización del repo**: ROJO bajo (no afecta cifras, pero rompe enlaces); ADR de migración requerido.

---

## 11. Cómo modificar este archivo

`08_CONTROL.md` es a su vez zona crítica (§3). Modificarlo es **ROJO** y requiere ADR.

Cambios típicos que disparan ROJO sobre `08_CONTROL.md`:

- agregar / quitar tipos en alguna lista del §4 (verde/amarillo/rojo);
- cambiar la lista de zonas críticas (§3);
- cambiar los gates de CI (§9);
- cambiar la plantilla de ADR (§6);
- cambiar la política de versionamiento (§7).

Cambios cosméticos sobre `08_CONTROL.md` (typos, ejemplos adicionales, mejor redacción) son AMARILLO si no cambian reglas.

---

## 12. Integración con el ecosistema de gobernanza

| Archivo | Relación con 08_CONTROL.md |
|---|---|
| [AGENTS.md](../AGENTS.md) §4 | declara zonas críticas; este archivo §3 las extiende y operacionaliza |
| [CLAUDE.md](../CLAUDE.md) §7 | reglas de lenguaje cuya modificación es ROJO según §4.3 |
| [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md) §14 | versión high-level de este semáforo; este archivo es la operacionalización |
| [01_METODOLOGIA.md](01_METODOLOGIA.md) | zona crítica; modificar = ROJO + ADR + bump |
| [04_HALLAZGOS.md](04_HALLAZGOS.md) | zona crítica; modificar = ROJO + ADR + bump del hallazgo |
| [02_INDICADORES.md](02_INDICADORES.md) | zona crítica; nueva variable del panel = ROJO + ADR |
| [03_FUENTES.md](03_FUENTES.md) | zona crítica; nueva fuente cruda = ROJO + ADR |
| [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md) §3, §3.24 | modificar listas anti-IA = AMARILLO si agrega, ROJO si quita |
| [06_NEUTRALIDAD.md](06_NEUTRALIDAD.md) | zona crítica; ROJO + ADR |
| [09_AUDITORIA.md](09_AUDITORIA.md) (pendiente) | recibe el log de cambios ROJOS y la firma de revisores |
| [RETOMAR.md](../00_admin/RETOMAR.md) | bitácora viva; cada sesión cierra acá con su color |

---

## 13. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: semáforo verde/amarillo/rojo, zonas críticas, plantilla ADR, política de versionamiento, gates CI propuestos, integración con ecosistema de gobernanza |
