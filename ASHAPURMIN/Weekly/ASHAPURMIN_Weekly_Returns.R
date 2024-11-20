# Load required libraries
require(quantmod)
library(tseries)
library(ggplot2)

# Fetch data for ASHAPURMIN.NS from Yahoo Finance
ASHAPURMIN <- getSymbols("ASHAPURMIN.NS", src = "yahoo", from = "2020-04-01", to = "2024-09-30", 
                  verbose = FALSE, auto.assign = FALSE)

# Convert to weekly data and calculate weekly returns
weekly_prices <- to.weekly(ASHAPURMIN)  # Convert to weekly OHLC
weekly_returns <- diff(log(Cl(weekly_prices)))  # Calculate log returns on weekly closing prices

# Convert xts object to data frame while preserving dates
Returns_df <- data.frame(
  Date = as.Date(rownames(as.data.frame(weekly_returns))),  # Convert row names to dates
  Returns = as.numeric(weekly_returns)
)

# Remove any NA values if present
Returns_df <- na.omit(Returns_df)

# Create the plot using ggplot2
ggplot(Returns_df, aes(x = Date, y = Returns)) +
  geom_line(color = "blue", size = 0.8) +  # Made line slightly thicker for weekly data
  geom_point(color = "blue", size = 1) +   # Added points to show weekly observations
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Weekly Returns of State Bank of India (ASHAPURMIN.NS)",
    x = "Date",
    y = "Returns",
    caption = "Data Source: Yahoo Finance"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_line(color = "gray90"),
    panel.grid.major = element_line(color = "gray85")
  ) +
  scale_y_continuous(
    breaks = seq(-0.15, 0.15, by = 0.05),
    labels = scales::number_format(accuracy = 0.01)
  ) +
  scale_x_date(
    date_breaks = "2 months",
    date_labels = "%b\n%Y",
    expand = c(0.02, 0.02)
  )

# If you want to save the plot
ggsave("ASHAPURMIN_Weekly_Returns.png", width = 12, height = 6, dpi = 300)

# Print first few rows to verify the data structure and some summary statistics
print("First few rows of weekly returns:")
print(head(Returns_df))

# Calculate some summary statistics for the weekly returns
summary_stats <- data.frame(
  Mean = mean(Returns_df$Returns, na.rm = TRUE),
  SD = sd(Returns_df$Returns, na.rm = TRUE),
  Min = min(Returns_df$Returns, na.rm = TRUE),
  Max = max(Returns_df$Returns, na.rm = TRUE)
)
print("\nSummary Statistics of Weekly Returns:")
print(summary_stats)