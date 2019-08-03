get_group_data <- function(dat_temp = dat_train, group_labs = 1:3){
  dat_hold = dat_temp %>% subset(activity %in% group_labs)
  # lets work with matrices 
  X = dat_hold %>% subset(select = -activity) %>% as.matrix()
  Y = dat_hold %>% subset(select = activity) %>% as.matrix()
  dat_return = list("X" = X, "Y" = Y)
  return(dat_return)
}
