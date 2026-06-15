---
name: escritura-econometrica
description: Patrones de redacción para resultados, metodología y hallazgos econométricos en el APER
metadata:
  type: style-guide
  version: v0.1.0
  session: 2026-06-14
---

# Redacción de Análisis Econométrico en el APER 2026

Este documento captura patrones de redacción específicos para secciones de resultados, metodología y análisis econométrico en el APER Bolivia 2026. Complementa [`.agent/05_ESTILO_NARRATIVO.md`](.agent/05_ESTILO_NARRATIVO.md) con reglas aplicadas a la comunicación de hallazgos técnicos.

## Estructura base: de hallazgos a limitaciones

### Patrón 1: Presentación de hallazgos econométricos

**Estructura TEEL adaptada para resultados:**

```
T  — Topic sentence
     UN hallazgo cuantitativo con dirección y magnitud.
     Ejemplo: "El gasto total no se asocia de forma estable con productividad."

E  — Evidence
     Cifras: coeficientes, correlaciones, intervalos de confianza.
     Año, unidad, fuente. Sin interpretar.
     Ejemplo: "ρ = −0,02 (n = 288), no significativo."

X  — Explanation
     ¿Por qué importa? Contraste con expectativa. Relación con otro hallazgo.
     Sin especular. Sin causalidad.
     Ejemplo: "Este resultado reafirma F01: inversión creció 10x sin retorno proporcional."

L  — Link
     Implicación de política o conexión con capítulo siguiente.
     Ejemplo: "El margen de reforma no es magnitud sino composición."
```

**Longitud:** 80–150 palabras por TEEL. Si >180, probablemente hay 2 hallazgos → partir.

---

## Antipatrones: qué evitar

### ❌ Subtítulos listicle dentro del texto

**Evitar:**
```markdown
Primero, el nivel del gasto no mueve los resultados. [párrafo]
Segundo, la composición se desplazó. [párrafo]
Tercero, la composición sí importa. [párrafo]
```

**Solución:** Usar subtítulos formales como topic sentences en negrita:

```markdown
### 5.2.1 Magnitud versus composición del gasto

**El nivel del gasto no mueve los resultados.** [párrafo desarrollado]

**La composición del gasto experimentó un desplazamiento marcado.** [párrafo desarrollado]

**A igual nivel de gasto, la composición sí se asocia con pobreza.** [párrafo desarrollado]
```

### ❌ Párrafos densos >200 palabras con múltiples ideas

**Evitar:**
```markdown
La pregunta es si el gasto se traduce en productividad. El análisis usa nueve 
departamentos. Al incluir efectos fijos, descuenta diferencias estructurales. 
El coeficiente refleja variación interna. [continúa sin pausas]
```

**Solución:** Dividir por idea lógica:

```markdown
¿Se traduce el gasto en productividad? El análisis responde comparando cada 
departamento consigo mismo en el tiempo durante 2016–2024.

Al fijar efectos de departamento y de año, el modelo descuenta variación 
que refleja solo diferencias estructurales permanentes...

Simultáneamente, el modelo controla choques macroeconómicos que afectaron 
a todas las regiones en un mismo período...
```

### ❌ Jerga sin contexto

**Evitar:**
```markdown
El coeficiente de Spearman frente a la tasa de NBI es ρ = −0,22, significativo al 1%.
```

**Solución:** Contextualizar para lector no especialista:

```markdown
La correlación entre gasto municipal en servicios técnicos y pobreza rural 
(coeficiente de Spearman ρ = −0,22, significativo al 1%) es negativa...
```

---

## Patrones ganadores

### ✅ Pregunta → Método → Hallazgo → Limitación

**Estructura de sección de resultados:**

1. **Pregunta operativa clara (1 oración)**
   - "¿Se asocia la magnitud del gasto con productividad departamental?"

2. **Cómo respondemos (1–2 párrafos)**
   - Panel de 9 departamentos, 2016–2024
   - Qué variable es resultado, qué es insumo
   - Qué se controla (efectos fijos de lugar y tiempo)

3. **Hallazgo principal (1 párrafo TEEL)**
   - Topic sentence en negrita
   - Cifra clave con contexto
   - Conexión a hallazgo anterior o expectativa

4. **Desagregación y matices (1–2 párrafos)**
   - Por subgrupo, por período, por agroecología
   - Dónde se mantiene el hallazgo, dónde no

5. **Limitaciones y scope (1 párrafo)**
   - Asociación vs causalidad
   - Tamaño de muestra, ventana temporal
   - Referencia a apéndice técnico

### ✅ Números integrados en prosa, no en listas

**Evitar:**
```markdown
Cambios 2016–2024:
- Apoyo directo: 43% → 63%
- Riego: 27% → 16%
- Servicios técnicos: 14% (sin cambio)
```

**Usar:**
```markdown
Entre 2016 y 2024, el apoyo directo a la producción se expandió de 43% a 63% 
del presupuesto sectorial. El riego e infraestructura se contrajo de 27% a 16%. 
Los servicios técnicos permanecieron estancados en aproximadamente 14%.
```

### ✅ Transiciones de causa-efecto

**Evitar:**
```markdown
Bolivia invierte poco en investigación. La investigación tiene alto retorno.
```

