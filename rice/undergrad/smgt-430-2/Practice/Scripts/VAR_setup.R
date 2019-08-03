library(forecast)
library(vars)
n = 50
get_data = function(){
  #sample(x = 0:4, size = n, replace = TRUE)
  rnorm(n)
}
a = ts(get_data())
b = ts(get_data())
c = ts(get_data())

#Run Augmented Dickey-Fuller tests to determine stationarity and differences to achieve stationarity.
diff_a = ndiffs(a, alpha = .05, test = 'adf')
diff_b = ndiffs(b, alpha = .05, test = 'adf')
diff_c = ndiffs(c, alpha = .05, test = 'adf')

#Difference to achieve stationarity
# you need an if because diff != 0 
a = diff(a, differences = diff_a)
b = diff(b, differences = diff_b)
c = diff(c, differences = diff_c)

my_ts = cbind(a, b, c)
my_ts = my_ts

#Lag optimization
optimal_model = VARselect(my_ts, lag.max = 10, type = 'both')
my_lag = optimal_model$selection[1]
#Vector autoregression with lags set according to results of lag optimisation. 
mjr = VAR(my_ts, p = my_lag)

#Test for serial autocorrelation using the Portmanteau test
#Rerun var model with other suggested lags if H0 can be rejected at 0.05
serial.test(mjr, lags.pt = my_lag, type = "PT.asymptotic")

# test = cbind(a=rnorm(10), b = rnorm(10), c = rnorm(10))

# yhat = predict(mjr, n.ahead = 20)
# yhat_a = round(yhat$fcst$a[,1])
# yhat_a = if_else(yhat_a < 0, 0, yhat_a)
# yhat_a = if_else(yhat_a > 4, 4, yhat_a)

predict(mjr, n.ahead = 20) %>% plot()
