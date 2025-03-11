# Loading necessary libraries
library(ggplot2)
library(dplyr)
library(forecast)
library(tseries)
library(TTR)

# 1. Loading and Preprocessing the Data
data <- read.csv("AAPL.csv")
data$Date <- as.Date(data$Date, format="%Y-%m-%d")
data <- data %>% arrange(Date)

# Selecting "Close" prices for analysis
close_prices <- ts(data$Close, start=c(1980, 12), frequency=365)

# Ploting the raw time series
plot.ts(close_prices, main="AAPL Closing Prices Over Time", ylab="Price", xlab="Time")

# 2. Decomposing the Time Series
# Dynamically detect the frequency of the series
detected_frequency <- ifelse(length(close_prices) > 365, 365, 7)
decomposed <- decompose(close_prices, type="multiplicative")
plot(decomposed)

# 3. Checking Stationarity
# Performing the Augmented Dickey-Fuller (ADF) test
adf_test <- suppressWarnings(adf.test(close_prices, alternative="stationary"))
cat("ADF Test Statistic (Original):", adf_test$statistic, "\n")
cat("p-value:", adf_test$p.value, "\n")

# Applying differencing 
if (adf_test$p.value > 0.05) {
  close_prices_diff <- diff(close_prices)
  adf_test_diff <- suppressWarnings(adf.test(close_prices_diff, alternative="stationary"))
  cat("ADF Test Statistic (Differenced):", adf_test_diff$statistic, "\n")
  cat("p-value (Differenced):", adf_test_diff$p.value, "\n")
  plot.ts(close_prices_diff, main="Differenced Time Series", ylab="Price", xlab="Time")
} else {
  print("The series is already stationary.")
  close_prices_diff <- close_prices
}

# 4. Train-Test Split
# Split the data into training (80%) and testing (20%)
train_size <- floor(0.8 * length(close_prices))
train_data <- close_prices[1:train_size]
test_data <- close_prices[(train_size + 1):length(close_prices)]

# Converting training data into a ts object with the detected frequency
train_data_ts <- ts(train_data, frequency=detected_frequency)

# 5. Model 1: ARIMA
arima_model <- auto.arima(train_data)
summary(arima_model)
forecast_arima <- forecast(arima_model, h=length(test_data))
plot(forecast_arima, main="ARIMA Forecast")

# Computing RMSE and MAE for ARIMA
rmse_arima <- sqrt(mean((test_data - forecast_arima$mean)^2, na.rm=TRUE))
mae_arima <- mean(abs(test_data - forecast_arima$mean), na.rm=TRUE)
cat(sprintf("ARIMA RMSE: %.4f, MAE: %.4f\n", rmse_arima, mae_arima))

# 6. Model 2: Holt-Winters
if (length(train_data) >= 2 * detected_frequency) {  # Ensure enough data for seasonal components
  hw_model <- HoltWinters(train_data_ts, seasonal="multiplicative")
  forecast_hw <- forecast(hw_model, h=length(test_data))
  plot(forecast_hw, main="Holt-Winters Forecast")
  
  # Computing RMSE and MAE for Holt-Winters
  rmse_hw <- sqrt(mean((test_data - forecast_hw$mean)^2, na.rm=TRUE))
  mae_hw <- mean(abs(test_data - forecast_hw$mean), na.rm=TRUE)
  cat(sprintf("Holt-Winters RMSE: %.4f, MAE: %.4f\n", rmse_hw, mae_hw))
} else {
  print("Not enough data for Holt-Winters model with multiplicative seasonality.")
  rmse_hw <- NA
  mae_hw <- NA
}

# 7. Model 3: Simple Exponential Smoothing (SES)
ses_model <- ses(train_data, h=length(test_data))
plot(ses_model, main="SES Forecast")

# Computing RMSE and MAE for SES
rmse_ses <- sqrt(mean((test_data - ses_model$mean)^2, na.rm=TRUE))
mae_ses <- mean(abs(test_data - ses_model$mean), na.rm=TRUE)
cat(sprintf("SES RMSE: %.4f, MAE: %.4f\n", rmse_ses, mae_ses))

# 8. Comparing the Models
# Compiling RMSE and MAE into a single table
rmse_values <- data.frame(
  Model = c("ARIMA", "Holt-Winters", "SES"),
  RMSE = c(rmse_arima, rmse_hw, rmse_ses),
  MAE = c(mae_arima, mae_hw, mae_ses)
)
print(rmse_values)

# Handling NA values and recommending the best model based on RMSE
rmse_values_clean <- rmse_values[!is.na(rmse_values$RMSE), ]
best_index <- which.min(rmse_values_clean$RMSE)
best_model <- rmse_values_clean[best_index, ]
cat(sprintf("The best model is: %s with RMSE: %.4f\n", best_model$Model, best_model$RMSE))

# 9. Exponential Moving Average (EMA)
ema <- EMA(close_prices, n=50)
plot.ts(close_prices, col="blue", main="AAPL Closing Prices with 50-Day EMA", ylab="Price", xlab="Time")
lines(ema, col="red", lwd=2)
