# Produce a concise management-ready insight table

data <- read.csv(
  "outputs/clean_advertising_campaigns.csv",
  stringsAsFactors = FALSE
)

p <- aggregate(
  cbind(spend, revenue, clicks, conversions, impressions) ~ platform,
  data,
  sum
)

p$ROAS <- p$revenue / p$spend
p$CTR <- p$clicks / p$impressions
p$CVR <- p$conversions / p$clicks

p <- p[order(-p$ROAS), ]

write.csv(
  p,
  "outputs/key_platform_insights.csv",
  row.names = FALSE
)

cat(
  "Best platform by ROAS:",
  p$platform[1],
  "\n"
)

cat(
  "Overall ROAS:",
  sum(data$revenue) / sum(data$spend),
  "\n"
)
