# Figure 2c: Thermotolerance of parental strains and recombinant segregants
#

library(ggplot2)
library(tidyverse)
library(writexl)

# ----- 1) Build Gen0 plotting table -----

# X-axis order follows the order in which hybrids first appear
# in the processed input file.
hy_levels <- df_raw %>%
  mutate(Hybrid = trimws(as.character(Hybrid))) %>%
  group_by(Hybrid) %>%
  summarise(
    first_row = min(row_number()),
    .groups = "drop"
  ) %>%
  arrange(first_row) %>%
  pull(Hybrid)

# Keep generation-0 measurements used in Figure 2c
df0 <- df_equal %>%
  filter(Gen == 0) %>%
  mutate(
    Hybrid = factor(Hybrid, levels = hy_levels)
  )

# Optional export of the processed plotting table
write_xlsx(
  df0,
  "ThermotoleranceFile.xlsx"
)

# ----- 2) Calculate mean and 95% confidence interval -----

summ0 <- df0 %>%
  group_by(Hybrid) %>%
  summarise(
    N = sum(!is.na(R_equal)),
    mean_R = mean(R_equal, na.rm = TRUE),
    se = sd(R_equal, na.rm = TRUE) / sqrt(N),
    CI = qt(0.975, df = pmax(N - 1, 1)) * se,
    .groups = "drop"
  )

# ----- 3) Color palette -----

my_colors <- c(
  "#316484",
  "#b46c6c",
  "darkmagenta",
  "#26432FFF", "#26432FFF", "#26432FFF", "#26432FFF",
  "#4D6D93FF", "#4D6D93FF", "#4D6D93FF", "#4D6D93FF",
  "#6FB382FF", "#6FB382FF", "#6FB382FF", "#6FB382FF",
  "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF",
  "#92BBD9FF", "#92BBD9FF", "#92BBD9FF", "#92BBD9FF"
)

col_map <- setNames(
  rep_len(my_colors, length(hy_levels)),
  hy_levels
)

# ----- 4) Generate plot -----

p <- ggplot(
  df0,
  aes(
    x = Hybrid,
    y = R_equal
  )
) +
  
  # Individual biological measurements
  geom_point(
    aes(colour = Hybrid),
    size = 3.5,
    alpha = 0.6,
    shape = 19
  ) +
  
  scale_color_manual(
    values = col_map,
    drop = FALSE
  ) +
  
  # Mean
  geom_point(
    data = summ0,
    aes(
      x = Hybrid,
      y = mean_R
    ),
    size = 1.5,
    color = "black",
    inherit.aes = FALSE
  ) +
  
  # 95% confidence interval
  geom_errorbar(
    data = summ0,
    aes(
      x = Hybrid,
      ymin = mean_R - CI,
      ymax = mean_R + CI
    ),
    width = 0.1,
    color = "black",
    inherit.aes = FALSE
  ) +
  
  # Reference line at equal growth at both temperatures
  geom_hline(
    yintercept = 1,
    linetype = "longdash",
    color = "#006666",
    linewidth = 0.5
  ) +
  
  ylab(
    expression(
      paste(
        "Thermotolerance (",
        R[equal],
        " = ",
        S[37],
        "/",
        S[30],
        ")"
      )
    )
  ) +
  
  xlab(NULL) +
  
  scale_y_continuous(
    limits = c(0, 1.5)
  ) +
  
  theme_bw() +
  
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.5
    ),
    legend.position = "none"
  )

# ----- 5) Add separators between tetrads -----

n_hy <- length(levels(df0$Hybrid))

# Positions after every four segregants
vline_pos <- seq(
  4,
  n_hy,
  by = 4
) + 0.5

p <- p +
  geom_vline(
    xintercept = vline_pos,
    linewidth = 0.5,
    color = "darkgray",
    linetype = "dashed"
  )

# ----- 6) Display and export -----

print(p)

ggsave(
  filename = "Gen0_R_equal_points_mean.pdf",
  plot = p,
  units = "in",
  width = 7,
  height = 4,
  dpi = 300
)

# Code-development note:
# This script was developed by authors with assistance from
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
