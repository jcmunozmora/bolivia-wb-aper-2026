# 35_fig_betas_por_tipo.R — Betas por tipo de gasto: ¿qué composición reduce pobreza?
# -----------------------------------------------------------------------------
# Coefficient plot: para cada TIPO de gasto agropecuario (clasificación MAFAP),
# coeficiente de su PARTICIPACIÓN sobre la pobreza departamental (controlando el
# gasto total y FE depto+año). Responde "¿existe correlación, y con qué tipo?":
# solo la participación de bienes públicos (servicios técnicos: I+D, extensión,
# sanidad) se asocia con menor pobreza; los demás tipos no.
# Estándar: .agent/07_FIGURAS.md (finding-first, paleta WB, highlight/gray-out).
#
# Fuente: panel_fe_by_type_results.rds (MEFP por grupo MAFAP + pobreza INE).
# Salida: 05_outputs/figures/fig44_betas_por_tipo.{png,pdf} (600 DPI)
# =============================================================================

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
suppressPackageStartupMessages({ library(data.table); library(ggplot2); library(sandwich); library(here) })
source(here("02_code", "04_visualization", "00_wb_theme.R"))

d <- as.data.table(readRDS(here("01_data/processed/panel_fe_by_type_results.rds"))$panel)

fe <- function(y, x) {
  dd <- d[is.finite(d[[y]]) & is.finite(d[[x]]) & is.finite(ln_total) & is.finite(precip_k)]
  f  <- lm(as.formula(sprintf("%s ~ %s + ln_total + precip_k + factor(dept_upper)+factor(year)", y, x)), dd)
  V  <- vcovCL(f, cluster = dd$dept_upper, type = "HC1"); b <- coef(f)[x]; se <- sqrt(diag(V))[x]
  G  <- uniqueN(dd$dept_upper); tc <- qt(.975, G-1)
  data.table(coef = b, ci_lo = b - tc*se, ci_hi = b + tc*se, p = 2*pt(abs(b/se), G-1, lower.tail = FALSE))
}

lab <- c(sh_tecnicos = "Servicios técnicos\n(I+D, extensión, sanidad)",
         sh_riego    = "Riego e infraestructura",
         sh_apoyo    = "Apoyo directo a la producción",
         sh_tierras  = "Tierras y otros")
outs <- c(pobreza_mod = "Pobreza moderada", pobreza_ext = "Pobreza extrema")

res <- rbindlist(lapply(names(outs), function(y)
  rbindlist(lapply(names(lab), function(x) cbind(outcome = outs[y], tipo = lab[x], fe(y, x))))))
res[, outcome := factor(outcome, levels = unname(outs))]
res[, tipo := factor(tipo, levels = rev(unname(lab)))]   # técnicos arriba
res[, sig := p < 0.10]

p <- ggplot(res, aes(x = coef, y = tipo, color = sig)) +
  geom_vline(xintercept = 0, color = WB_RED, linewidth = 0.6, linetype = "22") +
  geom_segment(aes(x = ci_lo, xend = ci_hi, y = tipo, yend = tipo), linewidth = 0.9) +
  geom_point(size = 2.8) +
  facet_wrap(~outcome, ncol = 2) +
  scale_color_manual(values = c(`TRUE` = WB_BLUE, `FALSE` = WB_GREY),
                     labels = c(`TRUE` = "Asociación significativa (90%)", `FALSE` = "No significativa"),
                     name = NULL) +
  labs(
    title    = "Solo asignar más a bienes públicos (I+D, extensión, sanidad) se asocia\ncon menor pobreza departamental, 2016–2024",
    subtitle = "Coeficiente de la participación de cada tipo de gasto agropecuario sobre la pobreza (controlando el gasto total), panel FE depto+año",
    x = "Cambio en la pobreza (pp) por unidad de participación del tipo · barra = IC 95% · línea roja = cero",
    y = NULL,
    caption = paste(
      "Fuente: MEFP (gasto agropecuario municipal por grupo MAFAP), INE (pobreza por departamento); cálculo propio (ADR-0018).",
      "Nota: cada coeficiente proviene de una regresión con efectos fijos de departamento y año, controlando el gasto total y la precipitación.",
      "Identificación asociativa, no causal; errores cluster-robustos por departamento (9 clusters → leer significancia con cautela).", sep = "\n")
  ) +
  theme_wb() +
  theme(legend.position = "top", legend.justification = "left",
        plot.title = element_text(size = 12.5), panel.spacing = unit(1.1, "lines"))

base <- here("05_outputs", "figures", "fig44_betas_por_tipo")
ggsave(paste0(base, ".png"), p, width = 10, height = 5, dpi = 600, bg = "white")
try(ggsave(paste0(base, ".pdf"), p, width = 10, height = 5, bg = "white"), silent = TRUE)
cat("✓ Guardado: fig44_betas_por_tipo.png + .pdf\n")
