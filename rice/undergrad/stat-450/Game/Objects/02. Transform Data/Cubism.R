Cubism <- R6Class(
  'Cubism', 
  # attributes
  private = list(
    Book = NA
  ), 
  # methods
  public = list(
    initialize = function(time, ahead, Book){
      if (time < 1 | ahead < 1) {
        message('invalid time or ahead parameter')
      }
      # give a Book, receive a Book
      private$Book = Book
      # set params for Cubism
      private$Book$Params$time = time
      private$Book$Params$ahead = ahead
      private$Book$Params$transformation = 'Cubism'
    }, 
    compute_X = function(){
      # grab data and params
      df = private$Book$Raw$DF %>% subset(select = -date)
      time = private$Book$Params$time
      ahead = private$Book$Params$ahead
      # we start at time + 1 since there will be enough past data for the cube
      hold_me = 1
      valid_points = (time + 1):(nrow(df) - (ahead))
      # allocate memory for X 
      X = matrix(0, nrow = length(valid_points), ncol = ncol(df) * time)
      for (row in valid_points) {
        cubes = c()
        for (t in 1:time) {
          value = df[row, ] - df[row - t, ]
          value = if_else(value > 0, 1, 0)
          cubes = c(cubes, value)
        }
        X[hold_me, ] = cubes
        hold_me = hold_me + 1
      }
      # save X and create col names for caret train function
      private$Book$Raw$DS$X = data.frame(X)
      # since X dates depend on X values, we add it here 
      private$Book$Raw$DS$Date = private$Book$Raw$DF$date[valid_points]
    }, 
    compute_Y = function(){
      # grab data and params
      df = private$Book$Raw$DF %>% subset(select = -date)
      ahead = private$Book$Params$ahead
      time = private$Book$Params$time
      # initialize returns and labels 
      returns = c()
      labels = c()
      valid_points = (time + 1):(nrow(df) - (ahead))
      # since we did not lag X, we must lead Y 
      for (row in valid_points) {
        open = df$open[row + 1] # we buy at the next day's open 
        close = df$close[row + ahead] # if ahead = 1, then we buy at open, sell at close
        return = close / open - 1
        label = if_else(return > 0, 1, 0)
        # store data 
        labels = c(labels, label)
        returns = c(returns, return)
      }
      # save data in Book 
      private$Book$Raw$DS$Y$labels = labels
      private$Book$Raw$DS$Y$returns = returns
    },
    get_Book = function(){
      return(private$Book)
    }
  )
)

# mjr = QueryQuantmod$new('GOOG')
# mjr$query()
# mjr2 = Cubism$new(2, 2, mjr$get_Book())
# mjr2$compute_X()
# mjr2$compute_Y()
# a = mjr2$get_Book() %>% str()
# print(sum(is.na(a$Raw$DS$Y$labels)) == 0)