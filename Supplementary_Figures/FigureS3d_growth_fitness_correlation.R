# Supplementary Figure 3d:
# Relationship between growth rate and competitive fitness at 30 °C
#
# This script documents the R workflow used to generate the correlation
# plot shown in Supplementary Figure 3d.
#
# Growth-rate estimates were obtained from growth-curve analysis, and
# competitive-fitness measurements were obtained from competition assays.
#
# Pearson's correlation was calculated across parental strains and
# recombinant segregants.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust labels, typography, spacing, and final panel layout.

library(ggplot2)

# Load processed growth-rate and fitness estimates
data <- read.table(
  "Correlation_growthFitnessF1Hybrids.txt",
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE
)

# Identify parental controls
data$Group <- "Segregant"

data$Group[data$Samples == "F2099"] <- "S. cerevisiae"
data$Group[data$Samples == "F2279"] <- "S. paradoxus"

# ---------------------------------------------------------------
# Pearson correlation
# ---------------------------------------------------------------

cor_test <- cor.test(
  data$Growth_rate_30C,
  data$Fitness_30C,
  method = "pearson",
  use = "complete.obs"
)

r_value <- unname(cor_test$estimate)
p_value <- cor_test$p.value

# Text shown on the figure
stat_label <- sprintf(
  "r = %.3f, p = %.3f",
  r_value,
  p_value
)

print(cor_test)

# ---------------------------------------------------------------
# Plot
# ---------------------------------------------------------------

plot_S3d <- ggplot(
  data,
  aes(
    x = Growth_rate_30C,
    y = Fitness_30C
  )
) +
  
  # Linear regression with 95% confidence interval
  geom_smooth(
    method = "lm",
    formula = y ~ x,
    se = TRUE,
    level = 0.95,
    color = "black",
    fill = "gray80",
    linewidth = 0.7,
    alpha = 0.4
  ) +
  # Segregants
  geom_point(
    data = subset(data, Group == "Segregant"),
    shape = 21,
    fill = "gray55",
    color = "black",
    size = 3,
    stroke = 0.4
  ) +
  
  # S. cerevisiae parent
  geom_point(
    data = subset(data, Group == "S. cerevisiae"),
    shape = 21,
    fill = "#316484",
    color = "black",
    size = 3.5,
    stroke = 0.4
  ) +
  
  # S. paradoxus parent
  geom_point(
    data = subset(data, Group == "S. paradoxus"),
    shape = 21,
    fill = "#b46c6c",
    color = "black",
    size = 3.5,
    stroke = 0.4
  ) +
  
  # Correlation statistics
  annotate(
    "text",
    x = -Inf,
    y = Inf,
    label = stat_label,
    hjust = -0.1,
    vjust = 1.5,
    size = 3.5
  ) +
  
  labs(
    x = expression("Growth rate (h"^{-1}*") at 30 " * degree * "C"),
    y = "Relative fitness (%)"
  ) +
  
  theme_classic(base_size = 11) +
  
  theme(
    legend.position = "none"
  )

print(plot_S3d)

# ---------------------------------------------------------------
# Export base plot
# ---------------------------------------------------------------

ggsave(
  "FigureS3d_growth_fitness_correlation.pdf",
  plot = plot_S3d,
  width = 4,
  height = 3.5,
  units = "in"
)

# Code-development note:
# This script was reconstructed from the original plotting workflow by
# Artemiza A. Martinez with assistance from ChatGPT (OpenAI) for code
# organization and documentation.
#
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
