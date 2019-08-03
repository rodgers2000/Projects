calculate_mspe <- function(yhat, y) {
  this_vec = yhat - y
  this_sum = t(this_vec) %*% this_vec
  this_sum = this_sum / length(y)
  return(sqrt(this_sum) %>% as.double())
}

# calculate_mspe(1:2, 3:4)
