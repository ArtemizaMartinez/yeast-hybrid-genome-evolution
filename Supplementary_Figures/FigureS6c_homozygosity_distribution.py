# Supplementary Figure 6c:
# Distribution of mutation homozygosity across evolved populations
#
# This script documents the Python workflow used to generate the
# homozygosity-distribution plot shown in Supplementary Figure 6c.
#
# For each evolved population, the level of homozygosity was calculated as:
#
#   1 - Level of Hete_allMutations
#
# The distributions for the two sequencing datasets were plotted using
# 60 shared histogram bins.
#
# The complete underlying values are provided in the associated processed
# data files.
#
# Final graphical formatting and panel assembly were performed in
# Adobe Illustrator.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator

# ---------------------------------------------------------------
# Load population-level summary table
# ---------------------------------------------------------------

summary_data = pd.read_csv(
    "summaryMutations_types.txt",
    sep="\t"
)

# ---------------------------------------------------------------
# Calculate homozygosity level
# ---------------------------------------------------------------

summary_data["Level of Homozygosity"] = (
    1 - summary_data["Level of Hete_allMutations"]
)

# Keep plotting variables
plot_data = summary_data[
    [
        "ID",
        "Level of Homozygosity",
        "Generation"
    ]
].dropna()

# ---------------------------------------------------------------
# Shared histogram bins
# ---------------------------------------------------------------

min_homozygosity = plot_data["Level of Homozygosity"].min()
max_homozygosity = plot_data["Level of Homozygosity"].max()

# 61 edges = 60 bins
bin_edges = np.linspace(
    min_homozygosity,
    max_homozygosity,
    61
)

# ---------------------------------------------------------------
# Plot distributions
# ---------------------------------------------------------------

plt.figure(
    figsize=(7, 5)
)

for generation in plot_data["Generation"].unique():

    subset = plot_data[
        plot_data["Generation"] == generation
    ]

    plt.hist(
        subset["Level of Homozygosity"],
        bins=bin_edges,
        alpha=0.5,
        label=f"Generation {generation}"
    )

# Reference cutoff used in the exploratory classification
plt.axvline(
    0.80,
    color="red",
    linestyle="--",
    linewidth=1,
    label="Homozygosity cutoff"
)

# ---------------------------------------------------------------
# Formatting
# ---------------------------------------------------------------

plt.xlabel("Level of homozygosity")
plt.ylabel("Frequency")

plt.legend(
    title="Dataset"
)

plt.gca().yaxis.set_major_locator(
    MaxNLocator(integer=True)
)

plt.tight_layout()

# ---------------------------------------------------------------
# Export base plot
# ---------------------------------------------------------------

plt.savefig(
    "FigureS6c_homozygosity_distribution.pdf",
    format="pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script was reconstructed from the original plotting workflow by
# Artemiza A. Martinez with assistance from ChatGPT (OpenAI) for code
# organization and documentation.
#
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
