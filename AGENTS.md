# AGENTS.md — APER 2026 Bolivia

**Versión:** v0.2.0 (thin pointer) · **Última actualización:** 2026-05-23

> **Esta es la puerta de entrada.** Toda la gobernanza operativa vive en [`.agent/`](.agent/).

---

## Antes de cualquier acción sustantiva, lee:

1. [`.agent/00_MASTER_PROMPT.md`](.agent/00_MASTER_PROMPT.md) — **fuente única** de identidad, invariantes, arquitectura, plan sección × sección, contratos, gates.
2. [`00_admin/RETOMAR.md`](00_admin/RETOMAR.md) — estado actual y próximos pasos.
3. [`.agent/README.md`](.agent/README.md) — mapa de todos los documentos de gobernanza.

Si vas a redactar, suma:
- [`.agent/05_ESTILO_NARRATIVO.md`](.agent/05_ESTILO_NARRATIVO.md) (TEEL + superestructura WB + Standard 0 anti-IA)
- [`.agent/06_NEUTRALIDAD.md`](.agent/06_NEUTRALIDAD.md) (vocabulario)

Si vas a construir o modificar figuras, suma:
- [`.agent/07_FIGURAS.md`](.agent/07_FIGURAS.md) (estándar gráfico, paleta, resolución, captions, anti-IA para gráficos)

Si vas a cambiar cifras/definiciones/metodología, suma:
- [`.agent/08_CONTROL.md`](.agent/08_CONTROL.md) (semáforo verde/amarillo/rojo)
- [`.agent/09_AUDITORIA.md`](.agent/09_AUDITORIA.md) (niveles A1–A5 de verificación)
- [`.agent/04_HALLAZGOS.md`](.agent/04_HALLAZGOS.md), [`.agent/01_METODOLOGIA.md`](.agent/01_METODOLOGIA.md), [`.agent/02_INDICADORES.md`](.agent/02_INDICADORES.md), [`.agent/03_FUENTES.md`](.agent/03_FUENTES.md)

Para gobernanza operativa extendida (riesgos, equipo, publicación, incidentes, etc.):
- [`.agent/10_RIESGOS.md`](.agent/10_RIESGOS.md) — registro de 20 riesgos con mitigación y dueño
- [`.agent/11_EQUIPO.md`](.agent/11_EQUIPO.md) — stakeholders, RACI, authorship, COI
- [`.agent/12_REPRODUCIBILIDAD.md`](.agent/12_REPRODUCIBILIDAD.md) — stack canónico, rebuild end-to-end
- [`.agent/13_PUBLICACION.md`](.agent/13_PUBLICACION.md) — estrategia, embargo MEFP, licencias, DOI
- [`.agent/14_CONFIDENCIALIDAD.md`](.agent/14_CONFIDENCIALIDAD.md) — PÚBLICO/INTERNO/RESTRINGIDO
- [`.agent/15_SEGURIDAD.md`](.agent/15_SEGURIDAD.md) — secrets, backups, accesos
- [`.agent/16_INCIDENTES.md`](.agent/16_INCIDENTES.md) — errata, brecha, post-mortem blameless
- [`.agent/17_GIT_WORKFLOW.md`](.agent/17_GIT_WORKFLOW.md) — branches, commits, tags, releases
- [`.agent/18_ONBOARDING.md`](.agent/18_ONBOARDING.md) — incorporación de personas
- [`.agent/19_COMUNICACION.md`](.agent/19_COMUNICACION.md) — canales, voceros, mesa MEFP, Q&A

---

## Principio rector

> No estás escribiendo un informe que opine sobre Bolivia.
> Estás construyendo evidencia técnica reproducible para que el MEFP, con el WB, evalúe opciones de repurposing del gasto agrícola.

---

## Invariantes no negociables (resumen)

Ver detalle en [`.agent/00_MASTER_PROMPT.md`](.agent/00_MASTER_PROMPT.md) Parte 3.

| # | Invariante | Falla típica que evita |
|---|---|---|
| 3.1 | Trazabilidad cuantitativa | Cifra fantasma sin RDS de respaldo |
| 3.2 | Fuente única (panel v12) | Cifras de archivos paralelos sin reconciliar |
| 3.3 | Neutralidad técnica | Advocacy, juicios morales, actores políticos nombrados |
| 3.4 | LLM-as-writer-not-calculator | Promedios mentales, cifras "recordadas" |
| 3.5 | Paridad bilingüe ES/EN | Claims diferentes en cada idioma |
| 3.6 | Versionamiento | Cambios de definición sin bump ni ADR |
| 3.7 | Reproducibilidad | Edición manual no documentada |

Si tienes que elegir entre velocidad y violar un invariante: paras, lo flagueas en `00_admin/RETOMAR.md`, no lo violas.

---

## Comandos canónicos

```bash
# Restaurar entorno R reproducible
Rscript -e 'renv::restore()'

# R del proyecto (sin init file global)
/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file

# Renderizar el sitio público (UTF-8 obligatorio)
cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render

# Renderizar el reporte técnico
cd 04_report && quarto render

# Test local del sitio
cd docs && python3 -m http.server 8000  # → http://localhost:8000
```

---

## Cierre de sesión

Toda sesión cierra con:
1. Bloque estandarizado pegado en `00_admin/RETOMAR.md` (formato ver `.agent/00_MASTER_PROMPT.md` Parte 15).
2. Si hubo cambio ROJO: ADR en `.agent/decisions/`.
3. Si se afectó cifra publicada: bump de `panel_version` o `methodology_version` o `findings_version`.

---

*Este archivo es intencionalmente corto: la verdad operativa vive en `.agent/`. Antes de esta versión (v0.1.0 → v0.2.0), `AGENTS.md` duplicaba contenido del Master Prompt; ahora apunta.*
