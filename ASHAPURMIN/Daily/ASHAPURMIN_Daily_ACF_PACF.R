# Load required libraries
require(quantmod)
library(tseries)
library(ggplot2)
library(forecast)
library(gridExtra)

# Fetch data for ASHAPURMIN.NS from Yahoo Finance
ASHAPURMIN <- getSymbols("ASHAPURMIN.NS", src = "yahoo", from = "2020-04-01", to = "2024-09-30", 
                  verbose = FALSE, auto.assign = FALSE)

# Calculate daily returns
Returns <- diff(log(Cl(ASHAPURMIN)))  # Using log returns for better statistical properties

# Convert xts object to time series
Returns_ts <- as.ts(Returns)

# Remove NA values
Returns_ts <- na.omit(Returns_ts)

# Create ACF plot
png("ACF_Plot.png", width = 800, height = 400)
acf_plot <- acf(Returns_ts, main = "Autocorrelation Function (ACF) for ASHAPURMIN Daily Returns",
    lag.max = 30, # Show 30 lags
    ci.col = "blue", # Color for confidence intervals
    ci.type = "ma") # Moving average type confidence intervals
dev.off()

# Create PACF plot
png("PACF_Plot.png", width = 800, height = 400)
pacf_plot <- pacf(Returns_ts, main = "Partial Autocorrelation Function (PACF) for ASHAPURMIN Daily Returns",
     lag.max = 30,
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
png("Model_Diagnostics.png", width = 1000, height = 800)
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