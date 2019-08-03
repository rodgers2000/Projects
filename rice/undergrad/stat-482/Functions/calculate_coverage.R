calculate_coverage <- function(dat = dat_UNIV){
  # give this function a tibble 
  mjr = apply(dat, 2, function(x) sum(is.na(x)) / length(x))
  names = names(mjr)
  df = as.tibble(1 - mjr)
  df$feature = names
  View(df)
}

