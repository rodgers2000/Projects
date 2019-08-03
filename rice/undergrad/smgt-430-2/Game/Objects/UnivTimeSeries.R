UnivTimeSeries <- R6Class(
  'UnivTimeSeries', 
  # attributes
  private = list(
    X = NA, # random variable
    model = NA 
  ), 
  # methods
  public = list(
    initialize = function(ts, periods) {
      # will use this for [0,1] interval
      source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
      library(forecast) # we will use this library for univariate models
      # ts is a time series vector
      # tranform proportion for bounding prediction between 0 and 1.
      x = PropTrans$public_methods$direct(ts)
      private$X = ts(x, frequency = periods)
    }, 
    get_model = function() {
      return(private$model)
    }, 
    auto_fit = function() {
      method = auto.arima(private$X, max.order = 50)
      private$model = method
    }, 
    manual_fit = function(O, S) {
      # O and S are vectors that correspond to the order and seasonal ranks
      # O = p, d, q
      # S = P, D, Q
      method = Arima(private$X, order = O, seasonal = S, method = 'ML')
      private$model = method
    }, 
    xreg_fit = function(xregs) {
      method = auto.arima(private$X, max.order = 50, xreg = xregs)
      private$model = method
    }, 
    predict_it = function(n_ahead, xregs = NA) {
      if (is.na(xregs)) {
        yhat = forecast(private$model, h = n_ahead, level = c(95))
        yhat = PropTrans$public_methods$inverse(data.frame(yhat))
        return(yhat)
      } else {
        yhat = forecast(private$model, h = n_ahead, level = c(95), xreg = xregs)
        yhat = PropTrans$public_methods$inverse(data.frame(yhat))
        return(yhat)
      }
    }
  )
)

# mjr = UnivTimeSeries$new(TeamTimeSeries$`Houston Astros`$win_pct, 1)
# mjr$auto_fit()
# # mjr$manual_fit(O = c(10, 4, 5), S = c(1, 1, 3))
# # mjr$tbats_fit()
# mjr$predict_it(n_ahead = 1)
# omg = mjr$get_model()
# 
# regressor = TeamTimeSeries$`New York Mets`$win_pct
# mjr2 = UnivTimeSeries$new(regressor, 1)
# mjr2$auto_fit()
# mjr$xreg_fit(xregs = regressor)
# mjr$predict_it(n_ahead = 1, xregs = mjr2$predict_it(n_ahead = 1)[1])
