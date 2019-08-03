adjust_high_returns <- function(Brain2 = Brain, cutoff = 100){
  
  if(cutoff > max(Brain2$Returns$return))
    warning("You arent filtering anything!!")
  else
    high_returns = Brain2$Returns$return > cutoff
  
  Brain2$Returns = Brain2$Returns[-which(high_returns), ]
  Brain2$Universe = Brain2$Universe[-which(high_returns), ]
  return(Brain2)
}
