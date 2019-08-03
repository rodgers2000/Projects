adjust_IDYX <- function(Brain2 = Brain){
  Brain2$Universe = Brain2$Universe[, c(1:5, 71, 6:70)]
  return(Brain2)
}
