# 14_CONFIDENCIALIDAD.md — Clasificación y manejo de datos

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/14_CONFIDENCIALIDAD.md`
**Marco de referencia:** WB Access to Information Policy, ISO/IEC 27002 (information classification), data minimization principles.
**Lecturas relacionadas:** [`03_FUENTES.md`](03_FUENTES.md), [`11_EQUIPO.md`](11_EQUIPO.md) (COI), [`13_PUBLICACION.md`](13_PUBLICACION.md), [`15_SEGURIDAD.md`](15_SEGURIDAD.md), [`16_INCIDENTES.md`](16_INCIDENTES.md).

> Cada dato del proyecto tiene un nivel de clasificación. Sin clasificación explícita, se asume el nivel más restrictivo.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **Tres niveles, claros.** PÚBLICO, INTERNO, RESTRINGIDO. Sin grises.
2. **Default conservador.** Lo no clasificado se trata como RESTRINGIDO hasta que se clasifique.
3. **Need-to-know.** Acceso por rol, no por curiosidad. Una persona accede a lo que necesita para su tarea.
4. **Trazabilidad de acceso.** Quién accedió a qué nivel queda en el log de auditoría cuando sea relevante.

---

## 2. Niveles de clasificación

### 2.1. PÚBLICO

```text
definición:    cualquier persona en internet puede acceder
ejemplos:
  - el reporte publicado (book, web, slides, briefs)
  - panel v12 dataset publicado (CC-BY 4.0)
  - scripts en repo público
  - presentaciones en eventos abiertos
  - press releases del WB
control:       repo público en GitHub; sitio público en GitHub Pages
publicabilidad: sí, post-A5 release
distribución:  abierta
```

### 2.2. INTERNO

```text
definición:    equipo APER (Círculo 1 — ver 11_EQUIPO §2.1) + co-TTL +
               consultor STC bajo NDA
ejemplos:
  - borradores en cualquier estado (draft / reviewed pre-A4)
  - bitácora RETOMAR.md (estado vivo del proyecto)
  - syncs internos y minutas
  - registros de auditoría A2 y A3
  - configuración técnica del proyecto
  - fichas de lectura del equipo
  - declaraciones COI agregadas (no las individuales)
control:       repo privado o repo público con .gitignore para items
               internos; carpetas con permisos de WB SharePoint si aplica
publicabilidad: NO; pueden volverse públicos después del release si la
               clasificación lo permite
distribución:  solo dentro del equipo APER
```

### 2.3. RESTRINGIDO

```text
definición:    nivel más alto; acceso por necesidad explícita
ejemplos:
  - declaraciones COI individuales (con datos personales)
  - minutas de mesa técnica MEFP con atribución a personas
  - comentarios MEFP no anonimizados
  - cartas formales WB-MEFP con contenido sensible
  - datos crudos con restricción de licencia (e.g. micro-datos INE bajo
    acuerdo restringido si aplica)
  - cualquier dato personal identificable
  - credenciales, tokens, API keys
control:       NO entra al repo (incluso privado); vive en OneDrive
               restringido + 2FA, carpeta con permisos individuales
publicabilidad: NO bajo ninguna circunstancia salvo declassification
               documentada y consentimiento
