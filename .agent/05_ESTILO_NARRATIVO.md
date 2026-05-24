# 05_ESTILO_NARRATIVO.md — APER 2026 Bolivia

**Versión:** v0.3.0
**Última actualización:** 2026-05-23
**Alcance:** capítulos del Quarto book, executive summary, briefs, slides ejecutivas, páginas del sitio público, cartas técnicas al MEFP.
**Lecturas relacionadas:** [06_NEUTRALIDAD.md](06_NEUTRALIDAD.md), [CLAUDE.md](../CLAUDE.md), [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md).
**Skill canónica para prosa EN:** `/quijote-writer` (Academic Writing Standards for Economists).

> NEUTRALIDAD dice **qué palabras** se pueden usar.
> Este archivo dice **cómo se arman los párrafos** con esas palabras.
> Y, antes que todo, dice **qué prosa nunca se publica** porque suena a IA sin editar (§3).

---

## 1. Principio rector

El APER 2026 se escribe en estilo **policy-report del Banco Mundial**:

- finding-first, no narrative-first;
- evidencia cuantificada y trazada;
- mecanismo explicado, no insinuado;
- implicación expresada como **opción técnica**, nunca como prescripción.

La unidad de trabajo es el **párrafo TEEL**, embebido en una **superestructura WB** que organiza capítulos y secciones (BLUF → pirámide → signposting). Antes de cualquier output, el redactor (humano o LLM) pasa el filtro anti-IA del §3.

> Un capítulo bien escrito es un árbol de TEEL anidados: cada sección es un párrafo TEEL grande; cada párrafo dentro es un TEEL chico; el book entero es un TEEL gigantesco con executive summary como Topic, capítulos como Evidence + Explanation y recomendaciones como Link.

---

## 2. La anatomía TEEL en una página (cheat sheet)

```text
┌─────────────────────────────────────────────────────────────────┐
│ T — Topic sentence (1 oración)                                  │
│     UN claim cuantitativo, finding-first, sin floritura.        │
│     Trae la magnitud y el período.                              │
│                                                                 │
│ E — Evidence (1–3 oraciones)                                    │
│     Cifra(s) con trazabilidad: figura/tabla referenciada,       │
│     fuente cruda, año, unidad. Sin interpretación todavía.      │
│                                                                 │
│ X — Explanation (1–3 oraciones)                                 │
│     Qué significa la evidencia. Mecanismo. Comparación con      │
│     benchmark. Incertidumbre. Caveats. Sin advocacy.            │
│                                                                 │
│ L — Link (1 oración)                                            │
│     Puente al siguiente párrafo, hallazgo o escenario.          │
│     Aquí — y solo aquí — puede aparecer "una opción técnica     │
│     sería" o "esto se explora en §X.Y".                         │
└─────────────────────────────────────────────────────────────────┘
```

Longitud objetivo: **80–140 palabras por párrafo**. Si pasa de 160, casi seguro contiene dos ideas — partir en dos TEEL.

> Nota notacional: a partir de v0.2.0 usamos **X** para Explanation y **E** para Evidence, para evitar la ambigüedad de las dos "E" del acrónimo original. La palabra "TEEL" sigue siendo la marca; internamente el orden es **T → E → X → L**.

---

## 3. STANDARD 0 — Pre-vuelo anti-prosa-IA (no negociable)

