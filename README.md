# Stock Market Analysis Tools in R

A collection of R scripts for analyzing stock market data from the National Stock Exchange of India (NSE).

## Overview

This project provides tools to analyze stock returns at different time intervals (daily, weekly, and monthly) for four NSE-listed stocks:

- AROGRANITE
- ARVSMART
- ASHAPURMIN
- ASIANTILES

## Features

### Returns Analysis

- Daily returns calculation
- Weekly returns aggregation
- Monthly returns aggregation

### Visualization

- Time series plots using ggplot2
- ACF (Autocorrelation Function) plots
- PACF (Partial Autocorrelation Function) plots

### Statistical Metrics

- Mean returns
- Standard deviation
- Min/Max values
- Annualized volatility
- Sharpe ratio (using 5% risk-free rate)

## Requirements

Required R packages:

r
require(quantmod)
library(tseries)
library(ggplot2)
library(forecast)
library(gridExtra)
library(xts)
library(scales)

Each stock directory contains analysis scripts for different time intervals:

- `*_Returns.R`: Calculates and plots returns
- `*_ACF_PACF.R`: Generates autocorrelation analysis plots

## Usage

1. Each script can be run independently
2. Data is fetched from Yahoo Finance (2020-04-01 to 2024-09-30)
3. Results are saved as PNG files in the respective directories
4. Statistical summaries are printed to the console

## Output Files

- Returns plots (PNG format)
- ACF/PACF plots (PNG format)
- Statistical summaries (console output)

## Note

Make sure you have an active internet connection as the scripts fetch data from Yahoo Finance.
