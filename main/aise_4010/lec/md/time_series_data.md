# Basic Concepts of Time Series Data

## What is Time Series Data?

Time Series Data is sequential data, essentially data taken over some span of time. They key characteristic
is that the data-points are *depdendent* on time, which makes it unique from other types of data. This time-dependency often means the
past data influences the present, so with DL models we are basically trying to predict the future.

Some examples of time series data:

- Stock Prices
- Weather History
- Sensor Readings
- Videos (sequence of frames over time)

## Time-Series Analysis

Time-Series Analysis deals wiht what type of information we are trying to extract from a big time-series dataset.
There are a few types of analysis.

- Forecasting: aims to predict future values based on past data
	- ex: Getting rich with stock predictions
- Classification & Clustering: involves categorizing different time-series data based on their characteristic
	- ex: grouping together ECG patterns of patients with heart-conditions
- Anomaly Detection: aims to indentify unusual or unexpected patterns in the data
	- ex: Threat detection on IoT network

## Time-Series Modelling

In order to perform the analyses above, we have a few modelling techniques available for modelling time-series-data:

- Classical Statistical Modelling
	- Parametric ARIMA/ARMA/SARIMA/etc models with interpretable coeffs.
- State-Space & Bayesian
	- Kalman filtering/smoothing, missing data handling
- Feature Based ML
	- Turn a series intoo a supervised table and fit a regressor/classifier (Random Forest, XGBoost, etc.)
- **Deep Learning**
	- Learn representations directly from sequences, capturing nonlinear/long-range structures. Best to use DL with Large data
	, multivariate sensors and complex patterns
- Hybrid & Ensembles
	- Combining different models from the above to use all of their strengths, hybrid models are usually more robust

Using these techniques we can basically perform Forecasting, Classification, and Anomaly Detection

## Why Deep Learning for Time-Series?

Time-Series-Data is usually very complex, large, high-dimensional, and has intricate time dependencies that traditional
methods struggle with. It has been proven to be effective in capturing complex patterns in data, in fields such as image
recognition, OCR, autonomous driving, TTS, TTImg, etc.

DL Also has the benefit of removing the most painful part of using traditional ML techniques, it doesnt need any human
intervention It learns from raw-data alone, which means feature engineering is not required, only dataset cleaning is
required. Furthermore DL can also handle non-linearity and can capture super long-range dependencies

## Types of Time-Series-Data

Time-Series data can be categorized according to its characteristics, we can group the data by

- Number of variables: Univariate or Multivariate?
	- Univariate means one variable changes over time, Multivariate means several variables are changing w.r.t time
- Nature of the Data: Continuous or Discrete?
	- This ones pretty self-explanatory
- Statistical Properties: Stationary or Non-Stationary?
	- Stationary means that the data's mean variance and autocovariance remain relatively constant over time, most real-world datasets are Non-Stationary, and must be transformed into Stationary sets for accurate modelling

## Components of Time-Series-Data

Time series data might exhibit some of the following components:

- Trends
	- a long term movement upwards or downwards
- Seasonality
	- a repeating pattern at *regular* intervals (months, years, etc.)
- Cyclic Patterns
	- patterns that occur over *irregular* intervals (over long periods, beyond seasonality)
- Irregularity (Noise)
	- short-term unpredictable variations or random fluctuations in the data that cannot be easily explained

Each type of pattern requires specific analytical approaches, and finding the patterns in your data is the key to a good analysis.

## Estimating Trends

There are a few ways to estimate trends:

- Moving Averages are robust & simple
- Exponential Moving Average: reacts faster than normal Moving Average
- LOESS (Locally Weighted Smoothing): flexible and robust
- Regression (Linear, Poly, Spline): interpretable
- Decomposition (classical or STL) can isolate a smooth "trend" component

