# 02_exploratory_analysis.R
# Exploratory and descriptive analysis

output_dir <- "output"
data_file <- file.path(output_dir, "cleaned_advertising_data.csv")

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found. Run 01_validate_and_clean.R first.")
}

data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

numeric_data <- data[sapply(data, is.numeric)]

if (ncol(numeric_data) > 0) {
  descriptive_statistics <- data.frame(
    Variable = names(numeric_data),
    Mean = sapply(numeric_data, mean, na.rm = TRUE),
    Median = sapply(numeric_data, median, na.rm = TRUE),
    Minimum = sapply(numeric_data, min, na.rm = TRUE),
    Maximum = sapply(numeric_data, max, na.rm = TRUE),
    Standard_Deviation = sapply(numeric_data, sd, na.rm = TRUE)
  )

  write.csv(
    descriptive_statistics,
    file.path(output_dir, "descriptive_statistics.csv"),
    row.names = FALSE
  )
}

missing_summary <- data.frame(
  Variable = names(data),
  Missing_Values = sapply(data, function(x) sum(is.na(x))),
  Missing_Percentage = round(
    sapply(data, function(x) mean(is.na(x))) * 100,
    2
  )
)

write.csv(
  missing_summary,
  file.path(output_dir, "missing_value_summary.csv"),
  row.names = FALSE
)

cat("Exploratory analysis completed.\n")
