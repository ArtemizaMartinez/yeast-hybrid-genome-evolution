# Figure 5b: Mutation classes and posterior probabilities
#
# This script documents the Python workflow used to generate the
# mutation-class and posterior-probability component of Figure 5b.
#
# For each prioritized gene, stacked bars show the number of missense
# and nonsense/frameshift mutations. Posterior probabilities for the
# two selection models are overlaid on a secondary y-axis.
#
# The complete numerical values are provided in the Source Data file
# associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, spacing, and final panel layout.
# These graphical modifications did not alter the underlying values.

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Load processed mutation-summary table
df = pd.read_excel("MutationsPosteriorProbPLOT.xlsx")

# Clean column names
df.columns = df.columns.str.replace(" ", "_").str.strip()

# Convert plotting columns to numeric
df["H1_P"] = pd.to_numeric(df["H1_P"], errors="coerce")
df["H2_P"] = pd.to_numeric(df["H2_P"], errors="coerce")
df["NONSYN"] = pd.to_numeric(df["NONSYN"], errors="coerce")
df["MIS"] = pd.to_numeric(df["MIS"], errors="coerce")
df["N_FS"] = pd.to_numeric(df["N/FS"], errors="coerce")
df["order"] = pd.to_numeric(df["order"], errors="coerce")

# Order genes according to the predefined ranking
df_sorted = df.sort_values(
    by="order"
).reset_index(drop=True)

indices = np.arange(len(df_sorted))

# Mark genes meeting the H1_P threshold
gene_labels = [
    f"{gene}*" if h1 < 0.05 else gene
    for gene, h1 in zip(
        df_sorted["Gene_Name"],
        df_sorted["H1_P"]
    )
]

# Create figure
fig, ax1 = plt.subplots(
    figsize=(16, 7)
)

# Mutation counts by class
ax1.bar(
    indices,
    df_sorted["MIS"],
    color="#493f60",
    label="Missense"
)

ax1.bar(
    indices,
    df_sorted["N_FS"],
    bottom=df_sorted["MIS"],
    color="#1cbdc2",
    label="Nonsense/frameshift"
)

ax1.set_ylabel("Mutation count")
ax1.legend(loc="upper left")

# Posterior probabilities on secondary axis
ax2 = ax1.twinx()

ax2.plot(
    indices,
    df_sorted["H1_P"],
    color="#1cbdc2",
    label="H1 posterior probability"
)

ax2.plot(
    indices,
    df_sorted["H2_P"],
    color="#493f60",
    linestyle="dashed",
    label="H2 posterior probability"
)

ax2.set_ylabel("Posterior probability")
ax2.set_ylim(0, 1.0)
ax2.legend(loc="upper right")

# Gene labels
ax1.set_xticks(indices)
ax1.set_xticklabels(
    gene_labels,
    rotation=90,
    fontsize=7
)

ax1.set_xlabel("Genes ordered by prioritized ranking")

plt.tight_layout()
plt.subplots_adjust(bottom=0.2)

# Export base plot before Adobe Illustrator editing
plt.savefig(
    "Figure5b_mutation_classes_posterior_probabilities.pdf",
    format="pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
