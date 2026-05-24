# 11_EQUIPO.md — Stakeholder map + RACI + Authorship + COI

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/11_EQUIPO.md`
**Marco de referencia:** RACI clásico (PMI) + ICMJE authorship adaptado a WB editorial + Vancouver guidelines on COI disclosure.
**Lecturas relacionadas:** [`08_CONTROL.md`](08_CONTROL.md), [`09_AUDITORIA.md`](09_AUDITORIA.md), [`10_RIESGOS.md`](10_RIESGOS.md), [`13_PUBLICACION.md`](13_PUBLICACION.md), [`18_ONBOARDING.md`](18_ONBOARDING.md).

> CONTROL define qué requiere aprobación. RIESGOS dice qué puede fallar. EQUIPO dice **quién** decide, **quién** firma, **quién** queda nombrado en la cubierta.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **Sin dueño, no hay decisión.** Toda decisión clave del APER tiene un nombre y un rol asignado.
2. **Separación de capas.** Quien escribe no firma la auditoría de lo propio; quien firma la auditoría no firma la mesa MEFP del mismo bloque (heredado de AUDITORIA §9).
3. **Authorship trazable.** El reporte se firma con criterios ICMJE adaptados a WB; nadie es "co-autor por cortesía", nadie con contribución sustantiva queda fuera.
4. **COI declarado o no se participa.** Conflictos de interés se declaran antes del rol, no después.

---

## 2. Stakeholder map

Tres círculos concéntricos según proximidad al producto.

### 2.1. Círculo 1 — Equipo de producción (escribe el reporte)

| Rol | Quién | Institución | Responsabilidad principal |
|---|---|---|---|
| **TTL (Task Team Leader)** | _[TODO_TRACE: nombre]_ | World Bank — Agriculture Global Practice | Liderazgo técnico del APER, autor principal, firmante de A4 y A5 |
| **co-TTL** | _[TODO_TRACE: nombre]_ | World Bank | Co-liderazgo, respaldo del TTL, firma A4 cuando TTL ausente |
| **Líder técnico EAFIT/CVP** | Juan Carlos Muñoz Mora | EAFIT — Centro de Valor Público | Arquitectura del panel v12, gobernanza del repo, redacción técnica, MEL |
| **Equipo APER core** | _[TODO_TRACE: lista]_ | EAFIT / WB / colaboradores | Construcción del panel, capítulos, figuras, A2/A3 |
| **Consultor PSE/Repurposing (STC)** | _[TODO_TRACE: nombre]_ | WB STC | PSE detallado, escenarios de repurposing, integración con cap. 06 |

### 2.2. Círculo 2 — Contraparte y revisores formales

| Rol | Quién | Institución | Relación |
|---|---|---|---|
| **Contraparte técnica MEFP** | _[TODO_TRACE: rol, no persona política]_ | MEFP — VIPFE / Presupuesto / Tesoro | Mesa técnica, validación de cifras, comentarios estructurados |
| **Contraparte técnica MDRyT** | _[TODO_TRACE]_ | MDRyT | Insumos sectoriales, validación institucional |
| **Peer reviewers internos WB** | _[TODO_TRACE: nombres]_ | WB | Revisión peer para release (A5) |
| **Peer reviewers externos** | _[TODO_TRACE]_ | académicos LAC + IFPRI + FAO | Revisión opcional para versión académica derivada |
| **WB Country Manager Bolivia** | _[TODO_TRACE]_ | WB Bolivia office | Escalación política, ventana de release |

### 2.3. Círculo 3 — Stakeholders informados (no producen, reciben)

| Rol | Por qué importa |
|---|---|
| Ministerio de Planificación del Desarrollo | Receptor potencial para articulación con PDES |
| Gobernaciones (9 departamentos) | Receptores de hallazgo F04 (territorial) |
| ANAPO, IBCE, otros gremios productivos | Receptores potenciales del cap. 02 (sector performance) |
| Fundación Jubileo, CIPCA, otras OSC | Aliados técnicos en disseminación |
| FAO Office Bolivia | Coordinación temática |
| BID Bolivia | AgriMonitor proviene de BID; relación técnica |
| Academia (universidades bolivianas) | Receptores académicos; versión académica eventual |

---

## 3. Organizational chart

```text
                    WB Country Manager Bolivia
                              │
                              │ escalación política
                              │
                    ┌─────────┴─────────┐
                    │       TTL          │   firma A4 y A5
                    │     (autor 1)      │
                    └─────────┬─────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │                │
        ┌─────┴─────┐   ┌─────┴─────┐    ┌────┴────┐
        │  co-TTL   │   │ Líder EAFIT│    │ STC PSE │
        │ (autor 2) │   │ (autor 3)  │    │(autor 4)│
        └───────────┘   └─────┬─────┘    └─────────┘
                              │
                    ┌─────────┴─────────┐
                    │   Equipo APER     │
                    │   core (EAFIT +   │
                    │   colaboradores)  │
                    └─────────┬─────────┘
                              │
                       ───────┴───────
                       │             │
                ┌──────┴───┐   ┌─────┴──────┐
                │ Datos    │   │ Redacción  │
                │ (panel)  │   │ (capítulos)│
                └──────────┘   └────────────┘

      ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─

           Contrapartes (mesa técnica)
           MEFP — MDRyT — otros
           (no son parte del equipo de
            producción; reciben, comentan)
