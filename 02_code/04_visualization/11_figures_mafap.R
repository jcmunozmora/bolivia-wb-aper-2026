# ============================================================================
# Script:        11_figures_mafap.R
# Propósito:     Generar las 5 figuras MAFAP del capítulo 3 del APER 2026
#                a partir de mafap_bolivia.rds producido por 17_mafap_classification.R
# Outputs:       fig18a_mafap_A_apoyo_productor       (SVG + PNG 600 DPI + PDF)
#                fig18b_mafap_BC_consumidor_otros     (...)
#                fig18c_mafap_D_apoyo_general         (...)
#                fig18d_mafap_E_rural_soporte         (...)
#                fig18_summary_mafap_ABCDE            (...)
# Estándar:      07_FIGURAS §6 (paleta híbrida — paleta de datos),
#                §7 (resolución), §8 (naming), §9 (caption finding-first)
# Autor:         Juan Carlos Muñoz Mora (EAFIT)
# Fecha:         2026-05-23
# ============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(here)
  library(scales)
  library(glue)
})

# Theme institucional WB (si no carga, se usa theme_minimal con tweaks)
tryCatch(
  source(here("02_code/04_visualization/00_wb_theme.R")),
  error = function(e) message("[warn] 00_wb_theme.R no cargado; uso theme_minimal inline")
)

# ---- 0. Configuración ------------------------------------------------------

PATH_DATA    <- here("01_data/processed/mafap_bolivia.rds")
OUT_DIR_SVG  <- here("05_outputs/figures/svg")
OUT_DIR_PNG  <- here("05_outputs/figures/png")
OUT_DIR_PDF  <- here("05_outputs/figures/pdf")
OUT_DIR_META <- here("05_outputs/figures/meta")

walk(c(OUT_DIR_SVG, OUT_DIR_PNG, OUT_DIR_PDF, OUT_DIR_META), \(d)
     dir.create(d, recursive = TRUE, showWarnings = FALSE))

# ---- Paleta APER 2026 — paleta de datos (07_FIGURAS §6.1) ------------------

palette_mafap <- c(
  "A" = "#1F4E79",   # azul WB profundo — apoyo al productor
  "A1" = "#1F4E79",
  "A2" = "#4472C4",  # azul medio — input subsidies (rev. foregone BDP)
  "A3" = "#7BA7D9",  # azul claro — income support
  "B"  = "#7030A0",  # morado — apoyo al consumidor
  "C"  = "#A6A6A6",  # gris medio — otros agentes
  "D"  = "#548235",  # verde oliva — apoyo general al sector
  "D1" = "#548235",  # research
  "D2" = "#6FA346",
  "D5" = "#82B85B",
  "D6" = "#9DCC76",
  "D9" = "#B8E091",
  "E"  = "#BF8F00"   # dorado mate — rural-soporte
)

# Tema policy report (alineado con paleta institucional 07_FIGURAS §5)
theme_aper_mafap <- function() {
  theme_minimal(base_family = "Inter", base_size = 11) +
    theme(
      plot.title       = element_text(face = "bold", size = 13, lineheight = 1.15),
      plot.subtitle    = element_text(size = 10.5, color = "#444444"),
      plot.caption     = element_text(size = 8, color = "#666666", hjust = 0, lineheight = 1.2),
      plot.caption.position = "plot",
      axis.title       = element_text(size = 9.5),
      axis.text        = element_text(size = 8.5),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "#D9D9D9", linewidth = 0.3),
      legend.position  = "top",
      legend.title     = element_blank(),
      legend.text      = element_text(size = 9),
      plot.margin      = margin(8, 12, 8, 12)
    )
}

