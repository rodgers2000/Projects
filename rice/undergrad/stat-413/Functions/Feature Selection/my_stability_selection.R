my_stability_selection <- function(group = Group){
  library(glmnet)
  set.seed(2000)
  X = group$Train$X
  Y = group$Train$Y
  n_classes = unique(Y) %>% length()
  cvfit = cv.glmnet(x=X, y=factor(Y), family="multinomial") 
  # Lasso, the default is alpha = 1 and standarize X and include intercept, which is what we want
  reps = 50
  stability_sign_array = array(0, dim=c(ncol(X), reps, n_classes), dimnames=list(colnames(X), 1:reps, 1:n_classes))
  
  for(i in 1:reps){
    indices = sample(1:nrow(X), nrow(X), replace=TRUE) # bootin'
    fit = glmnet(x=X[indices, ], y=factor(Y[indices]), family="multinomial", lambda=cvfit$lambda.1se)
    for(class in 1:n_classes){
      stability_sign_array[, i, class] = as.matrix(fit$beta[[class]]) %>% abs() %>% sign()
    }
    cat(i, "\n")
  }
  
  stability_score_array = array(0, dim=c(ncol(X), 1, n_classes), dimnames=list(colnames(X), "stability_score_", paste0(1:n_classes)))
  
  for(class in 1:n_classes){
    stability_score_array[,1,class] = apply(stability_sign_array[,,class], 1, mean) 
  }
  
  average_score = stability_score_array[,,1]
  
  for(dim in 2:n_classes){
    average_score = stability_score_array[,,dim] + average_score
  }
  
  # saveRDS(stability_score_array, paste0(getwd(), "/Data/stability scores (for each class)"))
  
  average_score = average_score / n_classes 
  
  average_score = average_score[average_score > .60]
  
  group$Train$X = group$Train$X[, colnames(group$Train$X) %in% names(average_score)]
  group$Test$X = group$Test$X[, colnames(group$Test$X) %in% names(average_score)]
  return(group)
}