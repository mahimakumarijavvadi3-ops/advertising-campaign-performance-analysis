# 02_descriptive_analysis.R
# Descriptive analysis of advertising campaign performance

output_dir <- "output"

data_file <- file.path(
  output_dir,
  "cleaned_advertising_data.csv"
)

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found. Run 01_validate_and_clean.R first.")
}

data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Numeric summary
numeric_data <- data[sapply(data, is.numeric)]

if (ncol(numeric_data) > 0) {

  summary_table <- data.frame(
    Variable = names(numeric_data),
    Mean = sapply(numeric_data, mean, na.rm = TRUE),
    Median = sapply(numeric_data, median, na.rm = TRUE),
    Minimum = sapply(numeric_data, min, na.rm = TRUE),
    Maximum = sapply(numeric_data, max, na.rm = TRUE),
    SD = sapply(numeric_data, sd, na.rm = TRUE)
  )

  write.csv(
    summary_table,
    file.path(output_dir, "descriptive_statistics.csv"),
    row.names = FALSE
  )
}

# Missing-value summary
missing_summary <- data.frame(
  Variable = names(data),
  Missing_Values = sapply(data, function(x) sum(is.na(x))),
  Missing_Percentage =
    round(sapply(data, function(x) mean(is.na(x))) * 100, 2)
)

write.csv(
  missing_summary,
  file.path(output_dir, "missing_value_summary.csv"),
  row.names = FALSE
)

cat("Descriptive analysis completed.\n")
