# Supplementary Figure 5
#
#Supplementary Figure 5 shows thermotolerance trajectories of independently
#evolved populations.
#
#Thermotolerance was calculated using the equal-average method
#(`R_equal = S37_equal / S30_equal`). Generation-0 measurements were
#summarized by the ancestral mean for each hybrid background, while evolved
#
#lineages were shown individually.
#
#Differences from the ancestral state were assessed using two-sided
#one-sample t-tests on lineage-level changes, followed by
#Benjamini-Hochberg correction.
#
#The processed data used to generate this figure are provided in
#`data/Trajectories_R_equal_data.txt`.
#
#Final graphical formatting and panel assembly were performed in
#Adobe Illustrator.

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# ---------------------------------------------------------------
# Load processed thermotolerance data
# ---------------------------------------------------------------

df <- read.delim(
  "../data/Trajectories_R_equal_data.txt",
  header = TRUE,
  sep = "\t"
)

# Expected columns:
# Hybrid
# Gen
# sample
# S30_equal
# S37_equal
# R_equal
# mu
# R_plot

# Preserve hybrid order
hy_levels <- unique(df$Hybrid)

df$Hybrid <- factor(
  df$Hybrid,
  levels = hy_levels
)

# ---------------------------------------------------------------
# Generation-0 ancestral mean
# ---------------------------------------------------------------

g0_means <- df %>%
  filter(Gen == 0) %>%
  group_by(Hybrid) %>%
  summarise(
    mu = mean(R_equal, na.rm = TRUE),
    .groups = "drop"
  )

# Gen0 is collapsed to the hybrid ancestral mean for visualization.
# Evolved generations retain the individual lineage values.
df_traj <- df %>%
  select(-any_of("mu")) %>%
  left_join(
    g0_means,
    by = "Hybrid"
  ) %>%
  mutate(
    R_plot = ifelse(
      Gen == 0,
      mu,
      R_equal
    )
  )

df_traj$Hybrid <- factor(
  df_traj$Hybrid,
  levels = hy_levels
)

# ---------------------------------------------------------------
# Pair lineage measurements across generations
# ---------------------------------------------------------------

df_wide <- df_traj %>%
  select(
    Hybrid,
    sample,
    Gen,
    R_equal
  ) %>%
  distinct() %>%
  pivot_wider(
    names_from = Gen,
    values_from = R_equal,
    names_prefix = "G"
  )

# ---------------------------------------------------------------
# Tests relative to Gen0
# ---------------------------------------------------------------

per_hybrid_stats <- df_wide %>%
  group_by(Hybrid) %>%
  summarise(

    n_5000 = sum(
      !is.na(G0) &
      !is.na(G5000)
    ),

    delta_5000 = mean(
      G5000 - G0,
      na.rm = TRUE
    ),

    p_5000 = if (
      n_5000 > 1
    ) {
      t.test(
        G5000 - G0,
        mu = 0,
        alternative = "two.sided"
      )$p.value
    } else {
      NA_real_
    },

    n_9000 = sum(
      !is.na(G0) &
      !is.na(G9000)
    ),

    delta_9000 = mean(
      G9000 - G0,
      na.rm = TRUE
    ),

    p_9000 = if (
      n_9000 > 1
    ) {
      t.test(
        G9000 - G0,
        mu = 0,
        alternative = "two.sided"
      )$p.value
    } else {
      NA_real_
    },

    .groups = "drop"
  )

# Convert to long format and apply BH correction
stats_long <- per_hybrid_stats %>%
  select(
    Hybrid,
    p_5000,
    p_9000
  ) %>%
  pivot_longer(
    cols = c(
      p_5000,
      p_9000
    ),
    names_to = "comparison",
    values_to = "p_raw"
  ) %>%
  mutate(
    Gen = case_when(
      comparison == "p_5000" ~ 5000,
      comparison == "p_9000" ~ 9000
    )
  ) %>%
  group_by(Gen) %>%
  mutate(
    p_adj = p.adjust(
      p_raw,
      method = "BH"
    )
  ) %>%
  ungroup() %>%
  mutate(
    label = case_when(
      is.na(p_adj)   ~ "",
      p_adj < 0.001  ~ "***",
      p_adj < 0.01   ~ "**",
      p_adj < 0.05   ~ "*",
      TRUE           ~ "N.S."
    )
  )

