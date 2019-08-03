adjust_return_features <- function(Brain2 = Brain){
  Brain2$Returns = Brain2$Returns %>% mutate(datadate = ymd(datadate), cyear = year(datadate))
  return(Brain2)
}
