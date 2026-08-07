# Supplementary Figure 2c:
# Relationship between chromosome size and uniparental inheritance
#
# This script documents the R workflow used to generate Supplementary
# Figure 2c.
#
# Each point represents one chromosome. The number of uniparental
# inheritance events observed across recombinant segregants was modeled
# as a function of chromosome size using a quasi-Poisson generalized
# linear model with a log link.
#
# The complete numerical values are provided in the Source Data and
# Supplementary Information associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, spacing, and final panel layout.

library(ggplot2)

# Load processed chromosome-level data
df <- read.table(
  "Uniparental.txt",
  header = TRUE,
  stringsAsFactors = FALSE
)

# Convert chromosome size from bp to Mb
df$SizeMb <- df$Size / 1e6

# Plot
plot_S2c <- ggplot(
  df,
  aes(
    x = SizeMb,
    y = Uniparental
  )
) +

  geom_point(
    shape = 21,
    fill = "#9497ac",
    color = "black",
    size = 3,
    stroke = 0.6
  ) +

  # Quasi-Poisson generalized linear fit
  geom_smooth(
    method = "glm",
    method.args = list(
      family = quasipoisson(link = "log")
    ),
    se = TRUE,
    linewidth = 0.9
  ) +

  labs(
    x = "Chromosome size (Mb)",
    y = "Uniparental (count)"
  ) +

  theme_bw() +

  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

print(plot_S2c)

# Export base plot before Adobe Illustrator editing
ggsave(
  "FigureS2c_uniparental_chromosome_size.pdf",
  plot = plot_S2c,
  width = 4,
  height = 3.5,
  units = "in",
  device = cairo_pdf
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
