# run_all.R
# Run the complete advertising campaign performance analysis

cat("Starting complete analysis...\n")

source("R/01_validate_and_clean.R")
source("R/02_exploratory_analysis.R")
source("R/03_statistical_analysis.R")
source("R/04_predictive_model.R")
source("R/05_visualization.R")

cat("Complete analysis finished successfully.\n")
