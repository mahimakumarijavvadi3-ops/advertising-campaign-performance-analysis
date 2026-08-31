# 05_visualization.R
# Advertising campaign performance visualizations

output_dir <- "output"
plot_dir <- file.path(output_dir, "plots")

if (!dir.exists(plot_dir)) {
  dir.create(plot_dir, recursive = TRUE)
}

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

if (ncol(numeric_data) >= 1) {

  png(
    file.path(plot_dir, "01_distribution.png"),
    width = 1000,
    height = 700
  )

  hist(
    numeric_data[[1]],
    main = paste(
      "Distribution of",
      names(numeric_data)[1]
    ),
    xlab = names(numeric_data)[1]
  )

  dev.off()
}

if (ncol(numeric_data) >= 2) {

  valid <- complete.cases(
    numeric_data[[1]],
    numeric_data[[2]]
  )

  png(
    file.path(plot_dir, "02_relationship.png"),
    width = 1000,
    height = 700
  )

  plot(
    numeric_data[[1]][valid],
    numeric_data[[2]][valid],
    main = paste(
      names(numeric_data)[2],
      "vs",
      names(numeric_data)[1]
    ),
    xlab = names(numeric_data)[1],
    ylab = names(numeric_data)[2],
    pch = 19
  )

  if (sum(valid) >= 3) {
    abline(
      lm(
        numeric_data[[2]][valid] ~ numeric_data[[1]][valid]
      )
    )
  }

  dev.off()
}

cat("Visualizations completed.\n")
