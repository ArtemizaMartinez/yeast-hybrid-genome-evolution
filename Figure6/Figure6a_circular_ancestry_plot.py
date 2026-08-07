# Figure 6a: Circular ancestry map across recombinant backgrounds
#
# This script documents the Python workflow used to generate the circular
# ancestry plot for Figure 6a.
#
# Chromosome lengths were combined with ancestry-block annotation files
# for multiple segregants/backgrounds. Each background was plotted as a
# separate concentric track, with complementary ancestry states shown in
# different colors.
#
# Specific genomic regions of interest were highlighted on the circular
# map and used for interpretation in the final figure.
#
# The complete genomic coordinates are provided in the Source Data file
# associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to adjust
# colors, labels, typography, spacing, and final panel layout. These
# graphical edits did not alter the underlying genomic coordinates.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ---------------------------------------------------------------
# Load chromosome lengths
# ---------------------------------------------------------------

chr_data = pd.read_csv(
    "Chr_LN_Rcircos.txt",
    sep="\t"
)

# ---------------------------------------------------------------
# Load ancestry annotation files
# Each tuple contains:
# (track_name, annotation_dataframe, color)
# ---------------------------------------------------------------

annotations = [
    ("1A_ce", pd.read_csv("1A_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("1A_pa", pd.read_csv("1A_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("1B_ce", pd.read_csv("1B_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("1B_pa", pd.read_csv("1B_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("2C_ce", pd.read_csv("2C_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("2C_pa", pd.read_csv("2C_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("2D_ce", pd.read_csv("2D_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("2D_pa", pd.read_csv("2D_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("3A_ce", pd.read_csv("3A_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("3A_pa", pd.read_csv("3A_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("3D_ce", pd.read_csv("3D_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("3D_pa", pd.read_csv("3D_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("4A_ce", pd.read_csv("4A_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("4A_pa", pd.read_csv("4A_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("4B_ce", pd.read_csv("4B_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("4B_pa", pd.read_csv("4B_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("5A_ce", pd.read_csv("5A_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("5A_pa", pd.read_csv("5A_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),

    ("5B_ce", pd.read_csv("5B_ce_annotation_Rcircos.txt", sep="\t"), "#316485"),
    ("5B_pa", pd.read_csv("5B_pa_annotation_Rcircos.txt", sep="\t"), "#b56c6c"),
]

# ---------------------------------------------------------------
# Clean formatting
# ---------------------------------------------------------------

chr_data.columns = chr_data.columns.str.strip()
chr_data["Chromosome"] = chr_data["Chromosome"].astype(str).str.strip()

for name, ann_data, _ in annotations:
    ann_data.columns = ann_data.columns.str.strip()
    ann_data["Chromosome"] = ann_data["Chromosome"].astype(str).str.strip()

# ---------------------------------------------------------------
# Compute cumulative chromosome positions
# ---------------------------------------------------------------

chr_data["cumulative_start"] = chr_data["chromEnd"].cumsum() - chr_data["chromEnd"]
total_length = chr_data["chromEnd"].sum()

# ---------------------------------------------------------------
# Initialize circular plot
# ---------------------------------------------------------------

fig, ax = plt.subplots(
    figsize=(10, 10),
    subplot_kw=dict(polar=True)
)

ax.set_axis_off()

# ---------------------------------------------------------------
# Plot chromosome labels
# ---------------------------------------------------------------

for _, row in chr_data.iterrows():
    start_angle = np.deg2rad((row["cumulative_start"] / total_length) * 360)
    end_angle = np.deg2rad(((row["cumulative_start"] + row["chromEnd"]) / total_length) * 360)

    label_angle = (start_angle + end_angle) / 2

    ax.text(
        label_angle,
        1.55,
        row["Chromosome"],
        horizontalalignment="center",
        verticalalignment="center",
        fontsize=10,
        rotation=np.degrees(label_angle) - 90,
        rotation_mode="anchor"
    )

# ---------------------------------------------------------------
# Plot ancestry annotations as concentric tracks
# ---------------------------------------------------------------

bar_height = 0.04
layer_map = {}

for name, ann_data, color in annotations:
    category = name.split("_")[0]  # e.g. 1A, 1B, 2C

    # Keep ce and pa from the same background at the same radial level
    if category not in layer_map:
        layer_map[category] = 1.2 - (len(layer_map) * 0.05)

    bottom = layer_map[category]

    for _, row in ann_data.iterrows():
        if row["Chromosome"] not in chr_data["Chromosome"].values:
            print(f"Skipping unknown chromosome: {row['Chromosome']} in {name}")
            continue

        chr_start = chr_data.loc[
            chr_data["Chromosome"] == row["Chromosome"],
            "cumulative_start"
        ].values[0]

        start_pos = chr_start + row["chromStart"]
        end_pos = chr_start + row["chromEnd"]

        start_angle = np.deg2rad((start_pos / total_length) * 360)
        end_angle = np.deg2rad((end_pos / total_length) * 360)

        ax.bar(
            (start_angle + end_angle) / 2,
            bar_height,
            width=(end_angle - start_angle),
            bottom=bottom,
            color=color,
            edgecolor="black",
            linewidth=0.5,
            alpha=0.5
        )

# ---------------------------------------------------------------
# Highlight region of interest 1 on chr12
# ---------------------------------------------------------------

gene_chr = "chr12"
gene_start = 88623
gene_end = 91349

if gene_chr in chr_data["Chromosome"].values:
    chr_row = chr_data[chr_data["Chromosome"] == gene_chr].iloc[0]

    start_cumulative_position = chr_row["cumulative_start"] + gene_start
    end_cumulative_position = chr_row["cumulative_start"] + gene_end

    start_angle = np.deg2rad((start_cumulative_position / total_length) * 360)
    end_angle = np.deg2rad((end_cumulative_position / total_length) * 360)

    ax.plot([start_angle, start_angle], [0, 1.5], color="red", linestyle="-", linewidth=2)
    ax.plot([end_angle, end_angle], [0, 1.5], color="red", linestyle="-", linewidth=2)
    ax.fill_betweenx([0, 1.5], start_angle, end_angle, color="red", alpha=0.3)
else:
    print(f"Warning: Chromosome {gene_chr} not found in chr_data")


# ---------------------------------------------------------------
# Save figure
# ---------------------------------------------------------------

fig.savefig(
    "Figure6a_circular_ancestry_plot.pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script was developed by Artemiza A. Martinez with assistance from
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
