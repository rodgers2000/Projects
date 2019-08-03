my_stability_selection <- function(Brain2 = Brain){
  library(glmnet)
  set.seed(2000)
  
  temp = Brain2$Universe[Brain2$Universe$Y %in% c(1, 3, 5), ]
  
  indices = sample(1:nrow(temp), 5000)
  
  X = temp[indices, c(7:71)] %>% as.matrix()
  Y = temp$Y[indices] %>% as.matrix()
  n_classes = unique(Y) %>% length()
  cvfit = cv.glmnet(x=X, y=factor(Y), family="multinomial") 
  # Lasso, the default is alpha = 1 and standardize X and include intercept, which is what we want
  reps = 100
  stability_sign_array = array(0, dim=c(ncol(X), reps, n_classes), dimnames=list(colnames(X), 1:reps, 1:n_classes))
  
  for(i in 1:reps){
    indices = sample(1:nrow(X), nrow(X), replace=TRUE) # bootin'
    fit = glmnet(x=X[indices, ], y=factor(Y[indices]), family="multinomial", lambda = min(cvfit$lambda))
    for(class in 1:n_classes){
      stability_sign_array[, i, class] = as.matrix(fit$beta[[class]]) %>% abs() %>% sign()
    }
    cat(i, "\n")
  }
  
  stability_score_array = array(0, dim=c(ncol(X), 1, n_classes), dimnames=list(colnames(X), "stability_score_", paste0(1:n_classes)))
  
  for(class in 1:n_classes){
    stability_score_array[,1,class] = apply(stability_sign_array[,,class], 1, mean) 
  }
  
  for(array in 1:n_classes){
    x = stability_score_array[,,array] 
    names = names(stability_score_array[,,array])
    write_csv(data.frame("Score" = x, "Feature" = names), paste0(getwd(), "/Results/Stability Scores/class", array, ".csv"))
  }
}