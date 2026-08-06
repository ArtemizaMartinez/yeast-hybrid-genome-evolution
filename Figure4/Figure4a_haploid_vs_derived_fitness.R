# Figure 4a: Fitness of haploid segregants and their
# corresponding diploid or higher-ploidy derivatives
#
# This script documents the R workflow used to generate Figure 4a.
#
# The complete numerical values, regression estimates, standard errors,
# and exclusion information are provided in the Source Data file
# associated with the article.
#
# Backgrounds 2B, 2D, and 5D were excluded because no valid fitness
# measurement was available for the derived founder used in this panel.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, spacing, and final panel layout.
# These graphical edits did not alter the underlying numerical values.

library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(ggrepel)
library(scales)



dat <- read_tsv(
  "Data_plotting_G0_haploids_diploids.txt",
  show_col_types = FALSE
) %>%
  rename(
    Ploidy = Mating,
    s = selection_coefficient_g,
    CI = CI_g
  ) %>%
  mutate(
    Ploidy = str_to_title(Ploidy)
  )

# Convert the haploid and derived-founder measurements to paired columns
wide <- dat %>%
  select(Competition, plot, Ploidy, s, CI) %>%
  distinct() %>%
  pivot_wider(
    names_from = Ploidy,
    values_from = c(s, CI)
  ) %>%

  # Exclude backgrounds without valid derived-founder fitness data
  filter(!plot %in% c("2B", "2D", "5D")) %>%

  mutate(
    # The S. cerevisiae reference is defined as fitness = 0
    s_Haploid = if_else(
      Competition == "yGIL2099",
      0,
      s_Haploid
    ),
    s_Diploid = if_else(
      Competition == "yGIL2099",
      0,
      s_Diploid
    ),

    delta_s = s_Diploid - s_Haploid,
    abs_delta = abs(delta_s),
    big_change = abs_delta > 0.05,
    is_control = Competition == "yGIL2099",

    # Convert selection coefficients and confidence intervals to percentages
    x = 100 * s_Haploid,
    y = 100 * s_Diploid,
    x_min = 100 * (s_Haploid - CI_Haploid),
    x_max = 100 * (s_Haploid + CI_Haploid),
    y_min = 100 * (s_Diploid - CI_Diploid),
    y_max = 100 * (s_Diploid + CI_Diploid)
  ) %>%
  filter(
    !is.na(x),
    !is.na(y)
  )

# Symmetrical axis limits that include all confidence intervals
lim_raw <- max(
  abs(c(
    wide$x_min,
    wide$x_max,
    wide$y_min,
    wide$y_max
  )),
  na.rm = TRUE
)

lim <- ceiling(lim_raw / 5) * 5

# Error-bar cap sizes
cap_w <- 0.015 * (2 * lim)
cap_h <- cap_w / 2

# Plot colors
col_err <- "#6B6B6B"
col_base <- "#6FA8DC"
col_big <- "#DAA520"
col_ctrl <- "#000000"

# Generate plot
plot_4a <- ggplot(
  wide,
  aes(x = x, y = y)
) +

  # Line showing equal haploid and derived-founder fitness
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    linewidth = 0.5
  ) +

  geom_hline(
    yintercept = 0,
    color = "black",
    linewidth = 0.4
  ) +

  geom_vline(
    xintercept = 0,
    color = "black",
    linewidth = 0.4
  ) +

  # Vertical confidence intervals
  geom_errorbar(
    aes(
      ymin = y_min,
      ymax = y_max
    ),
    width = cap_w,
    linewidth = 0.35,
    color = col_err,
    alpha = 0.9,
    na.rm = TRUE
  ) +

  # Horizontal confidence intervals
  geom_segment(
    aes(
      x = x_min,
      xend = x_max,
      y = y,
      yend = y
    ),
    linewidth = 0.35,
    color = col_err,
    alpha = 0.9,
    na.rm = TRUE
  ) +

  geom_segment(
    aes(
      x = x_min,
      xend = x_min,
      y = y - cap_h,
      yend = y + cap_h
    ),
    linewidth = 0.35,
    color = col_err,
    alpha = 0.9,
    na.rm = TRUE
  ) +

  geom_segment(
    aes(
      x = x_max,
      xend = x_max,
      y = y - cap_h,
      yend = y + cap_h
    ),
    linewidth = 0.35,
    color = col_err,
    alpha = 0.9,
    na.rm = TRUE
  ) +

  # S. cerevisiae control
  geom_point(
    data = subset(wide, is_control),
    shape = 24,
    fill = col_ctrl,
    size = 3.2,
    color = "black",
    stroke = 0.25
  ) +

  # Backgrounds with an absolute fitness shift ≤ 0.05
  geom_point(
    data = subset(wide, !is_control & !big_change),
    shape = 21,
    fill = col_base,
    size = 2.8,
    color = "black",
    stroke = 0.25
  ) +

  # Backgrounds with an absolute fitness shift > 0.05
  geom_point(
    data = subset(wide, !is_control & big_change),
    shape = 21,
    fill = col_big,
    size = 3,
    color = "black",
    stroke = 0.25
  ) +

  # Labels for highlighted backgrounds
  geom_text_repel(
    data = subset(wide, big_change),
    aes(label = plot),
    box.padding = 0.25,
    point.padding = 0.25,
    size = 3,
    min.segment.length = 0
  ) +

  coord_equal(
    xlim = c(-lim, lim),
    ylim = c(-lim, lim),
    expand = FALSE
  ) +

  scale_x_continuous(
    labels = label_number(accuracy = 1)
  ) +

  scale_y_continuous(
    labels = label_number(accuracy = 1)
  ) +

  labs(
    x = "Fitness effect of haploids (%)",
    y = "Fitness effect of diploid or higher-ploidy derivatives (%)"
  ) +

  theme_classic(base_size = 11) +

  theme(
    axis.line = element_line(linewidth = 0.6)
  )

print(plot_4a)

# Export the base plot before Adobe Illustrator editing
ggsave(
  "Figure4a_haploid_vs_derived_fitness.pdf",
  plot = plot_4a,
  width = 4,
  height = 4,
  device = cairo_pdf
)

# Pearson correlation
correlation_test <- cor.test(
  wide$s_Haploid,
  wide$s_Diploid,
  method = "pearson"
)

r_value <- unname(correlation_test$estimate)
p_value <- correlation_test$p.value
n_pairs <- nrow(wide)

# 95% confidence interval for Pearson's r using Fisher's z transformation
fisher_r_ci <- function(r, n, conf.level = 0.95) {
  if (is.na(r) || n < 4) {
    return(c(NA_real_, NA_real_))
  }

  z <- atanh(r)
  se <- 1 / sqrt(n - 3)
  z_critical <- qnorm(1 - (1 - conf.level) / 2)

  c(
    tanh(z - z_critical * se),
    tanh(z + z_critical * se)
  )
}

r_ci <- fisher_r_ci(
  r_value,
  n_pairs
)

cat(
  sprintf(
    paste0(
      "Pearson r = %.4f, ",
      "95%% CI [%.2f, %.2f], ",
      "two-sided P = %.4g, ",
      "n = %d paired backgrounds\n"
    ),
    r_value,
    r_ci[1],
    r_ci[2],
    p_value,
    n_pairs
  )
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for  organization and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
