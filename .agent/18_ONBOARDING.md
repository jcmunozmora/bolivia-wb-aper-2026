# 18_ONBOARDING.md — Incorporación de nuevos miembros (humanos)

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/18_ONBOARDING.md`
**Lecturas relacionadas:** [`11_EQUIPO.md`](11_EQUIPO.md), [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md), [`15_SEGURIDAD.md`](15_SEGURIDAD.md), [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md), [`README.md`](README.md).

> CLAUDE.md onboarda a los LLM. Este archivo onboarda a las personas. Sin onboarding documentado, cada nuevo miembro reinventa el contexto.

---

## 1. Principio rector

1. **El nuevo miembro debe ser productivo en 5 días hábiles.** No "leer todo durante 3 semanas" — leer lo necesario, hacer una contribución pequeña, iterar.
2. **Mentor asignado.** Una persona del equipo es responsable de responder dudas del nuevo durante los primeros 30 días.
3. **Checkpoint a 30 días.** Conversación corta con TTL evalúa fit y ajusta el rol.

---

## 2. Día 1 — Acceso y orientación

### 2.1. Antes del día 1 (prep del equipo)

```text
[ ] Acceso al repo GitHub (colaborador)
[ ] Acceso a OneDrive equipo APER (carpeta compartida)
[ ] Si rol involucra mesa MEFP: acceso a 00_admin/mesas_tecnicas/ (con permisos)
[ ] Mentor asignado y notificado
[ ] Cuenta en herramientas de sync (correo, calendar)
[ ] COI form preparado (11_EQUIPO §6.3)
[ ] Decision sobre nivel de acceso a RESTRINGIDO (14_CONFIDENCIALIDAD)
```

### 2.2. Día 1 — el nuevo miembro hace

```text
[ ] Clonar repo:
    git clone https://github.com/<org>/<repo>.git

[ ] Configurar git local con su email institucional

[ ] Leer en orden:
    1. README.md (raíz) — overview del proyecto
    2. .agent/README.md — mapa de gobernanza
    3. .agent/00_MASTER_PROMPT.md — partes 1-5 (identidad, invariantes,
       arquitectura, estándares)
    4. 00_admin/RETOMAR.md — estado actual de la sesión
    5. CLAUDE.md (raíz) — solo si trabajará con LLM-assistance

[ ] Verificar reproducibilidad (12_REPRODUCIBILIDAD §5):
    Rscript -e 'renv::restore()'

[ ] Sesión 1:1 con mentor (~ 1h)
    - tour del repo
    - tour de .agent/
    - hallazgos en estado actual
    - próximos hitos
    - dudas

[ ] Firmar declaración COI (11_EQUIPO §6.3) si rol lo requiere
```

---

## 3. Primera semana (días 2–5)

### 3.1. Lecturas dirigidas por rol

| Rol del nuevo | Lecturas obligatorias |
|---|---|
| Redacción / capítulos | `05_ESTILO_NARRATIVO.md` (especialmente §3 y §3.24), `06_NEUTRALIDAD.md` |
| Figuras / visualización | `07_FIGURAS.md` completo |
| Datos / panel / scripts | `01_METODOLOGIA.md`, `02_INDICADORES.md`, `03_FUENTES.md` |
| Análisis PSE | `01_METODOLOGIA §4.4`, `02_INDICADORES G08`, [Manual MAFAP] |
| Revisor / auditor | `09_AUDITORIA.md`, `08_CONTROL.md` |
| Web / disseminación | `07_FIGURAS.md` (§7.1, §13), `13_PUBLICACION.md` |
| Coordinación MEFP | `11_EQUIPO.md`, `14_CONFIDENCIALIDAD.md`, `00_admin/SINERGIA_*` |
| Cualquier rol | `04_HALLAZGOS.md` (los 8 hallazgos), `10_RIESGOS.md` (top 5 riesgos) |

### 3.2. Primera contribución pequeña

Asignar una tarea VERDE o AMARILLO chica:

```text
opciones típicas:
  - corregir un TODO_TRACE en INDICADORES o FUENTES
  - generar una figura simple desde panel v12 (con FIGURAS §15 checklist)
  - revisar la coherencia bilingüe de un párrafo del executive summary
  - agregar un ejemplo a ESTILO_NARRATIVO o NEUTRALIDAD
  - verificar un link / atribución
```

La tarea debe:

- pasar por el ciclo VERDE/AMARILLO del CONTROL completo (incluye A2)
- terminar con un commit + entry en RETOMAR.md
- ser revisada por el mentor (no auto-aprobada en esta primera contribución)

### 3.3. Asistir a mesas y syncs

```text
[ ] sync interno semanal del equipo (escuchando, no liderando)
[ ] mesa técnica MEFP si ocurre (solo si rol lo requiere; pedir
    autorización al TTL primero)
```

---

## 4. Primeros 30 días

### 4.1. Hitos esperados

```text
[ ] 3-5 contribuciones AMARILLAS completadas (con A2)
[ ] mentor confirma manejo independiente de:
    - clasificar cambios verde/amarillo/rojo (CONTROL §2)
    - escribir un párrafo TEEL pasando pre-flight anti-IA
    - generar una figura con metadata completa
    - cerrar sesión con bloque de RETOMAR.md formato §8 AGENTS.md
