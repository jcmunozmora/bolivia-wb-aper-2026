# 19_fig_gasto_pct_pib.R — Cap. 3: gasto público agropecuario como % del PIB
# Dos series: (a) gasto TOTAL / PIB (BOOST 2006-2008 + MEFP 2016-2023, con gap declarado),
#             (b) inversión / PIB (2000-2023, continua, de referencia).
# Mensaje: la agricultura aporta ~12% del PIB pero recibe ~1% del PIB en gasto público.
# Fuente: MEFP Presupuesto Abierto + BOOST + VIPFE (panel v12). Ver ADR-0012.
# Salida: fig_gasto_agro_pct_pib.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

m <- readRDS(here("01_data","processed","mafap_bolivia.rds"))

d <- m %>% transmute(
  year,
  # gasto total / PIB: MEFP (2016-2023) donde hay GDP, + BOOST (2006-2008)
  total_mmbs = coalesce(mefp_gasto_agro_total_bs/1e6, boost_presup_ejecutado_mm),
  pct_pib_total = if_else(!is.na(GDP_BOB_mm) & GDP_BOB_mm>0, 100*total_mmbs/GDP_BOB_mm, NA_real_),
  pct_pib_inv = inv_agro_pct_gdp
)

tot <- d %>% filter(!is.na(pct_pib_total), year>=2006) %>%
  mutate(fuente = if_else(year<=2008, "BOOST", "MEFP"))
inv <- d %>% filter(!is.na(pct_pib_inv), year>=2000)

C_TOT <- "#1F4E79"; C_INV <- "#BF8F00"

p <- ggplot() +
  # gap 2009-2015 sombreado
  annotate("rect", xmin=2008.5, xmax=2015.5, ymin=0, ymax=Inf, fill="gray85", alpha=0.35) +
  annotate("text", x=2012, y=1.55, label="sin dato de\ngasto total\n2009–2015", size=2.7,
           color="gray45", fontface="italic", lineheight=0.9) +
  # inversión / PIB (referencia, continua)
  geom_line(data=inv, aes(year, pct_pib_inv), color=C_INV, linewidth=1.0) +
  geom_point(data=inv, aes(year, pct_pib_inv), color=C_INV, size=1.4) +
  # gasto total / PIB (protagonista, dos tramos)
  geom_line(data=filter(tot, year<=2008), aes(year, pct_pib_total), color=C_TOT, linewidth=1.5) +
  geom_line(data=filter(tot, year>=2016), aes(year, pct_pib_total), color=C_TOT, linewidth=1.5) +
  geom_point(data=tot, aes(year, pct_pib_total), color=C_TOT, size=2.1) +
  # etiquetas de serie al final
  annotate("text", x=2023.3, y=tot$pct_pib_total[tot$year==2023], hjust=0, vjust=-0.3,
           label="Gasto total\n(corriente+capital)", color=C_TOT, fontface="bold", size=3, lineheight=0.9) +
  annotate("text", x=2023.3, y=inv$pct_pib_inv[inv$year==2023], hjust=0, vjust=1.1,
           label="Inversión\n(capital)", color=C_INV, fontface="bold", size=3, lineheight=0.9) +
  scale_x_continuous(breaks=seq(2000,2024,4), limits=c(2000,2027)) +
  scale_y_continuous(labels=label_number(accuracy=0.1, suffix="%"), limits=c(0,NA),
                     expand=expansion(mult=c(0,0.08))) +
  labs(
    title = "El gasto público agropecuario boliviano ronda el 1% del PIB",
    subtitle = "Gasto público agropecuario como proporción del PIB, 2000–2023. El gasto total (corriente+capital) se ubica en ~1,0–1,4% del PIB;\nla inversión sola, en ~0,3–0,7%. Para un sector que aporta cerca del 12% del PIB, la intensidad del gasto público es baja.",
    x = NULL, y = "% del PIB",
    caption = "Fuente: cálculo propio (Banco Mundial) sobre panel v12 — MEFP Presupuesto Abierto (gasto total devengado, 2016–2023), BOOST (2006–2008) y VIPFE (inversión). PIB en BOB corrientes (INE). El gasto total 2009–2015 no tiene fuente directa (gap declarado, ADR-0012); no se interpola."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13.5, face = "bold", color = "#2C3E50"),
    plot.subtitle = element_text(size = 9.6, color = "gray40", margin = margin(b=8), lineheight = 1.05),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t=10), lineheight=1.1),
    plot.caption.position = "plot",
    axis.title.y = element_text(size = 9.5, color = "gray30"),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12,14,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_gasto_agro_pct_pib.png"), p, width=10.5, height=5.8, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_gasto_agro_pct_pib.svg"), p, width=10.5, height=5.8, bg="white")
ggsave(here("05_outputs","figures","pdf","fig_gasto_agro_pct_pib.pdf"), p, width=10.5, height=5.8, bg="white")

cat("\n✅ fig_gasto_agro_pct_pib generada\n")
cat("Gasto total/PIB:\n"); print(tot %>% select(year, pct=pct_pib_total, fuente) %>% mutate(pct=round(pct,2)) %>% as.data.frame(), row.names=FALSE)
