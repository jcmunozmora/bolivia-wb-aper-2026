# 19_COMUNICACION.md — Canales, cadencia, voceros y crisis communication

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/19_COMUNICACION.md`
**Lecturas relacionadas:** [`11_EQUIPO.md`](11_EQUIPO.md), [`13_PUBLICACION.md`](13_PUBLICACION.md), [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md), [`16_INCIDENTES.md`](16_INCIDENTES.md).

> Un proyecto sin canales de comunicación claros se gestiona por correo electrónico — y se pierde. Este archivo evita eso.

---

## 1. Principio rector

1. **Una conversación, un canal.** Cada tipo de comunicación tiene su canal canónico.
2. **Trazabilidad mínima.** Decisiones se documentan; no quedan solo en la memoria de quien estuvo.
3. **Vocería única.** Hacia el público, hacia el MEFP, hacia los medios — el equipo habla con una sola voz.
4. **Cadencia respetada.** Los syncs ocurren en su día; las mesas técnicas son sagradas.

---

## 2. Canales canónicos

| Canal | Para qué | Quién participa | Trazabilidad |
|---|---|---|---|
| **Sync interno APER** | coordinación operativa semanal | equipo core (Círculo 1) | minuta corta en `00_admin/syncs/YYYY_MM_DD_sync.md` |
| **Mesa técnica MEFP** | validación técnica de cifras y hallazgos | TTL, co-TTL, MEFP contraparte | minuta en `00_admin/mesas_tecnicas/YYYY_MM_DD_minuta.md` (RESTRINGIDA) |
| **Sync con STC PSE** | coordinación con consultor PSE | TTL + STC | minuta corta `00_admin/syncs/stc_pse_<fecha>.md` |
| **Revisión de riesgos** | actualización del registro `10_RIESGOS.md` | TTL + equipo | rollup mensual `00_admin/risk_review_YYYY_MM.md` |
| **Email formal** | comunicación oficial WB ↔ MEFP, cartas, embargos | TTL + co-TTL como remitentes; contrapartes nombradas como destinatarios | archivo en `00_admin/cartas/` |
| **GitHub Issues** | tareas técnicas, bugs, mejoras | colaboradores del repo | issue tracker GitHub |
| **GitHub Discussions** | preguntas abiertas, decisiones por discutir | colaboradores | tracker |
| **Pull Requests** | revisión técnica de cambios ROJOS | revisor + autor | PR comments + tracker |
| **Chat interno** (Slack / Teams / WhatsApp) | preguntas rápidas no decisorias | equipo core | NO trazable; **no se documentan decisiones aquí** |
| **WB Communications** | press release, redes oficiales, prensa | TTL + Communications WB Bolivia | borradores en `00_admin/comms/` |

---

## 3. Cadencia

### 3.1. Tabla de cadencia

| Reunión / actividad | Frecuencia | Día / momento | Duración | Output |
|---|---|---|---|---|
| Sync interno APER | semanal | _[TODO_TRACE: martes 10:00]_ | 30–45 min | minuta |
| Mesa técnica MEFP | mensual (negociable a quincenal en periodo crítico) | acordado con MEFP | 60–90 min | minuta + acciones |
| Sync con STC PSE | quincenal durante consultoría | _[TODO_TRACE]_ | 30 min | minuta corta |
| Revisión de riesgos | mensual | última semana del mes | 30 min | rollup |
| Revisión retrospectiva trimestral | trimestral | _[TODO_TRACE]_ | 60 min | análisis + ajustes a gobernanza |
| Standup informal | diario opcional | inicio de día (15 min) | breve | sin minuta |
| Revisión release (A5) | hito | T-2 semanas pre-release | medio día | reporte A5 |

### 3.2. Reglas duras

```text
- los syncs no se cancelan; se posponen si imprescindible
- las mesas técnicas MEFP se documentan en minuta SIEMPRE, incluso si no
  hubo decisiones
