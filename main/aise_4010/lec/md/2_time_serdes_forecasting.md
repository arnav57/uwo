# Time Series Forecasting (Statistical Models)

## Forecasting,

In practice most of the time series represent \kw{stochastic} characteristics, and clearly the future values of the time-series cannot be precisely predicted,
In other words there will always be some error with forecasting.

In order to forecast there are two fundamentally different strategies

- ML based (learn variations)
- Statistical based (system identification using a linear/nonlinear model such as ARIMA and SARIMA)

## Cleaning the Data

For stats based forecasting, having clean data is *very* important. Cleaning data involves:

- Handling missing data and outliers
- Changing frequency
- Removing non-stationary effects, as some stats based models cannot handle non-stationary data

## Handling Missing Time-Series Data

this is *very* common, and it is necessary to find the time values that are missing from the time-series, it is very frequent in time-seres due to the burden of
long-term sampling. Some methods allow for missing values, but others do not.

The challenging part is that we cannot just put in some random data, as we want to ensure that all repeating patterns are still present, breaking this rule may effect
the quality of the forecasting from the model.

There are two types of missing values:

- \kw{MAR (Missing at Random)}
	- Variable has missing values that are randomly distributed, however they are related to some other variables values
- \kw{MNAR (Missing not at Random/Systematic Missing Data)}
	- TODO:

The most common methods to address missing data in time-series are:

- \kw{Imputation}: fill in missing data based on observations on the entire dataset
- \kw{Interpolation}: when we use neighbouring data-points to estimate the missing value. Interpolation can also be a form of Imputation
- \kw{Deletion} of affected time periods: when we choose not to use time-periods that have missing data at all. This risks losing information, and it will result in less data/patterns for your model to learn!

### Deletion

This is the easiest way of handling missing data, but might result in some information loss, this is *not* suitable for large amounts of missing data

### Statistical Imputation

Here we replace the missing data with the mean, median or mode of the variable, it is one of the most common methods. Its best to use this when the data is missing at random (MAR)
and when the % missing values is very low.

### Forward & Backward Fill

This is another type of way to handle missing time-series data, and its also very simple. Essentially when there is a trend/pattern that continues from one point to the next
we will fill missing values using the most recent (succeeding, or preceeding) value.

In this method we dont consider any relationships between data values, and its bst when dealing with time-series that show a relatively stable trend, or when missing values occur in consecutive intervals
Note that backwards filling should only be done when not trying to forecast.

### Linear Interpolation

Filling a missing data point by assuming a line between the nearest neighbours, this is a simple and fast approach.

We can use this if there is only linear relationships in the dataset, if there are non-linearities (seasonality, etc) this is not the best type of method as it will disrupt the seasonal pattern

### Regression Imputation

A method of imputing missing values by using the relationships between the data. In this method a regression model is used to predict the missing values based on the dataset.
This can be used when the data is numeric, and there is a strong correlation between the variable with missing values and other variables.

### KNN Imputation

K-Nearest-Neighbors is finding the K-nearest neighbors to the observation with missing data, and imputing them based on the non-missing-values in the neighbors
Its best to use this when the data are MAR, its easy to implement, but it should not be used for high-dimensional data due to computational overhead.

### Seasonal-Trend Decomposition

This method can capture complex-seasonal patterns that other imputation methods might miss. It can handle any type of seasonality, but its not appropriate to use if the
dataset has a high level of noise due to the magnitude of the residual component compared to the trend and seasonality. If there is a high level of noise its best to use robust STL.

## Upsampling and Downsampling

Resampling refers to the change of the freuqency in time-series observations. But why would we resample?

- Matching frequencies: Aligning time-series data from different sources or for different analyses that require a consistent frequency.
- Data Exploration: examining data behaviour at different resolutions to gain insights
- Computational Efficiency: Downsampling can reduce dataset size and the computational load for analysis or model training.
- Modelling Requirements: Some models may require data at a specific frequency

Upsampling means increasing the timestamp frequency, Downsampling is the opposite. Often with Upsampling we use Interpolation techniques to produce new data
Commonly we use polynomial interpolation to carry this out.

Downsampling would be carried out by aggregating multiple observations. You can take the mean of these points, etc.

## Removing Non-Stationary Effect

When a time series is \kw{stationary} is can be easier to model. Many stats based modelling techniques assume the data is stationary to be effective. This means
that we will have to make non-stationary data into stationary data.

Time series data are stationary if they do not have a trend or seasonal effects. Summary statisitcs calculation on the time series are consistent over time, like 
the mean the variance or the autocorrelation of the observations.

So how can we tell if our data is stationary?

- Visual inspection
	- can be unreliable
