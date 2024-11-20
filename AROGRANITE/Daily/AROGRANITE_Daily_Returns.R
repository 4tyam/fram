# Load required libraries
require(quantmod)
library(tseries)
library(ggplot2)

# Fetch data for AROGRANITE.NS from Yahoo Finance
AROGRANITE <- getSymbols("AROGRANITE.NS", src = "yahoo", from = "2020-04-01", to = "2024-09-30", 
                  verbose = FALSE, auto.assign = FALSE)

# Calculate daily returns
Returns <- diff(log(Cl(AROGRANITE)))  # Using log returns for better statistical properties

# Convert xts object to data frame while preserving dates
Returns_df <- data.frame(
  Date = as.Date(rownames(as.data.frame(Returns))),  # Convert row names to dates
  Returns = as.numeric(Returns)
)

# Remove any NA values if present
Returns_df <- na.omit(Returns_df)

# Create the plot using ggplot2
ggplot(Returns_df, aes(x = Date, y = Returns)) +
  geom_line(color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Daily Returns of State Bank of India (AROGRANITE.NS)",
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
ggsave("AROGRANITE_Daily_Returns.png", width = 12, height = 6, dpi = 300)

# Print first few rows to verify the data structure
print(head(Returns_df))