DifferenceTrans <- R6Class(
  'DifferenceTrans', 
  # methods
  public = list(
    direct = function(ts, num_d) {
      diff_ts = diff(x = ts, differences = num_d)
      return(diff_ts)
    }, 
    inverse = function(ts, num_d, ts_i) {
      # inputs: 
      # 1. difference ts, ts. 
      # 2. number of differences, num_d. 
      # 3. time series initial values, ts_i
      inv_diff_ts = diffinv(x = ts, differences = num_d, xi = ts_i)
      return(inv_diff_ts)
    }
  )
)

# d = 1
# x = 1:10
# mjr1 = DifferenceTrans$public_methods$direct(x, d) # difference != 0
# DifferenceTrans$public_methods$inverse(c(mjr1, 0), d, 1:2)