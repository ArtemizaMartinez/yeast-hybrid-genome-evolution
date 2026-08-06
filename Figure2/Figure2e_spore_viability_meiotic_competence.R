# Figure 2e: Spore viability and meiotic competence
# of segregant-derived diploids
#
# This script documents the R workflow used to generate the base plot
# for Figure 2e.
#
# The complete numerical values and sample sizes are provided in the
# Source Data file associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, typography, labels, spacing, category annotations,
# and final panel layout. These graphical edits did not alter the
# underlying numerical values.

# Load necessary libraries
library(ggplot2)
library(ggpattern)

# The plotting table contained the following columns:
#
# StrainID
# Measure
# Fraction
# ColorID
#
# Measure included:
# - Spore viability
# - Fully viable tetrads
#
# Fraction values were converted to percentages for plotting.

# Example structure:
#
 data <- data.frame(
   StrainID = ...,
   Measure = ...,
   Fraction = ...,
   ColorID = ...
 )

# Plot
plot_all <- ggplot(
  data,
  aes(
    x = StrainID,
    y = Fraction * 100,
    fill = ColorID,
    pattern = Measure
  )
) +
  geom_bar_pattern(
    stat = "identity",
    position = position_dodge(width = 0.9),
    width = 0.8,
    color = "black",
    pattern_fill = "black",
    pattern_angle = 45,
    pattern_density = 0.1,
    pattern_spacing = 0.02,
    pattern_key_scale_factor = 0.6
  ) +
  geom_text(
    aes(label = paste0(round(Fraction * 100, 1), "%")),
    position = position_dodge(width = 0.7),
    vjust = -0.5,
    size = 2.5,
    color = "black"
  ) +
  scale_fill_identity() +
  scale_pattern_manual(
    values = c(
      "Spore viability" = "none",
      "Fully viable tetrads" = "stripe"
    )
  ) +
  labs(
    x = "Segregant-derived diploid",
    y = "Percentage (%)",
    fill = NULL,
    pattern = "Measure"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      size = 8
    ),
    axis.title = element_text(
      size = 12,
      face = "bold"
    ),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

 ggsave(
   "Figure2e_spore_viability_meiotic_competence.pdf",
   plot = plot_all,
   width = 13,
   height = 3
 )

print(plot_all)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
