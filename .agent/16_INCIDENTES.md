# 16_INCIDENTES.md — Protocolo de incidentes y errata post-publicación

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/16_INCIDENTES.md`
**Marco de referencia:** SRE incident management (Google blameless post-mortem), ICMJE editorial corrections, COPE retraction guidelines, ISO 22301 (business continuity).
**Lecturas relacionadas:** [`10_RIESGOS.md`](10_RIESGOS.md), [`08_CONTROL.md`](08_CONTROL.md), [`09_AUDITORIA.md`](09_AUDITORIA.md), [`13_PUBLICACION.md`](13_PUBLICACION.md), [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md), [`15_SEGURIDAD.md`](15_SEGURIDAD.md).

> Un incidente no documentado se repite. Un incidente bien gestionado fortalece el sistema.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **Transparencia interna sin culpabilización.** Post-mortems son blameless. El sistema falla, no las personas.
2. **Visibilidad externa proporcional.** Errata de cifra publicada se anuncia; typo se corrige silenciosamente.
3. **Versionamiento de la corrección.** Una errata produce nueva versión del producto afectado, no edición sobre la versión publicada.
4. **Cierre formal.** Cada incidente cierra con acciones derivadas que reduzcan probabilidad de recurrencia.

---

## 2. Tipos de incidente

| ID | Categoría | Descripción | Severidad típica |
|---|---|---|---|
| T-01 | Errata tipográfica | typo, acento, formato de número incorrecto sin cambiar el valor | P2 / P3 |
| T-02 | Errata de cifra (mayor) | cifra publicada que cambia magnitud, dirección o interpretación de un hallazgo | **P0** |
| T-03 | Errata de cifra (menor) | cifra publicada incorrecta sin cambiar interpretación general | P1 |
| T-04 | Hallazgo invalidado | un hallazgo entero deja de sostenerse (panel rebuild, fuente retractada, error metodológico) | **P0** |
| T-05 | Fuente cruda retractada o revisada | la fuente upstream cambia su serie histórica, afectando cifras publicadas | P0 / P1 |
| T-06 | Brecha de confidencialidad | borrador, minuta, COI, credencial filtrado fuera de su nivel | **P0** |
| T-07 | Citación o atribución incorrecta | autor mal atribuido, DOI inexistente, atribución CC-BY ausente | P1 / P2 |
| T-08 | Reproducibilidad rota | rebuild en máquina limpia no reproduce cifras publicadas | P1 |
| T-09 | Sitio público caído o producto inaccesible | GitHub Pages down, Zenodo deposit perdido, PDF corrupto | P1 / P2 |
| T-10 | Distorsión / mala interpretación pública | medios o stakeholders reinterpretan el reporte fuera de su alcance técnico | P1 / P2 |
| T-11 | Incidente de equipo | salida abrupta, conflicto interno, COI no declarado descubierto | P1 |
| T-12 | Incidente legal | reclamo de atribución, infracción de licencia, embargo violado | P1 / P2 |

---

## 3. Matriz de severidad

```text
P0 — CRÍTICO
  - cifra del executive summary o hallazgo principal incorrecta
  - hallazgo entero invalidado
  - brecha que expone datos RESTRINGIDOS
  - violación pública del embargo MEFP
  → respuesta inmediata; comunicación MEFP en 24h; errata visible

P1 — MAYOR
  - cifra incorrecta en capítulo (no en exec summary)
  - reproducibilidad rota en producto publicado
  - atribución faltante en figura publicada
  - distorsión pública grave
  → respuesta en 72h; comunicación según contexto; errata en próxima
    actualización menor

P2 — MEDIO
  - typo en wording que confunde al lector
  - link interno roto
  - inconsistencia book ↔ web ↔ slides cosmética
  → respuesta en 1–2 semanas; corrección silenciosa o en próxima minor

P3 — MENOR
  - ajuste cosmético sin afecto a lectura
  → siguiente release ordinaria; sin urgencia
```

---

## 4. Esquema del registro de incidentes

Cada incidente se documenta como bloque YAML + prosa breve:

```yaml
---
incident_id: I-NNNN
type: T-NN
title: <título descriptivo>
severity: P0 | P1 | P2 | P3
status: open | investigating | mitigating | resolved | closed
opened_date: YYYY-MM-DD HH:MM
opened_by: <nombre, rol>
closed_date: YYYY-MM-DD HH:MM
artifact_affected: <book, web, slides, brief, panel, etc.>
artifact_version: <vX.Y.Z>
detected_by: <quién encontró el problema>
detection_channel: <revisión interna, MEFP, peer reviewer, lector público, monitor automático>
related_risk: <R-NNN si materializa riesgo del registro 10_RIESGOS.md>
related_ADR: <ADR-NNNN si requiere uno>
---