**Usar:**
```markdown
Bolivia invierte menos del 10% en investigación — precisamente el bien público 
con mayor retorno documentado. Esta desalineación sugiere que...
```

### ✅ Caveat formal al final, no interrumpiendo

**Evitar:**
```markdown
La correlación es negativa (aunque debe notarse que la muestra es pequeña y 
hay colinealidad entre variables) y significativa al 1%.
```

**Usar:**
```markdown
La correlación es negativa y significativa al 1%. Esta inferencia descansa en 
nueve departamentos — una muestra pequeña — y está sujeta a colinealidad parcial 
entre componentes de gasto (detalles en Apéndice E).
```

---

## Vocabulario específico para econometría

| Concepto | En vez de... | Usar... |
|----------|--------------|---------|
| Correlación sin causalidad | "está relacionado con" | "se asocia con", "muestra correlación con" |
| Nivel de significancia | "es significativo" | "es estadísticamente significativo al X%" |
| Falta de relación | "no hay relación" | "no muestra asociación", "permanece no significativo" |
| Muestra pequeña | "la muestra es pequeña" | "la inferencia descansa en N clusters / departamentos" |
| Cambio de valor en % | "creció" (ambiguo) | "pasó de X% a Y%", "se expandió X puntos" |
| Estimación no causal | "el efecto es..." | "la asociación sugiere...", "se correlaciona con..." |
| Variabilidad entre grupos | "hay diferencias" | "hay heterogeneidad", "hay dispersión" |
| Control estadístico | "separando" | "descontando", "controlando por", "fijando efectos de..." |

---

## Checklist pre-publicación

Antes de marcar un análisis econométrico como listo:

- [ ] ¿La pregunta operativa aparece en topic sentence?
- [ ] ¿Cada hallazgo tiene TEEL (topic, evidence, explanation, link)?
- [ ] ¿Los números están contextualizados, no en listas?
- [ ] ¿Los términos técnicos (ρ, NBI, efectos fijos) están explicados?
- [ ] ¿Las limitaciones (N pequeño, ventana corta, no causal) están separadas en párrafo final?
- [ ] ¿No hay "Primero, Segundo, Tercero" listicle dentro de los párrafos?
- [ ] ¿Las cifras tienen año, unidad y fuente?
- [ ] ¿Se evita lenguaje de causalidad cuando solo hay asociación?
- [ ] ¿Se conecta el hallazgo con F0X anterior o siguiente capítulo?
- [ ] ¿La referencia a Apéndice técnico es clara y accesible?

---

## Ejemplos de antes y después

### Ejemplo 1: Recomposición del gasto

**Antes (denso, listicle):**
```
Primero, el gasto productivo pasó de 43% a 63%. Segundo, riego cayó de 27% 
a 16%. Tercero, servicios técnicos se mantuvieron en 14%.
```

**Después (narrativo, contextualizado):**
```
Entre 2016 y 2024, el apoyo directo a la producción se expandió de 43% a 63% 
del presupuesto sectorial — un aumento de 20 puntos porcentuales que refleja 
principalmente el crecimiento de EMAPA. Simultáneamente, los bienes públicos 
de mayor retorno documentado — servicios técnicos de investigación, extensión 
y sanidad — se estancaron en aproximadamente 14% del presupuesto. Esta 
recomposición no fue resultado de deliberación explícita de política sectorial; 
respondió a ciclos de ingresos fiscales y presiones coyunturales.
```

### Ejemplo 2: Asociación de eficiencia con factores

**Antes (jerga sin contexto):**
```
El Gini de eficiencia es 0,81 para gasto ampliado. Los departamentos con 
menor precipitación registran menor eficiencia. ρ = −0,22, significativo al 1%.
```

**Después (explicado, integrado):**
```
El gasto ampliado (incluyendo infraestructura) muestra una concentración extrema: 
el índice de Gini es 0,81, y los diez departamentos principales ejecutan el 53% 
del total. Dentro de esa heterogeneidad, un factor natural emerge como determinante: 
departamentos con menor disponibilidad hídrica registran sistemáticamente menor 
eficiencia técnica (correlación ρ = −0,22, significativa al 1%). Por tanto, una 
porción de la brecha del altiplano refleja una desventaja agroecológica estructural, 
no exclusivamente ineficiencia de gestión.
```

---

## Referencias internas

- [`.agent/05_ESTILO_NARRATIVO.md`](.agent/05_ESTILO_NARRATIVO.md) — estructura TEEL y superestructura WB
- [`.agent/06_NEUTRALIDAD.md`](.agent/06_NEUTRALIDAD.md) — vocabulario de política
- [`04_report/05_spending_analysis.qmd`](../../04_report/05_spending_analysis.qmd) — ejemplos aplicados en Capítulo 5
- [`04_report/appendix/E_regresiones_panel_fe.qmd`](../../04_report/appendix/E_regresiones_panel_fe.qmd) — detalle técnico y ecuaciones

---

**Versión:** 0.1.0  
**Última actualización:** 2026-06-14  
**Próximas mejoras:** Ejemplos de visualización de coeficientes; captions de tablas econométricas; comunicación de intervalos de confianza.
