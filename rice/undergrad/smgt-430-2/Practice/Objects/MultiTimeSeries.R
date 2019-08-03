MultiTimeSeries <- R6Class(
  # this objects takes a list of time series and fits an AutoRegressive model to the data using the lowest IC 
  'MultiTimeSeries', 
  # attributes
  private = list(
    VAR_INFO = list(), # this is a mapping that contains all params for object 
    TS = NA, # this is going to be the matrix of time series for VAR
    model = NA 
  ), 
  # methods 
  public = list(
    initialize = function(TS, periods) {
      # inputs: 
      # 1. a list of time series that have win_pct as ts, TS 
      library(vars) # we will use this package for vector autoregressive model
      # for each time series
      for (ts in names(TS)) {
        # create an empty list for the time series
        private$VAR_INFO[[ts]] = list()
        # get the original time series
        x = PropTrans$public_methods$direct(TS[[ts]]$win_pct)
        ts_orig = ts(x, frequency = periods)
        # calculate number of differences 
        n_diffs = ndiffs(ts_orig, alpha = .05, test = 'adf', max.d = 3)
        # if there are differences needed, do 
        if (n_diffs > 0) {
          ts_diff = diff(ts_orig, differences = n_diffs)
        } else {
          ts_diff = ts_orig
        }
        # calculate initial values 
        # the most recent is at the end! so D1 = Xt - Xt-1
        # these are the values cut off, so save them for transformation
        ts_iv = ts_orig[1:n_diffs]
        # save the data! 
        private$VAR_INFO[[ts]]$initial_value = ts_iv
        private$VAR_INFO[[ts]]$diff_selected = n_diffs
        private$VAR_INFO[[ts]]$ts_orig = ts_orig
        private$VAR_INFO[[ts]]$ts_diff = ts_diff
      }
      # create times series matrix 
      ts_names = names(private$VAR_INFO)
      # calculate the smallest n 
      n_min = private$VAR_INFO[[ts_names[1]]]$ts_diff %>% length()
      # for each time series
      for (ts in ts_names[-1]) {
        n_temp = private$VAR_INFO[[ts]]$ts_diff %>% length()
        # if we have a new min, do 
        if (n_temp < n_min) {
          n_min = n_temp
        }
      }
      # use this n for the data frame values 
      TS = data.frame(index = 1:n_min)
      hold_me = 1
      # for each time series
      for (ts in names(private$VAR_INFO)) {
        n_temp = private$VAR_INFO[[ts]]$ts_diff %>% length()
        if (n_temp > n_min) {
          n_diff = n_temp - n_min
          # get rid of the oldest points so that all time series match length 
          ts_temp = private$VAR_INFO[[ts]]$ts_diff[-(1:n_diff)] 
        } else {
          ts_temp = private$VAR_INFO[[ts]]$ts_diff
        }
        TS[[paste0('ts_', hold_me)]] = ts_temp
        hold_me = hold_me + 1
      }
      # remove index 
      TS = TS[, -1]
      # save it! now we have a matrix of time series!
      private$TS = TS
    }, 
    auto_fit = function() {
      # vector autoregressive model 
      method = VAR(private$TS, lag.max = 10, ic = 'AIC')
      private$model = method
    }, 
    predict_it = function(n_ahead) {
      # predit the future 
      yhat = predict(private$model, n.ahead = n_ahead, ci = 0.95)
      crystal_ball = data.frame()
      # for each time series 
      for (ts in 1:length(private$VAR_INFO)) {
        # get predictions for time series
        yhat_temp = yhat$fcst[ts][[1]]
        # get time series values 
        temp_n_diff = private$VAR_INFO[[ts]]$diff_selected
        temp_ini_val = private$VAR_INFO[[ts]]$initial_value
        temp_ts_diff = private$VAR_INFO[[ts]]$ts_diff
        temp_name = names(private$VAR_INFO)[ts]
        # initialize data for transformation
        row_yhat = c()
        # for each predicted value 
        for (pred_temp in yhat_temp) {
          if (temp_n_diff > 0) {
            # use diff inverse
            inv_1 = DifferenceTrans$public_methods$inverse(ts = c(temp_ts_diff, pred_temp), num_d = temp_n_diff, ts_i = temp_ini_val)
            # then prop inverse
            inv_2 = PropTrans$public_methods$inverse(inv_1[length(inv_1)])
            row_yhat = c(row_yhat, inv_2) 
          } else {
            # use prop inverse
            inv_1 = PropTrans$public_methods$inverse(pred_temp)
            row_yhat = c(row_yhat, inv_1)
          }
        }
        # now we have transformed the data back to normal 
        this_row = data.frame(temp_name, t(row_yhat))
        colnames(this_row) = c('team', 'yhat', 'lower', 'upper' ,'ci')
        # bind by row to create a matrix of predictions
        crystal_ball = rbind(crystal_ball, this_row)
      }
      return(crystal_ball)
    }
  )
)

mjr = MultiTimeSeries$new(TeamTimeSeries[15:20], periods = 1)
mjr$auto_fit()
mjr$predict_it(n_ahead = 1)
