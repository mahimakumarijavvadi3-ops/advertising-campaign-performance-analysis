# run_all.R
# Run the complete advertising campaign performance analysis

cat("Starting complete analysis...\n")

# Always run from repository root
repo_dir <- normalizePath(getwd())

# Create required output directories
if (!dir.exists("outputs")) {
  dir.create("outputs", recursive = TRUE)
}

if (!dir.exists("outputs/plots")) {
  dir.create("outputs/plots", recursive = TRUE)
}

# Run analysis scripts in order
source(file.path("R", "01_validate_and_clean.R"))
source(file.path("R", "02_exploratory_analysis.R"))
source(file.path("R", "03_statistical_analysis.R"))
source(file.path("R", "04_predictive_model.R"))
source(file.path("R", "05_visualization.R"))

cat("Complete analysis finished successfully.\n")