```

---

## 4. RACI por decisión clave

Notación: **R** Responsible (ejecuta), **A** Accountable (firma final), **C** Consulted (consultado antes), **I** Informed (informado después).

| Decisión | TTL | co-TTL | Líder EAFIT | Equipo core | Consultor STC | MEFP |
|---|---|---|---|---|---|---|
| Bump del panel v12 → v13 | A | C | R | R | I | I |
| Adición de un hallazgo | A | C | R | C | I | C (mesa técnica) |
| Modificación de un hallazgo existente | A | C | R | C | I | C |
| Retirar un hallazgo (`retired`) | A | C | R | C | I | C |
| Cambio en METODOLOGIA (definición operativa) | A | C | R | C | C | I |
| Cambio en metodología PSE específicamente | A | C | C | C | R | I |
| Cambio en escenarios de repurposing | A | C | C | C | R | I |
| Cierre de un ADR (estado "aceptado") | A | C | C | C | I | I |
| Aprobar release del book (A5) | A | A | R | C | C | I |
| Compartir borrador con MEFP (A4) | A | C | R | I | I | I |
| Adopción/modificación de paleta de figuras | A | C | R | C | I | I |
| Cambio en lista NEVER WRITE (ESTILO §3.3) | A | C | R | C | I | I |
| Cambio en CONTROL.md / AUDITORIA.md | A | C | R | C | I | I |
| Cambio en NEUTRALIDAD.md | A | C | R | C | I | I |
| Onboarding nuevo miembro al equipo | A | C | R | I | I | I |
| Aceptar peer reviewer externo | A | C | R | I | I | I |
| Aceptar/rechazar comentario MEFP en mesa técnica | A | C | R | C | C | R (contraparte) |
| Release de paquete de datos abierto (panel v12 público) | A | C | R | C | I | C |
| Publicación en redes / canales públicos | A | C | C | I | I | I (después) |
| Decisión sobre embargo y fecha de release | A | C | C | I | I | C |
| Comunicación pública en crisis (errata mayor) | A | C | C | I | I | I |
| Cierre de incidente P0 o P1 (16_INCIDENTES) | A | C | R | C | I | I (si afecta MEFP) |

Notas:

- **A nunca puede ser dos personas distintas** — si dos firman, una es A y otra es C.
- **MEFP figura como C en mesa técnica** pero **A en decisiones internas del MEFP** (e.g. su propia validación) — no es A del producto WB.
- **Consultor STC es R** sobre PSE/escenarios pero no A — el A sigue siendo el TTL.

---

## 5. Authorship policy

Adaptación de ICMJE a la convención editorial WB de policy reports.

### 5.1. Criterios para figurar en la cubierta del reporte

Una persona figura como **autor** del APER 2026 si cumple **al menos 3 de los 4 criterios**:

1. **Contribución sustantiva** a concepción, diseño, adquisición de datos, análisis o interpretación.
2. **Redacción** o **revisión crítica** del manuscrito para contenido intelectual importante.
3. **Aprobación final** de la versión a publicar.
4. **Responsabilidad** por la integridad del trabajo en su conjunto o de la sección que lideró.

> Quien solo aportó financiamiento, supervisión general, o apoyo administrativo **no es autor** — va en `Acknowledgments`.

### 5.2. Orden de autores

Convención WB AgPER (alineada con FAO MAFAP y BID AgriMonitor):

```text
Autor 1 (TTL):              primer autor
Autor 2 (co-TTL):           segundo autor
Autor 3 (Líder técnico):    tercer autor (si contribución sustantiva)
Autor 4 (STC PSE):          cuarto autor (sobre componente PSE)
Co-autores adicionales:     orden por contribución cuantitativa (figuras,
                            capítulos, scripts del panel)
