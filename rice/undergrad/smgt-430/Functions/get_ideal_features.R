get_ideal_features <- function(dat_temp, features){
  dat_hold = dat_temp[, colnames(dat_temp) %in% features]
  return(dat_hold)
}