# Función canónica de guardado (07_FIGURAS §8.3)
save_figure <- function(p, figure_id, width = 6.3, height = 4.0, contract_json = NULL) {
  ggsave(file.path(OUT_DIR_SVG, glue("{figure_id}.svg")),
         p, width = width, height = height, units = "in", device = "svg")
  ggsave(file.path(OUT_DIR_PNG, glue("{figure_id}.png")),
         p, width = width, height = height, units = "in", dpi = 600, device = "png")
  ggsave(file.path(OUT_DIR_PDF, glue("{figure_id}.pdf")),
         p, width = width, height = height, units = "in", device = cairo_pdf)
  if (!is.null(contract_json)) {
    writeLines(contract_json, file.path(OUT_DIR_META, glue("{figure_id}.json")))
  }
  message(glue("✓ {figure_id} guardado (SVG + PNG 600DPI + PDF)"))
}

# ---- 1. Cargar datos -------------------------------------------------------

if (!file.exists(PATH_DATA)) {
  stop(glue("[error] No existe {PATH_DATA}. Ejecutar primero 17_mafap_classification.R."))
}

FX2015 <- 6.91  # USD const. 2015 = BOB const. 2015 / FX2015
mafap <- readRDS(PATH_DATA)
message(glue("Cargado mafap_bolivia.rds: {nrow(mafap)} años × {ncol(mafap)} cols"))

# Helper: pivot largo de las 5 categorías para gráficos apilados
df_long <- mafap %>%
  select(year, mafap_A_bob_2015, mafap_B_bob_2015, mafap_C_bob_2015,
         mafap_D_bob_2015, mafap_E_bob_2015) %>%
  rename(A = mafap_A_bob_2015, B = mafap_B_bob_2015, C = mafap_C_bob_2015,
         D = mafap_D_bob_2015, E = mafap_E_bob_2015) %>%
  pivot_longer(-year, names_to = "categoria", values_to = "monto_bob_2015") %>%
  # FIX m0.1.1: las columnas mafap_*_bob_2015 YA están en millones de BOB 2015;
  # no dividir por 1e6 (eso aplastaba A–D a ~0).
  mutate(monto_mm = monto_bob_2015)

# ----------------------------------------------------------------------------
# Figura 18a — MAFAP categoría A (Apoyo al productor)
# ----------------------------------------------------------------------------

fig_a <- mafap %>%
  filter(!is.na(mafap_A_bob_2015), year >= 2006) %>%
  mutate(monto_mm = mafap_A_bob_2015/FX2015,
         signo = if_else(monto_mm >= 0, "pos", "neg")) %>%
  ggplot(aes(x = year, y = monto_mm, fill = signo)) +
  geom_hline(yintercept = 0, color = "gray55", linewidth = 0.4) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = c(pos = palette_mafap["A2"], neg = "#C00000"), guide = "none") +
  scale_x_continuous(breaks = seq(2006, 2024, 4)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El apoyo presupuestario neto al productor es marginal o negativo",
    subtitle = "MAFAP A — transferencias presupuestarias netas (BT), millones de USD const. 2015, 2006–2023",
    x = NULL, y = "USD mm const. 2015",
    caption = "Fuente: IDB AgriMonitor (componente presupuestario BT); cálculo propio (Banco Mundial) sobre panel v12 [m0.2.0].\nNota: marco de gasto público MAFAP (Vol II). El sostén de precios (MPS) NO es gasto público y se reporta como OECD-PSE en el Capítulo 5. Los valores negativos reflejan net-imposición al productor vía restricciones de exportación (coherente con F03)."
  ) +
  theme_aper_mafap()