## Descripción

<qué pasó; cuándo se detectó; alcance>

## Impacto

<qué cifra, qué claim, qué audiencia se vio afectada>

## Mitigación inmediata

<acciones tomadas en las primeras horas>

## Acciones correctivas

<corrección de fondo: errata, bump de versión, ADR, etc.>

## Comunicación

<a quién se notificó; cuándo; con qué mensaje>

## Post-mortem

<causa raíz; gap del proceso; lecciones; acciones derivadas para prevenir recurrencia>

## Cierre

<fecha; firma del responsable de cierre>
```

---

## 5. Protocolo por tipo (los críticos)

### 5.1. T-02 / T-03 — Errata de cifra publicada

```text
DETECCIÓN
  - por revisión interna (audit retrospectivo)
  - por MEFP (mesa post-publicación)
  - por peer reviewer
  - por lector público
  - por re-run de reproducibilidad

PRIMERAS 24h (P0) o 72h (P1)
  1. confirmar la errata (trazar cifra → panel → fuente; correr rebuild)
  2. notificar al TTL inmediatamente
  3. clasificar severidad (P0 vs P1)
  4. preparar borrador de errata formal

ACCIONES CORRECTIVAS (P0)
  5. ADR de la corrección (qué cambia, por qué, qué disparó la corrección)
  6. bump del reporte: vX.Y.Z → vX.Y.(Z+1) si la cifra está en producto
     publicado; vX.(Y+1).0 si afecta hallazgo
  7. actualizar HALLAZGOS.md con bump de versión del hallazgo afectado
  8. regenerar figuras / tablas / slides / briefs dependientes
  9. A3 retrospectiva al capítulo afectado
  10. notificación formal MEFP en 24h con la errata
  11. errata visible en el sitio público:
      - banner en la página de la figura/hallazgo afectado
      - sección "Erratas" en home del sitio
      - issue en GitHub con tag `erratum-P0`
  12. press release / nota pública si la cifra fue ampliamente difundida

ACCIONES CORRECTIVAS (P1)
  5–10 igual que P0
  11. errata en la próxima actualización menor (v1.0.X)
  12. nota en sitio sin banner principal; lista de erratas accesible

POST-MORTEM (P0 y P1 obligatorio)
  - blameless: ¿qué falló del proceso?
  - ¿por qué A5 no lo detectó?
  - ¿qué test agregar a AUDITORIA.md para prevenir?
  - ¿requiere bump de ESTILO_NARRATIVO o CONTROL para reforzar?
