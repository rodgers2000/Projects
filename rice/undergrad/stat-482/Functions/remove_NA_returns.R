remove_NA_returns <- function(Brain2 = Brain){
  Brain2$Returns = Brain2$Returns %>% subset(!is.na(return) & !is.na(return_div))
  return(Brain2)
}
