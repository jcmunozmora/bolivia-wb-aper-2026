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

mafap <- readRDS(PATH_DATA)
message(glue("Cargado mafap_bolivia.rds: {nrow(mafap)} años × {ncol(mafap)} cols"))

# Helper: pivot largo de las 5 categorías para gráficos apilados
df_long <- mafap %>%
  select(year, mafap_A_bob_2015, mafap_B_bob_2015, mafap_C_bob_2015,
         mafap_D_bob_2015, mafap_E_bob_2015) %>%
  rename(A = mafap_A_bob_2015, B = mafap_B_bob_2015, C = mafap_C_bob_2015,
         D = mafap_D_bob_2015, E = mafap_E_bob_2015) %>%
  pivot_longer(-year, names_to = "categoria", values_to = "monto_bob_2015") %>%
  mutate(monto_mm = monto_bob_2015 / 1e6)

# ----------------------------------------------------------------------------
# Figura 18a — MAFAP categoría A (Apoyo al productor)
# ----------------------------------------------------------------------------

fig_a <- mafap %>%
  filter(!is.na(mafap_A_bob_2015), mafap_A_bob_2015 > 0) %>%
  mutate(monto_mm = mafap_A_bob_2015 / 1e6) %>%
  ggplot(aes(x = year, y = monto_mm)) +
  geom_col(fill = palette_mafap["A"], width = 0.7) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El apoyo al productor (MAFAP categoría A) se concentra en transferencias presupuestarias y MPS",
    subtitle = "Bolivia, millones de BOB constantes 2015, 2006–2024",
    x = NULL, y = "BOB mm 2015",
    caption = "Fuente: IDB AgriMonitor 2024 (MPS, BT); cálculo propio sobre panel v12 [m0.1.0].\nNota: A1 = Market Price Support; A2 = subsidios a insumos (incluye revenue foregone BDP, ver ADR-0010). Categoría agregada A = A1 + A2 + A3."
  ) +
  theme_aper_mafap()

save_figure(fig_a, "fig18a_mafap_A_apoyo_productor", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18b — MAFAP categorías B + C (Consumidor + Otros agentes)
# ----------------------------------------------------------------------------

fig_bc <- df_long %>%
  filter(categoria %in% c("B", "C"), !is.na(monto_mm)) %>%
  ggplot(aes(x = year, y = monto_mm, fill = categoria)) +
  geom_col(position = "stack", width = 0.7) +
  scale_fill_manual(values = palette_mafap[c("B", "C")],
                    labels = c("B — Apoyo al consumidor",
                               "C — Apoyo a otros agentes")) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El apoyo al consumidor (B) supera al de otros agentes (C) en todo el período",
    subtitle = "Bolivia, millones de BOB constantes 2015, 2006–2024",
    x = NULL, y = "BOB mm 2015",
    caption = "Fuente: IDB AgriMonitor 2024 (CSE); cálculo propio sobre panel v12 [m0.1.0].\nNota: B incluye compras EMAPA al consumidor con precio subsidiado + componente alimentario de bonos. C requiere clasificación granular pendiente (ver script 17_mafap_classification.R caveat §1)."
  ) +
  theme_aper_mafap()

save_figure(fig_bc, "fig18b_mafap_BC_consumidor_otros", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18c — MAFAP categoría D (Apoyo general al sector ≈ GSSE)
# ----------------------------------------------------------------------------

fig_d <- mafap %>%
  filter(!is.na(mafap_D_bob_2015), mafap_D_bob_2015 > 0) %>%
  mutate(monto_mm = mafap_D_bob_2015 / 1e6) %>%
  ggplot(aes(x = year, y = monto_mm)) +
  geom_area(fill = palette_mafap["D"], alpha = 0.7, color = palette_mafap["D"],
            linewidth = 0.6) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El apoyo general al sector (MAFAP D, bienes públicos) es la categoría clave para repurposing",
    subtitle = "Bolivia, millones de BOB constantes 2015, 2006–2024",
    x = NULL, y = "BOB mm 2015",
    caption = "Fuente: IDB AgriMonitor 2024 (GSSE); cálculo propio sobre panel v12 [m0.1.0].\nNota: MAFAP D incluye D1 investigación (INIAF), D2-D4 extensión, D5 sanidad (SENASAG), D6 infraestructura sectorial, D7 almacenamiento, D8 marketing, D9 costos administrativos, D10 otros. Equivalente aproximado a GSSE OECD."
  ) +
  theme_aper_mafap()

