# 10_RIESGOS.md — Risk register del APER Bolivia 2026

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/10_RIESGOS.md`
**Marco de referencia:** ISO 31000:2018 (gestión de riesgos), adaptado a project research/policy.
**Lecturas relacionadas:** [`08_CONTROL.md`](08_CONTROL.md), [`09_AUDITORIA.md`](09_AUDITORIA.md), [`16_INCIDENTES.md`](16_INCIDENTES.md), [`../00_admin/ESTADO_DE_DATOS.md`](../00_admin/ESTADO_DE_DATOS.md).

> CONTROL clasifica cambios. AUDITORIA verifica. RIESGOS anticipa: qué puede fallar antes de que falle.

---

## 1. Principio rector

Tres afirmaciones:

1. **Un riesgo no documentado es un riesgo que va a ocurrir.** El registro existe para forzar la conversación anticipada, no para tranquilizar.
2. **Cada riesgo tiene dueño nombrado.** Sin dueño, no hay mitigación.
3. **El registro es vivo.** Se revisa cada mes; los riesgos cerrados quedan visibles con su resolución; los nuevos se agregan apenas se identifican.

---

## 2. Categorías de riesgo

```text
DATOS         acceso, calidad, retractación, gaps
METODOLOGIA   panel rebuild, cambio en marco OECD/MAFAP, fuente revisada
POLITICO      cambio MEFP, elecciones, agenda WB, contraparte ausente
EQUIPO        rotación, COI no declarado, capacidad limitada
TECNICO       pérdida de datos, reproducibilidad rota, infra caída
REPUTACIONAL  errata grave, percepción advocacy, cobertura mediática
CRONOGRAMA    delay MEFP, gap personal en periodo crítico
LEGAL         licencia, atribución, embargo violado
```

---

## 3. Esquema del registro

Cada riesgo es un bloque con esta estructura:

```yaml
---
risk_id: R-NNN
category: DATOS | METODOLOGIA | POLITICO | EQUIPO | TECNICO | REPUTACIONAL | CRONOGRAMA | LEGAL
title: <título corto>
description: |
  <qué puede ocurrir y por qué importa>
likelihood: low | medium | high
impact: low | medium | high
score: <1–9>     # likelihood × impact en matriz 3×3
owner: <nombre, rol>
mitigation:
  preventive: <acciones para reducir probabilidad>
  contingent: <acciones si el evento ocurre>
trigger: <señal observable que activa contingencia>
status: open | mitigating | monitoring | closed
opened_date: YYYY-MM-DD
last_review: YYYY-MM-DD
related_ADR: <ADR-NNNN o n/a>
related_incident: <ID en INCIDENTES.md si materializó>
---
```

**Matriz likelihood × impact** (score = L × I, ambos en {1=low, 2=med, 3=high}):

| Score | Tratamiento |
|---|---|
| 1–2 | Monitor passive |
| 3–4 | Mitigation plan documentado |
| 6 | Mitigation activa + revisión mensual |
| 9 | Mitigation activa + revisión semanal + escalación al TTL |

---

## 4. Risk register canónico (v0.1.0)

### 4.1. Riesgos de datos

```yaml
---
risk_id: R-001
category: DATOS
title: MEFP no responde a carta solicitud de datos (MDRyT/INIAF/SENASAG 2009–2024)
description: |
  La carta MEFP está lista en 00_admin/carta_solicitud_MEFP.md pero el envío
  o la respuesta puede demorar > 4 semanas o no llegar. Sin esos datos, los
  hallazgos F07 (institucional) y partes de F03 (composición) quedan con
  cobertura institucional incompleta.
likelihood: high
impact: high
score: 9
owner: TTL + co-TTL
mitigation:
  preventive: |
    - Enviar la carta vía dos canales (formal + informal) en la próxima ventana.
    - Identificar 2 contactos secundarios en MEFP/MDRyT para escalación.
    - Mantener Wayback Machine como fuente secundaria mientras tanto.
  contingent: |
    - Si no hay respuesta en 4 semanas → escalación TTL al WB Country Manager.
    - Si no hay respuesta en 8 semanas → publicar el reporte con gap declarado
      explícitamente en HALLAZGOS y appendix (no se posterga el release).
