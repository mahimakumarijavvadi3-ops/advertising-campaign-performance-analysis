# Exploratory analysis and visual outputs

data <- read.csv(
  "outputs/clean_advertising_campaigns.csv",
  stringsAsFactors = FALSE
)

dir.create("outputs/plots", showWarnings = FALSE)

platform <- aggregate(
  cbind(spend, revenue, clicks, conversions, impressions) ~ platform,
  data,
  sum
)

platform$ROAS <- platform$revenue / platform$spend
platform$CTR <- platform$clicks / platform$impressions
platform$CVR <- platform$conversions / platform$clicks

write.csv(
  platform,
  "outputs/platform_summary.csv",
  row.names = FALSE
)

png(
  "outputs/plots/roas_by_platform.png",
  width = 1000,
  height = 600
)

barplot(
  platform$ROAS,
  names.arg = platform$platform,
  las = 2,
  ylab = "ROAS",
  main = "Return on Ad Spend by Platform"
)

dev.off()

data$month <- format(
  as.Date(data$date),
  "%Y-%m"
)

monthly <- aggregate(
  cbind(spend, revenue, conversions) ~ month,
  data,
  sum
)

monthly <- monthly[order(monthly$month), ]

write.csv(
  monthly,
  "outputs/monthly_summary.csv",
  row.names = FALSE
)

png(
  "outputs/plots/monthly_revenue.png",
  width = 1000,
  height = 600
)

plot(
  seq_len(nrow(monthly)),
  monthly$revenue,
  type = "o",
  xaxt = "n",
  xlab = "Month",
  ylab = "Revenue",
  main = "Monthly Advertising Revenue"
)

axis(
  1,
  seq_len(nrow(monthly)),
  monthly$month,
  las = 2,
  cex.axis = 0.7
)

dev.off()
