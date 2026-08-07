# Figure 5b: Underdispersion statistics for prioritized genes
#
# This script documents the Python workflow used to generate the
# underdispersion component of Figure 5b.
#
# Genes are displayed in the same predefined order used for the other
# Figure 5b panels. Points with underdispersion values < 2 are shown in
# gray, whereas values >= 2 are highlighted in black.
#
# The complete numerical values are provided in the Source Data file
# associated with the article.
#

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Load processed mutation-summary table
df = pd.read_excel("MutationsPosteriorProbPLOT.xlsx")

# Clean column names
df.columns = df.columns.str.replace(" ", "_").str.strip()

# Convert relevant columns to numeric
df["order"] = pd.to_numeric(df["order"], errors="coerce")
df["Underdispersed"] = pd.to_numeric(
    df["Underdispersed"],
    errors="coerce"
)

# Sort genes using the same predefined order as the other Figure 5b panels
df_sorted = df.sort_values(
    by="order"
).reset_index(drop=True)

# X-axis positions
indices = np.arange(len(df_sorted))

# Point colors:
# gray  = underdispersion < 2
# black = underdispersion >= 2
point_colors = np.where(
    df_sorted["Underdispersed"] >= 2,
    "black",
    "gray"
)

# Create figure
fig, ax = plt.subplots(figsize=(10, 4))

# Plot underdispersion values
ax.scatter(
    indices,
    df_sorted["Underdispersed"],
    c=point_colors,
    s=28,
    edgecolors="none"
)

# Reference threshold
ax.axhline(
    y=2,
    color="gray",
    linestyle="dashed",
    linewidth=0.8
)

# Gene labels
ax.set_xticks(indices)
ax.set_xticklabels(
    df_sorted["Gene_Name"],
    rotation=90,
    fontsize=7
)

# Axis labels
ax.set_xlabel("Gene")
ax.set_ylabel("Underdispersion")

# Clean plotting style
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

plt.tight_layout()

# Export base plot before Adobe Illustrator editing
plt.savefig(
    "Figure5b_underdispersion_points.pdf",
    format="pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
