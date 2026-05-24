# 06_NEUTRALIDAD.md — APER 2026 Bolivia

**Versión:** v0.1.0
**Última actualización:** 2026-05-23
**Alcance:** todo texto producido en el repositorio (capítulos del book, slides, web, briefs, cartas, alt-text, captions, README, commits que se hacen públicos).

---

## 1. Principio rector

El APER 2026 produce **evidencia técnica**, no advocacy.

> No estás escribiendo un informe que opine sobre Bolivia.
> Estás construyendo evidencia técnica reproducible para que el MEFP, con el WB, evalúe opciones de repurposing del gasto agrícola.

Neutralidad **técnica** ≠ neutralidad blanda. Las magnitudes se reportan con su tamaño real. Lo que se modula es el **lenguaje**, no la **evidencia**.

---

## 2. Reglas duras (no negociables)

### 2.1. Sin actores políticos nombrados

```text
PROHIBIDO:
- nombres de presidentes, ministros, parlamentarios
- nombres de partidos, frentes, coaliciones
- "el gobierno de X"
- "la administración de X"
- "durante la presidencia de X"

PERMITIDO:
- "en el periodo 20XX–20YY"
- "durante los años fiscales 20XX a 20YY"
- "bajo el marco normativo vigente en 20XX"
- nombres institucionales (MEFP, MDRyT, INE, ANAPO, EMAPA) cuando son fuente de datos o competencia institucional
```

### 2.2. Sin juicios morales sobre actores

```text
PROHIBIDO:
- "se equivocó"
- "acertó"
- "fracasó"
- "fue exitoso/a"
- "como prometió"
- "incumplió"
- "honró"
- "ignoró"

PERMITIDO:
- "los resultados observados muestran"
- "la cifra registrada fue"
- "la brecha frente al benchmark fue"
- "el indicador no alcanzó el valor esperado por X razones técnicas"
```

### 2.3. Sin lenguaje prescriptivo absoluto

```text
PROHIBIDO:
- "debe"
- "tiene que"
- "es necesario que"
- "urge"
- "es imprescindible"
- "el camino correcto es"

PERMITIDO:
- "una opción técnica sería"
- "un escenario consistente con la evidencia internacional"
- "para consideración del MEFP"
- "bajo el supuesto de techo fiscal constante"
- "manteniendo competencias institucionales actuales"
```

### 2.4. Sin advocacy emocional

```text
PROHIBIDO:
- "es urgente actuar"
- "no podemos esperar"
- "Bolivia necesita"
- "hay que transformar"
- "esto es inaceptable"

PERMITIDO:
- "la evidencia técnica sugiere margen de repurposing"
- "los retornos sociales del gasto en bienes públicos en la literatura son consistentemente más altos"
- "el indicador X se ubica Y puntos por debajo del benchmark regional"
```

### 2.5. Sin contrafactual político

```text
PROHIBIDO:
- "si se hubiera hecho X"
- "como prometía la administración Y"
- "a diferencia del gobierno anterior"

PERMITIDO:
- "bajo un escenario alternativo de composición del gasto"
- "frente al patrón histórico observado"
- "comparado con benchmarks regionales"
```

### 2.6. Sin adjetivos morales

```text
PROHIBIDO:
- "indebido"
- "irresponsable"
- "ineficaz" (cuando carga juicio; usar "no alcanzó la meta cuantitativa")
- "perverso"
- "regresivo" sin definición técnica explícita
- "progresivo" sin definición técnica explícita

PERMITIDO con definición:
- "regresivo" cuando se reporta incidencia con metodología citada
- "ineficiente" cuando se reporta brecha frente a frontera estimada
- "subóptimo" cuando se reporta dominancia frente a alternativa cuantificada
```

### 2.7. Sin adverbios innecesarios

```text
PROHIBIDOS por defecto (eliminar):
- "claramente"
- "obviamente"
- "evidentemente"
- "indudablemente"
- "ciertamente"
- "fuertemente"
- "significativamente" (cuando no hay test estadístico)
- "considerablemente"
- "dramáticamente"
- "sustancialmente" (cuando es retórico)

Permitidos solo cuando aportan precisión técnica:
- "estadísticamente significativo" (con p-value y test reportado)
- "monótonamente creciente" (cuando describe función)
```

Regla operativa: si podés borrar el adverbio y el claim sigue diciendo lo mismo, **lo borrás**.

---

## 3. Reglas suaves (preferencias editoriales)

| Preferencia | Por qué |
|---|---|
| Voz activa cuando hay sujeto institucional claro | "El MEFP registra…" vs. "Se registra por parte del MEFP…" |
| Frases cortas (≤ 25 palabras cuando se pueda) | Lectura policy + traducción ES↔EN más estable |
| Magnitudes con unidad explícita | "12% del PIB agrícola" no "12%" |
| Período explícito en cada claim cuantitativo | "2015–2023" no "en años recientes" |
| Incertidumbre declarada al primer uso | "X% (± Y pp, sensible a Z)" |
| Cita inline para fuentes externas | `[FAO 2023]` o `@fao2023` en BibTeX |
| Sin gerundios encadenados | "Bolivia está aumentando el gasto que viene creciendo…" → reescribir |

---

## 4. Glosario obligatorio

Términos que deben usarse exactamente como se definen en `01_METODOLOGIA.md` (cuando exista):