save_figure(fig_d, "fig18c_mafap_D_apoyo_general", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18d — MAFAP categoría E (Gasto rural-soporte; diferencia narrow/full)
# ----------------------------------------------------------------------------

fig_e <- mafap %>%
  filter(!is.na(mafap_E_bob_2015), mafap_E_bob_2015 > 0) %>%
  mutate(monto_mm = mafap_E_bob_2015 / 1e6) %>%
  ggplot(aes(x = year, y = monto_mm)) +
  geom_col(fill = palette_mafap["E"], width = 0.7) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El gasto rural-soporte (MAFAP E) define la diferencia entre GAP narrow y full",
    subtitle = "Bolivia, infraestructura rural municipal — millones de BOB constantes 2015, 2012–2023",
    x = NULL, y = "BOB mm 2015",
    caption = "Fuente: SIIF / Jubileo compilación municipal; cálculo propio sobre panel v12 [m0.1.0].\nNota: E1 educación rural, E2 salud rural, E3.1 caminos rurales, E3.2 agua y saneamiento, E3.3 electrificación. Cobertura 2012-2023 (limitación documentada en ESTADO_DE_DATOS.md). Categoría no incluida en MAFAP narrow."
  ) +
  theme_aper_mafap()

save_figure(fig_e, "fig18d_mafap_E_rural_soporte", height = 4.0)

# ----------------------------------------------------------------------------
# Figura 18 summary — Composición MAFAP A-E apilada
# ----------------------------------------------------------------------------

# Calcular shares relativos al narrow para % ; mantener E aparte
df_summary <- df_long %>%
  filter(!is.na(monto_mm), monto_mm > 0) %>%
  mutate(categoria = factor(categoria, levels = c("A", "B", "C", "D", "E")))

fig_summary <- df_summary %>%
  ggplot(aes(x = year, y = monto_mm, fill = categoria)) +
  geom_col(position = "stack", width = 0.7) +
  scale_fill_manual(
    values = palette_mafap[c("A", "B", "C", "D", "E")],
    labels = c("A — Apoyo al productor",
               "B — Consumidor",
               "C — Otros agentes",
               "D — Apoyo general (bienes públicos)",
               "E — Rural-soporte (solo en GAP full)")
  ) +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(
    title    = "El gasto agrícola público boliviano bajo MAFAP: composición A–E, 2006–2024",
    subtitle = "Millones de BOB constantes 2015. Diferencia narrow ↔ full = categoría E (rural-soporte)",
    x = NULL, y = "BOB mm 2015",
    caption = "Fuente: IDB AgriMonitor 2024 + BOOST + SIIF municipal; cálculo propio sobre panel v12 [m0.1.0].\nNota: Cifra MAFAP narrow = A + B + C + D (Maputo/CAADP). Cifra MAFAP full = narrow + E. Crosswalk con OECD-PSE en Apéndice D. Decisión de adopción dual: ADR-0009.\nCobertura: serie completa requiere SIIF municipal pre-2012 (gap documentado en 00_admin/ESTADO_DE_DATOS.md)."
  ) +
  theme_aper_mafap() +
  theme(legend.position = "top",
        legend.text = element_text(size = 8.5))

save_figure(fig_summary, "fig18_summary_mafap_ABCDE", height = 4.5, width = 7.5)

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
