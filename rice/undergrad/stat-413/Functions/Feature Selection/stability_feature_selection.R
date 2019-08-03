stability_feature_selection <- function(group = Group$group1){
  library(stabs)
  # lets solve for Q 
  pfer = 1
  pie = .9
  p = ncol(group$Train$X)
  q = sqrt(pfer*p*(2*pie-1))
  
  cols = stabsel(group$Train$X, group$Train$Y, 
                 fitfun = glmnet.lasso, 
                 sampling.type = "SS", 
                 q = q, 
                 PFER = pfer)
  
  cat(cols$selected %>% length(), '\n')
  
  group$Train$X = group$Train$X[, cols$selected]
  group$Test$X = group$Test$X[, cols$selected]
  return(group)
}