```text
gasto público agrícola            (definición operativa boliviana)
PSE / CSE                          (OECD methodology)
bienes públicos agrícolas         (vs. bienes privados/transferencias)
repurposing                       (reasignación dentro de techo fiscal)
escenario técnico                 (no recomendación, no prescripción)
nota de divergencia               (desacuerdo MEFP no resuelto)
panel v12                         (única fuente de verdad cuantitativa)
```

Sinónimos prohibidos (que pueden confundir al lector policy):

```text
"reforma del gasto" → usar "repurposing" o "reasignación dentro de techo fiscal"
"subsidios" sin tipificar → usar tipología técnica del PSE
"política agrícola" como cajón sastre → usar instrumento específico
"el sector" sin acotar → "el sector agrícola" o nombre del subsector
```

---

## 5. Reglas para escenarios de repurposing

Un escenario **siempre**:

1. Se nombra `Escenario S0X` con código.
2. Se acompaña de supuestos explícitos.
3. Declara si supone techo fiscal constante.
4. Cita la base de evidencia (literatura + panel).
5. Reporta banda de incertidumbre.
6. Lleva la marca **opción técnica para consideración del MEFP**, no prescripción.
7. No se compara con "lo que el gobierno debería hacer" — se compara con el baseline observado.

---

## 6. Reglas bilingües

Donde el contenido es bilingüe (executive summary, sitio público, slides ejecutivas, briefs):

```text
- mismo claim cuantitativo en ES y EN
- misma magnitud, mismo período
- misma cita de fuente
- misma declaración de incertidumbre
- alt-text equivalente (no traducción literal: equivalente comunicativo)
```

Términos técnicos en EN que **no se traducen**:

```text
- repurposing
- public goods (cuando se usa en sentido OECD/IFPRI)
- PSE / CSE
- BOOST (cuando refiere a la herramienta WB)
```

Términos técnicos en ES que **no se traducen**:

```text
- MEFP, MDRyT, INE, ANAPO, EMAPA (siglas institucionales)
- Plan de Desarrollo Económico y Social (cuando se cita el documento)
```

---

## 7. Reglas para captions y alt-text

### Caption (debajo de la figura)

```text
- empieza con el tipo de gráfico ("Composición del gasto…", "Evolución de…")
- período explícito
- unidad explícita
- fuente al final (entre paréntesis)
- sin adjetivos de valor ("notable", "preocupante")
```

### Alt-text

```text
- describe la figura para alguien que no la ve
- incluye la lectura principal en una oración
- termina con la fuente
- NO traduce el caption literal; lo amplía descriptivamente
```

Ejemplo:

```text
Caption: Composición del gasto agrícola por tipo de instrumento, 2015–2023 (% del total). Fuente: panel v12 sobre BOOST 2024.

Alt-text: Gráfico de barras apiladas que muestra cómo cambió la composición del gasto agrícola entre 2015 y 2023; la proporción asignada a bienes públicos se mantiene por debajo del 25% en todo el período, mientras transferencias y subsidios concentran la mayor parte. Fuente: panel v12 sobre BOOST 2024.
```

---

## 8. Reglas para citar al MEFP y otras contrapartes

```text
PERMITIDO:
- "según información provista por el MEFP en mesa técnica del DD-MM-AAAA…"
- "el MEFP indicó que la metodología vigente clasifica X como…"
- "en consulta técnica del DD-MM-AAAA, el MDRyT señaló que…"

PROHIBIDO:
- "el MEFP cree que"
- "el MDRyT quiere"
- "fuentes del gobierno"
- "según altos funcionarios"
```

Toda cita a contraparte queda con fecha y contexto. Si no hay fecha, no se cita.

---

## 9. Tests automáticos previstos

(A implementar en `scripts/audit_neutrality.R`)

```text
test_no_political_actors_named:
  - grep contra lista de nombres propios
  - grep contra nombres de partidos

test_no_moral_judgement:
  - grep contra lista de §2.2 y §2.6

test_no_advocacy:
  - grep contra lista de §2.4

test_no_unnecessary_adverbs:
  - grep contra lista de §2.7
  - umbral configurable

test_scenarios_marked_as_options:
  - cada escenario debe contener "opción técnica" o "for technical consideration"

test_uncertainty_declared:
  - cada claim cuantitativo en executive summary debe tener banda o nota
```

Salida esperada: reporte por capítulo con line numbers y sugerencias.

---

## 10. Excepciones documentadas

Si por razones técnicas un término del §2 es **necesario**, se documenta así:

```text
[EXCEPCIÓN NEUTRALIDAD §2.X — razón: ... — aprobada por: ... — fecha: ...]
```

Las excepciones se listan en el appendix del book y en `09_AUDITORIA.md`.

---

## 11. Frase de cierre obligatoria

Al final del executive summary y del último capítulo del book debe aparecer:

```text
Este reporte presenta análisis técnico del gasto público agrícola en Bolivia, producido por el Banco Mundial en diálogo con el MEFP. No constituye posición oficial del Estado Plurinacional de Bolivia. Las cifras son reproducibles desde el panel v12 y los scripts publicados; las opciones de repurposing son escenarios técnicos para consideración del MEFP, no recomendaciones vinculantes. La incertidumbre metodológica está declarada por hallazgo.
```

Versión en inglés equivalente en productos bilingües.

---

## 12. Cómo actualizar este archivo

Cambios a `06_NEUTRALIDAD.md` son **rojos** y requieren ADR si:

- se agrega o elimina una categoría de regla dura;
- se modifica el glosario obligatorio;
- se cambia la frase de cierre obligatoria.

Cambios amarillos:

- ampliar listas de adverbios o frases prohibidas;
- agregar ejemplos;
- agregar excepciones documentadas.
