# 01_validate_and_clean.R
# Data validation and cleaning

options(stringsAsFactors = FALSE)

data_dir <- "data"
output_dir <- "output"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Find CSV files in the data folder
csv_files <- list.files(
  data_dir,
  pattern = "\\.csv$",
  full.names = TRUE,
  ignore.case = TRUE
)

if (length(csv_files) == 0) {
  stop("No CSV file found in the data folder.")
}

# Read the first CSV file
raw_data <- read.csv(
  csv_files[1],
  stringsAsFactors = FALSE,
  check.names = FALSE
)

cat("Data loaded successfully.\n")
cat("Rows:", nrow(raw_data), "\n")
cat("Columns:", ncol(raw_data), "\n")

# Remove completely empty rows and columns
raw_data <- raw_data[
  rowSums(is.na(raw_data) | raw_data == "") < ncol(raw_data),
  ,
  drop = FALSE
]

raw_data <- raw_data[
  ,
  colSums(is.na(raw_data) | raw_data == "") < nrow(raw_data),
  drop = FALSE
]

# Remove duplicate observations
clean_data <- unique(raw_data)

# Trim whitespace from character columns
clean_data[] <- lapply(clean_data, function(x) {
  if (is.character(x)) {
    trimws(x)
  } else {
    x
  }
})

# Convert numeric-looking character columns
clean_data[] <- lapply(clean_data, function(x) {
  if (is.character(x)) {
    converted <- suppressWarnings(as.numeric(x))
    if (sum(!is.na(converted)) >= 0.8 * sum(!is.na(x))) {
      return(converted)
    }
  }
  x
})

# Save cleaned dataset
write.csv(
  clean_data,
  file.path(output_dir, "cleaned_advertising_data.csv"),
  row.names = FALSE
)

# Save validation summary
validation <- data.frame(
  Metric = c(
    "Original rows",
    "Cleaned rows",
    "Original columns",
    "Cleaned columns",
    "Duplicate rows removed"
  ),
  Value = c(
    nrow(raw_data),
    nrow(clean_data),
    ncol(raw_data),
    ncol(clean_data),
    nrow(raw_data) - nrow(clean_data)
  )
)

write.csv(
  validation,
  file.path(output_dir, "data_validation_summary.csv"),
  row.names = FALSE
)

cat("Data validation and cleaning completed.\n")
