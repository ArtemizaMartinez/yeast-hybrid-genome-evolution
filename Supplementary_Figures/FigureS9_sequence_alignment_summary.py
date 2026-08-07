# Supplementary Figure 9:
# Pairwise sequence-alignment summary
#
# This script calculates pairwise alignment statistics from an aligned
# FASTA file containing two sequences and exports residue-level alignment
# information for downstream visualization.
#
# For each aligned position, residues were classified as:
#   Match
#   Mismatch
#   Gap
#
# The script also reports sequence lengths, alignment length, number of
# matches, mismatches and indels, and overall percent identity.
#
# The resulting residue-level table was used as input for subsequent
# plotting of sequence divergence in Supplementary Figure 9.

from Bio import SeqIO
import pandas as pd


# ---------------------------------------------------------------
# Pairwise alignment statistics
# ---------------------------------------------------------------

def calculate_alignment_stats(seq1, seq2):

    match_count = sum(
        1 for a, b in zip(seq1, seq2)
        if a == b and a != "-"
    )

    mismatch_count = sum(
        1 for a, b in zip(seq1, seq2)
        if a != b and a != "-" and b != "-"
    )

    indel_count = sum(
        1 for a, b in zip(seq1, seq2)
        if a == "-" or b == "-"
    )

    alignment_length = len(seq1)

    percent_identity = (
        match_count / alignment_length * 100
        if alignment_length > 0
        else 0
    )

    size_seq1 = sum(
        1 for a in seq1 if a != "-"
    )

    size_seq2 = sum(
        1 for b in seq2 if b != "-"
    )

    return {
        "Percent Identity (%)": percent_identity,
        "Number of Matches": match_count,
        "Number of Mismatches": mismatch_count,
        "Number of Indels": indel_count,
        "Alignment Length": alignment_length,
        "Size of Sequence 1": size_seq1,
        "Size of Sequence 2": size_seq2
    }


# ---------------------------------------------------------------
# Load aligned FASTA file
# ---------------------------------------------------------------

fasta_file = "your_alignment_file.fas"

sequences = list(
    SeqIO.parse(
        fasta_file,
        "fasta"
    )
)

if len(sequences) != 2:
    raise ValueError(
        "The alignment file must contain exactly two sequences."
    )

seq1 = str(sequences[0].seq)
seq2 = str(sequences[1].seq)

seq1_name = sequences[0].id
seq2_name = sequences[1].id


if len(seq1) != len(seq2):
    raise ValueError(
        "Aligned sequences must have the same alignment length."
    )


# ---------------------------------------------------------------
# Calculate summary statistics
# ---------------------------------------------------------------

alignment_stats = calculate_alignment_stats(
    seq1,
    seq2
)


# ---------------------------------------------------------------
# Generate residue-level table
# ---------------------------------------------------------------

alignment_data = pd.DataFrame({

    "Position": range(
        1,
        len(seq1) + 1
    ),

    "Residue_Seq1": list(seq1),

    "Residue_Seq2": list(seq2),

    "Alignment_State": [
        (
            "Match"
            if a == b and a != "-"
            else
            "Mismatch"
            if a != b and a != "-" and b != "-"
            else
            "Gap"
        )
        for a, b in zip(seq1, seq2)
    ],

    "Comparison":
        f"{seq1_name} vs {seq2_name}"
})


# ---------------------------------------------------------------
# Export residue-level alignment information
# ---------------------------------------------------------------

alignment_data.to_csv(
    "alignment_plot_input.csv",
    index=False
)


# ---------------------------------------------------------------
# Print alignment summary
# ---------------------------------------------------------------

print("Alignment statistics")
print("--------------------")

print(
    f"Sequence 1: {seq1_name} "
    f"({alignment_stats['Size of Sequence 1']} residues)"
)

print(
    f"Sequence 2: {seq2_name} "
    f"({alignment_stats['Size of Sequence 2']} residues)"
)

print(
    f"Alignment length: "
    f"{alignment_stats['Alignment Length']}"
)

print(
    f"Matches: "
    f"{alignment_stats['Number of Matches']}"
)

print(
    f"Mismatches: "
    f"{alignment_stats['Number of Mismatches']}"
)

print(
    f"Indels: "
    f"{alignment_stats['Number of Indels']}"
)

print(
    f"Percent identity: "
    f"{alignment_stats['Percent Identity (%)']:.2f}%"
)

print(
    "\nResidue-level alignment data saved to "
    "alignment_plot_input.csv"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
