# Continue from previous code...

# Convert Returns to a data frame and ensure Date is in proper format
Returns_df <- data.frame(
  Date = as.Date(index(Returns)),
  Returns = as.numeric(coredata(Returns))
)

# Remove any NA values if present
Returns_df <- na.omit(Returns_df)

# Create the plot using ggplot2
ggplot(Returns_df, aes(x = Date, y = Returns)) +
  geom_line(color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Daily Returns of State Bank of India (SBIN.NS)",
    x = "Date",
    y = "Returns",
    caption = "Data Source: Yahoo Finance"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(angle = 45, hjust = 1),  # Angled x-axis labels
    panel.grid.minor = element_line(color = "gray90"),  # Lighter minor gridlines
    panel.grid.major = element_line(color = "gray85")   # Lighter major gridlines
  ) +
  scale_y_continuous(
    breaks = seq(-0.15, 0.15, by = 0.05),  # Custom breaks for y-axis
    labels = scales::number_format(accuracy = 0.01)  # Format as decimals
  ) +
  scale_x_date(
    date_breaks = "2 months",  # Show every 2 months
    date_labels = "%b\n%Y",    # Month and year on separate lines
    expand = c(0.02, 0.02)     # Slight padding on x-axis
  )

# If you want to save the plot
ggsave("SBI_Daily_Returns.png", width = 12, height = 6, dpi = 300)