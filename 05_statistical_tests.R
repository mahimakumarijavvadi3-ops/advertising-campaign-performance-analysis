# Statistical testing for advertising campaign performance
# Base R only - no external packages required

data <- read.csv(
  "outputs/clean_advertising_campaigns.csv",
  stringsAsFactors = FALSE
)

data$platform <- factor(data$platform)
data$campaign_type <- factor(data$campaign_type)
data$audience <- factor(data$audience)

# ---------------------------------------------------------
# 1. Correlation tests
# ---------------------------------------------------------

cor_spend_revenue <- cor.test(
  data$spend,
  data$revenue,
  method = "pearson"
)

cor_clicks_conversions <- cor.test(
  data$clicks,
  data$conversions,
  method = "pearson"
)

cor_impressions_clicks <- cor.test(
  data$impressions,
  data$clicks,
  method = "pearson"
)

correlation_results <- data.frame(
  test = c(
    "Spend vs Revenue",
    "Clicks vs Conversions",
    "Impressions vs Clicks"
  ),
  correlation = c(
    unname(cor_spend_revenue$estimate),
    unname(cor_clicks_conversions$estimate),
    unname(cor_impressions_clicks$estimate)
  ),
  p_value = c(
    cor_spend_revenue$p.value,
    cor_clicks_conversions$p.value,
    cor_impressions_clicks$p.value
  )
)

write.csv(
  correlation_results,
  "outputs/correlation_tests.csv",
  row.names = FALSE
)

# ---------------------------------------------------------
# 2. Platform comparison
# ---------------------------------------------------------

platform_groups <- split(
  data$revenue,
  data$platform
)

platform_anova <- aov(
  revenue ~ platform,
  data = data
)

anova_summary <- summary(platform_anova)[[1]]

anova_results <- data.frame(
  test = "Revenue difference across platforms",
  statistic = anova_summary$`F value`[1],
  p_value = anova_summary$`Pr(>F)`[1]
)

write.csv(
  anova_results,
  "outputs/platform_anova.csv",
  row.names = FALSE
)

# ---------------------------------------------------------
# 3. Campaign type comparison
# ---------------------------------------------------------

campaign_anova <- aov(
  revenue ~ campaign_type,
  data = data
)

campaign_summary <- summary(campaign_anova)[[1]]

campaign_anova_results <- data.frame(
  test = "Revenue difference across campaign types",
  statistic = campaign_summary$`F value`[1],
  p_value = campaign_summary$`Pr(>F)`[1]
)

write.csv(
  campaign_anova_results,
  "outputs/campaign_type_anova.csv",
  row.names = FALSE
)

# ---------------------------------------------------------
# 4. Conversion-rate comparison
# ---------------------------------------------------------

data$conversion_rate <- ifelse(
  data$clicks > 0,
  data$conversions / data$clicks,
  NA
)

conversion_platform <- aggregate(
  conversion_rate ~ platform,
  data = data,
  FUN = mean,
  na.rm = TRUE
)

conversion_platform <- conversion_platform[
  order(-conversion_platform$conversion_rate),
]

write.csv(
  conversion_platform,
  "outputs/platform_conversion_rates.csv",
  row.names = FALSE
)

# ---------------------------------------------------------
# 5. Statistical test report
# ---------------------------------------------------------

sink("outputs/statistical_test_report.txt")

cat("ADVERTISING CAMPAIGN STATISTICAL TEST REPORT\n")
cat("============================================\n\n")

cat("Correlation: Spend vs Revenue\n")
print(cor_spend_revenue)

cat("\nCorrelation: Clicks vs Conversions\n")
print(cor_clicks_conversions)

cat("\nCorrelation: Impressions vs Clicks\n")
print(cor_impressions_clicks)

cat("\nANOVA: Revenue by Platform\n")
print(summary(platform_anova))

cat("\nANOVA: Revenue by Campaign Type\n")
print(summary(campaign_anova))

cat("\nMean Conversion Rate by Platform\n")
print(conversion_platform)

sink()

# ---------------------------------------------------------
# 6. Console summary
# ---------------------------------------------------------

cat("\nStatistical analysis completed successfully.\n")

cat(
  "Spend-Revenue correlation:",
  round(
    unname(cor_spend_revenue$estimate),
    4
  ),
  "\n"
)

cat(
  "Spend-Revenue p-value:",
  round(
    cor_spend_revenue$p.value,
    6
  ),
  "\n"
)

cat(
  "Platform ANOVA p-value:",
  round(
    anova_results$p_value,
    6
  ),
  "\n"
)

cat(
  "Campaign Type ANOVA p-value:",
  round(
    campaign_anova_results$p_value,
    6
  ),
  "\n"
)
