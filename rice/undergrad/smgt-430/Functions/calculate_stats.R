calculate_stats <- function(dat_temp = dat_feat, stats = my_stats){
  ## this function calculates stats for a specific data set 
  ## it returns the stat matrix 
  library(e1071)
  stat_df = tibble('stats' = stats)
  for (col in 1:ncol(dat_temp)) {
    row = 1
    for (stat in stats) {
      stat_df[row, 1+col] = do.call(stat, list(dat_temp[[col]], na.rm = TRUE))
      row = row + 1
    }  
  }
  colnames(stat_df)[-1] = colnames(dat_temp)
  return(stat_df)
}