trigger: 4 semanas sin acuse de recibo o respuesta sustantiva
status: open
opened_date: 2026-05-23
last_review: 2026-05-23
related_ADR: n/a
---

---
risk_id: R-002
category: DATOS
title: BOOST 2024 release contiene revisiones retroactivas
description: |
  WB BOOST puede publicar revisiones que cambien cifras de años previos
  ya analizados. Si el equipo descubre la revisión después de publicar,
  el book contiene cifras desactualizadas.
likelihood: medium
impact: high
score: 6
owner: TTL
mitigation:
  preventive: |
    - Fechar la descarga de BOOST y declarar la versión en captions de figuras.
    - Suscribirse al canal de updates del BOOST.
    - Revisar el portal BOOST mensualmente durante el ciclo del reporte.
  contingent: |
    - Si la revisión llega antes del release: ADR + bump panel v12→v13 + A3 al
      capítulo afectado.
    - Si llega después del release: errata formal (16_INCIDENTES T-02).
trigger: notificación de release BOOST o cambio detectado en descarga test
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-003
category: DATOS
title: IDB AgriMonitor edición feb-2026 modifica serie histórica PSE Bolivia
description: |
  IDB publica anualmente; la edición de feb-2026 puede revisar la serie
  PSE/CSE/GSSE histórica de Bolivia. Como toda la sección PSE (F06) y los
  escenarios (F08) dependen de esa serie, cambios contaminan el reporte.
likelihood: high
impact: high
score: 9
owner: equipo APER (responsable PSE)
mitigation:
  preventive: |
    - Esperar la edición feb-2026 antes de cerrar F06 a status `reviewed`.
    - Mantener un script de diff que compare release nuevo vs viejo.
  contingent: |
    - Si la revisión cambia magnitudes > 5%: ADR-0003 v2 + regenerar todas
      las figuras PSE + bump del panel.
    - Documentar la divergencia en METODOLOGIA §4.4.
trigger: anuncio público de la edición feb-2026 o cambio detectado en API/portal
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-004
category: DATOS
title: Memorias MDRyT 2015–2018, 2020, 2022–2023 nunca aparecen
description: |
  Wayback Machine no las tiene; el sitio MDRyT bloquea con Cloudflare.
  Estos 5 años son cruciales para F07 (institucional) y para tendencia
  de gasto.
likelihood: medium
impact: medium
score: 4
owner: co-TTL
mitigation:
  preventive: |
    - Solicitud explícita vía MEFP en la carta de R-001.
    - Búsqueda alterna: archivos del IICA, FAO Office Bolivia, CEPAL.
  contingent: |
    - Si no aparecen: nota de divergencia en HALLAZGOS F07 + caveat en
      capítulo 03 sobre cobertura institucional discontinua.
trigger: 8 semanas sin acceso desde envío de carta
status: open
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.2. Riesgos metodológicos

```yaml
---
risk_id: R-005
category: METODOLOGIA
title: OECD revisa el manual PSE durante el ciclo del reporte
description: |
  Si OECD publica revisión metodológica del PSE Manual, los cálculos
  IDB AgriMonitor podrían cambiar o requerir ajuste. Bolivia podría
  quedar desalineada con el benchmark internacional.
likelihood: low
impact: high
score: 3
owner: equipo APER (responsable PSE)
mitigation:
  preventive: |
    - Citar versión específica del manual en METODOLOGIA §4.4.
    - Suscribirse a updates de OECD Agricultural Statistics.
  contingent: |
    - Si hay revisión: declarar que el APER 2026 usa manual versión X;
      próximo APER alineará con versión nueva.
trigger: anuncio público de OECD revising PSE methodology
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-006
category: METODOLOGIA
title: Panel v12 → v13 requiere reescribir capítulos completos
description: |
  Si se incorpora una fuente nueva (e.g. MDRyT 2015–2018 cuando llegue)
  o cambia una definición core, el panel bumpa a v13. Eso obliga a
  regenerar todas las figuras y revisar todos los claims cuantitativos.
likelihood: medium
impact: high
score: 6
owner: TTL
mitigation:
  preventive: |
    - Cerrar el conjunto de fuentes antes de empezar a redactar capítulos
      sustantivos (cap. 03–05).
    - Si una fuente nueva aparece tarde, evaluar si justifica bump o si
      entra en próximo APER.
  contingent: |
    - ADR de migración v12→v13 con tabla de impacto por hallazgo.
    - A3 obligatoria por capítulo afectado.
trigger: petición o necesidad de bump del panel
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.3. Riesgos políticos

```yaml
---
risk_id: R-007
category: POLITICO
title: Cambio de contraparte MEFP durante el ciclo
description: |
  El MEFP rota personal técnico. Un cambio en el nivel de contacto (asesor,
  director, viceministro) puede congelar la mesa técnica por semanas.
