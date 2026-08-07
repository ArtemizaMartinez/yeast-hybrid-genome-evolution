# Supplementary Figure 3b-d:
# Growth curves and Gompertz growth-rate estimation
#
# This script reconstructs the analysis workflow used for Supplementary
# Figure 3b-d from the processed growth-curve table.
#
# Growth was measured as OD600 across multiple time points. For each strain
# and time point, the processed input table contains the mean OD600 and the
# standard deviation among replicate measurements.
#
# Growth curves were fitted using a Gompertz model with
# scipy.optimize.curve_fit. Fitted growth parameters were subsequently used
# for downstream comparisons with competitive fitness.
#
#
# Final graphical assembly and formatting were performed in Adobe Illustrator.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from scipy.optimize import curve_fit

# ---------------------------------------------------------------
# Load processed growth-curve data
# ---------------------------------------------------------------

data = pd.read_excel("GrowthCurve30.xlsx")  ## and GrowthCurve37 and GrowthCurve16

# Expected columns used here:
# Fsample : strain/sample identifier
# Time    : growth time in hours
# OD      : mean OD600 across replicate measurements
# STD     : standard deviation among replicate measurements

data = data[["Fsample", "Time", "OD", "STD"]].copy()

# Remove incomplete rows
data = data.dropna(
    subset=["Fsample", "Time", "OD"]
)

# Sort by sample and time
data = data.sort_values(
    ["Fsample", "Time"]
)

# ---------------------------------------------------------------
# Gompertz model
# ---------------------------------------------------------------

# Standard four-parameter Gompertz function:
#
# y(t) = bottom + amplitude * exp[-exp(-rate * (t - midpoint))]
#
# Parameters:
# bottom    = initial/background OD
# amplitude = total increase in OD
# rate      = Gompertz rate parameter
# midpoint  = time around the inflection point

def gompertz(t, bottom, amplitude, rate, midpoint):
    return bottom + amplitude * np.exp(
        -np.exp(
            -rate * (t - midpoint)
        )
    )

# ---------------------------------------------------------------
# Fit each strain independently
# ---------------------------------------------------------------

fit_results = []

for sample, sample_data in data.groupby("Fsample"):

    sample_data = sample_data.sort_values("Time")

    x = sample_data["Time"].to_numpy(dtype=float)
    y = sample_data["OD"].to_numpy(dtype=float)

    # Starting values for curve fitting
    bottom_guess = max(0, np.min(y))
    amplitude_guess = max(y) - min(y)
    rate_guess = 0.3

    # Approximate midpoint using the time point closest to half-maximal OD
    half_value = min(y) + amplitude_guess / 2
    midpoint_guess = x[np.argmin(np.abs(y - half_value))]

    initial_guess = [
        bottom_guess,
        amplitude_guess,
        rate_guess,
        midpoint_guess
    ]

    try:

        popt, pcov = curve_fit(
            gompertz,
            x,
            y,
            p0=initial_guess,
            maxfev=10000
        )

        bottom, amplitude, rate, midpoint = popt

        # Maximum slope of this Gompertz parameterization
        # occurs at the inflection point:
        max_growth_rate = amplitude * rate / np.e

        fit_results.append({
            "Fsample": sample,
            "bottom": bottom,
            "amplitude": amplitude,
            "gompertz_rate": rate,
            "midpoint_h": midpoint,
            "max_growth_rate": max_growth_rate
        })

    except RuntimeError:

        print(f"Gompertz fit failed for {sample}")

        fit_results.append({
            "Fsample": sample,
            "bottom": np.nan,
            "amplitude": np.nan,
            "gompertz_rate": np.nan,
            "midpoint_h": np.nan,
            "max_growth_rate": np.nan
        })

# Convert fitted parameters to dataframe
fit_results = pd.DataFrame(fit_results)

# Save fitted growth parameters
fit_results.to_csv(
    "FigureS3_Gompertz_growth_parameters.csv",
    index=False
)

print(fit_results)

# ---------------------------------------------------------------
# Plot growth curves
# ---------------------------------------------------------------

fig, ax = plt.subplots(
    figsize=(8, 6)
)

for sample, sample_data in data.groupby("Fsample"):

    sample_data = sample_data.sort_values("Time")

    x = sample_data["Time"].to_numpy(dtype=float)
    y = sample_data["OD"].to_numpy(dtype=float)
    sd = sample_data["STD"].to_numpy(dtype=float)

    # Plot mean OD600 measurements
    ax.plot(
        x,
        y,
        marker="o",
        markersize=2,
        linewidth=1,
        label=sample
    )

    # Variation among replicate measurements
    ax.fill_between(
        x,
        y - sd,
        y + sd,
        alpha=0.10
    )

    # Add fitted Gompertz curve
    sample_fit = fit_results[
        fit_results["Fsample"] == sample
    ]

    if not sample_fit["gompertz_rate"].isna().all():

        bottom = sample_fit["bottom"].iloc[0]
        amplitude = sample_fit["amplitude"].iloc[0]
        rate = sample_fit["gompertz_rate"].iloc[0]
        midpoint = sample_fit["midpoint_h"].iloc[0]

        x_fit = np.linspace(
            x.min(),
            x.max(),
            200
        )

        y_fit = gompertz(
            x_fit,
            bottom,
            amplitude,
            rate,
            midpoint
        )

        ax.plot(
            x_fit,
            y_fit,
            linewidth=0.8,
            alpha=0.7
        )

# ---------------------------------------------------------------
# Formatting
# ---------------------------------------------------------------

ax.set_xlabel("Growth time (hours)")
ax.set_ylabel("OD600")

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

# With many strains the legend can be removed and added later in Illustrator
ax.legend(
    fontsize=6,
    bbox_to_anchor=(1.02, 1),
    loc="upper left",
    frameon=False
)

plt.tight_layout()

# Export base plot
plt.savefig(
    "FigureS3_growth_curves_Gompertz.pdf",
    format="pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script reconstructs the analysis workflow from the processed data
# and documented analysis method. It was prepared by Artemiza A. Martinez
# with assistance from ChatGPT (OpenAI) for
# organization, and documentation.
#
# The authors are responsible for the scientific decisions, interpretation,
# and final figure.
