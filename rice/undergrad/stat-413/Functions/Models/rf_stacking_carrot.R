rf_stacking_carrot <- function(group = Group, models = 19){
  
  matrix = matrix(0, nrow = nrow(group$Test$X), ncol = models)
  df_predictions = as.data.frame(matrix)
  final_predictions = vector("double", nrow(group$Test$X))
  
  for(model in 1:models){
    fitControl = trainControl('none', verboseIter = FALSE, allowParallel = TRUE)
    
    datControl = NULL
    
    gridControl = expand.grid(mtry = sqrt(ncol(group$Train$X)))
    
    method_fit = train(group$Train$X, factor(group$Train$Y),
                       method = 'rf',
                       preProcess = datControl, 
                       trControl = fitControl, 
                       tuneGrid = gridControl, 
                       ntree = 900)
    
    df_predictions[, model] = predict(method_fit, group$Test$X)
    cat(model, "\n")
  }
  
  for(row in 1:nrow(df_predictions)){
    temp = df_predictions[row, ] %>% as.matrix() %>% table()
    pred = which.max(temp) %>% names() %>% as.double()
    final_predictions[row] = pred
  }
  
  group$Test$CrystalBall = final_predictions
  group$Test$STACK = df_predictions
  group$Test$Method = method_fit
  
  return(group)
}