- las minutas se distribuyen dentro de 24h del evento
- la cadencia se respeta; cambios estructurales requieren acuerdo del equipo
```

---

## 4. Voceros

### 4.1. Quién habla por el APER hacia afuera

| Audiencia externa | Vocero principal | Alterno |
|---|---|---|
| MEFP — comunicación técnica | TTL | co-TTL |
| MEFP — comunicación política / escalación | WB Country Manager | TTL |
| MDRyT, otras contrapartes técnicas bolivianas | TTL | co-TTL |
| Consultor STC | TTL | Líder técnico EAFIT |
| Peer reviewers externos | TTL | co-TTL |
| Medios — prensa general | WB Communications | TTL solo si Comms lo autoriza |
| Comunidad académica (consultas técnicas) | TTL | Líder técnico EAFIT |
| Sociedad civil organizada | TTL + WB Comms | n/a |
| Redes oficiales WB | WB Communications | n/a |

### 4.2. Reglas duras de vocería

```text
- nadie del equipo habla en medios a título personal sobre el APER 2026
  hasta el release; después del release: solo voceros designados.

- consultas técnicas (de académicos, otros equipos WB) pueden responderse
  por TTL o Líder EAFIT directamente, en escritura, con copia al otro;
  decisiones no se toman sin sync interno.

- en EVENTO PÚBLICO con audiencia mixta (gobierno + academia + sociedad
  civil): el TTL representa al equipo; otros pueden asistir como
  audiencia.

- en CRISIS de comunicación (16_INCIDENTES §5.5): solo TTL + WB
  Communications + WB Country Manager hablan; el resto del equipo
  redirige preguntas a ellos.
```

---

## 5. Mesa técnica MEFP — protocolo

### 5.1. Antes de la mesa

```text
[ ] agenda compartida con MEFP ≥ 5 días antes
[ ] paquete técnico (borrador del bloque a discutir) enviado ≥ 3 días antes
    con watermark "Borrador bajo embargo — para revisión técnica"
[ ] objetivos claros: qué se busca de esta mesa (validación, escalación,
    feedback)
```

### 5.2. Durante la mesa

```text
[ ] una persona designada toma minuta
[ ] todas las objeciones MEFP se anotan con atribución a rol (no a
    persona política)
[ ] decisiones se confirman al cierre con "¿este es el acuerdo?"
[ ] acciones pendientes se asignan con owner y plazo
```

### 5.3. Después de la mesa

```text
[ ] minuta circulada al equipo APER (INTERNO) en 24h
[ ] minuta enviada a MEFP para validación en 48h (versión final)
[ ] acciones derivadas creadas como entradas en RETOMAR.md o issues GitHub
[ ] si hubo objeciones que afectan cifras: protocolo HALLAZGOS §6.4
    (incorporar si hay fuente; documentar divergencia si no)
[ ] si la mesa generó un riesgo nuevo: agregar a 10_RIESGOS
```

### 5.4. Plantilla de minuta

```markdown
# Minuta — Mesa técnica MEFP — YYYY-MM-DD

**Clasificación:** RESTRINGIDO (14_CONFIDENCIALIDAD.md)

## Participantes

- WB: TTL <nombre>, co-TTL <nombre>
- MEFP: <rol> <nombre>, <rol> <nombre>
- Otros: <STC PSE si aplica>

## Agenda

1. ...
2. ...

## Resumen de discusión

### Tema 1: <título>

- punto de discusión
- posición MEFP
- posición equipo APER
- decisión (si la hubo)

## Acuerdos

| # | Acuerdo | Owner | Plazo |
|---|---|---|---|
| 1 | ... | ... | ... |

## Acciones pendientes

| # | Acción | Owner APER | Owner MEFP | Plazo |
|---|---|---|---|---|
| 1 | ... | ... | ... | ... |

## Próxima mesa

Fecha tentativa: YYYY-MM-DD

## Firma

