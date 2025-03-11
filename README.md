# 📌 Time Series Analysis Project

## 📖 Overview
This project focuses on **time series analysis and forecasting** of **Apple (AAPL) stock prices** using various statistical and machine learning techniques. The goal is to analyze trends, check stationarity, and build predictive models to forecast future stock prices.

## 📂 Dataset Information
The dataset consists of **historical Apple stock prices**, including:
- **Date**: Trading date
- **Open, High, Low, Close**: Stock price details
- **Volume**: Number of shares traded
- **Close Price** (Target Variable): The main focus for forecasting

## 🏗️ Project Workflow
1. **Data Preprocessing & Exploration:**
   - Converting date to a proper format
   - Sorting data chronologically
   - Visualizing raw time series trends

2. **Time Series Decomposition:**
   - Identifying **trend, seasonal, and residual components**
   - Using **multiplicative decomposition** to observe patterns

3. **Stationarity Check & Transformation:**
   - **Augmented Dickey-Fuller (ADF) Test** to determine stationarity
   - **Differencing the series** if needed to achieve stationarity

4. **Train-Test Split:**
   - Splitting data into **80% training and 20% testing** for model evaluation

5. **Time Series Forecasting Models Applied:**
   - **ARIMA (AutoRegressive Integrated Moving Average)**
   - **Holt-Winters (Exponential Smoothing with Trend & Seasonality)**
   - **Simple Exponential Smoothing (SES)**
   - **Exponential Moving Average (EMA)** for trend detection

6. **Model Evaluation Metrics:**
   - **Root Mean Squared Error (RMSE)**: Measures prediction accuracy
   - **Mean Absolute Error (MAE)**: Measures deviation from actual values
   - **Visualizing Forecasts** using line plots

## 📊 Results & Insights
- **Model Performance Comparison:**
  - **ARIMA:** RMSE = **X.XXX**, MAE = **X.XXX**
  - **Holt-Winters:** RMSE = **X.XXX**, MAE = **X.XXX**
  - **SES:** RMSE = **X.XXX**, MAE = **X.XXX**
- **Best Model:** The model with the lowest RMSE was **[Best Model]**, making it the most accurate for forecasting Apple stock prices.
- **Exponential Moving Average (EMA)** provided a smoothed representation of stock price trends.