Esta sección **se ejecuta antes que las §4–§11** y **anula** cualquier otra consideración estilística salvo corrección factual. Está adaptada del Standard 0 de la skill [`/quijote-writer`](https://) (Academic Writing Standards for Economists), que es la **autoridad canónica para prosa en inglés** del proyecto.

### 3.1. Por qué

Un borrador con prosa rugosa pero humana es preferible a un borrador con prosa pulida que suena a LLM. La prosa con marcadores de IA pierde credibilidad antes de que su argumento sea evaluado: peer reviewers y editores del WB están entrenados para detectarla, y el MEFP la lee como "el WB no se tomó esto en serio". Una sola página con tono de IA contamina todo el reporte.

### 3.2. Las 12 banderas rojas

Cada bandera es una señal dura de prosa LLM sin edición humana. **Una ocurrencia = bandera. Dos o más en el mismo párrafo = regenerar el párrafo entero.**

1. **Cadenas de verbos aspiracionales.** `aimed to + V-ing + V-ing`, `intended to + V + and + V`, `busca + V + y + V`. Rechazar: *"This component aimed to reinforce the intervention by promoting discussion and increasing engagement."* / *"Este componente buscaba reforzar la intervención promoviendo el diálogo y fortaleciendo la participación."*

2. **Cadenas modificadoras vacías.** Verbos del tipo `designed to / intended to / presented as / serves to / strives to / seeks to / busca / pretende / apunta a / aspira a` + frase nominal abstracta. Rechazar: *"una herramienta concebida para fortalecer la toma de decisiones."*

3. **Oraciones multi-cláusula huecas.** 25+ palabras con dos o más cláusulas relativas (`which / that / que / la cual`) encadenadas, terminando en sustantivo abstracto. Rechazar y partir en dos.

4. **Aliteración tripartita.** Listas de tres verbos o adjetivos casi rimados. Rechazar a la vista:
   - EN: *produce, promote, prioritize / robust, reliable, replicable / foster, facilitate, formalize / navigate, negotiate, network*.
   - ES: *fortalecer, fomentar, formalizar / promover, profundizar, priorizar / robusto, resiliente, replicable / articular, alinear, armonizar*.

5. **Sobreuso de em dash.** Más de un em dash (—) por párrafo usado como pausa estructural. Después del segundo en un párrafo, reemplazar por punto, paréntesis o coma.

6. **Simetría mecánica de párrafos.** Tres o más párrafos consecutivos con longitud similar, abridor similar y estructura interna similar. La prosa académica real es **asimétrica**. Romper deliberadamente el ritmo.

7. **Vocabulario IA.** Las siguientes palabras aparecen desproporcionadamente en texto LLM sin editar:
   - **EN:** *leverage, navigate, robust, comprehensive, delve, pivotal, endeavor, harness, tapestry, foster, cultivate, embark, paramount, multifaceted, holistic, intricate, seamless, dynamic, vital, crucial, essential, unprecedented, transformative, nuanced, profound, meaningful, rich*.
   - **ES:** *fortalecer, fomentar, robusto, integral, profundizar, clave, emprender, aprovechar, tejido, cultivar, primordial, multifacético, holístico, intrincado, articulado, dinámico, vital, crucial, esencial, sin precedentes, transformador, matizado, profundo, significativo*.

   **Dos palabras de esta lista en el mismo párrafo = regenerar.**
   **Una sola en el abstract / executive summary / mensajes clave = regenerar.**

8. **Apilamiento de hedges.** Marcadores de incertidumbre acumulados: *may potentially / could possibly / might suggest that / podría eventualmente / posiblemente podría / parecería sugerir que*. Rechazar y dejar **un solo** hedge.

9. **Aperturas vacías.** Oraciones o párrafos que empiezan con:
   - EN: *It is worth noting that / It is important to mention that / In recent years / In today's world / This paper aims to / In the rapidly evolving landscape of / In the modern era*.
   - ES: *Cabe mencionar que / Es importante señalar que / En los últimos años / En el mundo actual / Este reporte busca / En el panorama actual / En la era moderna*.

   Borrar el abridor y empezar con el hecho.

10. **Topic-sentence obligatorio en cada párrafo.** Que **todos** los párrafos abran con una topic sentence perfectamente declarativa es **en sí mismo** una señal de IA. **Al menos uno de cada tres párrafos** debe abrir con un hecho, una cifra, una cita, o un *"Dado X, …"* / *"Given X, …"* antes de que aparezca la idea topical.

11. **Abstracción rimbombante.** *In the realm of / in the landscape of / at the heart of / at the intersection of / in the era of / en el ámbito de / en el panorama de / en el corazón de / en la intersección de / en la era de*. Reemplazar por referencia concreta.

12. **Conclusión sin evidencia.** *demonstrating the importance of / underscoring the need for / highlighting the critical role of / lo que demuestra la importancia de / lo que subraya la necesidad de / poniendo de manifiesto el rol crítico de*. La IA inserta estas frases para sonar académica. **Aportar la evidencia o borrar la afirmación.**

### 3.3. Lista NEVER WRITE — tolerancia cero (ES + EN)

Estas frases no aparecen en ninguna salida de este proyecto. Si un borrador las contiene, se flaguean **todas las ocurrencias** con su línea.

**Inglés:**

```text
It is worth noting that
It is important to note / mention / highlight that
It goes without saying that
In recent years
In today's world
In the rapidly evolving landscape (of)
In the modern era
A growing body of research / literature
Plays a pivotal role
Serves as a testament to
Underscores the importance of
Comprehensive understanding
Multifaceted approach
Robust framework
Unprecedented levels of
Game-changing
Cutting-edge
Foster a deeper understanding
Navigate the complexities (of)
Delve into
Embark on a journey
At the heart of
At the intersection of
A nuanced understanding of
Stands as a testament to
A profound impact on
It is essential to
It is crucial to
Of paramount importance
Holistic approach
The very fabric of
Rich tapestry (of)
Plays a vital role
```

**Español:**

```text
Cabe mencionar que
Cabe destacar que
Es importante señalar que
Es importante mencionar que
Vale la pena destacar que
No está de más mencionar que
En los últimos años
En el mundo actual
En el panorama actual
En la era moderna
Un creciente cuerpo de literatura / investigación
Juega un rol clave / pivotal / fundamental
Constituye un testimonio de
Subraya la importancia de
Comprensión integral
Enfoque integral / multifacético / holístico
Marco robusto
Niveles sin precedentes de
Revolucionario
Innovador / de vanguardia
Fomentar una comprensión más profunda
Navegar las complejidades de
Profundizar en
Emprender un viaje
En el corazón de
En la intersección de
Una comprensión matizada de
Un impacto profundo en
Es esencial
Es crucial
De vital / primordial importancia
Enfoque holístico
El tejido mismo de
Rico tapiz de
Juega un papel vital
```

### 3.4. Loop de validación obligatorio

Antes de publicar prosa (propia o reescrita), correr **en este orden**:

```text
1. Leer el output completo como bloque.
2. CAPA BASE — escanear:
   - las 12 banderas rojas (§3.2)
   - la lista NEVER WRITE (§3.3) en ES y EN
3. CAPA EXTENDIDA — escanear:
   - vocabulario IA extendido (§3.11)
   - sellos sintácticos (§3.12)
   - sellos estructurales (§3.13): three-bullet, listicle creep, headers, énfasis, preguntas retóricas
   - cohesión hueca (§3.14)
   - andamiaje narrativo (§3.15)
   - teatralidad cuantitativa (§3.16) — adjetivos sin magnitud
   - tropos narrativos (§3.17)
   - auto-divulgación de modelo (§3.18) — tolerancia cero
   - verificación anti-alucinación (§3.19) — números, citas, decretos, programas
   - tipografía y unicode (§3.20)
   - defensive prose (§3.21)
   - tone calibration (§3.22)
4. CAPA ES (si la prosa es en español) — escanear §3.24:
   - fórmulas académicas ES (§3.24.1)
   - anglicismos sintácticos del LLM (§3.24.2)
   - pasiva refleja sin agente conocido (§3.24.3)
   - subjuntivo abusado (§3.24.4)
   - conectores ornamentales ES (§3.24.5)
   - prosa zombie / sustantivos en -ción/-miento (§3.24.6)
   - tropos ES adicionales (§3.24.7)
   - tipografía ES — comillas, decimales, rayas (§3.24.8)
   - registro / sobre-formalidad (§3.24.9)
5. Si algo falla: regenerar el pasaje con instrucción explícita de evitar la bandera.
   No mostrar la versión que falla.
6. Asignar AI-likelihood score (0–10) usando rúbrica §3.10 (más estricta para ES, §3.24.11).
7. En modo auditoría, agregar al cierre del reporte:
   "AI-pattern check: N banderas activadas (lista por subsección §3.X);
    M frases NEVER WRITE detectadas; idioma ES/EN; score N/10."
   Si ninguna: declarar explícitamente
   "Checked all anti-AI flags §3.2–§3.24; no triggers found."
```

**Regla de oro del loop**: si el AI-likelihood score es ≥ 4 (EN) o ≥ 3 (ES), **no se muestra al usuario**; se regenera primero.

**Para prosa recibida** (revisión): el diagnóstico **debe** mostrar evidencia — qué bandera, qué fragmento, qué línea. Una revisión que reporta "limpio" sin la declaración explícita anterior **no se acepta**.

### 3.5. Cuando no podés evitar el patrón IA

Algunos contenidos son intrínsecamente secos y la prosa natural cae en patrones IA: descripciones de procedimientos, métodos, notas metodológicas, anexos técnicos. Si tras dos intentos seguís activando banderas:

- **parás de generar**;
- **declarás explícitamente** al usuario: *"Este pasaje es difícil de escribir naturalmente porque [razón]. Acá hay un borrador que activa [bandera], y acá hay una versión human-edited que pasa el check pero es menos pulida."*;
- ofrecés alternativas concretas;
- **nunca presentás prosa IA-flavored como prosa pulida**.

Honestidad sobre la limitación antes que output pulido pero sintético.

### 3.6. Reglas anti-detección (ritmo y asimetría)

Heredadas del §9 de `/quijote-writer`, aplicables a ES y EN:

- **Variar la longitud de párrafos.** Algunos de 2–3 oraciones, otros de 5–6. Nunca tres párrafos consecutivos del mismo largo.
- **Romper paralelismos consecutivos.** "X hace A. Y hace B. Z hace C." es máquina. Mezclar: una oración que reformula, una que matiza, una que avanza.
- **Sin conectores formulaicos en cada párrafo.** No siempre *However / Moreover / Furthermore / Sin embargo / Asimismo / Además*. Que las ideas conecten por contenido.
- **Una oración directa, coloquial, sin hedging, por sección.** "El problema es más simple de lo que parece." / "En la práctica, no funcionó."
- **No abrir todos los párrafos con topic sentence limpia.** Cada tercer párrafo puede abrir con un hecho, una cifra, o un *"Dado X, …"*.
- **Variar la posición de la cita.** No siempre al final. A veces mid-sentence, a veces al inicio, a veces omitida si el claim es descriptivo.
- **No producir estructuras perfectamente balanceadas pro/contra.** La escritura académica real es asimétrica.
- **Evitar aliteraciones** ("produce, promote, prioritize" / "fortalecer, fomentar, formalizar").
- **Dejar un finding declarado sin elaboración** antes de que la siguiente oración elabore. La IA explica todo de inmediato; el humano deja respirar.

### 3.7. Falsos cognados y latinismos (Spanish ↔ English)

Heredado del Standard 8 de `/quijote-writer`. Para prosa EN escrita por hispanohablantes:

| Patrón ES | Error EN típico | EN correcto |
|---|---|---|
| "A su vez" | "In their turn" | "In turn" / "Furthermore" |
| "Tal y como" | "Just as" | "As" |
| "De cara a" | "Facing" | "For" / "Toward" |
| "En aras de" | "In the airs of" | "To" |
| "Por otro lado" | "On the other side" | "On the other hand" / "However" |
| "Cabe mencionar que" | "It is worth mentioning that" | (borrar y decir el hecho) |
| "Se evidencia que" | "It is evidenced that" | "We find" / "Results show" |
| "Se procede a" | "We proceed to" | (borrar; hacerlo: "We estimate…") |
| "En definitiva" | "In a definitive manner" | "In sum" / "Overall" |
| "Dicho lo anterior" | "Said the foregoing" | "Given this" |
| "Utilizar" | "Utilize" | "Use" |
| "Metodología" como sinónimo de método | "Methodology" | "Method" |
| "Permite" + V-ing | "Allows + Ving" | "Allows us to" + infinitive |

### 3.8. American English por defecto

El APER 2026 se escribe en **American English** (alineado con estándar editorial WB):

- `-ize` no `-ise` (organize, analyze, recognize)
- `-or` no `-our` (labor, behavior, color)
- `-er` no `-re` (center, fiber)
- `while` no `whilst`; `among` no `amongst`; `toward` no `towards`
- `program` no `programme`; `judgment` no `judgement`; `enrollment` no `enrolment`

### 3.9. Invocación de `/quijote-writer`

`/quijote-writer` es la skill canónica para **revisión de prosa en inglés** del proyecto APER 2026. Invocarla en estos casos:

| Cuándo | Modo |
|---|---|
| Antes del handoff al MEFP de cualquier sección en EN | revisión sección por sección |
| Antes de publicar al sitio público (`www/`) en EN | revisión sección por sección |
| Antes de generar el executive summary EN | revisión completa de abstract |
| Cuando un capítulo EN llegue a estado `reviewed` | revisión completa de capítulo |
| Cuando una sesión escribió más de 500 palabras EN | barrido anti-AI |
| Cuando el AI-likelihood score auto-evaluado es ≥ 4 | regeneración asistida |

Para **prosa en español**, la skill no aplica directamente (está calibrada para EN), pero las banderas §3.2, la lista NEVER WRITE §3.3 y el loop §3.4 sí aplican usando las listas ES.

### 3.10. AI-likelihood score: rúbrica operativa

| Score | Diagnóstico | Acción |
|---|---|---|
| 0–1 | Prosa humana, asimétrica, sin marcadores IA | Publicar |
| 2–3 | Algún rastro IA pero menor (e.g., 1 adverbio filler aislado) | Pulir y publicar |
| 4–5 | Varias banderas, ritmo regular, vocabulario IA presente | Reescribir el pasaje afectado |
| 6–7 | Patrón IA dominante, simetría mecánica, hedges apilados | Regenerar el pasaje completo con instrucciones de evitación |
| 8–10 | Tono LLM puro | Descartar y reescribir desde el outline |

El score se reporta en el bloque de cierre de sesión (formato §8 de [AGENTS.md](../AGENTS.md)) cuando se haya escrito prosa sustantiva.

---

### 3.11. Vocabulario IA extendido (capa 2)

Listas adicionales sobre las del §3.2 flag 7. **Una palabra de esta capa en abstract / mensajes clave = regenerar; dos en cualquier párrafo = regenerar.**

**Cuantificadores vacíos:**

```text
EN: myriad, plethora, host of, array of, wealth of, manifold, countless,
    numerous, a number of, a variety of, a range of, a spectrum of,
    a constellation of, a suite of, a portfolio of
ES: una miríada de, un sinnúmero de, un abanico de, una gama de,
    un espectro de, una serie de, un conjunto de, un universo de,
    múltiples, diversos, variados (sin enumeración)
```

Sustitución: enumerar (3 cosas, no "a host of things") o dar cifra ("12 programas, no "a number of programs").

**Intensificadores hollow:**

```text
EN: remarkably, notably, particularly, especially, significantly
    (sin test), substantially, considerably, dramatically,
    profoundly, deeply, fundamentally, inherently, intrinsically
ES: notablemente, particularmente, especialmente, significativamente
    (sin test), sustancialmente, considerablemente, dramáticamente,
    profundamente, fundamentalmente, intrínsecamente
```

Regla: si podés borrar el adverbio y el claim sobrevive, **lo borrás** (NEUTRALIDAD §2.7 endurecido).

**Sustantivos abstractos de policy-marketing:**

```text
EN: framework, pathway, roadmap, ecosystem, landscape (figurado),
    space (figurado), arena, conversation (figurado), narrative,
    paradigm, blueprint, North Star, lodestar, compass (figurado)
ES: marco (cuando no es metodológico), hoja de ruta, ecosistema
    (figurado), panorama (figurado), espacio (figurado), conversación
    (figurado), narrativa, paradigma, brújula (figurado), norte
    (figurado)
```

Permitidos solo cuando son técnicos y definidos (e.g. "marco regulatorio del Decreto 0123", no "marco para pensar el problema").

**Verbos performativos vacíos:**

```text
EN: leverage, unlock, unpack, surface (as verb), operationalize,
    instrumentalize, orchestrate, curate, weave, knit, stitch,
    distill, scaffold
ES: apalancar, desbloquear, desempacar, operacionalizar,
    orquestar, curar (figurado), tejer, hilar, destilar, andamiar
```

**Adjetivos vacíos de "calidad":**

```text
EN: meaningful, impactful, transformative, game-changing,
    groundbreaking, paradigm-shifting, world-class, best-in-class,
    cutting-edge, state-of-the-art, next-generation
ES: significativo (sin test), impactante, transformador,
    revolucionario, innovador (sin justificar), de clase mundial,
    de vanguardia, de última generación
```

### 3.12. Sellos sintácticos del LLM

Patrones de oración que aparecen en GPT/Claude/Gemini independientemente del vocabulario. Cada uno es bandera.

**Patrones a flaguear:**

| Patrón | Ejemplo a rechazar | Reescritura |
|---|---|---|
| `Not only X, but also Y` | "Not only does the program reduce poverty, but it also improves health." | "The program reduced poverty by X% and improved health outcomes by Y pp." |
| `Both X and Y` apilado (≥2 por párrafo) | "Both productivity and equity are both important." | (eliminar uno de los "both") |
| `While X, Y` como apertura repetida | "While the data show improvement, the gap remains." | "The data show improvement. The gap remains." |
| `From X to Y` figurado | "From smallholders to large estates, the impact is clear." | "Smallholders and large estates both show impact, though magnitudes differ (table X.Y)." |
| `Whether X or Y` | "Whether through subsidies or transfers, the result is similar." | "Subsidies and transfers produce similar results (figure X)." |
| Tríada coordinada `X, Y, and Z` (cuando los 3 son del mismo registro abstracto) | "Productivity, sustainability, and resilience are key." | "Productivity (TFP), sustainability (CO₂eq), and resilience (yield variance) — each is measured separately." |
| Apositivos en comas anidados (≥2 niveles) | "The program, which was launched in 2015, aimed at smallholders, particularly those in highland regions, …" | (partir en dos oraciones) |
| Inversión sintáctica retórica | "Significant though the gains are, …" | "The gains are significant. However, …" |
| `It is X that Y` (cleft construction sobre-usado) | "It is the composition of spending that drives the result." | "The composition of spending drives the result." |
| `One of the most X` | "One of the most important findings is…" | "The main finding is…" |

### 3.13. Sellos estructurales

LLMs convierten prosa en estructura visible (listas, headers, énfasis). Reglas duras:

**Three-bullet syndrome:**

- Si una sección tiene **exactamente 3 bullets** repetidas dos veces seguidas, suena LLM. Variar: usar 2, 4 o 5; o convertir uno de los bloques en prosa.

**Listicle creep:**

- Si una idea cabe en 2 oraciones, **no** se convierte en bullet list.
- Bullet list solo si: (a) el orden no importa Y (b) cada bullet es realmente independiente Y (c) son ≥ 3 items.
- Evitar bullets de una palabra; evitar bullets con punto cuando son fragmentos.

**Headers cada 2 párrafos:**

- En el book, cada `##` debe cubrir al menos 3 párrafos sustantivos.
- Cada `###` debe cubrir al menos 2 párrafos o 1 párrafo + figura.
- Headers más cortos que eso = LLM saltando.

**Énfasis tipográfico abusivo:**

- **Bold** solo para términos del glosario (NEUTRALIDAD §4) en su primera aparición, o para encabezados de bullet en mensajes clave.
- *Italics* solo para términos en latín, nombres científicos, o títulos de obras. No para énfasis genérico.
- Si encontrás bold/italics más de una vez por párrafo: borrar el énfasis y dejar que la palabra cargue sola.

**Preguntas retóricas:**

- Cero preguntas retóricas en capítulos sustantivos del book.
- Permitidas en sección introductoria de cada capítulo **una sola vez**, formulada como pregunta de investigación, no como pregunta retórica de coaching ("Why does this matter?", "What does the data tell us?", "How can Bolivia move forward?").

**Numeración paralela excesiva:**

- "First… Second… Third… Finally…" en bullets es aceptable.
- En prosa corrida, **una sola** secuencia "Primero/First… Segundo/Second…" por sección. No más.

### 3.14. Cohesión hueca (conectores y bisagras)

Conectores que **parecen** transición pero son humo. Cada uno es bandera. Acción: borrar el conector y dejar la oración empezar con el sujeto.

```text
EN: Building on this, Taken together, In essence, Indeed,
    Of course, Crucially, Importantly, Notably, Interestingly,
    Strikingly, Tellingly, As such, In this regard, In light of this,
    With this in mind, That said, This being said, By the same token,
    On a related note, By extension, To this end, Accordingly,
    In essence, Ultimately (cuando es relleno)

ES: Sobre esta base, En conjunto, En esencia, De hecho,
    Por supuesto, Crucialmente, Importantemente, Notablemente,
    Curiosamente, Llamativamente, Como tal, En este sentido,
    A la luz de esto, Dicho esto, Por la misma razón, En una nota
    relacionada, Por extensión, En este orden de ideas, En definitiva
    (cuando es relleno), En última instancia (cuando es relleno)
```

Excepción: si el conector marca **un giro lógico real** (causa, consecuencia, contraste, ejemplo), está bien — pero usar el conector funcional preciso ("therefore", "however", "for example"), no el ornamental.

### 3.15. Andamiaje narrativo excesivo

LLMs explican su propia estructura. Cero tolerancia para:

```text
EN: In what follows, In this section, In the following section,
    The next section will, Having established X, we now turn to Y,
    Before turning to X, As we will see, As discussed above,
    As mentioned previously, As noted earlier, As stated before,
    The remainder of this section, This section will discuss,
    This section is organized as follows

ES: A continuación, En lo que sigue, En esta sección, En la siguiente
    sección, La próxima sección, Habiendo establecido X, antes de
    pasar a Y, Como veremos, Como se discutió antes, Como se mencionó
    anteriormente, Como se señaló previamente, El resto de esta sección,
    Esta sección discutirá, Esta sección se organiza de la siguiente manera
```

Excepciones permitidas (con moderación):

- **Una sola frase de roadmap** al final de la introducción del book (paragraph 4 de la intro, formato §4 de `/quijote-writer`).
- **Una sola referencia precisa** al final de un párrafo Link (§7) del tipo "§5.3 desarrolla la desagregación".

### 3.16. Teatralidad cuantitativa

Adjetivos cuantitativos sin cifra son ruido y, en un APER, son **fallo metodológico**. NEUTRALIDAD §2.6 endurecido.

**Prohibidos sin magnitud adjunta:**

```text
EN: significant, substantial, considerable, dramatic, sharp,
    sizable, marked, pronounced, modest, slight, moderate,
    wide, broad, narrow, deep, shallow, high, low,
    increased, decreased, improved, deteriorated, expanded, contracted
ES: significativo, sustancial, considerable, dramático, marcado,
    pronunciado, modesto, leve, moderado, amplio, estrecho, profundo,
    superficial, alto, bajo, aumentado, disminuido, mejorado,
    deteriorado, expandido, contraído
```

Regla: cada adjetivo cuantitativo va acompañado de **número + unidad + período**.

| Mala | Buena |
|---|---|
| "El gasto aumentó significativamente." | "El gasto aumentó 38% en términos reales entre 2015 y 2023." |
| "Una porción sustancial de los recursos…" | "62% de los recursos…" |
| "Productividad notablemente mayor en X" | "TFP 22% mayor en X (panel v12, 2018–2023)." |
| "Wide variation across regions" | "Variation across regions ranges from X% in Y to Z% in W." |

### 3.17. Tropos narrativos prohibidos

Frases hechas de marketing/storytelling importadas al policy report. **Cero tolerancia.**

```text
EN: at a crossroads, at a turning point, at a critical juncture,
    now more than ever, the time is ripe, the time has come,
    the clock is ticking, the window of opportunity,
    a journey toward, a pathway to, a roadmap for,
    through the lens of, through the prism of,
    in this space, in the policy space, in the conversation around,
    a story of, a tale of, a paradigm of, a vision of,
    on the road to, on the path to, on the cusp of,
    bridging the gap (figurado), turning the corner,
    moving the needle, raising the bar, leveling the playing field
ES: en una encrucijada, en un punto de inflexión, en un momento crítico,
    ahora más que nunca, ha llegado el momento, el tiempo apremia,
    la ventana de oportunidad,
    un camino hacia, una ruta hacia, una hoja de ruta para,
    a través de la lente de, a través del prisma de,
    en este espacio, en la conversación sobre,
    una historia de, un relato de, un paradigma de, una visión de,
    en el camino hacia, en la cúspide de,
    cerrar la brecha (figurado), dar vuelta la página, mover la aguja,
    elevar el nivel, nivelar el campo de juego
```

Sustitución: si necesitás transición narrativa, usá un hecho fechado ("entre 2015 y 2023…") o una pregunta de política ("¿cuál es la composición del gasto?…").

### 3.18. Auto-divulgación de modelo (tolerancia cero absoluta)

Nunca puede aparecer:

```text
"As an AI / language model / assistant"
"Based on my training"
"I cannot / I'm unable to / I don't have access to"
"While I cannot X, I can Y"
"My knowledge cutoff"
"I apologize, but"
"I hope this helps"
"Certainly!" / "Sure!" / "Absolutely!"
"Let me know if you need"
"Here's a draft for you"

equivalentes en ES:
"Como modelo de lenguaje / IA / asistente"
"Basado en mi entrenamiento"
"No puedo / no tengo acceso a"
"Mi corte de conocimiento"
"Espero que esto ayude"
"¡Claro!" / "¡Por supuesto!" / "¡Absolutamente!"
"Avísame si necesitas"
```

Acción: si **cualquiera** de estas frases aparece en un commit, archivo de gobernanza, capítulo del book, slide, brief o web → **rollback inmediato**.

### 3.19. Verificación anti-alucinación

LLMs inventan: números plausibles, autores con nombres creíbles, programas inexistentes, DOIs falsos, decretos inventados, fechas erróneas. En un APER que toca instituciones bolivianas, esto es **falta grave**.

**Antes de publicar, verificar:**

```text
[ ] Toda cifra cuantitativa: existe en panel v12 (RDS + script verificados)
[ ] Toda cita bibliográfica: aparece en references.bib con DOI/URL verificable
[ ] Todo programa/iniciativa boliviana nombrada: existe (verificar en sitio oficial MEFP/MDRyT/INE)
[ ] Toda fecha específica: verificada contra fuente primaria
[ ] Todo decreto/ley citado: verificado en Gaceta Oficial
[ ] Todo benchmark internacional: cita FAO/OECD/WB con año y URL
[ ] Toda sigla institucional: expandida en su primera aparición y verificada
[ ] Toda atribución ("según el MEFP en mesa técnica…"): fecha + minuta de la mesa
```

**Banderas de sospecha (revisión humana obligatoria):**

```text
- números demasiado redondos (50%, 100%, 1.000) sin trazabilidad
- "según estudios recientes" sin cita
- "el programa X demostró Y" sin cita verificable
- "expertos coinciden en" — borrar
- estadística boliviana sin fuente INE/MEFP/MDRyT
- autor con apellido común (Smith, Pérez, García) sin DOI
```

### 3.20. Tipografía y unicode

LLMs introducen caracteres Unicode silenciosamente. Algunos detectores académicos los marcan. Reglas:

**Caracteres y su uso:**

```text
em dash (—) U+2014       máximo 1 por párrafo (§3.2 flag 5)
en dash (–) U+2013       solo para rangos numéricos ("2015–2023")
hyphen (-)               para palabras compuestas y rangos no numéricos
ellipsis (…) U+2026      en lugar de "...". Aceptable, pero máximo 1 por página
smart quotes (" " ' ') U+201C–U+2019  consistentes en todo el book; configurar Quarto
straight quotes (" ')    NO usar (genera inconsistencia)
nbsp ( ) U+00A0          permitido entre cifra y unidad ("12 %", "USD 1 000")
soft hyphen U+00AD       PROHIBIDO (artefacto de LLM o PDF)
zero-width space U+200B  PROHIBIDO
```

**Auditoría rápida:**

```bash
# detectar caracteres unicode "sospechosos" (debe correr en CI)
grep -P '[\x{200B}\x{00AD}\x{FEFF}]' 04_report/*.qmd
```

**Espaciado del em dash:**

- Convención WB / Economist: **sin espacios** (`palabra—palabra`).
- Convención latinoamericana editorial: **con espacios** (`palabra — palabra`).
- Decisión del proyecto: **con espacios** (mejor legibilidad en Quarto/PDF, equivalente bilingüe).
- Aplicar consistentemente en todo el book.

### 3.21. Defensive prose y over-disclaiming

Hedging blando que diluye los claims. Bandera.

```text
EN: While not without limitations, Caveats notwithstanding,
    It should be acknowledged that, We acknowledge that,
    To be sure, To be clear, Of course,
    This is not to say that, This does not imply that
    (usado como muletilla en cada sección)

ES: Si bien no exento de limitaciones, Salvando las distancias,
    Cabe reconocer que, Reconocemos que, Por supuesto,
    Para ser claros, Sin que esto implique,
    Lo cual no significa que (como muletilla)
```

Sustitución: incertidumbre va en una **frase específica con la fuente del caveat** ("La cifra es sensible al tratamiento de X, ver apéndice A.3"), no en un disclaimer ornamental.

### 3.22. Tone calibration

Optimismo de marketing impropio del policy report. Bandera.

```text
EN: encouraging results, promising outcomes, notable progress,
    impressive gains, remarkable success, exciting findings,
    powerful evidence, compelling case, striking pattern,
    important lessons

ES: resultados alentadores, resultados prometedores, progreso notable,
    avances impresionantes, éxito remarcable, hallazgos emocionantes,
    evidencia poderosa, caso convincente, patrón llamativo,
    lecciones importantes
```

Sustitución: reportar la cifra y su comparación; el lector califica.

| Mala | Buena |
|---|---|
| "Los resultados son alentadores." | "El indicador X aumentó Y pp entre 2018 y 2023, recorriendo el 40% de la brecha hacia el benchmark regional." |
| "Una historia de éxito." | "Bolivia redujo la brecha en Y pp respecto al benchmark, frente a Z pp en el promedio regional." |

### 3.23. Referencias canónicas externas

El Standard 0 del APER 2026 se ancla en estándares editoriales reconocidos. Cuando un agente o revisor humano tenga duda sobre una regla, consultar (en orden):

1. **WB Editorial Style Guide** (World Bank Group) — autoridad institucional para el reporte. Reglas de capitalización, números, citas, abreviaciones.
2. **The Economist Style Guide** (12th ed., 2018) — referencia para prosa policy concisa y directa. "Use short words. Use short sentences. Do not be too clever."
3. **Strunk & White,** *The Elements of Style* (4th ed.) — "Omit needless words." Regla universal del §3 entero.
4. **Joseph M. Williams,** *Style: Toward Clarity and Grace* — para análisis sentence-level (active voice, agente claro, fluencia).
5. **Helen Sword,** *Stylish Academic Writing* (2012) — para evitar "zombie nouns" y prosa académica muerta. Su lista de "waste words" coincide con §3.11 y §3.14.
6. **UK GDS Plain English / US Plain Writing Act guidance** — referencias para el principio "more common word > less common word" (Standard 1 de `/quijote-writer`).
7. **APA Publication Manual** (7th ed.) — para citas, números, tablas (cuando el WB Style Guide remite a APA).

Para auditoría de prosa **anti-IA específicamente**, referencias adicionales:

8. **Helen Sword,** "The Writer's Diet Test" — herramienta sentence-level para detectar "flabby" prose.
9. **Bender, Gebru, McMillan-Major & Mitchell** (2021), "On the Dangers of Stochastic Parrots…" — base conceptual del riesgo de prosa LLM en contextos institucionales.
10. **Nature / Science** editorial guidelines sobre uso de IA generativa en escritura (2023+) — referencia para política de divulgación.

> Si una recomendación de esos textos contradice una regla del §3 del APER, **prevalece §3** (más estricto por diseño policy report).

---

### 3.24. Énfasis en prosa española (capa profunda)

**Por qué esta subsección es la más extensa del §3.** Los detectores anti-IA y las listas de patrones (incluidas las del propio `/quijote-writer`) están **fuertemente sesgadas hacia el inglés**: la literatura, las herramientas y los corpora de entrenamiento del detector están en EN. La prosa LLM en español pasa más fácilmente como humana porque:

- el español académico latinoamericano **tolera más** el registro formal, el subjuntivo y la voz pasiva — exactamente lo que el LLM defaultea;
- los anglicismos sintácticos que el LLM introduce desde su training EN-heavy **suenan elevados** en ES (no torpes);
- los conectores ornamentales ("asimismo", "por su parte", "en tal sentido") **son aceptados** en redacción académica tradicional ES pero son banderas LLM;
- las listas EN-céntricas del §3 no capturan estos patrones específicos.

Esta subsección **amplía y profundiza** las listas ES de las subsecciones previas con casos propios del español.

#### 3.24.1. Fórmulas académicas ES de tolerancia cero (extensión §3.3)

Frases que el español académico tradicional acepta pero que en prosa policy WB son banderas LLM duras. **Tolerancia cero**:

```text
Cabe destacar / Cabe señalar / Cabe mencionar / Cabe resaltar /
Cabe apuntar / Cabe agregar / Cabe añadir / Cabe acotar / Cabría señalar
Conviene destacar / Conviene señalar / Convendría apuntar
Es menester / Es dable apuntar / Es de destacar / Es de señalar
Es importante destacar / Es importante señalar / Es importante mencionar /
  Es importante notar / Es importante resaltar
Resulta importante / Resulta necesario / Resulta menester / Resulta relevante
Vale la pena destacar / Vale la pena mencionar / Vale la pena señalar /
  Vale destacar / Vale mencionar
No está de más / No está de más mencionar / No está de más señalar
Merece la pena / Merece especial atención / Merece destacarse
Es de notar que / Es de hacer notar que / Es preciso señalar que /
  Es preciso destacar que
Por su parte (como muletilla)
A su vez (como muletilla)
Asimismo (más de una vez por sección)
Del mismo modo / De igual manera / De igual forma (como muletillas)
En este sentido / En tal sentido / En ese sentido (como muletillas)
Bajo este marco / Bajo esta óptica / Bajo esta perspectiva /
  Bajo esta lógica / Bajo este enfoque
Dentro de este contexto / Dentro de este marco / Dentro de esta lógica
Desde esta perspectiva / Desde este enfoque / Desde esta óptica /
  Desde esta mirada / Desde esta visión
Es así como / Es de este modo que / Es por ello que / Es por esto que
De este modo / De esta manera / De esta forma (como muletillas)
En definitiva / En última instancia / En suma / En síntesis (como rellenos)
Por todo lo anterior / Por lo anteriormente expuesto / Por lo expuesto /
  Por lo dicho hasta aquí
A modo de cierre / A modo de conclusión / A manera de cierre
En aras de / En pos de / De cara a
Habida cuenta de / Habida cuenta que / Dado que (cuando es relleno)
Considerando que / Teniendo en cuenta que / Tomando en consideración que
A la luz de / A la luz de lo anterior
En el marco de (cuando no es referencia técnica)
A nivel de (como muletilla; preferir referencia específica)
En el plano de / En el ámbito de (como muletilla)
```

**Regla operativa**: si la oración sobrevive al borrarse el conector, **se borra el conector**.

#### 3.24.2. Anglicismos sintácticos del LLM en español

Patrones que el LLM importa desde su corpus EN al escribir en ES. Suenan "elevados" pero son falsos cognados estructurales. **Cada uno es bandera**.

| Patrón LLM (ES con sabor EN) | Por qué falla | Forma correcta |
|---|---|---|
| "el gasto y los componentes **del mismo**" | "mismo" como pronombre (anglicismo "of the same") | "el gasto y sus componentes" |
| "los productores y **las mismas** organizaciones" | id. | "los productores y esas organizaciones" / "esas mismas organizaciones" como adjetivo es aceptable |
| "**reportar** resultados" | anglicismo de "to report" | "informar resultados" / "presentar resultados" |
| "**soportar** la política" | anglicismo de "to support" | "respaldar / apoyar la política" |
| "**aplicar** (sin objeto) para el subsidio" | anglicismo de "to apply for" | "solicitar el subsidio" / "postular al subsidio" |
| "**direccionar** los recursos" | anglicismo de "to direct" | "orientar / dirigir / canalizar los recursos" |
| "**accesar** la información" | anglicismo de "to access" | "acceder a la información" |
| "**asumir** que el panel es completo" | anglicismo de "to assume" | "suponer que el panel es completo" |
| "**adicionalmente**" | anglicismo de "additionally" | "además" |
| "**eventualmente** ocurrirá" | falso cognado de "eventually" | "finalmente / con el tiempo" |
| "**en base a** los datos" | calco incorrecto | "con base en los datos" / "sobre la base de" / "a partir de" |
| "**a través de** + N abstracto" (cuando es muletilla) | anglicismo de "through" | "mediante" / "por medio de" |
| "**permite + gerundio**" ("permite reduciendo") | calco del gerundio inglés | "permite reducir" (infinitivo) |
| "**robusto**" (sin definición técnica) | anglicismo de "robust" | "sólido" / "consistente" / definir como técnico (e.g. "robusto a heterocedasticidad") |
| "**comprehensivo**" | calco de "comprehensive" | "integral / exhaustivo / completo" — y mejor concreto |
| "**implementar**" (overused) | anglicismo de "implement" | "ejecutar / poner en marcha / aplicar" según contexto |
| "**evidenciar**" (overused) | calco LLM de "to evidence" | "mostrar / documentar / demostrar" |
| "**impactar**" (transitivo) | anglicismo de "to impact" | "afectar / influir en / incidir en" |
| "**enfrentar desafíos**" como muletilla | calco de "to face challenges" | enumerar los desafíos concretos |
| "**al final del día**" | calco de "at the end of the day" | "en definitiva" o (mejor) borrar |
| "**la data**" (femenino, singular, anglicismo) | anglicismo de "the data" | "los datos" |
| "**ser exitoso**" (predicativo) | calco de "to be successful" | "tener éxito" / "cumplir el objetivo" |
| "**ser consistente con**" sin contexto técnico | calco de "consistent with" | "coincidir con / ser compatible con" (o "ser consistente con" si es uso estadístico técnico) |
| "**proveer**" + sustantivo abstracto | anglicismo de "to provide" | "ofrecer / brindar / dar / aportar" |
| "**El mismo / La misma**" como sujeto retomado | anglicismo de "the same" / "it" | usar el sustantivo o un demostrativo claro |

#### 3.24.3. Voz pasiva en español: cuándo es LLM

El español tolera la pasiva refleja ("se observa que…", "se evidencia que…") más que el inglés. **Pero el LLM la abusa**. Reglas:

- **Pasiva refleja con sujeto agente conocido** = bandera. Si la institución que actúa es conocida (MEFP, INE, BOOST), nombrarla.
  - Mala: *"Se evidencia que el gasto aumentó."*
  - Buena: *"El panel v12 muestra que el gasto aumentó."* / *"BOOST 2024 registra un aumento del gasto."*
- **Pasiva refleja como apertura de párrafo** (≥ 2 párrafos seguidos así) = bandera de simetría LLM.
- **"Se ha + participio"** repetido (≥ 3 veces en una sección) = bandera. El LLM gravita al perfecto compuesto cuando duda.
- **"Es + participio"** ("es ejecutado", "es financiado") sin agente = anglicismo. Preferir activa con agente o pasiva con "por": "ejecutado por el MDRyT".

#### 3.24.4. Subjuntivo de LLM

El español académico tradicional tolera subjuntivos elegantes ("convendría que se considerara…", "sería pertinente que…"). El LLM los **abusa para hedger** todo. Reglas:

- **Un solo nivel de subjuntivo de cortesía por sección.** "Sería pertinente que se examinara que se considerara…" = regenerar.
- **"Habría / podría / debería"** como hedge ornamental: rechazar. Reemplazar con claim factual o con "una opción técnica sería" (§7).
- **"Quizás / tal vez / acaso"** seguido de subjuntivo: usar **una sola vez** por sección, y solo cuando la incertidumbre es real y trazable.

#### 3.24.5. Conectores ornamentales ES (extensión §3.14)

Conectores que el LLM en ES usa como muletilla universal. **Cada ocurrencia es bandera**:

```text
"Es así como"          → borrar; empezar con el sujeto
"Es por ello que"      → borrar
"En este orden de ideas" → borrar
"En tal sentido"       → borrar
"En ese orden"         → borrar
"Por su parte"         → borrar o reemplazar con el sustantivo concreto
"A su vez"             → borrar o "También" / "Además"
"Asimismo" (>1 por sección)  → borrar las extras o reemplazar con "También"
"De igual manera / De igual forma" → "También" / "Igualmente" una sola vez
"Del mismo modo"       → idem
"Por otra parte"       → "También" o nada
"Por su lado"          → nombrar el sujeto
"Sobre el particular"  → borrar
"Al respecto"          → borrar o referencia concreta
"En lo concerniente a" → "sobre"
"En lo relativo a"     → "sobre"
"En lo referente a"    → "sobre"
"En cuanto a"          → aceptable una vez por sección
"Por lo que respecta a"→ "sobre"
"Habida cuenta de"     → "dado que" (una vez por sección)
```

#### 3.24.6. Vocabulario de prosa zombie ES (Sword adaptado)

Helen Sword llama "zombie nouns" a sustantivos abstractos terminados en `-ción`, `-miento`, `-ización`, `-idad` que vampirizan los verbos. En ES son rampantes y el LLM los multiplica:

```text
implementación, ejecución, articulación, operacionalización,
materialización, focalización, priorización, profundización,
fortalecimiento, fomento, impulso, mejoramiento, posicionamiento,
empoderamiento, alineamiento,
sostenibilidad, integralidad, transversalidad, intersectorialidad,
multidimensionalidad, complementariedad, gobernabilidad
```

Regla: si un párrafo tiene **≥ 3 zombies** sin verbo activo principal claro, reescribir con verbo activo. (Umbral relajado respecto al pedido original ≥2 para no saturar de banderas en prosa policy-talk ES tradicional; se endurece a ≥2 si futuras versiones del book muestran prosa LLM persistente.)

| Mala (zombie) | Buena (verbal) |
|---|---|
| "La implementación de la articulación intersectorial requiere el fortalecimiento de la priorización." | "El MEFP debe coordinar con el MDRyT y priorizar los instrumentos X y Y." |
| "La operacionalización de la sostenibilidad pasa por la transversalización del enfoque." | "Para sostener el programa Z, se aplica el criterio W en cada componente." |

#### 3.24.7. Tropos narrativos ES adicionales (extensión §3.17)

Específicos del policy report en español de la región (incluidos los del WB en español):

```text
"en una encrucijada", "ante una oportunidad histórica",
"un antes y un después", "un punto de quiebre",
"la hora de", "es el momento de",
"un cambio de paradigma", "una nueva manera de", "una mirada distinta",
"poner en valor", "poner en el centro",
"colocar en la agenda", "instalar en la conversación",
"abrir el debate", "tender puentes",
"sentar las bases", "echar raíces", "abrir caminos",
"hacia el futuro" (sin fecha), "rumbo a", "de cara al"
```

#### 3.24.8. Tildes, puntuación y tipografía ES

- **Tildes diacríticas**: el LLM a veces omite o agrega ("éste/este", "sólo/solo"). RAE actual: "este/esta/esto" sin tilde como pronombres; "solo" sin tilde. Aplicar consistente.
- **Comas vocativas y de inciso**: el LLM tiende a sobreusarlas. Si la coma no marca pausa lógica, borrarla.
- **Punto y coma**: el LLM ama el punto y coma. Tope: **1 por párrafo**. Si hay más, partir oraciones.
- **Guion vs. raya (em dash)**: en ES editorial latinoamericano la raya va con espacios (— como acá —). Decidido en §3.20.
- **Comillas**: **comillas dobles inglesas "…"** consistentes en todo el book (ES y EN). Decisión del proyecto. Comillas simples '...' solo para citas anidadas. **Nunca mezclar con «…» ni con straight quotes.**
- **Cifras**: separador decimal **coma** ES ("1,4% del PIB") vs **punto** EN ("1.4% of GDP"). Consistencia por idioma. Separador de miles: punto en ES ("1.000"), coma en EN ("1,000"). NO el separador francés con espacio (1 000) salvo cita literal.

#### 3.24.9. Registro y formalidad ES

El español académico tradicional latinoamericano (incluido el del WB en ES) tiende a la **sobre-formalidad**. El LLM la lleva al extremo. Reglas:

- **Sin gerundios de posterioridad ni de explicación**: "El MEFP autorizó el gasto, **siendo** este ejecutado…" → "El MEFP autorizó el gasto. La ejecución…".
- **Sin "el cual / la cual / los cuales"** como sustituto de "que" cuando "que" funciona. El LLM prefiere "el cual" porque suena culto; es un sello.
- **Sin futuro retórico**: "Se analizará en lo que sigue" → "§5.3 analiza".
- **Sin "el presente reporte / el presente documento / el presente análisis"**: usar "este reporte" o (mejor) borrar la referencia.
- **Sin "los autores del presente trabajo consideran que"**: el reporte habla con voz institucional; nada de auto-referencia.

#### 3.24.10. Checklist específico ES

Antes de cerrar un párrafo escrito en español:

```text
[ ] Cero frases §3.24.1 (Cabe destacar / Es importante señalar / Asimismo abusado…)
[ ] Cero anglicismos sintácticos §3.24.2 (del mismo, reportar, soportar, en base a…)
[ ] Pasiva refleja con agente conocido → reescrita en activa
[ ] No más de un subjuntivo de cortesía por sección
[ ] No más de un conector ornamental §3.24.5 por sección
[ ] Conteo de "zombies" en `-ción/-miento` ≤ 2 por párrafo, con verbo activo principal
[ ] Tropos §3.24.7 ausentes
[ ] Decimal con coma, miles con punto (ES) — consistente
[ ] Comillas y rayas según §3.24.8
[ ] Sin "el presente / el cual / los cuales / siendo + participio" abusados
```

#### 3.24.11. Por qué ES requiere score más estricto

En la rúbrica §3.10, **para prosa en español**, endurecer la banda:

| Score | Acción en EN | Acción en ES (más estricto) |
|---|---|---|
| 0–1 | Publicar | Publicar |
| 2–3 | Pulir y publicar | **Pulir y revisar** antes de publicar |
| 4–5 | Reescribir pasaje | **Regenerar pasaje completo** |
| 6+ | Regenerar | Descartar y reescribir desde outline |

Razón: la prosa LLM en ES "suena más bien" que en EN, lo que hace que pase desapercibida. Compensamos con umbral más bajo.

---

## 4. T — Topic sentence

### 4.1. Regla

Una sola oración. Un solo claim. Magnitud + período + sujeto técnico.

### 4.2. Patrones aceptados

```text
[Sujeto cuantitativo] [verbo factual] [magnitud] [período].
"El gasto agrícola público representó X% del gasto total en 2015–2023."

[Comparación] [magnitud] [referencia].
"La participación de bienes públicos en el gasto agrícola se ubicó Y pp por debajo del promedio de América Latina en 2020."

[Composición] [magnitud] [unidad temporal].
"Las transferencias a empresas estatales concentraron Z% del gasto agrícola ejecutado en 2022."
```

### 4.3. Anti-patterns (corregir siempre)

| Mala | Por qué falla | Buena |
|---|---|---|
| "El gasto agrícola en Bolivia es un tema complejo." | No-claim, no-magnitud | "El gasto agrícola público promedió 1,4% del PIB en 2015–2023." |
| "Como veremos, el gasto agrícola ha crecido." | Forward-reference vacío | "El gasto agrícola creció 38% en términos reales entre 2015 y 2023." |
| "Es importante señalar que…" | NEVER WRITE §3.3 | (eliminar el preámbulo, escribir el claim directo) |
| "Bolivia, como muchos países de la región, enfrenta…" | Comparación vaga sin magnitud | "El gasto agrícola por hectárea en Bolivia se ubicó en USD X en 2022, frente a USD Y en el promedio andino." |
| "Históricamente…" | Período impreciso | "Entre 2010 y 2023 el gasto…" |

### 4.4. Diagnóstico rápido del Topic sentence

Tres preguntas:

1. ¿Tiene una magnitud cuantitativa? Si no → reescribir.
2. ¿Tiene período explícito? Si no → reescribir.
3. ¿Podría aparecer tal cual como bullet en un slide? Si no → reescribir.

### 4.5. Recordatorio §3.2 flag 10

**No** todos los párrafos abren con topic sentence. **Uno de cada tres** abre con un hecho, cifra o setup `Dado X, …`. Si la sección entera abre con topic limpia, romper el patrón.

---

## 5. E — Evidence

### 5.1. Regla

1–3 oraciones que **muestran la cifra y su origen** sin interpretarla todavía.

### 5.2. Componentes obligatorios

```text
- magnitud (con unidad)
- período / año
- referencia a figura o tabla del book ("véase figura 5.3")
- fuente cruda entre paréntesis o en cita ("BOOST 2024", "INE Censo Agropecuario 2013", "FAO 2023")
- desagregación cuando aplica (región, cultivo, instrumento)
```

### 5.3. Patrones aceptados

```text
"La figura X.Y muestra que el gasto se concentró en [componente] con [magnitud]% en [año], frente a [magnitud comparativa] en [año comparativo]."

"En 2022, el [indicador] alcanzó [valor] [unidad], con desagregación territorial entre [rango bajo] en [región baja] y [rango alto] en [región alta] (tabla X.Y)."

"De acuerdo con [fuente], el [indicador] de Bolivia se ubicó en [valor] en [año], comparado con [valor benchmark] del promedio [región/grupo de comparación]."
```

### 5.4. Reglas duras

- **Cada cifra requiere trazabilidad** (RDS + script + variable + período + raw_source). Si no la tenés, `[TODO_TRACE: ...]` y seguís.
- **Sin interpretación** en este bloque. Si escribís "lo cual indica que…", ya pasaste a Explanation.
- **Sin adjetivos**: no "preocupante", no "notable", no "robusto" (salvo definición técnica).

### 5.5. Cuándo la Evidence ocupa dos párrafos

Si necesitás presentar más de tres cifras para soportar el Topic, partís en dos TEEL encadenados:

```text
TEEL_1: T = claim agregado; E = cifra agregada; X = mecanismo macro; L = "la composición interna se examina a continuación".
TEEL_2: T = claim desagregado; E = cifras desagregadas; X = lectura por componente; L = puente al siguiente subtema.
```

---

## 6. X — Explanation

### 6.1. Regla

Lo que la evidencia **significa** técnicamente. Mecanismo, comparación, caveat, incertidumbre.

### 6.2. Componentes recomendados

```text
- mecanismo: por qué la cifra es lo que es (composición, regla de clasificación, evento técnico)
- comparación: contra benchmark internacional, contra serie histórica, contra escenario contrafactual técnico
- incertidumbre: rango, sensibilidad a definición, dependencia de fuente
- caveat: lo que la cifra NO dice
- referencia a literatura cuando aporta interpretación
```

### 6.3. Patrones aceptados

```text
"Esta composición refleja la clasificación funcional del MEFP, que asigna [X] a la categoría [Y]; bajo una clasificación tipo OECD-PSE el mismo gasto se distribuye como [...] (véase metodología §X)."

"La magnitud observada es consistente con la evidencia internacional sobre [tema] [@cita], que reporta retornos sociales más altos para [componente] que para [componente alternativo]."

"La cifra es sensible al tratamiento de [variable Z]: bajo el supuesto alternativo de [supuesto], el indicador se ubicaría en [rango] (apéndice A.3)."
```

### 6.4. Reglas duras

- **Sin advocacy**: no "esto muestra la urgencia de…", no "el sistema debe…"
- **Sin contrafactual político**: no "si se hubiera priorizado…", sí "bajo un escenario alternativo cuantificado de…"
- **Sin intención**: la cifra no "busca", "intenta" ni "pretende"; alguien la causó (institución), pero la **intención** no se infiere.
- **Incertidumbre obligatoria cuando aplica**: si el claim depende de un supuesto fuerte, se dice.
- **Hedging único** (§3.2 flag 8): un solo marcador por claim, no apilar.

### 6.5. Anti-patterns

| Mala | Buena |
|---|---|
| "Esto es muy preocupante." | "La cifra se ubica Y pp por debajo del benchmark regional reportado por [@oecd2022]." |
| "El gobierno debería revisar…" | (mover a Link como "opción técnica"; o eliminar) |
| "Como es obvio…" | (eliminar; si es obvio sobra la frase) |
| "Sin embargo, la realidad es…" | "Bajo una clasificación alternativa, …" |
| "may potentially suggest that…" | "suggests that…" (un solo hedge) |

---

## 7. L — Link

### 7.1. Regla

Una oración que **enlaza** al siguiente párrafo, sección, hallazgo o escenario. Es el único lugar donde puede aparecer la fórmula "una opción técnica sería" — y solo si encadena con un escenario formalmente desarrollado.

### 7.2. Patrones aceptados

```text
"La composición por instrumento se examina en §X.Y."
"Esta brecha alimenta el hallazgo F0X (véase 04_HALLAZGOS.md)."
"Una opción técnica explorada en §6.2 sería [escenario S0X], que mantiene techo fiscal y reasigna [...]."
"Las implicaciones para la arquitectura institucional se discuten en el capítulo 4."
"Estos resultados son insumo del escenario de repurposing S02."
```

### 7.3. Cuándo el Link puede omitirse

- En el último párrafo de un capítulo, si la sección de cierre ya consolida.
- En párrafos de catálogo o de figura puente. En esos casos, conviene una **mini-L** (medio renglón).

### 7.4. Anti-patterns

| Mala | Buena |
|---|---|
| "En conclusión, todo esto es muy importante." | "El detalle por instrumento se examina en §5.3." |
| "Veremos más adelante que…" | (referencia precisa: "§5.3" o eliminar) |
| "Por lo tanto, Bolivia debe…" | "Una opción técnica para consideración del MEFP, cuantificada en §6.2, sería…" |
| "Esto demuestra la importancia de…" | §3.2 flag 12 — aportar evidencia o borrar |

---

## 8. Variantes TEEL por tipo de párrafo

No todos los párrafos son iguales. Cuatro variantes principales:

### 8.1. TEEL de hallazgo (capítulos 02–05)

El más común. Sigue la estructura canónica T-E-X-L. Trae cifra del panel, la interpreta, enlaza a §siguiente o a `04_HALLAZGOS.md`.

### 8.2. TEEL de figura (acompañar gráfico/tabla)

Comprimido. La E (Evidence) referencia la figura y resume sus dos lecturas principales.

```text
T: claim que la figura demuestra.
E: "La figura X.Y muestra [dos lecturas]. Fuente: panel v12 sobre BOOST 2024."
X: 1 oración con el mecanismo o caveat clave.
L: puente.
```

Longitud: 60–90 palabras.

### 8.3. TEEL de opción técnica / escenario (capítulo 06)

T: nombre del escenario + magnitud del cambio.
E: composición del escenario + supuestos (techo fiscal, elasticidades).
X: efectos esperados con literatura + banda de incertidumbre.
L: marcado explícito como "opción para consideración del MEFP" + referencia al apéndice metodológico.

### 8.4. TEEL de cierre / síntesis (final de sección o capítulo)

T: el hallazgo del bloque en una oración.
E: 1–2 cifras ancla.
X: cómo se conecta con el argumento general del capítulo.
L: puente al siguiente capítulo o al cierre del book.

---

## 9. Superestructura WB (capa por encima de TEEL)

TEEL organiza párrafos. Capítulos y secciones requieren **dos capas adicionales**:

### 9.1. BLUF — Bottom Line Up Front

Cada **capítulo** abre con un bloque "Mensajes clave" (3–5 bullets), cada uno con magnitud y período. Cada **sección** abre con una oración finding-first antes del primer TEEL.

Formato del bloque "Mensajes clave":

```markdown
::: {.callout-note title="Mensajes clave / Key messages"}
- **Hallazgo 1.** [claim cuantitativo bilingüe en una oración]
- **Hallazgo 2.** [...]
- **Hallazgo 3.** [...]
- **Implicación técnica.** [opción para consideración del MEFP — solo si aplica]
:::
```

### 9.2. Pirámide invertida (Minto adaptado)

Cada capítulo se ordena de **más importante a más detallado**:

```text
1. Mensajes clave (BLUF)
2. Hallazgos sustantivos (TEEL principales)
3. Desagregaciones (TEEL secundarios)
4. Caveats metodológicos
5. Puente al siguiente capítulo
```

Regla: **un lector que solo lea los topic sentences debe entender el capítulo entero**. Si no, los topics están mal escritos o el orden está roto. (Excepción §3.2 flag 10: uno de cada tres párrafos no abre con topic limpia; el ejercicio se hace sobre el conjunto, no oración por oración.)

### 9.3. Signposting (rotulación)

Cada sección y subsección señaliza dónde está el lector:

- títulos con verbos finding-first cuando se pueda ("La composición del gasto se concentra en transferencias", no "Composición del gasto");
- mini-introducción de 2 oraciones al inicio de cada sección (qué pregunta responde + qué encuentra);
- referencias internas precisas ("§5.3", no "más adelante");
- callouts diferenciados para `Mensajes clave`, `Caveat metodológico`, `Opción técnica`, `Nota de divergencia con MEFP`.

---

## 10. Reglas de ritmo y longitud

| Unidad | Longitud objetivo | Tope |
|---|---|---|
| Oración | ≤ 25 palabras | 35 |
| Topic sentence | ≤ 22 palabras | 30 |
| Párrafo TEEL | 80–140 palabras | 180 |
| Sección (h2) | 3–7 párrafos | 10 |
| Capítulo | 6–10 páginas Quarto | 14 |
| Bloque "Mensajes clave" | 3–5 bullets | 6 |
| Bullet de "Mensajes clave" | ≤ 28 palabras | 35 |
| Abstract / Executive summary | ≤ 150 palabras | 180 |

Si excedés el tope, partís. Sin excepción.

**Asimetría obligatoria** (§3.2 flag 6): la longitud de párrafos varía deliberadamente dentro del rango. No producir tres párrafos consecutivos del mismo largo.

---

## 11. Ejemplos completos

### 11.1. TEEL canónico ES (capítulo 05 — composición del gasto)

```text
[T] El gasto agrícola público se concentró en transferencias a productores
y empresas estatales, con 62% del total ejecutado en 2018–2023.
[E] La figura 5.2 descompone la ejecución anual por instrumento: las
transferencias representaron entre 55% y 68% del total, mientras los
bienes públicos (I+D, extensión, sanidad) se ubicaron entre 14% y 19%
(panel v12 sobre BOOST 2024).
[X] Esta composición se aleja del patrón observado en países comparables
de la región andina, donde los bienes públicos típicamente superan 25%
del gasto agrícola [@oecd2022]; la diferencia es sensible al tratamiento
de subsidios a fertilizantes (apéndice A.3).
[L] La brecha por instrumento alimenta el hallazgo F03 y motiva el
escenario de repurposing S02 (§6.2).
```

Conteo: ~110 palabras. Cuatro componentes claros. Cero advocacy. Cifras trazadas. Link específico.

### 11.2. TEEL canónico EN (executive summary) — pasa /quijote-writer

```text
[T] Public spending on agriculture in Bolivia averaged 1.4% of GDP in
2015–2023, with transfers to producers and state enterprises accounting
for 62% of executed outlays.
[E] Figure ES.2 disaggregates spending by instrument, showing public
goods (R&D, extension, animal and plant health) between 14% and 19% of
the total over the same period (panel v12 based on BOOST 2024).
[X] This composition departs from the benchmark share of public goods
reported for upper-middle-income agricultural economies [@ifpri2023];
the gap is sensitive to the classification of fertilizer subsidies
(Methodological Annex A.3).
[L] Section 6 develops a technical repurposing scenario (S02) that
holds the fiscal envelope constant and reallocates from transfers to
public goods for MEFP consideration.
```

AI-likelihood score auto-evaluado: 1/10. Vocabulario neutro, sin banderas activadas, asimetría natural, cifras trazadas, contribution clause ausente del cuerpo.

### 11.3. TEEL de figura (más comprimido)

```text
[T] La participación de bienes públicos en el gasto agrícola se mantuvo
por debajo del 20% en todo el período 2015–2023.
[E] La figura 5.3 grafica la serie anual, con un mínimo de 14% en 2019
y un máximo de 19% en 2016 (panel v12 sobre BOOST 2024).
[X] La estabilidad de la composición sugiere una rigidez institucional
en la asignación, no un ajuste cíclico.
[L] El análisis institucional se desarrolla en el capítulo 3.
```

### 11.4. TEEL de opción técnica (capítulo 06)

```text
[T] El escenario S02 reasigna 30% de las transferencias genéricas
actuales hacia I+D, extensión y sanidad, manteniendo techo fiscal
constante en horizonte de cinco años.
[E] La tabla 6.2 detalla la composición ex-ante y ex-post del gasto
bajo S02, junto con los supuestos de elasticidad tomados de [@ifpri2023]
y [@fao2023] (apéndice metodológico §A.5).
[X] Los efectos esperados sobre TFP, ingreso rural y emisiones se
ubican en bandas de incertidumbre alta, dada la dependencia de
elasticidades estimadas en otros contextos productivos; la banda se
reporta en la figura 6.4.
[L] El escenario S02 se presenta como opción técnica para
consideración del MEFP, sin compromiso de adopción y sujeto a
calibración con datos bolivianos en la fase de consultoría PSE.
```

### 11.5. Reescritura: párrafo malo → TEEL (con diagnóstico anti-IA)

**Versión inicial (mala, AI-likelihood 8/10):**

```text
El gasto agrícola en Bolivia es un tema complejo y multifacético. Como
muchos países de la región, el país enfrenta importantes desafíos para
priorizar adecuadamente los recursos públicos. Es importante señalar
que históricamente el gasto se ha concentrado en transferencias, lo
cual claramente plantea preguntas sobre su efectividad. Se requiere una
revisión urgente de estas políticas.
```

**Diagnóstico §3.2 + §3.3:**

- Bandera 7 (vocabulario IA): "multifacético".
- Bandera 9 / NEVER WRITE: "Es importante señalar que".
- Bandera 11: "tema complejo" (abstracción rimbombante implícita).
- Bandera 12: "se requiere una revisión urgente" — claim conclusivo sin evidencia.
- NEVER WRITE: "importantes desafíos" (estructura vacía).
- NEUTRALIDAD §2.3: "se requiere", "urgente" (lenguaje prescriptivo + advocacy).
- NEUTRALIDAD §2.7: "claramente".
- TEEL: topic sin claim cuantitativo, evidence inexistente, explanation reemplazada por adjetivos, link es advocacy.

**Versión TEEL corregida (AI-likelihood 1/10):**

```text
[T] El gasto agrícola público promedió 1,4% del PIB en 2015–2023, con
62% concentrado en transferencias a productores y empresas estatales.
[E] La figura 5.1 muestra la evolución anual del gasto y su composición
por instrumento (panel v12 sobre BOOST 2024).
[X] La participación de transferencias en el gasto agrícola se ubica
por encima de la mediana de países andinos para el mismo período
[@oecd2022]; la brecha es sensible al tratamiento de subsidios
indirectos (apéndice A.3).
[L] La composición por instrumento se examina en detalle en §5.2 y
alimenta el escenario de repurposing S02 (§6.2).
```

---

## 12. Checklist por párrafo

Antes de dar por cerrado un párrafo, verificar:

```text
PRE-FLIGHT ANTI-IA (§3)
[ ] Cero banderas §3.2 activadas (o ≤ 1 aislada)
[ ] Cero frases de la lista NEVER WRITE §3.3
[ ] AI-likelihood score ≤ 3
[ ] Si EN: pasa el filtro /quijote-writer Standard 0
[ ] Hedging único (no apilado)

ESTRUCTURA TEEL
[ ] Topic tiene magnitud y período
[ ] Topic cabría como bullet de slide
[ ] Evidence enlaza a figura/tabla y trae fuente cruda
[ ] Cada cifra tiene RDS + script en metadato (o TODO_TRACE)
[ ] Explanation tiene mecanismo, no adjetivos
[ ] Explanation declara incertidumbre cuando aplica
[ ] Link es específico (§X.Y o hallazgo F0X)

LENGUAJE
[ ] Sin adverbios prohibidos (NEUTRALIDAD §2.7)
[ ] Sin actores políticos nombrados (NEUTRALIDAD §2.1)
[ ] Sin advocacy (NEUTRALIDAD §2.4)
[ ] Sin latinismos / falsos cognados (§3.7)
[ ] American English si EN (§3.8)

RITMO
[ ] Longitud entre 80 y 160 palabras
[ ] Si es el tercer párrafo seguido, considerar romper apertura (§3.2 flag 10)
[ ] Si bilingüe: paridad de claim, magnitud, período, fuente
```

---

## 13. Checklist por capítulo

```text
[ ] Abre con "Mensajes clave" (3–5 bullets bilingües)
[ ] Cada sección abre con BLUF de 2 oraciones
[ ] Los topic sentences leídos en orden cuentan la historia del capítulo
[ ] Asimetría de longitudes de párrafo verificada (§3.2 flag 6)
[ ] Cada cifra tiene metadato de trazabilidad
[ ] Las figuras tienen caption + alt-text (ES y EN si aplica)
[ ] Caveats metodológicos en callout dedicado
[ ] Sección de cierre con TEEL de síntesis
[ ] Puente al capítulo siguiente
[ ] Enlaces internos verificados
[ ] Render quarto sin warnings
[ ] Pre-flight anti-IA (§3.4) corrido y reportado
[ ] AI-likelihood promedio del capítulo ≤ 3
[ ] Si EN: pasaje por /quijote-writer en modo capítulo completo
```

---

## 14. Errores frecuentes y su corrección

| Error | Corrección |
|---|---|
| Topic narrativo ("Como veremos…") | Topic finding-first con magnitud |
| Mezclar Evidence y Explanation en una oración | Partir en dos oraciones; primero la cifra, luego la lectura |
| Advocacy en Explanation | Mover a Link como "opción técnica" o eliminar |
| Cifras sin período | Agregar año/rango |
| Cifras sin unidad | Agregar unidad explícita |
| Adverbios filler | Eliminar (NEUTRALIDAD §2.7) |
| Link vago ("más adelante") | Referencia precisa (§X.Y) |
| Párrafo > 180 palabras | Partir en dos TEEL encadenados |
| Topic con dos claims | Partir en dos párrafos |
| Falta de incertidumbre | Agregar caveat o banda |
| Tres párrafos seguidos del mismo largo | Reescribir para asimetría (§3.2 flag 6) |
| Aliteración tripartita | Reemplazar con verbo único o lista no rimada |
| Hedge apilado ("podría posiblemente sugerir") | Un solo hedge |
| Vocabulario IA ("fortalecer", "robusto") | Sustantivar el verbo o usar palabra concreta |
| Em dash como muletilla | Punto, paréntesis o coma |
| Abrir todos los párrafos con topic | Romper uno de cada tres con hecho/cifra/setup |

---

## 15. Tests automáticos previstos

(En `scripts/audit_style.R` y `scripts/audit_ai_patterns.R`, a futuro)

```text
test_topic_has_magnitude:
  - regex sobre primera oración: detectar número + unidad
  - flag si falta

test_paragraph_length:
  - contar palabras por párrafo
  - flag si > 180

test_no_filler_phrases:
  - grep contra lista NEVER WRITE §3.3 (ES + EN)
  - flag por línea con la frase exacta

test_link_is_specific:
  - grep links genéricos ("más adelante", "veremos", "later", "below")
  - sugerir referencia precisa

test_bullet_count_in_key_messages:
  - contar bullets en bloque "Mensajes clave"
  - flag si > 6

test_ai_vocabulary_density:
  - grep contra lista de vocabulario IA §3.2 flag 7 (ES + EN)
  - flag si ≥ 2 palabras de la lista en el mismo párrafo
  - flag automático si CUALQUIERA aparece en abstract / mensajes clave

test_em_dash_density:
  - contar em dashes por párrafo
  - flag si > 1

test_paragraph_length_symmetry:
  - calcular coeficiente de variación de longitudes de párrafos consecutivos
  - flag si CV < 0.15 (demasiada simetría)

test_paragraph_opener_diversity:
  - clasificar aperturas: topic-sentence, fact, citation, "given X"
  - flag si > 80% son topic-sentence

test_tripartite_alliteration:
  - grep patterns "V, V, and V" donde las V comparten 2+ letras iniciales
  - flag a sugerir reescritura

test_hedge_stacking:
  - grep patterns "may potentially", "could possibly", "might suggest that"
  - equivalente ES
  - flag automático

# ----- nuevos tests por subsección §3.11–§3.24 -----

test_extended_ai_vocabulary:
  - grep listas §3.11 (cuantificadores vacíos + intensificadores hollow +
    sustantivos abstractos + verbos performativos + adjetivos de "calidad")
  - umbral ≥ 1 por párrafo en abstract/mensajes clave; ≥ 2 en cuerpo

test_syntactic_llm_patterns:
  - grep "not only X but also Y" y equivalente "no solo X sino también Y"
  - grep "while X, Y" apertura repetida
  - grep "it is X that Y" / "es X lo que Y"
  - grep "one of the most" / "uno de los más"

test_three_bullet_syndrome:
  - contar bloques de exactamente 3 bullets seguidos
  - flag si ≥ 2 bloques de 3 en la misma sección

test_listicle_creep:
  - flag bullet lists con < 3 items
  - flag bullets de 1 palabra
  - flag bullets fragmentos terminados en punto

test_header_density:
  - contar palabras entre headers ## y ###
  - flag si < 200 palabras entre headers

test_rhetorical_questions:
  - grep "?" en cuerpo de capítulo
  - flag toda pregunta retórica fuera de intro de capítulo

test_hollow_connectors_es_en:
  - grep listas §3.14 (EN) y §3.24.5 (ES)
  - flag cada ocurrencia

test_narrative_scaffolding:
  - grep listas §3.15 (EN + ES)
  - flag cada ocurrencia

test_quantitative_theater:
  - grep adjetivos cuantitativos §3.16 (EN + ES)
  - verificar si hay número + unidad en ±15 palabras
  - flag si adjetivo aparece sin magnitud

test_narrative_tropes:
  - grep listas §3.17 (EN + ES) y §3.24.7 (ES adicional)
  - flag cualquier ocurrencia

test_model_self_disclosure:
  - grep listas §3.18
  - tolerancia cero — rollback automático

test_hallucination_guards:
  - cifras redondas (50%, 100%, 1.000) sin trazabilidad RDS
  - citas en texto sin entrada en references.bib
  - decretos/programas sin URL Gaceta Oficial o sitio MEFP
  - "según estudios recientes" / "expertos coinciden" sin cita

test_unicode_hygiene:
  - grep U+200B, U+00AD, U+FEFF (cero tolerancia)
  - contar em dash, en dash, ellipsis Unicode
  - verificar consistencia smart vs straight quotes

test_defensive_prose:
  - grep listas §3.21 (EN + ES)
  - flag cada ocurrencia

test_tone_calibration:
  - grep listas §3.22 (EN + ES)
  - flag cada ocurrencia

# ----- tests ES profundos §3.24 -----

test_es_academic_formulas:
  - grep §3.24.1 ("cabe destacar", "es importante señalar", etc.)
  - tolerancia cero

test_es_syntactic_anglicisms:
  - grep §3.24.2 ("del mismo" pronominal, "reportar", "soportar",
    "en base a", "permite + gerundio", "robusto" sin contexto técnico,
    "implementar" overused, "evidenciar" overused, "la data")
  - flag cada ocurrencia

test_es_passive_voice_density:
  - contar "se observa que / se evidencia que / se ha visto que"
  - flag si > 3 por sección
  - flag si apertura de 2 párrafos consecutivos

test_es_subjunctive_density:
  - contar "habría / podría / debería / convendría / sería pertinente"
  - flag si > 1 por sección como hedge ornamental

test_es_zombie_nouns:
  - contar sustantivos en -ción / -miento / -ización / -idad por párrafo
  - flag si ≥ 3 sin verbo activo principal claro

test_es_typography:
  - decimal separator: coma en ES, punto en EN — consistencia
  - thousands separator: punto en ES, coma en EN — consistencia
  - em dash CON espacios en todo el book (ES y EN) — decisión §3.20
  - comillas dobles inglesas "…" en todo el book — decisión §3.24.8
  - flag toda aparición de comillas latinas «…» o straight quotes

test_es_register_formality:
  - grep "el presente reporte / el presente documento"
  - grep "el cual / la cual / los cuales" cuando "que" funciona
  - grep gerundio de posterioridad ("siendo + participio")
  - grep futuro retórico ("se analizará en lo que sigue")
```

---

## 16. Integración con archivos de gobernanza

- **06_NEUTRALIDAD.md** rige el **vocabulario**; este archivo rige la **composición + filtro anti-IA**.
- **CLAUDE.md** §8 referencia este archivo cuando entra en modo "poblar capítulo" o "preparar slide". El pre-flight §3 corre **antes** del modo de trabajo, no después.
- **`/quijote-writer`** es la skill canónica para prosa EN. Invocarla según §3.9.
- **08_CONTROL.md** (pendiente): cambiar la estructura TEEL canónica, la longitud objetivo, o las banderas §3.2 es **rojo** + ADR. Agregar variantes (§8), ejemplos (§11) o frases a la lista NEVER WRITE (§3.3) es **amarillo**.
- **09_AUDITORIA.md** (pendiente): incluirá los checklists §12–§13 + el loop de validación §3.4 como parte de la revisión por capítulo.

---

## 17. Decisiones congeladas (insumo para ADRs)

### Propuesta ADR-0005 — TEEL + superestructura WB como estilo narrativo canónico

```text
Contexto: el reporte debe ser legible por economistas WB, MEFP,
peer reviewers y auditores de reproducibilidad. Requiere finding-first,
trazabilidad, neutralidad técnica y compatibilidad bilingüe.

Decisión: adoptar TEEL (Topic-Evidence-Explanation-Link) como
anatomía de párrafo, combinado con BLUF + pirámide + signposting
como superestructura de capítulo y sección.

Alternativas descartadas:
- estilo narrativo libre (no escala, no auditable)
- IMRAD académico (no es el género del producto)
- BLUF puro sin TEEL (insuficiente para detalle técnico)
- McKinsey/Minto puro (insuficiente para trazabilidad cifra-a-RDS)

Estado: propuesta — pendiente aprobación TTL.
```

### Propuesta ADR-0006 — Standard 0 anti-prosa-IA como pre-flight obligatorio

```text
Contexto: la prosa LLM sin editar es detectable y daña la credibilidad
del reporte ante peer reviewers, editores WB y contrapartes MEFP. Un
borrador con prosa rugosa pero humana siempre es preferible a uno
pulido pero sintético.

Decisión: adoptar el Standard 0 de la skill /quijote-writer como
pre-flight obligatorio para toda prosa del APER 2026, con extensión
de listas a español. El loop §3.4 corre antes de cualquier publicación.

Operacionalización:
- 12 banderas rojas (§3.2) bilingües
- lista NEVER WRITE (§3.3) ES + EN
- AI-likelihood score (§3.10) en cada cierre de sesión
- invocación de /quijote-writer para prosa EN (§3.9)
- tests automáticos en scripts/audit_ai_patterns.R (a implementar)

Alternativas descartadas:
- solo revisión humana (no escala con el volumen del reporte)
- solo /quijote-writer al final (deja entrar prosa IA al borrador y
  contamina al editor que revisa)
- listas solo en EN (el reporte es bilingüe; el ES también necesita
  filtro)

Estado: propuesta — pendiente aprobación TTL.
```

---

## 18. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: TEEL + superestructura WB + ejemplos |
| v0.2.0 | 2026-05-23 | + §3 Standard 0 anti-prosa-IA (12 banderas + NEVER WRITE bilingüe + loop + score) — importado y extendido de `/quijote-writer`. Renumeración §3–§16 → §4–§17. Cambio notacional E→X para Explanation. |
| v0.3.0 | 2026-05-23 | + §3.11–§3.23: vocabulario IA extendido, sellos sintácticos del LLM, sellos estructurales (three-bullet, listicle creep, headers, énfasis, preguntas retóricas), cohesión hueca, andamiaje narrativo, teatralidad cuantitativa, tropos narrativos, auto-divulgación de modelo (cero tolerancia), verificación anti-alucinación, tipografía/Unicode, defensive prose, tone calibration, referencias canónicas (WB / Economist / Strunk-White / Williams / Sword / GDS). + §3.24: capa profunda ES con 11 subsecciones (fórmulas académicas tolerancia cero, anglicismos sintácticos, pasiva, subjuntivo, conectores ornamentales, prosa zombie, tropos ES, tipografía ES, registro, checklist ES, score endurecido). Loop §3.4 ampliado a tres capas (base + extendida + ES). Tests §15 ampliados con 22 nuevos chequeos. |