likelihood: medium
impact: medium
score: 4
owner: TTL
mitigation:
  preventive: |
    - Mantener relación con ≥ 2 contactos en MEFP, no solo uno.
    - Documentar mesas técnicas con minuta (00_admin/) firmada.
  contingent: |
    - Si rota la contraparte: re-introducción del proyecto al sucesor
      (1 reunión + paquete técnico resumen).
trigger: notificación de cambio o silencio > 4 semanas tras mesa previa
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-008
category: POLITICO
title: MEFP objeta hallazgo en mesa técnica sin alternativa verificable
description: |
  Si MEFP discrepa sobre cifra o interpretación pero no aporta fuente o
  metodología alternativa, el equipo APER debe decidir: ceder, mantener,
  o documentar divergencia.
likelihood: medium
impact: medium
score: 4
owner: TTL
mitigation:
  preventive: |
    - Compartir borradores tempranos para detectar objeciones pronto.
    - Acompañar cada hallazgo con su nivel de incertidumbre declarado.
  contingent: |
    - Aplicar protocolo HALLAZGOS §6.4: si la objeción es trazable, se
      incorpora; si no, queda como nota de divergencia en appendix.
    - El reporte NO se censura por objeción sin fuente.
trigger: objeción formal sin fuente alterna en mesa técnica
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-009
category: POLITICO
title: Coincidencia del release con calendario político sensible (Bolivia)
description: |
  Releases cerca de elecciones, debates fiscales, o eventos políticos
  pueden hacer que el reporte se lea como advocacy aunque no lo sea.
likelihood: medium
impact: high
score: 6
owner: TTL + WB Country Manager
mitigation:
  preventive: |
    - Identificar fechas sensibles al inicio del ciclo (calendario electoral,
      debates de PGN).
    - Calendarizar el release fuera de ventanas críticas.
    - Disclaimer técnico §23 del MASTER_PROMPT en cada producto.
  contingent: |
    - Si el release cae en ventana sensible: posponer 4 semanas O publicar
      con comunicación reforzada de neutralidad técnica.
trigger: identificación de evento político en ± 2 semanas del release
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.4. Riesgos de equipo

```yaml
---
risk_id: R-010
category: EQUIPO
title: Rotación de TTL o miembro core durante ciclo crítico
description: |
  Si rota el TTL del WB o un miembro core del equipo APER (EAFIT) en las
  últimas 12 semanas pre-release, el conocimiento contextual se pierde.
likelihood: low
impact: high
score: 3
owner: TTL
mitigation:
  preventive: |
    - RETOMAR.md como bitácora viva (transfiere contexto si alguien entra).
    - 11_EQUIPO.md con RACI claro (sucesor sabe qué decide).
    - Mentor asignado (18_ONBOARDING.md).
  contingent: |
    - Onboarding acelerado (1 semana) al sucesor.
    - Posponer release si afecta A5.
trigger: notificación de rotación
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-011
category: EQUIPO
title: Conflicto de interés no declarado de revisor o auditor
description: |
  Un revisor con vínculo con MEFP, MDRyT, o el sector agrícola privado
  no declarado puede sesgar la revisión técnica.
likelihood: low
impact: high
score: 3
owner: TTL
mitigation:
  preventive: |
    - Declaración de COI obligatoria al inicio del rol (11_EQUIPO.md).
    - Revisor por capítulo distinto del autor (AUDITORIA §9).
  contingent: |
    - Si se descubre COI no declarado: reemplazar revisor + auditoría retrospectiva.
trigger: descubrimiento o sospecha
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.5. Riesgos técnicos

```yaml
---
risk_id: R-012
category: TECNICO
title: Pérdida de datos crudos en 01_data/raw/
description: |
  Aunque las fuentes son re-descargables, perder el snapshot exacto que
  reproduce el panel v12 rompe la reproducibilidad.