save_figure(fig_a, "fig18a_mafap_A_apoyo_productor", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18b — MAFAP categorías B + C (Consumidor + Otros agentes)
# ----------------------------------------------------------------------------

# RETIRADA en m0.2.0: bajo el marco de gasto público (Vol II), la categoría B
# se medía con el CSE de AgriMonitor (price-inclusive, NO presupuestario) y C no
# tiene proxy. Ambas quedan como `no_data` hasta clasificación BOOST granular.
# El CSE se reporta como OECD-PSE en el Capítulo 5. Por tanto NO se genera fig18b
# (sería engañosa: serie vacía o basada en una medida que no es gasto público).
message("[m0.2.0] fig18b OMITIDA: B (consumidor) y C (otros agentes) son no_data en el marco de gasto público. CSE → Cap. 5 (PSE).")

# ----------------------------------------------------------------------------
# Figura 18c — MAFAP categoría D (Apoyo general al sector ≈ GSSE)
# ----------------------------------------------------------------------------

fig_d <- mafap %>%
  filter(!is.na(mafap_D_bob_2015), mafap_D_bob_2015 > 0) %>%
  mutate(monto_mm = mafap_D_bob_2015/FX2015) %>%
  ggplot(aes(x = year, y = monto_mm)) +
  geom_area(fill = palette_mafap["D"], alpha = 0.7, color = palette_mafap["D"],
            linewidth = 0.6) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El apoyo general al sector (MAFAP D, bienes públicos) es la categoría clave para repurposing",
    subtitle = "Bolivia, millones de USD constantes de 2015, 2006–2024",
    x = NULL, y = "USD mm const. 2015",
    caption = "Fuente: IDB AgriMonitor (GSSE); cálculo propio (Banco Mundial) sobre panel v12 [m0.2.0].\nNota: MAFAP D = apoyo general al sector (servicios públicos), proxy = GSSE OECD. Conceptualmente comprende I+D (INIAF), extensión, sanidad (SENASAG), infraestructura sectorial, etc.; la desagregación por subcategoría (D1–D10) requiere clasificación funcional BOOST granular y no se cuantifica en este panel agregado."
  ) +
  theme_aper_mafap()

save_figure(fig_d, "fig18c_mafap_D_apoyo_general", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18d — MAFAP categoría E (Gasto rural-soporte; diferencia narrow/full)
# ----------------------------------------------------------------------------

fig_e <- mafap %>%
  filter(!is.na(mafap_E_bob_2015), mafap_E_bob_2015 > 0) %>%
  mutate(monto_mm = mafap_E_bob_2015/FX2015) %>%
  ggplot(aes(x = year, y = monto_mm)) +
  geom_col(fill = palette_mafap["E"], width = 0.7) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El gasto rural-soporte (MAFAP E) define la diferencia entre GAP narrow y full",
    subtitle = "Bolivia, infraestructura rural municipal — millones de USD constantes de 2015, 2012–2023",
    x = NULL, y = "USD mm const. 2015",
    caption = "Fuente: SIIF / Jubileo compilación municipal; cálculo propio (Banco Mundial) sobre panel v12 [m0.2.0].\nNota: E = soporte rural (infraestructura municipal). Cobertura solo 2012–2021 (limitación documentada en ESTADO_DE_DATOS.md). Categoría incluida en MAFAP full, no en narrow. Subcategorías (E1–E3) conceptuales, no cuantificadas en este panel."
  ) +
  theme_aper_mafap()

save_figure(fig_e, "fig18d_mafap_E_rural_soporte", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18 summary — MOVIDA a 16_fig_mafap_publicexp.R (m0.2.0)
# ----------------------------------------------------------------------------
# La composición A–E apilada quedó obsoleta bajo el marco de gasto público:
# A puede ser negativa (BT neto) y B/C son no_data, por lo que un stack A–E es
# engañoso. La figura summary corregida (D+E apilados + A como línea neta) la
# produce ahora `02_code/04_visualization/16_fig_mafap_publicexp.R`.
message("[m0.2.0] fig18_summary se genera en 16_fig_mafap_publicexp.R (NO aquí, para no sobrescribir la versión corregida).")

# ---- Cierre ----------------------------------------------------------------

message("")
message("=== Resumen de figuras MAFAP generadas ===")
message("  fig18a_mafap_A_apoyo_productor        → cap 3 §H2.2.3")
message("  fig18b_mafap_BC_consumidor_otros      → cap 3 §H2.2.4")
message("  fig18c_mafap_D_apoyo_general          → cap 3 §H2.2.5")
message("  fig18d_mafap_E_rural_soporte          → cap 3 §H2.2.6")
message("  fig18_summary_mafap_ABCDE             → cap 3 §H2.2.2 (visión general)")
message("")
message("Outputs en: 05_outputs/figures/{svg,png,pdf}/")
message("Contratos JSON: pendientes (ver 07_FIGURAS §16; agregar en sesión de revisión A3)")
# ============================================================================
