# Validate, clean and prepare the advertising campaign data
# Base R only: no external packages are required.

data <- read.csv("data/advertising_campaigns.csv", stringsAsFactors = FALSE)

required <- c("date","platform","campaign_type","audience","region",
              "spend","impressions","clicks","conversions","revenue")

stopifnot(all(required %in% names(data)))

data$date <- as.Date(data$date)
stopifnot(all(!is.na(data$date)))

numeric_cols <- c("spend","impressions","clicks","conversions","revenue")

for (v in numeric_cols) {
  stopifnot(all(is.finite(data[[v]])))
}

stopifnot(
  all(data$spend >= 0),
  all(data$impressions > 0),
  all(data$clicks >= 0),
  all(data$conversions >= 0),
  all(data$revenue >= 0),
  all(data$clicks <= data$impressions)
)

data$ctr <- data$clicks / data$impressions

data$conversion_rate <- ifelse(
  data$clicks > 0,
  data$conversions / data$clicks,
  0
)

data$cpc <- ifelse(
  data$clicks > 0,
  data$spend / data$clicks,
  NA_real_
)

data$roas <- ifelse(
  data$spend > 0,
  data$revenue / data$spend,
  NA_real_
)

# Fixed, reproducible 80/20 split used by the predictive model.
set.seed(42)

idx <- sample(
  seq_len(nrow(data)),
  floor(0.80 * nrow(data))
)

data$split <- ifelse(
  seq_len(nrow(data)) %in% idx,
  "train",
  "test"
)

dir.create("outputs", showWarnings = FALSE)

dir.create(
  "outputs/plots",
  showWarnings = FALSE,
  recursive = TRUE
)

write.csv(
  data,
  "outputs/clean_advertising_campaigns.csv",
  row.names = FALSE
)

cat(
  "Validation and cleaning completed:",
  nrow(data),
  "rows\n"
)

cat(
  "Training rows:",
  sum(data$split == "train"),
  "Test rows:",
  sum(data$split == "test"),
  "\n"
)
