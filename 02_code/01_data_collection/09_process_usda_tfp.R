library(data.table)
library(tidyverse)
library(scales)

here_root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
source(file.path(here_root, "02_code/04_visualization/00_wb_theme.R"))

raw_file <- file.path(here_root, "01_data/raw/usda_ers/usda_ers_tfp_international.csv")
proc_dir <- file.path(here_root, "01_data/processed")
fig_dir  <- file.path(here_root, "05_outputs/figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

# ── 1. Leer y filtrar ─────────────────────────────────────────────────────────
cat("Leyendo USDA ERS TFP...\n")
d <- fread(raw_file)
setnames(d, "Country/territory", "country")

latam_iso3 <- c("BOL", "PER", "CHL", "COL", "BRA", "ECU", "PRY", "ARG", "MEX")
latam_names <- c(
  BOL = "Bolivia", PER = "Perú", CHL = "Chile", COL = "Colombia",
  BRA = "Brasil",  ECU = "Ecuador", PRY = "Paraguay", ARG = "Argentina",
  MEX = "México"
)

key_vars <- c("TFP_Index", "Outall_Index", "Input_Index",
              "Land_Index", "Labor_Index", "Capital_Index", "Materials_Index",
              "Outall_Q", "Outcrop_Q", "Outanim_Q",
              "Cropland_Q", "IrrigArea_Q", "Labor_Q", "Capital_Q",
              "Fertilizer_Q", "Feed_Q")

lac <- d[ISO3 %in% latam_iso3 & Variable %in% key_vars]
cat("LAC obs:", nrow(lac), "\n")

# Pivot a wide
lac_wide <- dcast(lac, ISO3 + country + Year ~ Variable, value.var = "Value")
lac_wide[, country_label := latam_names[ISO3]]

# Bolivia solamente
bol <- lac_wide[ISO3 == "BOL"][order(Year)]
cat("Bolivia wide:", nrow(bol), "años ×", ncol(bol), "variables\n")

# ── 2. Guardar ────────────────────────────────────────────────────────────────
saveRDS(lac_wide, file.path(proc_dir, "usda_tfp_latam.rds"))
saveRDS(bol,      file.path(proc_dir, "usda_tfp_bolivia.rds"))
readr::write_csv(bol, file.path(proc_dir, "usda_tfp_bolivia.csv"))
cat("Guardados en", proc_dir, "\n\n")

# ── 3. Resumen Bolivia ────────────────────────────────────────────────────────
cat("=== Bolivia TFP Summary (2000-2023) ===\n")
print(bol[Year >= 2000, .(Year, TFP_Index, Outall_Index, Input_Index,
                          Land_Index, Labor_Index, Capital_Index, Fertilizer_Q)])

# ── 4. Fig 6: TFP Bolivia 1961-2023 ───────────────────────────────────────────
p6 <- ggplot(bol, aes(x = Year, y = TFP_Index)) +
  annotate("rect", xmin = 2006, xmax = 2019, ymin = -Inf, ymax = Inf,
           fill = WB_YELLOW, alpha = 0.12) +
  annotate("text", x = 2012.5, y = 60, label = "Gobierno\nMorales",
           color = WB_NAVY, size = 3, alpha = 0.7) +
  geom_line(color = WB_BLUE, linewidth = 1.2) +
  geom_point(color = WB_BLUE, size = 1.8) +
  geom_hline(yintercept = 100, linetype = "dashed", color = WB_GREY, linewidth = 0.5) +
  scale_x_continuous(breaks = seq(1961, 2023, 10)) +
  scale_y_continuous(labels = label_number(suffix = "")) +
  labs(title    = "Productividad Total de Factores Agropecuaria",
       subtitle = "Bolivia, 1961-2023 (Índice 2015=100)",
       x = NULL, y = "TFP Index (2015=100)",
       caption  = "Fuente: USDA Economic Research Service, International Agricultural Productivity.") +
  theme_wb()
ggsave(file.path(fig_dir, "fig06_tfp_bolivia_1961_2023.png"), p6, width = 9, height = 5, dpi = 150)
cat("Fig 6 guardado\n")

# ── 5. Fig 7: TFP Bolivia vs LAC 2000-2023 ────────────────────────────────────
# Rebase a 2000=100 para comparación de crecimiento
lac_tfp <- lac_wide[Year >= 2000, .(ISO3, country_label, Year, TFP_Index)]
base_2000 <- lac_tfp[Year == 2000, .(ISO3, tfp_base = TFP_Index)]
lac_tfp <- merge(lac_tfp, base_2000, by = "ISO3")
lac_tfp[, TFP_2000base := TFP_Index / tfp_base * 100]

highlight_countries <- c("BOL", "PER", "CHL", "COL", "BRA")
lac_bg   <- lac_tfp[!ISO3 %in% highlight_countries]
lac_fg   <- lac_tfp[ISO3 %in% highlight_countries]

country_colors <- c(
  BOL = WB_RED, PER = WB_TEAL, CHL = WB_BLUE,
  COL = WB_ORANGE, BRA = WB_GREEN
)

p7 <- ggplot() +
  geom_line(data = lac_bg, aes(x = Year, y = TFP_2000base, group = ISO3),
            color = WB_GREY, linewidth = 0.5, alpha = 0.5) +
  geom_line(data = lac_fg, aes(x = Year, y = TFP_2000base,
            color = ISO3, group = ISO3), linewidth = 1.3) +
  geom_hline(yintercept = 100, linetype = "dashed", color = WB_GREY, linewidth = 0.5) +
  scale_color_manual(values = country_colors,
                     labels = latam_names[highlight_countries]) +
  scale_x_continuous(breaks = seq(2000, 2023, 5)) +
  scale_y_continuous(labels = label_number(suffix = "")) +
  labs(title    = "Crecimiento de la Productividad Agropecuaria (TFP)",
       subtitle = "Bolivia y comparadores LAC, 2000-2023 (Índice 2000=100)",
       x = NULL, y = "TFP Index (2000=100)", color = "País",
       caption  = "Fuente: USDA ERS International Agricultural Productivity. Países en gris: resto LAC.") +
  theme_wb() +
  theme(legend.position = "right")
ggsave(file.path(fig_dir, "fig07_tfp_latam_comparison.png"), p7, width = 9, height = 5, dpi = 150)
cat("Fig 7 guardado\n")

# ── 6. Fig 8: Descomposición TFP Bolivia — Inputs vs Output ───────────────────
bol_decomp <- bol[Year >= 2000,
                  .(Year, TFP_Index, Outall_Index, Input_Index,
                    Land_Index, Labor_Index, Capital_Index, Materials_Index)] |>
  pivot_longer(-Year, names_to = "component", values_to = "index") |>
  mutate(component = recode(component,
    TFP_Index       = "TFP Total",
    Outall_Index    = "Output total",
    Input_Index     = "Inputs totales",
    Land_Index      = "Tierra",
    Labor_Index     = "Trabajo",
    Capital_Index   = "Capital",
    Materials_Index = "Materiales"
  ),
  group = case_when(
    component == "TFP Total"     ~ "TFP",
    component %in% c("Output total") ~ "Output",
    TRUE ~ "Inputs"
  ))

p8 <- ggplot(bol_decomp[bol_decomp$component %in%
                          c("TFP Total", "Output total", "Inputs totales"), ],
             aes(x = Year, y = index, color = component)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 100, linetype = "dashed", color = WB_GREY, linewidth = 0.4) +
  scale_color_manual(values = c("TFP Total"     = WB_BLUE,
                                "Output total"  = WB_TEAL,
                                "Inputs totales" = WB_RED)) +
  scale_x_continuous(breaks = seq(2000, 2023, 5)) +
  labs(title    = "Descomposición de la Productividad Agropecuaria",
       subtitle = "Bolivia, 2000-2023 (Índice 2015=100)",
       x = NULL, y = "Índice (2015=100)", color = NULL,
       caption  = "Fuente: USDA ERS. TFP = Output / Inputs.") +
  theme_wb() +
  theme(legend.position = "bottom")
ggsave(file.path(fig_dir, "fig08_tfp_decomposition_bolivia.png"), p8, width = 9, height = 5, dpi = 150)
cat("Fig 8 guardado\n")

# ── 7. Fig 9: Índices de factores — tierra, trabajo, capital ──────────────────
p9 <- ggplot(bol_decomp[bol_decomp$component %in%
                          c("Tierra", "Trabajo", "Capital", "Materiales"), ],
             aes(x = Year, y = index, color = component)) +
  geom_line(linewidth = 1.1) +
  geom_hline(yintercept = 100, linetype = "dashed", color = WB_GREY, linewidth = 0.4) +
  scale_color_manual(values = c(Tierra = WB_TEAL, Trabajo = WB_BLUE,
                                Capital = WB_ORANGE, Materiales = WB_NAVY)) +
  scale_x_continuous(breaks = seq(2000, 2023, 5)) +
  labs(title    = "Índices de Insumos Agropecuarios",
       subtitle = "Bolivia, 2000-2023 (Índice 2015=100)",
       x = NULL, y = "Índice (2015=100)", color = "Factor",
       caption  = "Fuente: USDA ERS International Agricultural Productivity.") +
  theme_wb() +
  theme(legend.position = "right")
ggsave(file.path(fig_dir, "fig09_input_indices_bolivia.png"), p9, width = 9, height = 5, dpi = 150)
cat("Fig 9 guardado\n")

# ── 8. Tabla ranking TFP LAC ──────────────────────────────────────────────────
tfp_rank <- lac_wide[Year %in% c(2000, 2010, 2015, 2020, 2023),
                     .(ISO3, country_label, Year, TFP_Index)] |>
  as_tibble() |>
  pivot_wider(names_from = Year, values_from = TFP_Index,
              names_prefix = "tfp_") |>
  mutate(growth_2000_2023 = (tfp_2023 / tfp_2000 - 1) * 100) |>
  arrange(desc(growth_2000_2023))

cat("\n=== Ranking TFP LAC: Crecimiento 2000-2023 ===\n")
print(tfp_rank[, c("country_label", "tfp_2000", "tfp_2010", "tfp_2015", "tfp_2023", "growth_2000_2023")])

readr::write_csv(tfp_rank, file.path(proc_dir, "usda_tfp_lac_ranking.csv"))

cat("\n=== Todas las figuras guardadas ===\n")
print(list.files(fig_dir, pattern = "fig0[6-9].*\\.png"))
