importance_selection <- function(group = Group){
  # all feature selection functions will return a new list with features selected 
  library(randomForest)
  
  rf = randomForest(group$Train$X, factor(group$Train$Y), 
                    ntree = 500,  
                    mtry = sqrt(ncol(group$Train$X))
                    )
  # 184 are kept with m try = p 
  # sqrt p keeps 490
  keep_vars = importance(rf, type = 2)
  feat_all = rownames(keep_vars)
  feat_keep = feat_all[keep_vars > 1]
  
  group$Train$X = group$Train$X[, colnames(group$Train$X) %in% feat_keep]
  group$Test$X = group$Test$X[, colnames(group$Test$X) %in% feat_keep]
  
  return(group)
}