distribución:  solo personas nombradas con need-to-know
```

---

## 3. Matriz de clasificación por tipo de artefacto

| Artefacto | PÚBLICO | INTERNO | RESTRINGIDO |
|---|:---:|:---:|:---:|
| Reporte publicado (book, web, slides, briefs post-A5) | ✓ | | |
| Panel v12 dataset post-release | ✓ | | |
| Scripts del repo | ✓ | | |
| `00_MASTER_PROMPT.md` y demás `.agent/0N_*.md` | ✓ | | |
| `README.md` raíz | ✓ | | |
| Borradores `04_report/*.qmd` pre-release | | ✓ | |
| Borradores web `www/*.qmd` pre-release | | ✓ | |
| Borradores slides | | ✓ | |
| `00_admin/RETOMAR.md` | | ✓ | |
| `00_admin/ESTADO_DE_DATOS.md` | | ✓ | |
| Syncs internos y minutas | | ✓ | |
| Registros A2 y A3 sin identificación de personas externas | | ✓ | |
| Versiones pre-v12 del panel | | ✓ | |
| Documentación técnica interna | | ✓ | |
| Declaraciones COI individuales firmadas | | | ✓ |
| Minutas mesa técnica MEFP (con nombres) | | | ✓ |
| Comentarios MEFP no agregados / anonimizados | | | ✓ |
| Cartas WB ↔ MEFP con contenido sensible | | | ✓ |
| Datos crudos con licencia restringida | | | ✓ |
| Credenciales, tokens, API keys | | | ✓ |
| Backups con datos restringidos | | | ✓ |
| Cualquier dato personal identificable (PII) | | | ✓ |

---

## 4. Reglas operativas

### 4.1. Storage por nivel

```text
PÚBLICO:
  - GitHub público (repo del proyecto)
  - GitHub Pages (sitio público)
  - Zenodo (deposit de releases)

INTERNO:
  - GitHub privado o GitHub público con secciones en .gitignore
  - OneDrive equipo APER (carpeta compartida con TODO el equipo)
  - SharePoint WB si aplica

RESTRINGIDO:
  - OneDrive con permisos individuales y 2FA obligatorio
  - NUNCA en repo git (incluso privado)
  - Carpeta dedicada: 00_admin/restricted/ con .gitignore
  - Acceso por solicitud nombrada al TTL
```

### 4.2. Estructura `00_admin/` por clasificación

```text
00_admin/
  README.md                          PÚBLICO — describe la carpeta
  RETOMAR.md                          INTERNO — bitácora
  ESTADO_DE_DATOS.md                  INTERNO — gaps de datos
  SINERGIA_ToR_PSE_Repurposing.md     INTERNO — coordinación STC
  Inventario_Datos_APER_*.xlsx        INTERNO — inventario fuentes
  cartas/
    carta_MEFP_<fecha>.docx           RESTRINGIDO — carta formal
    carta_Jubileo_<fecha>.md          INTERNO — comunicación operativa
  mesas_tecnicas/
    YYYY_MM_DD_minuta.md              RESTRINGIDO (si nombres MEFP)
                                       INTERNO (si agregada / anonimizada)
  coi/                                RESTRINGIDO — declaraciones individuales
    <nombre>_<fecha>.md
  handoff/                            RESTRINGIDO (transferencias entre
    <nombre>_<fecha>.md               personas; pueden contener info COI)
  syncs/                              INTERNO — minutas internas
    YYYY_MM_DD_sync.md
  release_<vX.Y.Z>/                   pre-release INTERNO; post-release PÚBLICO
  audit_log/                          INTERNO — log de A2-A5
    audit_log_2026.md
```

### 4.3. .gitignore obligatorio para no-publicables

```text
# carpetas restringidas
00_admin/restricted/
00_admin/coi/
00_admin/handoff/
00_admin/cartas/*.docx
00_admin/mesas_tecnicas/*_restringida.md

# credenciales y secrets (también en 15_SEGURIDAD.md)
.env
.env.local
*.key
*.pem
*_secret.*
**/CREDENCIALES.md

# backups locales
.bak
*~
```

---

## 5. Cómo clasificar un artefacto nuevo

1. **¿Contiene datos personales identificables (PII)?** → RESTRINGIDO automático.
2. **¿Contiene atribución a personas en el MEFP / MDRyT / contrapartes?** → RESTRINGIDO.
3. **¿Contiene credenciales, tokens, accesos?** → RESTRINGIDO.
4. **¿Es un borrador pre-release?** → INTERNO.
5. **¿Es coordinación operativa interna del equipo APER?** → INTERNO.
6. **¿Es un producto post-release (vX.Y.Z) ya publicado?** → PÚBLICO.
7. **En duda** → INTERNO por default; consultar con TTL antes de mover a PÚBLICO.

---

## 6. Política de manejo de comentarios MEFP

Esta es una zona particularmente sensible.

### 6.1. Recepción

```text
- Comentarios llegan vía mesa técnica (minuta), correo formal, o anotación
  en borrador compartido.
- Recibirlos NO los publica: entran a 00_admin/mesas_tecnicas/ RESTRINGIDO.
```

### 6.2. Procesamiento

```text
- Cada comentario se categoriza (HALLAZGOS §8 tipo D-NNNN si abre divergencia).
- La versión PÚBLICA del comentario (si llega a appendix del book) está
  anonimizada o agregada:
    - "El MEFP indicó que la clasificación X debería ser Y."  (sin persona)
    - "Comentario técnico recibido en mesa del 2026-MM-DD..." (sin persona)
- La versión INTERNA puede mantener atribución a rol (no a persona política).
- La versión RESTRINGIDA (minuta original) mantiene atribución completa.
```

### 6.3. Reglas duras

```text
- Nombres de personas del MEFP NUNCA aparecen en productos públicos.
- Posiciones políticas (Ministro, Viceministro) NUNCA se citan
  textualmente en productos públicos sin permiso por escrito.
- Roles técnicos genéricos (Dirección de Presupuesto, VIPFE) sí pueden
  citarse en agregado.
