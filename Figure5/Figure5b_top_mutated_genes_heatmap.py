# Figure 5b: Recurrently mutated genes across hybrid backgrounds
#
# This script documents the Python workflow used to generate the base plot
# for Figure 5b.
#
# The plot summarizes mutation counts for the most frequently mutated genes
# across hybrid backgrounds. A heatmap displays per-background mutation
# counts, and a side bar plot shows the total mutation counts for each gene
# separated by parental species.
#
# The complete numerical values are provided in the Source Data file
# associated with the article.
#
# The exported figure was subsequently edited in Adobe Illustrator to adjust
# colors, labels, typography, spacing, and final panel layout. These
# graphical edits did not alter the underlying numerical values.

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
from mpl_toolkits.axes_grid1 import make_axes_locatable
import matplotlib.ticker as ticker

# Load processed mutation table
data = pd.read_csv("ListNonSynMutationsHybrids.csv")

# Clean column names
data.columns = data.columns.str.strip()

# Count total number of mutations per gene
total_mutations_per_gene = data["Gene Name"].value_counts()

# Select the most frequently mutated genes
top_genes = total_mutations_per_gene.head(60).index

# Retain only those genes
filtered_data = data[data["Gene Name"].isin(top_genes)]

# Build heatmap matrix: genes x backgrounds
pivot_table = filtered_data.pivot_table(
    index="Gene Name",
    columns="Background",
    aggfunc="size",
    fill_value=0
)

# Sort genes by total mutation count
pivot_table["Total Mutations"] = pivot_table.sum(axis=1)
pivot_table.sort_values("Total Mutations", ascending=False, inplace=True)
sorted_genes = pivot_table.index

# Remove total column before plotting
pivot_table.drop(columns="Total Mutations", inplace=True)

# Export processed matrix
output_file_path = "Figure5b_top_mutated_genes_matrix.csv"
pivot_table.to_csv(output_file_path)

print(f"Mutation count matrix saved to: {output_file_path}")

# Custom color map for mutation counts
colors = ["#f8f6f9", "#c6b2c5", "#8d718e", "#4e4283", "#000000"]
cmap = mcolors.ListedColormap(colors)

# Boundaries for color bins
bounds = [0, 1, 3, 4, 5, 6]
norm = mcolors.BoundaryNorm(bounds, cmap.N)

# Create figure
fig, ax = plt.subplots(figsize=(6, 8), sharey=True)

# Heatmap
heatmap_ax = sns.heatmap(
    pivot_table,
    annot=False,
    cmap=cmap,
    norm=norm,
    linewidths=0.1,
    linecolor="lightgray",
    ax=ax
)

# Labels
heatmap_ax.set_xlabel("Background")
heatmap_ax.set_ylabel("Gene name")

# Italicize gene names
heatmap_ax.set_yticks(ticks=range(len(sorted_genes)))
heatmap_ax.set_yticklabels(
    [f"$\\it{{{gene}}}$" for gene in sorted_genes],
    fontsize=6,
    rotation=0
)
heatmap_ax.set_xticklabels(
    heatmap_ax.get_xticklabels(),
    fontsize=6
)

# Add side axis for species counts
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="20%", pad=0.1)

# Mutation counts by species
species_counts = (
    filtered_data
    .groupby(["Gene Name", "Species"])
    .size()
    .unstack(fill_value=0)
    .reindex(sorted_genes)
)

# Ensure both parental species columns exist
species_counts["paradoxus"] = species_counts.get(
    "paradoxus",
    pd.Series(0, index=species_counts.index)
)
species_counts["cerevisiae"] = species_counts.get(
    "cerevisiae",
    pd.Series(0, index=species_counts.index)
)

# Species colors
species_colors = ["#b56c6c", "#316485"]

# Side stacked bars
cax.barh(
    species_counts.index,
    species_counts["paradoxus"],
    color=species_colors[0],
    label="S. paradoxus"
)
cax.barh(
    species_counts.index,
    species_counts["cerevisiae"],
    left=species_counts["paradoxus"],
    color=species_colors[1],
    label="S. cerevisiae"
)

cax.set_xlabel("Total mutations")
cax.set_yticklabels([])
cax.invert_yaxis()
cax.legend(frameon=False, fontsize=7)

# Show integer ticks only
cax.xaxis.set_major_locator(ticker.MaxNLocator(integer=True))
cax.tick_params(axis="x", labelsize=5)

# Save figure
plt.tight_layout()
plt.savefig(
    "Figure5b_top_mutated_genes_heatmap.pdf",
    format="pdf",
    bbox_inches="tight"
)
plt.show()

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
