# Supplementary Figure 4b:
# Mutation counts in hybrid and uniparental protein complexes
#
# This script documents the Python workflow used to generate the base
# heatmaps for Supplementary Figure 4b.
#
# Two processed matrices were used:
#   - mutation counts in hybrid complexes
#   - mutation counts in uniparental complexes
#
# Rows correspond to protein complexes and columns to evolved populations
# or genetic backgrounds. Mutation counts were displayed using the same
# discrete color scale in both heatmaps.
#
# The complete underlying values are provided in the Source Data and
# Supplementary Information associated with the article.
#
# The exported plots were subsequently edited in Adobe Illustrator to
# adjust labels, typography, spacing, and final panel layout.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors as mcolors

# ---------------------------------------------------------------
# Input matrices
# ---------------------------------------------------------------

hybrid = pd.read_csv(
    "hybrid_counts_matrix_ALL_complexes2.csv",
    index_col=0
)

uniparental = pd.read_csv(
    "nonhybrid_counts_matrix_ALL_complexes2.csv",
    index_col=0
)

# Ensure numeric matrices
hybrid = (
    hybrid
    .apply(pd.to_numeric, errors="coerce")
    .fillna(0)
    .astype(int)
)

uniparental = (
    uniparental
    .apply(pd.to_numeric, errors="coerce")
    .fillna(0)
    .astype(int)
)

# ---------------------------------------------------------------
# Align matrices
# ---------------------------------------------------------------

common_rows = hybrid.index.union(uniparental.index)
common_cols = hybrid.columns.union(uniparental.columns)

hybrid = hybrid.reindex(
    index=common_rows,
    columns=common_cols,
    fill_value=0
)

uniparental = uniparental.reindex(
    index=common_rows,
    columns=common_cols,
    fill_value=0
)

# ---------------------------------------------------------------
# Shared discrete mutation-count scale
#
# Bins:
# 0
# 1–2
# 3
# 4
# 5
# >=6
# ---------------------------------------------------------------

colors = [
    "#f8f6f9",
    "#c6b2c5",
    "#8d718e",
    "#4e4283",
    "#2c205f",
    "#000000"
]

cmap = mcolors.ListedColormap(colors)

global_max = int(
    max(
        hybrid.values.max(),
        uniparental.values.max()
    )
)

bounds = [
    -0.5,
    0.5,
    2.5,
    3.5,
    4.5,
    5.5,
    max(6, global_max) + 0.5
]

norm = mcolors.BoundaryNorm(
    bounds,
    cmap.N,
    clip=True
)

tick_locs = [
    (bounds[i] + bounds[i + 1]) / 2
    for i in range(len(bounds) - 1)
]

tick_labels = [
    "0",
    "1–2",
    "3",
    "4",
    "5",
    "≥6"
]

# ---------------------------------------------------------------
# Plotting function
# ---------------------------------------------------------------

def plot_heatmap(matrix, title, output_file):

    fig, ax = plt.subplots(figsize=(10, 8))

    image = ax.imshow(
        matrix.values,
        aspect="auto",
        interpolation="nearest",
        cmap=cmap,
        norm=norm
    )

    ax.set_title(title)
    ax.set_xlabel("Sample")
    ax.set_ylabel("Protein complex")

    ax.set_xticks(
        np.arange(matrix.shape[1])
    )

    ax.set_xticklabels(
        matrix.columns,
        rotation=90,
        fontsize=6
    )

    # Downsample row labels when many complexes are present
    max_rows_to_label = 60

    if matrix.shape[0] <= max_rows_to_label:
        row_indices = np.arange(matrix.shape[0])
    else:
        step = max(
            1,
            matrix.shape[0] // max_rows_to_label
        )
        row_indices = np.arange(
            0,
            matrix.shape[0],
            step
        )

    ax.set_yticks(row_indices)

    ax.set_yticklabels(
        [matrix.index[i] for i in row_indices],
        fontsize=5
    )

    colorbar = fig.colorbar(
        image,
        ax=ax
    )

    colorbar.set_label(
        "Mutation count"
    )

    colorbar.set_ticks(
        tick_locs
    )

    colorbar.set_ticklabels(
        tick_labels
    )

    plt.tight_layout()

    plt.savefig(
        output_file,
        format="pdf",
        bbox_inches="tight"
    )

    plt.close()

# ---------------------------------------------------------------
# Generate the two heatmaps
# ---------------------------------------------------------------

plot_heatmap(
    hybrid,
    "Mutation counts in hybrid complexes",
    "FigureS4b_hybrid_complex_mutations.pdf"
)

plot_heatmap(
    uniparental,
    "Mutation counts in uniparental complexes",
    "FigureS4b_uniparental_complex_mutations.pdf"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
