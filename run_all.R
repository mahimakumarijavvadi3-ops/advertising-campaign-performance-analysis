
# Advertising Campaign Performance Analysis
# Main execution script

# Set the working directory to the GitHub repository root
if (nzchar(Sys.getenv("GITHUB_WORKSPACE"))) {
  setwd(Sys.getenv("GITHUB_WORKSPACE"))
}

# Create required output directories
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/plots", recursive = TRUE, showWarnings = FALSE)

# Run the analysis scripts in sequence
source("01_validate_and_clean.R")
source("02_eda.R")
source("03_predictive_model.R")
source("04_key_insights.R")
source("05_statistical_tests.R")

message("Complete analysis finished successfully.")
