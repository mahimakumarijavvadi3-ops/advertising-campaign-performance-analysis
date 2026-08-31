# 03_statistical_analysis.R
# Statistical analysis

output_dir <- "outputs"
data_file <- file.path(output_dir, "clean_advertising_campaigns.csv")

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found.")
}

data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

numeric_data <- data[sapply(data, is.numeric)]

correlation_results <- data.frame(
  Variable = character(),
  Correlation = numeric(),
  stringsAsFactors = FALSE
)

if (ncol(numeric_data) >= 2) {
  reference <- numeric_data[[1]]

  for (i in 2:ncol(numeric_data)) {
    current <- numeric_data[[i]]
    valid <- complete.cases(reference, current)

    if (sum(valid) >= 3) {
      correlation_results <- rbind(
        correlation_results,
        data.frame(
          Variable = names(numeric_data)[i],
          Correlation = cor(reference[valid], current[valid])
        )
      )
    }
  }
}

write.csv(
  correlation_results,
  file.path(output_dir, "correlation_analysis.csv"),
  row.names = FALSE
)

cat("Statistical analysis completed.\n")
