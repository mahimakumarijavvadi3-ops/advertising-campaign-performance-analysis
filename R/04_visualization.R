# 04_visualization.R
# Advertising campaign performance visualizations

output_dir <- "output"
plot_dir <- file.path(output_dir, "plots")

if (!dir.exists(plot_dir)) {
  dir.create(plot_dir, recursive = TRUE)
}

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

if (ncol(numeric_data) >= 1) {

  # Distribution of first numeric variable
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
    xlab = names(numeric_data)[1],
    col = "lightgray",
    border = "white"
  )

  dev.off()
}

if (ncol(numeric_data) >= 2) {

  # Relationship between first two numeric variables
  png(
    file.path(plot_dir, "02_relationship.png"),
    width = 1000,
    height = 700
  )

  plot(
    numeric_data[[1]],
    numeric_data[[2]],
    main = paste(
      names(numeric_data)[2],
      "vs",
      names(numeric_data)[1]
    ),
    xlab = names(numeric_data)[1],
    ylab = names(numeric_data)[2],
    pch = 19
  )

  abline(
    lm(
      numeric_data[[2]] ~ numeric_data[[1]],
      na.action = na.omit
    )
  )

  dev.off()
}

cat("Visualizations completed.\n")