```

Excepciones:

- Si el equipo decide **alfabético después del TTL**: declarar en nota.
- Si hay **equal contribution**: indicar con asterisco al final del nombre.

### 5.3. Acknowledgments

Receptores típicos:

- Contrapartes MEFP / MDRyT nombrados por **rol** (no persona política).
- Peer reviewers (con permiso).
- Apoyo institucional EAFIT/CVP.
- Donantes y programas del WB que financian la línea de trabajo.
- Comentarios técnicos recibidos en mesas o talleres (referenciados por evento, no individuos sin permiso).

Cada agradecimiento individual requiere **consentimiento explícito** del nombrado.

### 5.4. Citación canónica del reporte

Formato recomendado (ver `13_PUBLICACION.md` §7 para versión completa):

```text
World Bank. 2026. Bolivia: Agricultural Public Expenditure Review 2026.
Washington, DC: World Bank. doi:10.5281/zenodo.XXXXX.
```

Si el equipo decide visibilidad de autores en la cita: `(Authors: <lista>)` después del título.

---

## 6. Declaración de conflictos de interés (COI)

### 6.1. Quién declara

**Toda persona** que participa en cualquiera de estos roles debe declarar COI antes de iniciar:

- TTL, co-TTL, líder técnico EAFIT, equipo APER core.
- Consultor STC PSE.
- Revisores peer internos y externos.
- Auditores A3/A4/A5.
- Auditor de neutralidad (si rota).

### 6.2. Categorías de COI relevantes para el APER

```text
FINANCIERO     consultoría remunerada con MEFP, MDRyT, empresas estatales
               agrícolas (EMAPA, INIAF, SENASAG), o gremios productivos
               (ANAPO, IBCE, CAO, etc.) en los últimos 36 meses.

INSTITUCIONAL  cargo directivo en gobierno boliviano, en organismos
               internacionales con posición pública sobre Bolivia agrícola,
               o en organizaciones que reciben financiamiento sustantivo
               de las contrapartes del APER.

INTELECTUAL    posición pública previa (artículo, columna, op-ed) sobre
               los temas tratados en el APER que pueda interpretarse como
               compromiso con una conclusión específica.

PERSONAL       relación familiar o cercana con personas en posiciones de
               decisión en las contrapartes del APER.
```

### 6.3. Plantilla de declaración

```yaml
---
coi_declaration:
  name: <nombre completo>
  role_in_aper: <TTL | co-TTL | Líder EAFIT | core team | STC | reviewer | auditor>
  date: YYYY-MM-DD
  financial:
    has_financial_coi: yes | no
    detail: |
      <descripción si yes; en blanco si no>
  institutional:
    has_institutional_coi: yes | no
    detail: ...
  intellectual:
    has_intellectual_coi: yes | no
    detail: ...
  personal:
    has_personal_coi: yes | no
    detail: ...
  declaration: |
    Declaro que la información provista es completa y correcta a la fecha
    de firma. Me comprometo a actualizar esta declaración dentro de 30
    días si surge un nuevo COI durante mi participación en el APER 2026.
  signature: <nombre + fecha>