# ---------------------------------------------------------------
# Mean ± SE for plotting
# ---------------------------------------------------------------

hyb_means <- df_traj %>%
  group_by(
    Hybrid,
    Gen
  ) %>%
  summarise(
    N = sum(!is.na(R_plot)),
    mean_R = mean(
      R_plot,
      na.rm = TRUE
    ),
    se_R = sd(
      R_plot,
      na.rm = TRUE
    ) / sqrt(N),
    .groups = "drop"
  )

# Position significance labels above each trajectory
sig_labels <- stats_long %>%
  left_join(
    hyb_means %>%
      group_by(Hybrid) %>%
      summarise(
        y_max = max(
          mean_R + se_R,
          na.rm = TRUE
        ),
        .groups = "drop"
      ),
    by = "Hybrid"
  ) %>%
  mutate(
    y_pos = pmin(
      y_max * 1.05,
      1.45
    )
  )

# ---------------------------------------------------------------
# Color palette
# ---------------------------------------------------------------

my_colors <- c(
  "#316484",
  "#b46c6c",
  "darkmagenta",
  "darkmagenta",

  "#26432FFF", "#26432FFF", "#26432FFF", "#26432FFF",
  "#4D6D93FF", "#4D6D93FF", "#4D6D93FF", "#4D6D93FF",
  "#6FB382FF", "#6FB382FF", "#6FB382FF", "#6FB382FF",
  "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF",
  "#92BBD9FF", "#92BBD9FF", "#92BBD9FF", "#92BBD9FF"
)

col_map <- setNames(
  my_colors[seq_along(hy_levels)],
  hy_levels
)

# ---------------------------------------------------------------
# Plot thermotolerance trajectories
# ---------------------------------------------------------------

plot_S5 <- ggplot() +

  # Independent evolved lineages
  geom_line(
    data = df_traj,
    aes(
      x = Gen,
      y = R_plot,
      group = interaction(
        Hybrid,
        sample
      ),
      color = Hybrid
    ),
    alpha = 0.5,
    linewidth = 0.4
  ) +

  geom_point(
    data = df_traj,
    aes(
      x = Gen,
      y = R_plot,
      color = Hybrid
    ),
    alpha = 0.8,
    size = 1.3
  ) +

  # Reference: equal relative growth at both temperatures
  geom_hline(
    yintercept = 1,
    color = "gray",
    linewidth = 0.4
  ) +

  # Mean trajectory
  geom_line(
    data = hyb_means,
    aes(
      x = Gen,
      y = mean_R,
      group = Hybrid
    ),
    color = "black",
    linewidth = 0.7
  ) +

  # Mean ± SE
  geom_errorbar(
    data = hyb_means,
    aes(
      x = Gen,
      ymin = mean_R - se_R,
      ymax = mean_R + se_R
    ),
    width = 300,
    linewidth = 0.4,
    color = "black"
  ) +

  # BH-adjusted significance
  geom_text(
    data = sig_labels,
    aes(
      x = Gen,
      y = y_pos,
      label = label
    ),
    size = 2.5,
    vjust = 0
  ) +

  scale_color_manual(
    values = col_map,
    drop = FALSE
  ) +

  scale_y_continuous(
    limits = c(0, 1.5)
  ) +

  facet_wrap(
    ~ Hybrid,
    ncol = 4
  ) +

  labs(
    x = "Generation",
    y = expression(
      "Thermotolerance (" *
      R[equal] *
      ")"
    )
  ) +

  theme_bw() +

  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_blank(),
    strip.text = element_text(
      size = 8,
      face = "bold"
    ),
    legend.position = "none",
    axis.text.x = element_text(size = 7),
    axis.text.y = element_text(size = 7),
    axis.title = element_text(size = 8)
  )

print(plot_S5)

# ---------------------------------------------------------------
# Export base plot
# ---------------------------------------------------------------

ggsave(
  "FigureS5_thermotolerance_trajectories.pdf",
  plot = plot_S5,
  width = 8,
  height = 10,
  dpi = 300
)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