```

### 5.2. T-04 — Hallazgo invalidado

```text
EVALUACIÓN PREVIA (no es urgencia inmediata salvo P0 evidente)
  - ¿el hallazgo se sostiene parcialmente?
  - ¿se trata de re-clasificar (e.g. de "F03 confirmado" a "F03 sujeto a
    revisión") o de retirar completamente?

ACCIONES
  1. ADR de invalidación
  2. status del hallazgo en HALLAZGOS.md: → `retired` o `contested`
  3. nota visible en la página del hallazgo afectado en sitio público
  4. comunicación MEFP (mesa técnica especial si es P0)
  5. bump del reporte: típicamente minor (v1.X.0) por la magnitud del cambio
  6. preservar versión retirada en el histórico de HALLAZGOS.md §9
  7. post-mortem: ¿cómo llegó este hallazgo al release?
     ¿qué A3/A4/A5 falló?
```

### 5.3. T-05 — Fuente retractada o revisada upstream

```text
EVALUACIÓN
  - ¿la revisión cambia magnitudes en cifras publicadas?
  - ¿bug upstream o decisión metodológica nueva?
  - cuantificar impacto antes de actuar

ACCIONES
  1. documentar la revisión upstream con fecha y enlace
  2. correr rebuild con datos nuevos para cuantificar delta
  3. si delta significativo:
      - tratar como T-03 o T-02 según magnitud
      - ADR de migración a fuente revisada
      - bump panel (v12 → v13)
      - regenerar productos afectados
  4. si delta despreciable:
      - documentar en METODOLOGIA.md como nota de "fuente actualizada en
        fecha X; impacto < ε; cifras publicadas se mantienen con caveat"
      - próximo APER incorporará la versión actualizada
```

### 5.4. T-06 — Brecha de confidencialidad

```text
SEVERIDAD: P0 automático

PRIMERAS HORAS
  1. contener: revocar acceso, retirar el contenido del canal donde se filtró
  2. evaluar alcance: ¿qué nivel filtró? ¿quién lo vio?
  3. si credencial: protocolo 15_SEGURIDAD §5.1 (rotar + auditar uso)
  4. si dato RESTRINGIDO: notificar a personas afectadas en 24h
  5. notificación TTL + WB Country Manager
  6. si afecta MEFP: comunicación formal en 48h
  7. evaluar si activar protocolo legal WB

POST-MORTEM
  - causa raíz (proceso, configuración, error humano)
  - gap en 14_CONFIDENCIALIDAD o 15_SEGURIDAD
  - actualización de hooks, .gitignore, política
```

### 5.5. T-10 — Distorsión / mala interpretación pública

```text
EVALUACIÓN
  - ¿es interpretación legítima alternativa o distorsión de los claims?
  - ¿alcance: medios locales, redes, MEFP recibió la versión distorsionada?
  - ¿requiere respuesta o solo monitoreo?

ACCIONES (decisión del TTL)
  - respuesta pública: vocero oficial vía canal único (19_COMUNICACION.md)
  - respuesta privada: aclaración técnica al stakeholder específico
  - no-acción: solo si el alcance es marginal y la corrección amplificaría
    la distorsión
  - reforzar disclaimer técnico §23 en futuras comunicaciones
```

---

## 6. Errata formal vs corrección silenciosa

| Tipo de cambio | Cómo se trata |
|---|---|
| Cifra publicada incorrecta (P0/P1) | **Errata formal** — banner visible, ADR, bump versión, comunicación MEFP |
| Interpretación que necesita matiz | Errata formal — nota visible aunque sin bump si no cambia magnitud |
| Typo en cifra (e.g. "$1,4%" en vez de "1,4%") sin cambiar el número | Corrección silenciosa — próxima versión menor |
| Link interno roto | Corrección silenciosa |
| Atribución CC-BY faltante | Errata visible — agregar atribución en página afectada + nota |
| Reescritura de párrafo para mejor claridad sin cambiar claim | Sin tratamiento de errata; va al CHANGELOG de la próxima versión |
| Reformato cosmético de figura | Silencioso |

### 6.1. Plantilla de errata visible

```markdown
> **Errata (YYYY-MM-DD).** En la versión vX.Y.Z, la figura/tabla/párrafo
> [referencia] indicaba [cifra/claim incorrecto]. La cifra correcta es
> [cifra correcta]. Esta corrección no cambia [opcional: la interpretación
> general / el hallazgo F0X / etc.]. Versión corregida: vX.Y.Z+1.
> Fuente del error: [breve causa]. Ver ADR-NNNN.
```

---

## 7. Post-mortem blameless

Cuando es obligatorio: P0 y P1 siempre. P2 a discreción del TTL.

### 7.1. Plantilla

```markdown
# Post-mortem I-NNNN — <título>

**Severidad:** P0 | P1 | P2
**Fecha del incidente:** YYYY-MM-DD
**Fecha del post-mortem:** YYYY-MM-DD
**Facilitador:** <nombre>
**Participantes:** <equipo APER + revisores relevantes>

## Resumen ejecutivo (3 líneas)

<qué pasó; qué impacto tuvo; qué se hizo>

## Cronología

| Hora | Evento |
|---|---|
| HH:MM | ... |

## Causa raíz

<5 whys o equivalente; identificar el origen sistémico, no la persona>

## Lo que funcionó

<acciones del equipo que limitaron el impacto>

## Lo que no funcionó

<gaps del proceso, herramientas, o gobernanza>

## Acciones derivadas

| # | Acción | Owner | Plazo | Status |
|---|---|---|---|---|
| 1 | ... | ... | ... | open |

## Gobernanza afectada

¿Este incidente requiere modificar:
  - 08_CONTROL.md (semáforo)
  - 09_AUDITORIA.md (checklist)
  - 10_RIESGOS.md (registro de riesgos)
  - otros .agent/ files
?

## Firma

<facilitador, fecha>
```

### 7.2. Regla blameless

```text
EL POST-MORTEM ES SOBRE EL SISTEMA, NO SOBRE LAS PERSONAS.

  - "Juan no revisó la figura" → MAL
  - "El proceso A3 no incluyó verificación cruzada book ↔ slides" → BIEN
  - "Maria mal calculó la cifra" → MAL
  - "El script no validó el filtro temporal; output silenciosamente
     incluía datos fuera del período declarado" → BIEN

Si el factor humano es real (e.g. omisión deliberada, COI no declarado),
se trata en 11_EQUIPO §6 y NO en el post-mortem técnico.
```

---

## 8. Archivo de incidentes

```text
00_admin/incidents/
  README.md                              índice de incidentes
  I-0001_YYYY-MM-DD_<slug>.md            bloque + post-mortem
  I-0002_YYYY-MM-DD_<slug>.md
  ...
  rollup/
    rollup_2026_YYYY-MM.md               resumen mensual
```

Clasificación: **INTERNO** por default. Si involucra a MEFP o terceros, RESTRINGIDO hasta declassification post-cierre.

---

## 9. Comunicación durante incidentes

### 9.1. Audiencias y canales por severidad

| Severidad | Audiencias | Canal | Plazo |
|---|---|---|---|
| **P0** | TTL → co-TTL → equipo APER → MEFP → WB Country Manager → público (si aplica) | 1) chat interno equipo (sync inmediato); 2) email formal MEFP; 3) errata visible en sitio | acción en <4h, comunicación en <24h |
| **P1** | TTL → equipo → MEFP (si aplica) | email + entrada en sitio "erratas" | <72h |
| **P2** | TTL → equipo | sync semanal | próxima minor |
| **P3** | mención en sync | n/a | próxima minor |

### 9.2. Vocería

Detalles en `19_COMUNICACION.md`. Para incidentes:

```text
- Vocero único: TTL (alterno: co-TTL si TTL no disponible)
- Comunicaciones MEFP: vía contraparte técnica formal
- Comunicaciones públicas (medios): SOLO vía WB Communications, no
  directo desde equipo APER
- En P0: todo borrador de comunicación pasa por WB Country Manager antes
```

### 9.3. Q&A canónico para errata

Si la errata genera preguntas externas, el equipo prepara un Q&A breve:

```text
- ¿Qué cambió exactamente?
- ¿Cambia la interpretación principal del reporte? (sí / no — sé honesto)
- ¿Por qué ocurrió?
- ¿Qué medidas se toman para que no se repita?
- ¿Dónde se accede a la versión corregida?
```

---

## 10. Cierre de un incidente

Un incidente se cierra cuando:

```text
[ ] todas las acciones de mitigación están completas
[ ] post-mortem firmado (si requerido)
[ ] acciones derivadas asignadas con owner y plazo
[ ] errata publicada (si aplica)
[ ] HALLAZGOS / METODOLOGIA / panel actualizados (si aplica)
[ ] riesgo asociado en 10_RIESGOS revisado (cerrar o actualizar)
[ ] ADR firmado (si aplica)
[ ] entrada en 00_admin/incidents/ completa
[ ] notificación de cierre al equipo y stakeholders relevantes
```

---

## 11. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `10_RIESGOS.md` | Riesgo materializado → incidente; este archivo cierra el ciclo |
| `08_CONTROL.md` | Incidente puede requerir ADR + bump |
| `09_AUDITORIA.md` | Falla A5 → incidente; protocolo de falla §11 referencia este archivo |
| `13_PUBLICACION.md` | Errata afecta versionamiento del reporte |
| `14_CONFIDENCIALIDAD.md` | T-06 (brecha) usa políticas de ese archivo |
| `15_SEGURIDAD.md` | T-06 con credenciales aplica protocolo §5.1 de ese archivo |
| `04_HALLAZGOS.md` | T-02/T-03/T-04 disparan bump de hallazgo |
| `11_EQUIPO.md` | T-11 (incidente de equipo) sigue políticas de equipo |
| `00_admin/incidents/` | Repositorio operativo de incidentes |

---

## 12. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Agregar tipo de incidente §2 | AMARILLO |
| Cambiar matriz de severidad §3 | ROJO + ADR |
| Cambiar protocolo P0 §5 | ROJO + ADR |
| Cambiar política de errata formal vs silenciosa §6 | ROJO + ADR |
| Agregar plantilla / variación menor | VERDE |

---

## 13. TODOs para alcanzar v1.0

- [ ] Crear `00_admin/incidents/` con README explicando convenciones.
- [ ] Plantilla de post-mortem como archivo template en `00_admin/incidents/_template_postmortem.md`.
- [ ] Drill: simular un incidente P0 (errata) y correr el protocolo §5.1 como ejercicio.
- [ ] Definir SLA interno para tiempos de respuesta P0/P1.
- [ ] Capacitar al equipo en el protocolo (sesión interna).
- [ ] Vincular cada riesgo de 10_RIESGOS con la respuesta del incidente correspondiente si materializa.

---

## 14. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: 12 tipos de incidente, matriz de severidad P0-P3, esquema YAML del registro, protocolos detallados para errata de cifra / hallazgo invalidado / fuente retractada / brecha confidencialidad / distorsión pública, errata formal vs silenciosa con plantilla, post-mortem blameless con plantilla, archivo en `00_admin/incidents/`, comunicación por severidad |