[ ] entender el flujo de trabajo end-to-end
[ ] conocer top-3 riesgos abiertos del registro 10_RIESGOS
[ ] haber leído al menos un capítulo del book en estado actual
```

### 4.2. Checkpoint a 30 días

Conversación corta (~30 min) con TTL + mentor:

```text
desde el lado del miembro:
  - ¿qué entendiste del proyecto?
  - ¿qué te sorprendió?
  - ¿qué necesitas para ser productivo en los próximos 90 días?
  - ¿qué documentación falta o es confusa?

desde el lado del equipo:
  - feedback sobre las contribuciones
  - ajuste de scope del rol si necesario
  - decisión sobre asumir cambios ROJOS con ADRs (típico desde día 30+)
```

Output: nota corta en `00_admin/onboarding/<nombre>_30days.md` (clasificación INTERNO).

---

## 5. Rol específico: nuevo TTL o co-TTL

Si el nuevo miembro es TTL o co-TTL (e.g. rotación R-010), el proceso es más intenso.

```text
día 1-2:
  - reunión con TTL saliente (handoff completo)
  - revisión de carta MEFP, ADRs activos, riesgos top-5
  - relaciones MEFP y otros stakeholders (Círculo 2)

semana 1:
  - mesa técnica conjunta con TTL saliente y MEFP (transferencia visible)
  - revisión de cronograma de release

semana 2:
  - asumir responsabilidad de A4 (si periodo lo requiere)
  - co-firma de release próximo si TTL saliente lo hizo

mes 1:
  - decisiones ROJAS bajo doble firma temporal
```

Handoff documentado en `00_admin/handoff/<TTL>_YYYY_MM_DD.md` (RESTRINGIDO).

---

## 6. Rol específico: consultor STC (PSE/Repurposing)

Onboarding adaptado a contratación externa:

```text
día 1:
  - acceso temporal a OneDrive equipo APER + repo
  - NDA firmado (si el contrato STC no lo cubre)
  - declaración COI específica al sector agrícola boliviano

primera semana:
  - lectura: 01_METODOLOGIA §4.4-4.6, 02_INDICADORES G08, 04_HALLAZGOS F06+F08
  - sync con TTL para alinear scope de la consultoría
  - revisión de 00_admin/SINERGIA_ToR_PSE_Repurposing.md

primer hito:
  - entrega 1 según ToR, integrada vía A3 del capítulo afectado
```

---

## 7. Onboarding express (< 4 horas — para revisores peer ad-hoc)

Si una persona se incorpora solo para revisar (e.g. peer reviewer externo de A5):

```text
[ ] Leer .agent/README.md
[ ] Leer .agent/00_MASTER_PROMPT.md (partes 1-3)
[ ] Leer el capítulo o sección a revisar
[ ] Recibir el checklist específico (de 09_AUDITORIA.md según nivel A)
[ ] Firmar declaración COI corta
[ ] Producir el reporte de revisión en formato §15 de AUDITORIA.md
```

---

## 8. Salida del equipo (offboarding)

Espejo del onboarding. Detalle operativo en `11_EQUIPO §7`.

```text
[ ] Handoff documentado en 00_admin/handoff/<nombre>_<fecha>.md
[ ] Reasignación de RACI §4 si era A en alguna decisión
[ ] Cierre de accesos (revocación):
    - GitHub (collaborator removed)
    - OneDrive equipo APER (acceso retirado)
    - 2FA tokens revocados (si tenía a RESTRINGIDO)
    - SSH keys removidas (si aplica)
    - Zenodo / WB internal (si tenía credenciales)
[ ] Si era TTL/co-TTL: anuncio público interno del cambio
[ ] Reconocimiento en Acknowledgments del próximo release (si contribución sustantiva)
[ ] Conversación de cierre con el TTL
```

---

## 9. Documentos a llenar durante el onboarding

| Documento | Cuándo | Quién firma |
|---|---|---|
| Declaración COI | día 1 | miembro nuevo |
| Hoja de acceso (GitHub + OneDrive + Zenodo + servidores) | día 1 | mentor + TTL |
| NDA si el rol involucra RESTRINGIDO + miembro no es WB / EAFIT | día 1 | miembro nuevo |
| Nota de checkpoint 30 días | día 30 | miembro + TTL + mentor |
| Acknowledgment de lectura de invariantes | día 1 | miembro |

---

## 10. Errores frecuentes en el onboarding (anti-patterns)

```text
- pedirle al nuevo que "lea todo .agent/ antes de tocar nada"
  → en su lugar: lectura guiada + primera contribución pequeña en semana 1

- no asignar mentor
  → cada nuevo necesita una persona de contacto explícita

- darle acceso RESTRINGIDO desde día 1 sin necesidad
  → mínimo privilegio; subir cuando el rol lo requiera

- no firmar COI por "ahorrar tiempo"
  → COI es prerrequisito; sin firma no participa

- olvidar onboardear al consultor STC porque "no es del equipo"
  → STC es Círculo 1; requiere onboarding completo proporcional al rol
```

---

## 11. TODOs para alcanzar v1.0

- [ ] Crear `00_admin/onboarding/` para notas de checkpoint.
- [ ] Crear plantilla de "Hoja de acceso" en `00_admin/onboarding/_template_acceso.md`.
- [ ] Mentor designado por default cuando alguien nuevo se incorpora.
- [ ] Lista de lecturas dirigidas §3.1 validada con el equipo.
- [ ] Decidir si COI es obligatorio para peer reviewers o solo para Círculo 1+2.

---

## 12. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: día 1, primera semana, primeros 30 días con checkpoint, casos especiales (TTL nuevo, consultor STC, revisor peer express), offboarding alineado con 11_EQUIPO §7, documentos por firmar, anti-patterns |
