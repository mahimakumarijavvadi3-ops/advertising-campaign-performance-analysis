
# 02_exploratory_analysis.R
# Exploratory and descriptive analysis

output_dir <- "outputs"

data_file <- file.path(
  output_dir,
  "clean_advertising_campaigns.csv"
)

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found. Run 01_validate_and_clean.R first.")
}

campaign_data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Select numeric columns
numeric_data <- campaign_data[
  sapply(campaign_data, is.numeric)
]

# Descriptive statistics
if (ncol(numeric_data) > 0) {

  descriptive_statistics <- data.frame(
    Variable = names(numeric_data),
    Mean = sapply(numeric_data, mean, na.rm = TRUE),
    Median = sapply(numeric_data, median, na.rm = TRUE),
    Minimum = sapply(numeric_data, min, na.rm = TRUE),
    Maximum = sapply(numeric_data, max, na.rm = TRUE),
    Standard_Deviation = sapply(
      numeric_data,
      sd,
      na.rm = TRUE
    )
  )

  write.csv(
    descriptive_statistics,
    file.path(
      output_dir,
      "descriptive_statistics.csv"
    ),
    row.names = FALSE
  )
}

# Missing value summary
missing_summary <- data.frame(
  Variable = names(campaign_data),
  Missing_Values = sapply(
    campaign_data,
    function(x) sum(is.na(x))
  ),
  Missing_Percentage = round(
    sapply(
      campaign_data,
      function(x) mean(is.na(x))
    ) * 100,
    2
  )
)

write.csv(
  missing_summary,
  file.path(
    output_dir,
    "missing_value_summary.csv"
  ),
  row.names = FALSE
)

cat("Exploratory analysis completed successfully.\n")
