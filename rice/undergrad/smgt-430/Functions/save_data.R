save_data <- function(df, path){
  write_csv(df, paste0(path, '.csv'))
}