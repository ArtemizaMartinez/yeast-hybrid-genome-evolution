# Figure 5a: Genes enriched for nonsynonymous mutations
#
# This script documents the R workflow used to generate the base plot
# for Figure 5a.
#
# The input table contains, for each gene, the number of observed
# nonsynonymous mutations and the multiple-testing-adjusted P value
# from the mutation-enrichment analysis.
#
# The complete numerical values and statistical results are provided
# in the Source Data file associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, and final panel layout.
# These graphical edits did not alter the underlying numerical values.

library(ggplot2)
library(ggrepel)
library(scales)

# Load processed mutation-enrichment results
data <- read.csv(
  "TargetsNonSYn_Hyb_Adj.txt",
  sep = "\t",
  header = TRUE
)

# Highlight genes passing the plotting thresholds
data$Highlight <- ifelse(
  data$P2_hybridsNonSyn_Adj_BH < 1e-3 &
    data$C2_hybridsNonSyn > 5,
  "Highlighted",
  "Normal"
)

# Generate enrichment plot
plot_5a <- ggplot(
  data,
  aes(
    x = C2_hybridsNonSyn,
    y = P2_hybridsNonSyn_Adj_BH
  )
) +

  geom_point(
    aes(fill = Highlight),
    shape = 21,
    color = "black",
    alpha = 0.9,
    size = 3
  ) +

  scale_y_log10(
    limits = c(1e-24, 1),
    expand = c(0, 0),
    labels = trans_format(
      "log10",
      math_format(10^.x)
    )
  ) +

  scale_x_continuous(
    limits = c(
      0,
      max(data$C2_hybridsNonSyn, na.rm = TRUE) + 1
    ),
    expand = c(0.001, 0),
    breaks = seq(
      0,
      max(data$C2_hybridsNonSyn, na.rm = TRUE),
      by = 5
    )
  ) +

  # Adjusted-P-value threshold
  geom_hline(
    yintercept = 1e-3,
    linewidth = 0.5,
    color = "black",
    linetype = "dashed"
  ) +

  scale_fill_manual(
    values = c(
      "Highlighted" = "darkslateblue",
      "Normal" = "gray"
    ),
    guide = "none"
  ) +

  labs(
    x = "Nonsynonymous mutations",
    y = "BH-adjusted P value"
  ) +

  theme_bw() +

  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Add gene labels to highlighted points
plot_5a <- plot_5a +
  geom_text_repel(
    data = subset(
      data,
      P2_hybridsNonSyn_Adj_BH < 1e-3 &
        C2_hybridsNonSyn > 5
    ),
    aes(label = GENE_name),
    size = 2.3,
    segment.size = 0.2,
    segment.color = "transparent",
    fontface = "italic",
    force = 0.5,
    hjust = 0.3
  )

# Fine-tune axis spacing
plot_5a <- plot_5a +
  theme(
    axis.ticks.length.x = unit(0.20, "cm"),
    axis.text.x = element_text(
      margin = margin(t = 0.2, unit = "cm")
    ),
    axis.ticks.length.y = unit(0.20, "cm"),
    axis.text.y = element_text(
      margin = margin(r = 0.3, unit = "cm")
    )
  )

print(plot_5a)

# Export base plot before Adobe Illustrator editing
ggsave(
  "Figure5a_mutation_enrichment.pdf",
  plot = plot_5a,
  units = "in",
  width = 6,
  height = 4,
  dpi = 300
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