Minuta tomada por: <nombre>
Validada por: <TTL, fecha>
Acuse de recibo MEFP: <nombre, rol, fecha>
```

Versión RESTRINGIDA queda en `00_admin/mesas_tecnicas/`. Versión INTERNA (anonimizada / agregada) puede archivarse aparte si el contenido lo permite.

---

## 6. Distribución de borradores

Detalle en `14_CONFIDENCIALIDAD §8`. Resumen:

| Audiencia | Versión | Canal | Watermark |
|---|---|---|---|
| Equipo APER core | actual sin restricción | repo o OneDrive equipo | "DRAFT — internal" |
| Peer reviewer interno WB | post-A3 | OneDrive con permiso temporal | "DRAFT — peer review only" |
| MEFP (mesa técnica) | post-A4 | acordado con MEFP (email + portal) | "Borrador bajo embargo" |
| Público | nunca pre-release | n/a | n/a |

---

## 7. Q&A canónico (preparar antes del release)

Antes del release, el equipo prepara un Q&A escrito que cubre las preguntas anticipadas. Este Q&A:

- alinea las respuestas de los voceros designados;
- evita respuestas improvisadas en eventos públicos;
- mantiene neutralidad técnica.

### 7.1. Plantilla de Q&A

```markdown
# Q&A Canónico — APER Bolivia 2026 vX.Y.Z

**Audiencias:** prensa general, MEFP, comunidad académica, sociedad civil
**Fecha de actualización:** YYYY-MM-DD
**Vocero principal:** TTL
**Vocero alterno:** co-TTL

## Q1: ¿Qué es el APER 2026?

<respuesta de 3-5 líneas, alineada con NEUTRALIDAD §11>

## Q2: ¿El WB recomienda a Bolivia hacer X?

R: El reporte no recomienda; documenta evidencia técnica y presenta
opciones técnicas para consideración del MEFP. Las decisiones son del
Estado Plurinacional de Bolivia.

## Q3: ¿Por qué publica el WB un reporte sobre el gasto agrícola?

<respuesta>

## Q4: ¿Quién financió el reporte?

<respuesta — fuente de financiamiento WB declarada en Acknowledgments>

## Q5: ¿Cómo se aseguraron de la neutralidad?

R: Mediante un sistema de gobernanza documentado en .agent/, que incluye
reglas de lenguaje (NEUTRALIDAD), anti-IA (ESTILO §3), trazabilidad
cifra-a-fuente, y un comité de auditoría A1-A5. El reporte presenta
evidencia, no advocacy.

## Q6: ¿Por qué la cifra X es Y%? ¿No debería ser Z%?

R: La cifra X es Y% según el panel v12 (m0.1.0), calculada con
metodología documentada en METODOLOGIA.md §<...>. La incertidumbre se
declara en HALLAZGOS.md (nivel <...>). Para una discusión técnica
detallada, ver capítulo <NN> y apéndice <Ax>.

## Q7: ¿Qué pasa si Bolivia no adopta las opciones del cap. 6?

R: Las opciones son técnicas, no prescriptivas. La adopción es decisión
soberana del MEFP. El reporte queda como herramienta de referencia
técnica.

## Q8: ¿Se actualizará este reporte?

R: Errata o ajustes menores: versionado en vX.Y.Z. Próximo ciclo APER:
3-5 años (decisión institucional WB-Bolivia).

## Q9: ¿Dónde se accede a los datos?

R: Panel v12 publicado bajo CC-BY 4.0 en Zenodo (DOI <...>). Scripts en
GitHub (link). Citación canónica en PUBLICACION §7.

## Q10: ¿Cómo se contacta al equipo APER?

