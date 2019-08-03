use_p_feature_selection <- function(group = Group$group1, p = 10){
  # all feature selection functions will return a new list with features selected 
  columns = sample(1:ncol(group$Train$X), p)
  group$Train$X = group$Train$X[, columns]
  group$Test$X = group$Test$X[, columns]
  return(group)
}