```

---

## 7. PII (Personally Identifiable Information)

### 7.1. Definición operativa

PII incluye, para el APER:

```text
- nombres + identificación de personas en encuestas
- coordenadas exactas de parcelas individuales
- identificadores fiscales de empresas individuales (si fueran usados)
- correos / teléfonos / direcciones de contrapartes y stakeholders
```

### 7.2. Reglas

- **El panel v12 NO contiene PII** — todo es agregado nacional o departamental.
- Encuestas INE EH se usan en agregado, nunca a nivel individual en outputs.
- Si alguna vez se incorpora un dataset con PII (e.g. encuesta CIPCA con productores nombrados), se separa del panel canónico y se procesa con anonimización antes de cualquier output.

### 7.3. Anonimización mínima

Si una fuente con PII se incorpora:

```text
- remover identificadores directos (nombre, DNI, CI, RUT, correo, teléfono)
- coordenadas → agregar a nivel municipio o superior
- ID interno aleatorio no reversible
- guardar la tabla de mapeo (si necesaria) en RESTRINGIDO + 2FA
```

---

## 8. Distribución de borradores

| Audiencia | Qué reciben | Cómo | Marca obligatoria |
|---|---|---|---|
| Equipo APER core | borradores actuales sin restricción interna | git (rama / commit) o OneDrive equipo | "DRAFT — internal" |
| co-TTL, STC PSE | borradores relevantes a su componente | igual | "DRAFT — internal" |
| Peer reviewer interno WB | versión revisada A3 lista para review | OneDrive con permiso temporal | "DRAFT — peer review only — do not distribute" |
| MEFP (mesa técnica) | versión post-A4 | canal acordado con MEFP (correo formal o portal) | "Borrador bajo embargo — para revisión técnica" |
| Público | NUNCA pre-release | n/a | n/a |

Cada borrador entregado externamente lleva watermark `DRAFT — vX.Y.Z — DD/MM/YYYY` en el pie de cada página.

---

## 9. Período de retención

| Tipo | Retención mínima | Notas |
|---|---|---|
| Reporte publicado | Permanente | en GitHub + Zenodo |
| Panel v12 publicado | Permanente | Zenodo |
| Borradores pre-release | 5 años post-release | en `.agent/legacy/` |
| Minutas mesa técnica MEFP | 10 años | RESTRINGIDO, OneDrive |
| Declaraciones COI | 10 años | RESTRINGIDO |
| Datos crudos con licencia | según licencia | mínimo hasta release + 5 años |
| Audit log | 10 años | INTERNO post-release |
| Comunicaciones WB-MEFP | según WB Records Mgmt | RESTRINGIDO si tenían PII |

Al cierre del proyecto, archivo formal según WB Records Management Policy.

---

## 10. Declassification (downgrade de nivel)

Un artefacto puede bajar de nivel (e.g. de INTERNO a PÚBLICO) **solo** si:

1. La razón inicial para el nivel restrictivo dejó de aplicar (e.g. embargo terminó).
2. El TTL aprueba el downgrade por escrito.
3. Si hay PII o atribución a personas: las personas afectadas dieron consentimiento O el dato se anonimizó.
4. La acción queda en el audit log con fecha y firma.

Nunca se sube de nivel **a posteriori** — si algo fue público, lo fue. Lo que se hace es retractar (`16_INCIDENTES.md`) si fue publicado por error.

---

## 11. Brecha de confidencialidad

Categoría de incidente (`16_INCIDENTES.md` T-06):

```text
- borrador INTERNO compartido públicamente
- minuta RESTRINGIDA enviada a audiencia incorrecta
- credenciales filtradas (también activa 15_SEGURIDAD.md protocolo)
- PII en producto público no anonimizada
```

Severidad típica: **P0 o P1** según contenido. Protocolo de respuesta en `16_INCIDENTES.md`.

---

## 12. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `03_FUENTES.md` | §9 licencias informa qué fuentes son redistribuibles |
| `11_EQUIPO.md` | COI individuales son RESTRINGIDO |
| `13_PUBLICACION.md` | Define qué entra al release público |
| `15_SEGURIDAD.md` | Credenciales y .env son RESTRINGIDO técnico |
| `16_INCIDENTES.md` | Brecha de confidencialidad es categoría T-06 |
| `09_AUDITORIA.md` | A4 verifica clasificación antes del handoff MEFP |
| `00_admin/audit_log/` | INTERNO; refleja accesos relevantes |

---

## 13. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Agregar artefacto a matriz §3 | AMARILLO |
| Cambiar nivel de un tipo de artefacto | ROJO + ADR |
| Cambiar los 3 niveles (agregar / quitar / renombrar) | ROJO + ADR |
| Cambiar retención mínima §9 | ROJO + ADR + revisión WB Records |
| Cambiar reglas PII §7 | ROJO + ADR + revisión legal WB |

---

## 14. TODOs para alcanzar v1.0

- [ ] Auditar todos los archivos del repo y asignar nivel explícito.
- [ ] Crear `00_admin/restricted/` con permisos OneDrive 2FA.
- [ ] Completar `.gitignore` con todas las rutas RESTRINGIDAS.
- [ ] Documentar la convención de watermark de borradores.
- [ ] Validar política PII con legal WB (si aplica).
- [ ] Programar revisión anual de niveles de clasificación.

---

## 15. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: 3 niveles (PÚBLICO/INTERNO/RESTRINGIDO), matriz de clasificación por artefacto, política de manejo de comentarios MEFP, regla de PII, distribución de borradores con watermark, período de retención, declassification, integración con INCIDENTES |
