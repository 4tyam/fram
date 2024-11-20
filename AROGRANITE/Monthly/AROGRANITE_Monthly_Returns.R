# Load required libraries
require(quantmod)
library(tseries)
library(ggplot2)
library(xts)

# Fetch data for AROGRANITE.NS from Yahoo Finance
AROGRANITE <- getSymbols("AROGRANITE.NS", src = "yahoo", from = "2020-04-01", to = "2024-09-30", 
                  verbose = FALSE, auto.assign = FALSE)

# Convert to monthly data (keeping the original column name)
monthly_prices <- to.monthly(AROGRANITE)

# Calculate monthly returns using closing prices
monthly_returns <- diff(log(Cl(monthly_prices)))

# Create data frame for plotting
plot_data <- data.frame(
  Date = as.Date(index(monthly_returns)),
  Returns = as.numeric(coredata(monthly_returns))
)

# Remove NA values
plot_data <- na.omit(plot_data)

# Print structure to verify data
print("Data Structure:")
str(plot_data)
print("\nFirst few rows:")
head(plot_data)

# Create the plot
p <- ggplot(plot_data, aes(x = Date, y = Returns)) +
  geom_line(linewidth = 1, color = "blue") +
  geom_point(size = 2.5, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Monthly Returns of State Bank of India (AROGRANITE.NS)",
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
    breaks = seq(-0.3, 0.3, by = 0.05),
    labels = scales::number_format(accuracy = 0.01)
  ) +
  scale_x_date(
    date_breaks = "3 months",
    date_labels = "%b\n%Y",
    expand = c(0.02, 0.02)
  )

# Print plot
print(p)

# Save plot
ggsave("AROGRANITE_Monthly_Returns.png", p, width = 12, height = 6, dpi = 300)

# Calculate summary statistics
summary_stats <- data.frame(
  Mean = mean(plot_data$Returns, na.rm = TRUE),
  SD = sd(plot_data$Returns, na.rm = TRUE),
  Min = min(plot_data$Returns, na.rm = TRUE),
  Max = max(plot_data$Returns, na.rm = TRUE)
)

# Print summary statistics
print("\nSummary Statistics of Monthly Returns:")
print(summary_stats)

# Calculate and print annualized metrics
annualized_vol <- sd(plot_data$Returns, na.rm = TRUE) * sqrt(12)
annualized_return <- mean(plot_data$Returns, na.rm = TRUE) * 12

print(paste("\nAnnualized Volatility:", round(annualized_vol, 4)))
print(paste("Annualized Return:", round(annualized_return, 4)))