likelihood: low
impact: high
score: 3
owner: equipo APER (responsable de datos)
mitigation:
  preventive: |
    - Backup semanal a OneDrive + Zenodo deposit al release.
    - Checksums SHA-256 por archivo en 01_data/raw/<fuente>/CHECKSUMS.md
      (FUENTES §8).
  contingent: |
    - Restaurar desde último backup conocido.
    - Si backup viejo: rebuild panel y verificar diff con cifras publicadas.
trigger: archivo faltante o checksum incorrecto
status: open
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-013
category: TECNICO
title: renv.lock obsoleto y máquina nueva no puede reproducir
description: |
  Si una librería rompe compatibilidad o un paquete desaparece de CRAN,
  el comando renv::restore() puede fallar en una máquina limpia.
likelihood: medium
impact: medium
score: 4
owner: equipo APER (responsable técnico)
mitigation:
  preventive: |
    - Pin versión R y todas las versiones de paquetes en renv.lock.
    - Verificar reproducibilidad en máquina limpia cada 4 semanas (A5).
    - Considerar Docker image canónica para release final.
  contingent: |
    - Documentar workaround en 12_REPRODUCIBILIDAD.md.
    - Si paquete desaparece: snapshot tarball en repo (con licencia).
trigger: renv::restore() falla en máquina test
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-014
category: TECNICO
title: Sitio público GitHub Pages caído durante release o mesa técnica
description: |
  GitHub Pages tiene downtime ocasional. Si MEFP entra a verlo en mesa
  técnica y el sitio está caído, la experiencia se daña.
likelihood: low
impact: low
score: 1
owner: equipo APER (responsable web)
mitigation:
  preventive: |
    - PDF descargable del book + slides en mirror (OneDrive, Zenodo).
    - Sitio espejo opcional (Netlify, Cloudflare Pages).
  contingent: |
    - Compartir mirror PDF inmediatamente.
trigger: monitoreo de uptime alerta
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.6. Riesgos reputacionales

```yaml
---
risk_id: R-015
category: REPUTACIONAL
title: Errata mayor en cifra publicada
description: |
  Cifra del executive summary o de hallazgo principal resulta errónea
  después de publicación. El reporte pierde credibilidad ante MEFP y
  comunidad técnica.
likelihood: low
impact: high
score: 3
owner: TTL
mitigation:
  preventive: |
    - A5 obligatoria con traceability audit completo (AUDITORIA §7).
    - Reproducibilidad en máquina limpia antes de release.
    - Revisión cruzada de cifras book ↔ web ↔ slides ↔ briefs.
  contingent: |
    - Protocolo 16_INCIDENTES T-02: errata visible + comunicación MEFP
      en 24h + corrección versionada + post-mortem.
trigger: descubrimiento de discrepancia trazada
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-016
category: REPUTACIONAL
title: Cobertura mediática reinterpreta hallazgos como advocacy
description: |
  Periodistas o políticos pueden citar el reporte fuera de contexto,
  presentándolo como prescripción del WB sobre Bolivia.
likelihood: medium
impact: medium
score: 4
owner: TTL + Comunicaciones WB
mitigation:
  preventive: |
    - Disclaimer técnico §23 visible en cada producto.
    - Lenguaje "opción técnica para consideración" en escenarios.
    - Q&A canónico para periodistas (19_COMUNICACION.md).
  contingent: |
    - Respuesta única vocera del WB.
    - Aclaración pública si la distorsión es grave.
trigger: cobertura mediática detectada
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.7. Riesgos de cronograma

```yaml
---
risk_id: R-017
category: CRONOGRAMA
title: Consultor PSE/Repurposing (STC) entrega tardío o sin sincronía
description: |
  La fase del consultor PSE depende del APER. Si su entrega coincide con
  el release del book, los escenarios del cap. 6 quedan desactualizados
  vs. el trabajo del consultor.
