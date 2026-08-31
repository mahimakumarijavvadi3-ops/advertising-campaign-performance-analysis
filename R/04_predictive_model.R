# 04_predictive_model.R
# Basic predictive model

output_dir <- "output"
data_file <- file.path(output_dir, "cleaned_advertising_data.csv")

if (!file.exists(data_file)) {
  stop("Cleaned dataset not found.")
}

data <- read.csv(
  data_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

numeric_data <- data[sapply(data, is.numeric)]

if (ncol(numeric_data) >= 2) {

  model_data <- na.omit(numeric_data[, 1:2, drop = FALSE])

  if (nrow(model_data) >= 5) {

    names(model_data) <- c("Target", "Predictor")

    set.seed(123)

    train_index <- sample(
      seq_len(nrow(model_data)),
      size = floor(0.8 * nrow(model_data))
    )

    train_data <- model_data[train_index, , drop = FALSE]
    test_data <- model_data[-train_index, , drop = FALSE]

    model <- lm(
      Target ~ Predictor,
      data = train_data
    )

    predictions <- predict(
      model,
      newdata = test_data
    )

    rmse <- sqrt(
      mean((test_data$Target - predictions)^2)
    )

    model_metrics <- data.frame(
      Metric = c(
        "Training R-squared",
        "Test RMSE"
      ),
      Value = c(
        summary(model)$r.squared,
        rmse
      )
    )

    write.csv(
      model_metrics,
      file.path(output_dir, "model_performance.csv"),
      row.names = FALSE
    )

    predictions_output <- data.frame(
      Actual = test_data$Target,
      Predicted = predictions
    )

    write.csv(
      predictions_output,
      file.path(output_dir, "model_predictions.csv"),
      row.names = FALSE
    )

    writeLines(
      capture.output(summary(model)),
      file.path(output_dir, "predictive_model_summary.txt")
    )
  }
}

cat("Predictive modeling completed.\n")
