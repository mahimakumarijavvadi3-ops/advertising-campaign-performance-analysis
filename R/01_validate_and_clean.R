# 01_validate_and_clean.R
# Data validation and cleaning

options(stringsAsFactors = FALSE)

data_dir <- "data"
output_dir <- "outputs"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

csv_files <- list.files(
  data_dir,
  pattern = "\\.csv$",
  full.names = TRUE,
  ignore.case = TRUE
)

if (length(csv_files) == 0) {
  stop("No CSV file found in the data folder.")
}

raw_data <- read.csv(
  csv_files[1],
  stringsAsFactors = FALSE,
  check.names = FALSE
)

original_rows <- nrow(raw_data)
original_columns <- ncol(raw_data)

# Remove completely empty rows
raw_data <- raw_data[
  rowSums(is.na(raw_data) | raw_data == "") < ncol(raw_data),
  ,
  drop = FALSE
]

# Remove completely empty columns
raw_data <- raw_data[
  ,
  colSums(is.na(raw_data) | raw_data == "") < nrow(raw_data),
  drop = FALSE
]

clean_data <- unique(raw_data)

# Trim whitespace in character columns
clean_data[] <- lapply(clean_data, function(x) {
  if (is.character(x)) trimws(x) else x
})

write.csv(
  clean_data,
  file.path(output_dir, "clean_advertising_campaigns.csv"),
  row.names = FALSE
)

validation_summary <- data.frame(
  Metric = c(
    "Original rows",
    "Cleaned rows",
    "Original columns",
    "Cleaned columns",
    "Duplicate rows removed"
  ),
  Value = c(
    original_rows,
    nrow(clean_data),
    original_columns,
    ncol(clean_data),
    original_rows - nrow(clean_data)
  )
)

write.csv(
  validation_summary,
  file.path(output_dir, "data_validation_summary.csv"),
  row.names = FALSE
)

cat("Data validation and cleaning completed.\n")
