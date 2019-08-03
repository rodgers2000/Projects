adjust_Y <- function(Brain2 = Brain){
  temp = Brain2$Universe
  temp = temp %>% group_by(GVKEY) %>% 
    mutate(Y = lead(return_label, 1)) %>% ungroup()
  
  # we assume that NA returns mean that a company either went private or bankrupt, but we dont know which one, so we 
  # erased them. 
  temp = temp %>% subset(!is.na(Y), select = -return_label)
  Brain2$Universe = temp
  return(Brain2)
}
