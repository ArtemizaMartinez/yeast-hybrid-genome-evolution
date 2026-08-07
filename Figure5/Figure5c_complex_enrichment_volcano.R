# Figure 5c: Enrichment of mutations in protein complexes
#
# This script documents the R workflow used to generate the base plot
# for Figure 5c.
#
# The input table contains, for each protein complex, the excess of
# observed mutations relative to expectation and the associated
# statistical significance.
#
# The complete numerical values and statistical results are provided
# in the Source Data file associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, spacing, and final panel layout.
# These graphical edits did not alter the underlying numerical values.

library(readxl)
library(dplyr)
library(ggplot2)
library(ggrepel)

# Read processed complex-enrichment results
df_raw <- read_excel(
  "volcano plot.xlsx",
  skip = 1
)

# Clean columns and define significance
df <- df_raw %>%
  rename(
    log_p_value = `log p-value`
  ) %>%
  select(
    Complex_Name,
    Excess,
    log_p_value
  ) %>%
  filter(
    !is.na(Excess),
    !is.na(log_p_value)
  ) %>%
  mutate(
    Significance = ifelse(
      abs(Excess) >= 2 & log_p_value >= 1.1,
      "Significant",
      "Not Significant"
    ),
    Label = ifelse(
      Significance == "Significant",
      Complex_Name,
      ""
    )
  )

# Generate volcano plot
plot_5c <- ggplot(
  df,
  aes(
    x = Excess,
    y = log_p_value
  )
) +
  geom_point(
    aes(color = Significance),
    size = 2
  ) +

  # Threshold lines
  geom_vline(
    xintercept = c(-1, 1),
    linetype = "dashed",
    color = "grey50"
  ) +
  geom_hline(
    yintercept = 1.3,
    linetype = "dashed",
    color = "grey50"
  ) +

  # Labels for significant complexes
  geom_text_repel(
    data = subset(df, Significance == "Significant"),
    aes(label = Label),
    size = 3,
    max.overlaps = 50,
    box.padding = 0.2,
    point.padding = 0.1,
    segment.size = 0.2
  ) +

  scale_color_manual(
    values = c(
      "Significant" = "#4c4582",
      "Not Significant" = "#9497ad"
    )
  ) +

  labs(
    x = "Excess",
    y = "log10 P value",
    color = NULL
  ) +

  theme_minimal(base_size = 14) +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"),
    axis.text = element_text(color = "black"),
    axis.title = element_text(color = "black"),
    legend.position = "none"
  )

print(plot_5c)

# Export base plot before Adobe Illustrator editing
ggsave(
  "Figure5c_complex_enrichment_volcano.pdf",
  plot = plot_5c,
  width = 8,
  height = 6,
  units = "in"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