R: Consultas técnicas: <correo institucional canónico>. Consultas de
prensa: vía WB Communications Bolivia <correo>.
```

---

## 8. Comunicación pública

### 8.1. Release

Detallado en `13_PUBLICACION §10`. Resumen:

- página de release en sitio público con resumen, links de descarga, Q&A
- nota en sitio WB Bolivia office
- distribución a stakeholders del Círculo 2 + 3 (`11_EQUIPO §2`)
- press release coordinado con WB Comms (si se decide)

### 8.2. Post-release

```text
- monitoreo de menciones / citaciones
- respuesta a consultas técnicas vía canal canónico (vocero)
- tracking de descargas (Zenodo + GitHub) sin tracking de usuarios
- si surge errata o distorsión: protocolo 16_INCIDENTES.md
```

### 8.3. Eventos públicos

Si el equipo participa en evento público presentando el APER:

```text
[ ] Q&A canónico revisado y compartido con voceros
[ ] slides ejecutivas usadas (no improvisar slides nuevos)
[ ] disclaimer técnico §23 leído al inicio
[ ] grabación archivada si el evento lo permite
[ ] preguntas no respondibles en el momento → "respondemos por escrito"
```

---

## 9. Crisis communication

Cuando aplica:

```text
- errata mayor (P0) descubierta tras publicación
- brecha de confidencialidad
- distorsión mediática de magnitud
- objeción pública del MEFP al reporte
```

### 9.1. Quién decide

```text
- TTL convoca
- WB Country Manager autoriza comunicación pública
- WB Communications redacta nota oficial
- equipo APER provee insumo técnico
```

### 9.2. Plazos

| Severidad | Comunicación interna | Comunicación MEFP | Comunicación pública |
|---|---|---|---|
| P0 | < 4h | < 24h | < 48h (si requerida) |
| P1 | < 24h | < 72h | próxima minor |
| P2 | siguiente sync | en mesa técnica próxima | siguiente minor |

### 9.3. Reglas

```text
- mientras se prepara la respuesta oficial: equipo NO responde
  preguntas externas; redirige a vocero o a "respuesta oficial en breve"
- nunca pedir disculpas reflexivas ("we sincerely apologize") como muletilla;
  reconocer el error, explicar la corrección, presentar acción derivada
- nunca culpar a personas; el sistema mejora (alineado con 16_INCIDENTES §7)
- después de la crisis: post-mortem documentado en 00_admin/incidents/
```

---

## 10. Comunicaciones internas — buenas prácticas

```text
- preguntas rápidas → chat (no documentadas)
- decisiones → email o sync con minuta
- urgencia real → mencionar TTL directamente
- "para tu información" → email; no esperan respuesta
- "para tu decisión" → email + sync; esperan respuesta con plazo
- temas que tocan ROJO → no se deciden en chat; van a sync formal
```

---

## 11. Reglas de email institucional

```text
- TO: destinatarios principales (acción requerida)
- CC: stakeholders informados
- BCC: solo cuando hay razón explícita (lista grande de destinatarios)
- nunca CC a una lista masiva del WB para "cobertura"
- asunto descriptivo: "[APER 2026] <tema>"
- versionado: si reenviás versión nueva del mismo asunto, marcar "(v2)"
- archivo: comunicaciones formales con MEFP se archivan en 00_admin/cartas/
```

---

## 12. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `11_EQUIPO.md` | Voceros §4 derivan del stakeholder map §2 |
| `13_PUBLICACION.md` | §10 comunicación pública del release y §9 vocería |
| `14_CONFIDENCIALIDAD.md` | Minutas mesa técnica son RESTRINGIDAS |
| `16_INCIDENTES.md` | Crisis communication §5.5 + §9 de este archivo |
| `08_CONTROL.md` | Cambios a este archivo son AMARILLO típicamente; ROJO si tocan vocería oficial |
| `00_admin/syncs/`, `00_admin/mesas_tecnicas/`, `00_admin/comms/` | repositorios operativos |

---

## 13. TODOs para alcanzar v1.0

- [ ] Confirmar día/hora del sync interno semanal del equipo (`[TODO_TRACE]`).
- [ ] Confirmar cadencia de mesa técnica con MEFP en próxima reunión.
- [ ] Crear `00_admin/syncs/` con README.
- [ ] Crear plantilla de minuta MEFP como template archivo.
- [ ] Preparar Q&A canónico inicial (4 semanas antes del release).
- [ ] Definir correo institucional canónico para consultas (`aper-bolivia@worldbank.org` o similar).
- [ ] Coordinar con WB Comms el press release del próximo release.
- [ ] Convención de asunto de email "[APER 2026] ..." adoptada por el equipo.

---

## 14. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: 10 canales canónicos, cadencia (sync semanal + mesa MEFP + sync STC + revisión riesgos), voceros por audiencia, protocolo de mesa técnica MEFP con plantilla, distribución de borradores con watermark, Q&A canónico con 10 preguntas anticipadas, comunicación pública del release, crisis communication, reglas de email |