likelihood: medium
impact: medium
score: 4
owner: TTL
mitigation:
  preventive: |
    - 00_admin/SINERGIA_ToR_PSE_Repurposing.md documenta interfaces y plazos.
    - Hitos del consultor sincronizados con A3/A4 del APER.
  contingent: |
    - Si hay desfase: marcar escenarios S0X como "v1, sujetos a calibración
      en fase de consultoría PSE" — sin pretender ser definitivos.
trigger: desfase observado en cronograma compartido
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-018
category: CRONOGRAMA
title: Carta MEFP atrasa más de 4 semanas para envío
description: |
  La carta está lista pero pendiente de aprobación interna WB y/o
  validación del equipo APER. Cada semana de atraso es una semana sin
  datos clave.
likelihood: medium
impact: high
score: 6
owner: TTL
mitigation:
  preventive: |
    - Marcar la carta como prioridad ROJA en RETOMAR.md.
    - Definir fecha límite explícita.
  contingent: |
    - Si pasa 4 semanas: escalación al WB Country Manager.
    - Si pasa 8 semanas: continuar con cobertura disponible y nota de gap.
trigger: 4 semanas desde redacción de la carta sin envío
status: open
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

### 4.8. Riesgos legales

```yaml
---
risk_id: R-019
category: LEGAL
title: Atribución incorrecta o ausente de fuente con licencia CC-BY
description: |
  MapBiomas, FAOSTAT, ESA WorldCover exigen atribución. Una figura sin
  atribución explícita viola la licencia.
likelihood: medium
impact: low
score: 2
owner: equipo APER (responsable de figuras)
mitigation:
  preventive: |
    - FIGURAS §9.3: tabla de citas canónicas + flag de atribución.
    - Checklist por figura (FIGURAS §15) incluye atribución.
  contingent: |
    - Errata cosmética con corrección inmediata.
trigger: revisor detecta atribución faltante
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---

---
risk_id: R-020
category: LEGAL
title: Cambio de licencia de fuente cruda durante el ciclo
description: |
  Una fuente abierta hoy puede cambiar a licencia restrictiva. Si el
  reporte ya la usó, hay riesgo de reuso post-publicación.
likelihood: low
impact: low
score: 1
owner: equipo APER (responsable de fuentes)
mitigation:
  preventive: |
    - Fechar la descarga + snapshot inmutable de la fuente.
    - Citar la licencia vigente al momento de descarga.
  contingent: |
    - Si la licencia cambia: documentar; no se elimina la cita pero se
      añade nota sobre el cambio para futuros lectores.
trigger: notificación o detección de cambio de licencia
status: monitoring
opened_date: 2026-05-23
last_review: 2026-05-23
---
```

---

## 5. Tabla resumen (sortable mental)

| ID | Categoría | Título corto | L | I | Score | Owner | Estado |
|---|---|---|---|---|---|---|---|
| R-001 | DATOS | Carta MEFP sin respuesta | H | H | 9 | TTL | open |
| R-002 | DATOS | BOOST 2024 revisión retroactiva | M | H | 6 | TTL | monitoring |
| R-003 | DATOS | IDB AgriMonitor feb-2026 | H | H | 9 | equipo APER | monitoring |
| R-004 | DATOS | Memorias MDRyT no aparecen | M | M | 4 | co-TTL | open |
| R-005 | METOD | OECD revisa PSE manual | L | H | 3 | equipo APER | monitoring |
| R-006 | METOD | Panel v12→v13 forzado | M | H | 6 | TTL | monitoring |
| R-007 | POLIT | Cambio contraparte MEFP | M | M | 4 | TTL | monitoring |
| R-008 | POLIT | Objeción MEFP sin fuente | M | M | 4 | TTL | monitoring |
| R-009 | POLIT | Release en ventana sensible | M | H | 6 | TTL+CM | monitoring |
| R-010 | EQUIPO | Rotación TTL/core | L | H | 3 | TTL | monitoring |
| R-011 | EQUIPO | COI no declarado | L | H | 3 | TTL | monitoring |
| R-012 | TECNICO | Pérdida 01_data/raw/ | L | H | 3 | equipo APER | open |
| R-013 | TECNICO | renv.lock obsoleto | M | M | 4 | equipo APER | monitoring |
| R-014 | TECNICO | GitHub Pages caído | L | L | 1 | equipo APER | monitoring |
| R-015 | REPUT | Errata mayor publicada | L | H | 3 | TTL | monitoring |
| R-016 | REPUT | Distorsión mediática | M | M | 4 | TTL+Com | monitoring |
| R-017 | CRONO | Consultor PSE desfase | M | M | 4 | TTL | monitoring |
| R-018 | CRONO | Carta MEFP atrasada | M | H | 6 | TTL | open |
| R-019 | LEGAL | Atribución CC-BY incompleta | M | L | 2 | equipo APER | monitoring |
| R-020 | LEGAL | Licencia de fuente cambia | L | L | 1 | equipo APER | monitoring |