---
```

Las declaraciones se archivan en `00_admin/coi/<nombre>_<fecha>.md` (path restringido — ver `14_CONFIDENCIALIDAD.md`).

### 6.4. Manejo de COI declarado

| COI declarado | Acción |
|---|---|
| **Sin COI** | participa con rol completo |
| **COI financiero financiero histórico (> 36 meses)** | participa con divulgación visible en `Acknowledgments` |
| **COI financiero activo en los últimos 12 meses con contraparte directa del APER** | recusación del rol O revisión por par adicional + divulgación |
| **COI institucional activo** | recusación del rol O reasignación a tarea sin conflicto |
| **COI intelectual** | divulgación visible; el rol se mantiene salvo si el TTL decide que la apariencia de conflicto es alta |
| **COI personal** | recusación del rol que involucra a la persona en cuestión |

Decisión: **TTL** firma la determinación. Si el COI es del TTL, decide el WB Country Manager.

### 6.5. Revisión anual

Las declaraciones se revisan al inicio de cada año fiscal del APER y al sumar nuevos miembros al equipo.

---

## 7. Cambios de equipo (rotación, salida, incorporación)

### 7.1. Incorporación

1. COI declarado (§6).
2. Onboarding según `18_ONBOARDING.md`.
3. Mentor asignado dentro del equipo.
4. Actualización del stakeholder map §2 + RACI §4 si el rol no estaba documentado.

### 7.2. Salida planificada

1. Handoff documentado en `00_admin/handoff/<nombre>_YYYY_MM_DD.md`:
   - tareas activas
   - decisiones pendientes
   - relaciones MEFP que mantenía
   - artefactos en producción
2. Reasignación de RACI §4.
3. Cierre de accesos (`15_SEGURIDAD.md`).

### 7.3. Salida abrupta o emergencia

Protocolo en `16_INCIDENTES.md` (categoría EQUIPO).

---

## 8. Reuniones y cadencia

Detalle operativo en `19_COMUNICACION.md`. Resumen:

| Reunión | Cadencia | Participantes | Producto |
|---|---|---|---|
| Sync interno APER | semanal | equipo core | minuta corta en `00_admin/syncs/` |
| Mesa técnica MEFP | mensual / quincenal | TTL, co-TTL, MEFP contraparte | minuta en `00_admin/mesas_tecnicas/` |
| Revisión de riesgos | mensual | TTL + equipo | rollup en `00_admin/risk_review_YYYY_MM.md` |
| Sync con STC PSE | quincenal durante fase de consultoría | TTL + STC | minuta corta |
| Revisión release (A5) | hito | comité APER completo | reporte A5 |

---

## 9. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `08_CONTROL.md` | RACI §4 informa quién firma cambios ROJOS |
| `09_AUDITORIA.md` | §9 roles de auditoría se derivan de §2 stakeholder map |
| `10_RIESGOS.md` | R-007 (cambio MEFP), R-010 (rotación), R-011 (COI) usan §6–§7 de este archivo |
| `13_PUBLICACION.md` | Authorship §5 alimenta la página de créditos del book |
| `14_CONFIDENCIALIDAD.md` | Declaraciones COI son nivel RESTRINGIDO |
| `18_ONBOARDING.md` | Inicio del rol nuevo dispara §7.1 |
| `00_admin/coi/` | repositorio (privado) de declaraciones firmadas |
| `00_admin/handoff/` | repositorio de handoffs documentados |

---

## 10. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Actualizar nombres en §2 stakeholder map | AMARILLO |
| Agregar fila a RACI §4 | AMARILLO |
| Cambiar quién es A en una decisión existente | ROJO + ADR |
| Cambiar criterios ICMJE adaptados §5.1 | ROJO + ADR |
| Cambiar política COI §6 | ROJO + ADR |
| Cambiar el organizational chart §3 | ROJO + ADR |

---

## 11. TODOs para alcanzar v1.0

- [ ] Llenar todos los `[TODO_TRACE: nombre]` del §2 stakeholder map con nombres reales y consentimiento.
- [ ] Recolectar declaraciones COI iniciales de todos los miembros del Círculo 1.
- [ ] Archivar las declaraciones en `00_admin/coi/`.
- [ ] Definir contraparte técnica oficial del MEFP por nombre/rol (no persona política).
- [ ] Confirmar peer reviewers internos WB con sus áreas de revisión.
- [ ] Documentar la decisión de orden de autores antes del release (A5).
- [ ] Crear `00_admin/handoff/` con plantilla de handoff.
- [ ] Plan de comunicación con WB Country Manager sobre escalación (sync inicial).

---

## 12. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: stakeholder map en 3 círculos, org chart, RACI sobre 22 decisiones clave, authorship policy adaptada de ICMJE, política COI con 4 categorías y plantilla, cadencia de reuniones, integración con CONTROL/AUDITORIA/RIESGOS/INCIDENTES |
