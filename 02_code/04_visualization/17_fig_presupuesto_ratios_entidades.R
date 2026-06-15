# 17_fig_presupuesto_ratios_entidades.R — Cap. 3: ratios de gasto + entidades ejecutoras
# Fig A: tres ratios de intensidad del gasto agropecuario (Bolivia, 2000–2024).
# Fig B: ¿quién ejecuta el gasto agropecuario? (share por tipo de entidad, BOOST 2004–2008).
# Fuente: panel v12 (VIPFE/MEFP) + aper_agro.rds (BOOST entidad-año).
# Salida: fig_ratios_gasto_agro.* y fig_entidades_ejecutoras.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(patchwork); library(here)

# ============================================================================
# FIGURA A — Tres ratios de intensidad del gasto agropecuario
# ============================================================================

m <- readRDS(here("01_data","processed","mafap_bolivia.rds"))

ratios <- m %>%
  filter(year >= 2000) %>%
  transmute(
    year,
    `% del PIB`                       = inv_agro_pct_gdp,
    `% del PIB agropecuario`          = if_else(!is.na(agr_gdp_usd) & agr_gdp_usd > 0,
                                                100 * inv_agro_usd_mm / (agr_gdp_usd/1e6), NA_real_),
    `% de la inversión pública total` = inv_agro_pct_total
  ) %>%
  pivot_longer(-year, names_to = "ratio", values_to = "valor") %>%
  filter(!is.na(valor)) %>%
  mutate(ratio = factor(ratio, levels = c("% del PIB", "% del PIB agropecuario", "% de la inversión pública total")))

# Líneas de referencia (Maputo 10% solo para el panel de gasto público)
ref <- tibble(ratio = factor("% de la inversión pública total",
                             levels = levels(ratios$ratio)), yref = 10)

pA <- ggplot(ratios, aes(year, valor)) +
  geom_hline(data = ref, aes(yintercept = yref), linetype = "dashed", color = "#C00000", linewidth = 0.4) +
  geom_line(color = "#1F4E79", linewidth = 1.1) +
  geom_point(color = "#1F4E79", size = 1.6) +
  facet_wrap(~ratio, scales = "free_y", nrow = 1) +
  scale_x_continuous(breaks = seq(2000, 2024, 8)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1, suffix = "%")) +
  labs(
    title = "La intensidad del gasto público agropecuario boliviano es baja y volátil",
    subtitle = "Inversión pública agropecuaria como proporción del PIB, del PIB agropecuario y de la inversión pública total, 2000–2024.\nLínea roja: referencia de Maputo (10%). La comparación principal es la evolución de Bolivia en el tiempo.",
    x = NULL, y = NULL,
    caption = "Fuente: cálculo propio (Banco Mundial) sobre panel v12 — VIPFE/MEFP (inversión y gasto), WDI/INE (PIB y PIB agropecuario). Nota: el ratio sobre 'inversión pública total' no es el ratio de Maputo estricto (gasto público total); ese se reporta en §3.3 (hallazgo F04, ~6%)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13.5, face = "bold", color = "#2C3E50"),
    plot.subtitle = element_text(size = 9.6, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    strip.text = element_text(face = "bold", size = 10, color = "#1F4E79"),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

# ============================================================================
# FIGURA B — ¿Quién ejecuta el gasto agropecuario?
# ============================================================================

a <- readRDS(here("01_data","processed","aper_agro.rds"))

ent <- a %>%
  filter(year >= 2004) %>%
  mutate(grupo = case_when(
    grepl("Prefectura", entity_name, ignore.case = TRUE) ~ "Prefecturas\n(gobiernos departamentales)",
    grepl("Municipalidad|Gobierno Municipal", entity_name, ignore.case = TRUE) ~ "Municipios",
    grepl("Ministerio", entity_name, ignore.case = TRUE) ~ "MDRyT / Ministerio rector",
    grepl("EMAPA|Apoyo a la Producci", entity_name, ignore.case = TRUE) ~ "EMAPA",
    grepl("PL.?480", entity_name, ignore.case = TRUE) ~ "PL-480 (ayuda alimentaria)",
    grepl("Investigaci|CIAT|INIAF", entity_name, ignore.case = TRUE) ~ "I+D (CIAT / INIAF)",
    TRUE ~ "Otras entidades"
  )) %>%
  group_by(grupo) %>% summarise(ej = sum(budget_executed, na.rm = TRUE), .groups = "drop") %>%
  mutate(share = 100 * ej / sum(ej)) %>%
  arrange(share) %>%
  mutate(grupo = factor(grupo, levels = grupo),
         es_min = grepl("MDRyT", grupo),
         fill_col = if_else(es_min, "#C00000", "#1F4E79"))

n_ent <- n_distinct(a$entity_name[a$year >= 2004])

pB <- ggplot(ent, aes(share, grupo)) +
  geom_col(aes(fill = fill_col), width = 0.7) +
  scale_fill_identity() +
  geom_text(aes(label = paste0(round(share,1), "%")), hjust = -0.15, size = 3.3, color = "gray25") +
  scale_x_continuous(labels = label_number(suffix="%"), expand = expansion(mult = c(0, 0.12)), limits = c(0, 40)) +
  labs(
    title = "El Ministerio de Agricultura ejecuta solo uno de cada cinco bolivianos del gasto agropecuario",
    subtitle = paste0("Participación en la ejecución del gasto público agropecuario por tipo de entidad, promedio 2004–2008.\n",
                      "Los gobiernos subnacionales (prefecturas + municipios) ejecutan cerca del 62%; en total ", n_ent,
                      " entidades distintas ejecutan gasto del sector."),
    x = NULL, y = NULL,
    caption = "Fuente: cálculo propio (Banco Mundial) sobre BOOST/VIPFE (aper_agro, ejecución entidad-año). Ventana 1996–2008 (cobertura BOOST con detalle por entidad). La descentralización ejecutora se profundizó tras la Ley 031/2010 de Autonomías (ver §3.1 y Capítulo 4)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.6, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    axis.text.y = element_text(size = 9.5, color = "gray20", lineheight = 0.9),
    panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 16, 10, 12)
  )

# ---- Guardar ----
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_ratios_gasto_agro.png"), pA, width = 11, height = 5.2, dpi = 600, bg = "white")
ggsave(here("05_outputs","figures","svg","fig_ratios_gasto_agro.svg"), pA, width = 11, height = 5.2, bg = "white")
ggsave(here("05_outputs","figures","pdf","fig_ratios_gasto_agro.pdf"), pA, width = 11, height = 5.2, bg = "white")
ggsave(here("05_outputs","figures","png","fig_entidades_ejecutoras.png"), pB, width = 10.5, height = 5.6, dpi = 600, bg = "white")
ggsave(here("05_outputs","figures","svg","fig_entidades_ejecutoras.svg"), pB, width = 10.5, height = 5.6, bg = "white")
ggsave(here("05_outputs","figures","pdf","fig_entidades_ejecutoras.pdf"), pB, width = 10.5, height = 5.6, bg = "white")

cat("\n✅ Figuras generadas: fig_ratios_gasto_agro + fig_entidades_ejecutoras\n")
cat("\nShares ejecución (2004-2008):\n"); print(ent %>% arrange(desc(share)) %>% select(grupo, share) %>% mutate(share=round(share,1)) %>% as.data.frame(), row.names=FALSE)