**Top 5 por score (priorizar mitigación activa):**

1. R-001 (9) — Carta MEFP sin respuesta
2. R-003 (9) — IDB AgriMonitor feb-2026
3. R-002 (6) — BOOST revisión retroactiva
4. R-006 (6) — Panel v12→v13
5. R-009 (6) — Release en ventana política

---

## 6. Periodicidad de revisión

| Tipo de revisión | Cadencia | Responsable | Output |
|---|---|---|---|
| Revisión semanal de top-3 riesgos (score ≥ 9) | semanal | equipo APER | actualización del estado en este archivo |
| Revisión mensual del registro completo | mensual | TTL + equipo | rollup en `00_admin/risk_review_YYYY_MM.md` |
| Revisión trimestral con WB Country Office | trimestral | TTL | minuta + actualización del registro |
| Re-evaluación post-incidente | ad-hoc | quien sea owner | entrada en `16_INCIDENTES.md` + cierre o actualización del riesgo origen |

---

## 7. Disparadores de escalación

| Condición | Escalación |
|---|---|
| Riesgo score ≥ 9 sin mitigación activa | TTL → WB Country Manager en 48h |
| Riesgo materializado (se vuelve incidente) | abrir entrada en 16_INCIDENTES.md + post-mortem |
| Nuevo riesgo identificado con score ≥ 6 | revisión inmediata con TTL antes del próximo sync |
| Riesgo open > 8 semanas sin movimiento | re-evaluar owner + plan |

---

## 8. Cómo agregar un riesgo nuevo

1. Identificar la categoría (§2).
2. Asignar `risk_id` siguiente correlativo (R-021, R-022...).
3. Llenar el bloque YAML con los campos del esquema §3.
4. Score = likelihood × impact.
5. Owner nombrado y notificado.
6. Si score ≥ 6: comentar en el próximo sync.
7. Agregar fila a la tabla resumen §5.

---

## 9. Cómo cerrar un riesgo

```yaml
status: closed
closed_date: YYYY-MM-DD
closure_reason: |
  <por qué se cierra: el evento ocurrió y se manejó, o el evento dejó de
  ser relevante, o la mitigación preventiva volvió la probabilidad despreciable>
closure_evidence: <referencia a ADR, incidente, minuta, etc.>
```

El bloque permanece visible (append-only). No se borra.

---

## 10. Integración con otros archivos

| Doc | Relación |
|---|---|
| `08_CONTROL.md` | Cambios ROJOS pueden originarse en mitigación de riesgo (e.g. R-006 panel bump). |
| `09_AUDITORIA.md` | A5 (release) revisa estado del registro como input obligatorio. |
| `16_INCIDENTES.md` | Riesgo materializado se vuelve incidente; el id del riesgo origen se referencia. |
| `00_admin/RETOMAR.md` | Top-3 riesgos abiertos se reflejan como contexto al cerrar sesión. |
| `00_admin/ESTADO_DE_DATOS.md` | Riesgos de DATOS dialogan con el estado operativo de acceso. |

---

## 11. Cómo modificar este archivo

Modificar `10_RIESGOS.md` es AMARILLO si agrega/cierra riesgos; ROJO si cambia categorías, esquema o matriz L×I (requiere ADR).

---

## 12. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: marco ISO 31000 adaptado, 8 categorías, 20 riesgos canónicos identificados con esquema YAML, matriz L×I, periodicidad de revisión, triggers de escalación, integración con CONTROL/AUDITORIA/INCIDENTES |
