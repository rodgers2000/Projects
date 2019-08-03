library(R6)

Cubism <- R6Class(
  'Cubism', 
  # attributes
  private = list(
    time = NA,
    ahead = NA, 
    DS = list('X' = NA, 'Y' = list('labels' = NA, 'returns' = NA)), 
    DF = NA
  ), 
  # methods
  public = list(
    initialize = function(time, ahead, DF){
      private$time = time
      private$ahead = ahead
      private$DF = DF
      private$DS$X = matrix(0, nrow = nrow(DF)-time, ncol = time*(ncol(DF)-1))
    }, 
    compute_X = function(){
      # we dont need date 
      df = private$DF %>% subset(select = -date)
      # store n 
      n = nrow(df)
      # create a function that computes the cube for each row 
      cubical <- function(start = 1, time = 2){
        row = c()
        for (t in 1:time) {
          value = (df[start, ] - df[start+t, ]) %>% as.double()
          value = if_else(value > 0, 1, 0)
          row = c(row, value)
        }
        return(row)
      }
      # for each entry that it is allowed: index < nrow - t + 1
      # this means that we need the previous data or else we can't compute it, so drop it
      for (row in 1:n) {
        if (row < n - private$time + 1) {
          private$DS$X[row, ] = cubical(row, private$time)
        } else {
          break
        }
      }
      # now we have computed the X cubism matrix
      # we need to add date back into X, so that we can condition the model
      private$DS$X = cbind(private$DF$date[1:(nrow(private$DS$X))], data.frame(private$DS$X))
      colnames(private$DS$X)[1] = 'date'
    }, 
    compute_Y = function() {
      # initialize sequences
      labels = c()
      returns = c()
      indices = c()
      for (day in private$ahead:nrow(private$DS$X)) {
        # we buy in at the open and 1 day ahead means we sell at the close of that day. 
        # 2 days ahead means we sell at the close of the next day. 
        close = private$DF$close[day-private$ahead+1]
        open = private$DF$open[day]
        return = close / open - 1
        label = if_else(return > 0, 1, 0)
        labels = c(labels, label)
        returns = c(returns, return)
        indices = c(indices, day)
      }
      # now we have the true labels and returns
      # save data 
      private$DS$Y$labels = labels
      private$DS$Y$returns = returns
      # we have to change X too!
      private$DS$X = private$DS$X[indices, ]
    }, 
    get_DS = function() {
      return(private$DS)
    }
  )
)

# test code 
# mjr = QuantmodStock$new()
# mjr$query_quantmod()
# mjr2 = Cubism$new(3, 3, mjr$get_DF())
# mjr2$compute_X()
# mjr2$compute_Y()
# mjr2$get_DS()[['X']] %>% head()
# mjr2$get_DS()[['Y']][['labels']] %>% head()