- Summary statistics
- Statistical tests (KPSS, ADF)
	- this is the most accurate way
- Autocorrelation Function (ACF)

### Summary Statistics

This is a "quick and dirty" check, but it can be wrong. Essentially this works by splitting the data into two/more partitions and comparing the mean/variance of each group
If they differ significantly, the data is likely to be non-stationary

### Statistical Tests

Statistical tests (unit root tests) always gives you the right answer. it makes strong assumptions about your data. They can only be used to inform the degree to which a null
hypothesis can be rejected, or not be rejected.

- Augmented Dickey-Fuller (ADF)
- Kwaitkowski-Philips-Schmidt-Shin (KPSS)

In ADF:

- Null hypothesis $H_0$ if not rejected, the suggests the time series have a unit-root, meaning it is non-stationary, so it has some time-dependent structure
- Altnerate hypothesis $H_1$, is $H_0$ is rejected, suggests the opposite of $H_0$
- Interpreting the p-value
	- if $p \leq 0.05$ reject $H_0$(stationary)
	- if $p > 0.05$ accept $H_0$ (non-stationary)

Note that KPSS is the inverse of ADF, so $H_0$ and $H_1$ are swapped.

### Autocorrelation & Partial Autocorrelation Function

Autocorrelation analysis is an important step in the Exploratory Data Analaysis (EDA) of Time-series. It helps to detect hidden patterns and seasonality, it also helps in checking
for randomness.

It is very important when using an ARIMA model for forecasting because the autocorrelation helps to indentify the AR and MA parameters for the model.

The autocorrelation function (ACF):: is a correlation between a time-series and its own past values at different time lags (ACF at lag $k$ is the correlation betwen time series values at time $t$ and time $t-k$)

the partial ACF (PACF): TODO

We can use ACF/PACF to determine if data is stationary or non-stationary. In stationary data the ACF/PACF might have a few spikes but WILL quickly decay to 0
Non-stationary data has the ACF/PACF shows no gradual decay, or very slow decay in addtion to spikes at the start. However this is not always the best approach.

### Making Time-Series Stationary

We can do this by eliminating the trend, and reducing the seasonality.

- Transforms such as $\log{}$ can help stabilize the variance of a time-series
- Differencing cann help stabilize the mean of time-series by removing changes in the level of a time-series $y_t = y_t - y_{t-1}$

We can apply a lag-2 or second order differenced, occasionally the differenced data will not appear stationary, and may be necessary to difference it again. Going beyond second orders
are typically not needed

$$
y_t - y_{t-1} - ( y_{t-1} - y_{t-2} ) = y_t - 2y_{t-1} + y_{t-2}
$$

Lag-$m$ or seasonal differincing, it removes the seasonal effect between an observation and a previous observation during the same season. Here $m$ is the number of seasons

$$
y_t - y_{t-m}
$$

## ARIMA Model Based Prediction

ARIMA stands for "auto-regressive integrated moving average", it features three parts

-  The Autoregressor
-  The Integrator
-  The Moving Average

This model is a class of linear model, that uses past data-values to forecast future values. It can handle non-stationary data.

### The Autoregressor

This is essentially predicting a variable with a linear combination of predictors. The AR model assumes that the current point $y_t$ is dependent on previous values
due to this assumption we can build a linear-regression model.

The term autoregression indicates that it is a regression of the variable against itself. These models are quite flexibile at handling a wide range of different
time-series patterns.

We define an auto-regressive model of order $p$ as $\text{AR}\left(p\right)$ as below

$$
\text{AR}\left( p \right) = c + a_1 y_{t-1} + a_2 y_{t-2} + \dots + a_p y_{t-p} + \epsilon_{\text{whitenoise}}
$$

The ACF/PACF can be used to estimate the parameters for our AR. TODO

### The Moving Average

Rather than using past-values of the forecasr variable in a regression, the moving average model uses past forecast errors in a regression-like model
The MA model assumes that the current value $y_t$ is dependent on the error terms, including the current error

We define a moving-avergae model of order $q$ as $\text{MA}\left(q\right)$ as below

$$
\text{MA}\left(q\right) = c + \epsilon_{\text{whitenoise}} + a_1 \epsilon_1 + a_2 \epsilon_2 + \dots + a_q \epsilon_q
$$

### The ARIMA

If we combine differencing with the ARMA model, we can the ARIMA model. We define an ARIMA model with order $p$ $d$ and $q$ as below

$$
\text{ARIMA} \left( p, d, q \right):
$$

$$
y_{t}' = c + \Sigma_{n=1}^{p} a_n y_{t-n}' + \Sigma_{n=1}^{q} b_n \epsilon_{t-n}
$$

