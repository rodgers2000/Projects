PropTrans <- R6Class(
  # this class is used to perform a transformation on a proportion scalar. 
  # this will cause the predicted value to fall between 0 and 1. 
  # we want this for predicting a team's record for a season. 
  'PropTrans', 
  # methods 
  public = list(
    direct = function(prop) {
      # input: normal proportion
      # output: transformed proportion
      num = prop 
      den = 1 - prop
      return(log(num / den))
    }, 
    inverse = function(trans_prop) {
      # input: transformed proportion
      # output: normal proportion
      num = 1 
      den = exp(-trans_prop) + 1
      return(num / den)
    }
  )
)

# PropTrans$public_methods$direct(.5000)
# PropTrans$public_methods$inverse(0)