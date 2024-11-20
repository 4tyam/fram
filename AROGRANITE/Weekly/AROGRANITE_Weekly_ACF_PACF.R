library(forecast)
library(quantmod)
library(tseries)
library(ggplot2)
library(gridExtra)
library(xts)

# Fetch data for AROGRANITE.NS from Yahoo Finance
AROGRANITE <- getSymbols("AROGRANITE.NS", src = "yahoo", from = "2020-04-01", to = "2024-09-30", 
                  verbose = FALSE, auto.assign = FALSE)

# Convert to weekly data and calculate returns
weekly_prices <- to.weekly(AROGRANITE)
weekly_returns <- diff(log(Cl(weekly_prices)))

# Convert to time series object
Returns_ts <- as.ts(weekly_returns)
Returns_ts <- na.omit(Returns_ts)

# Create ACF plot
png("Weekly_ACF_Plot.png", width = 800, height = 400)
acf_plot <- acf(Returns_ts, main = "Autocorrelation Function (ACF) for AROGRANITE Weekly Returns",
    lag.max = 52, # Show 52 weeks (1 year) of lags
    ci.col = "blue", # Color for confidence intervals
    ci.type = "ma") # Moving average type confidence intervals
dev.off()

# Create PACF plot
png("Weekly_PACF_Plot.png", width = 800, height = 400)
pacf_plot <- pacf(Returns_ts, main = "Partial Autocorrelation Function (PACF) for AROGRANITE Weekly Returns",
     lag.max = 52,
     ci.col = "blue")
dev.off()

# Perform automatic ARIMA model selection
auto_arima <- auto.arima(Returns_ts,
                        max.p = 5, # maximum AR order
                        max.q = 5, # maximum MA order
                        max.P = 0,
                        max.Q = 0,
                        max.order = 5,
                        max.d = 0, # no differencing needed as we're working with returns
                        ic = "aic", # use AIC for model selection
                        trace = TRUE) # show model selection process

# Print model summary
print("ARIMA Model Summary:")
print(summary(auto_arima))

# Get model coefficients
print("\nModel Coefficients:")
print(coef(auto_arima))

# Create diagnostic plots for the model
png("Weekly_Model_Diagnostics.png", width = 1000, height = 800)
par(mfrow = c(2,2))
checkresiduals(auto_arima)
dev.off()

# Perform Ljung-Box test on residuals
lb_test <- Box.test(residuals(auto_arima), lag = 10, type = "Ljung-Box")
print("\nLjung-Box Test for Residuals:")
print(lb_test)

# Calculate AIC and BIC
print("\nModel Information Criteria:")
print(paste("AIC:", AIC(auto_arima)))
print(paste("BIC:", BIC(auto_arima)))

# Print basic statistics
print("\nWeekly Returns Statistics:")
print(summary(Returns_ts))
print("\nStandard Deviation:")
print(sd(Returns_ts, na.rm = TRUE))

# Additional volatility calculations for weekly data
print("\nAnnualized Volatility (assuming 52 weeks):")
print(sd(Returns_ts, na.rm = TRUE) * sqrt(52))

print("\nSharp Ratio (assuming risk-free rate of 5%):")
mean_return <- mean(Returns_ts, na.rm = TRUE)
std_dev <- sd(Returns_ts, na.rm = TRUE)
rf_weekly <- 0.05/52  # Converting annual risk-free rate to weekly
sharpe_ratio <- (mean_return - rf_weekly)/(std_dev)
print(paste("Weekly Sharpe Ratio:", sharpe_ratio))
print(paste("Annualized Sharpe Ratio:", sharpe_ratio * sqrt(52)))