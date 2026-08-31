# 03_statistical_analysis.R
# Statistical analysis of advertising campaign performance

output_dir <- "output"

data_file <- file.path(
  output_dir,
  "cleaned_advertising_data.csv"
)

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found.")
}

data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

numeric_data <- data[sapply(data, is.numeric)]

results <- data.frame(
  Variable = character(),
  Correlation_with_First_Numeric = numeric(),
  stringsAsFactors = FALSE
)

# Correlation analysis
if (ncol(numeric_data) >= 2) {

  reference <- numeric_data[[1]]

  for (i in 2:ncol(numeric_data)) {

    current <- numeric_data[[i]]

    valid <- complete.cases(reference, current)

    if (sum(valid) >= 3) {

      correlation <- suppressWarnings(
        cor(reference[valid], current[valid])
      )

      results <- rbind(
        results,
        data.frame(
          Variable = names(numeric_data)[i],
          Correlation_with_First_Numeric = correlation
        )
      )
    }
  }
}

write.csv(
  results,
  file.path(output_dir, "correlation_analysis.csv"),
  row.names = FALSE
)

# Basic linear model when at least two numeric variables exist
if (ncol(numeric_data) >= 2) {

  model_data <- numeric_data[, 1:2]
  model_data <- na.omit(model_data)

  if (nrow(model_data) >= 3) {

    names(model_data) <- c("Target", "Predictor")

    model <- lm(
      Target ~ Predictor,
      data = model_data
    )

    model_summary <- capture.output(
      summary(model)
    )

    writeLines(
      model_summary,
      file.path(output_dir, "linear_model_summary.txt")
    )
  }
}

cat("Statistical analysis completed.\n")
