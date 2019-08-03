the_stack_carrot <- function(group = Group, models = 5){
  
  matrix = matrix(0, nrow = nrow(group$Test$X), ncol = models)
  df_predictions = as.data.frame(matrix)
  final_predictions = vector("double", nrow(group$Test$X))
  
    fitControl = trainControl('none', verboseIter = FALSE, allowParallel = TRUE)
    
    datControl = NULL
    
    gridControl = expand.grid(mtry = sqrt(ncol(group$Train$X)))
    
    method_fit = train(group$Train$X, factor(group$Train$Y),
                       method = 'rf',
                       preProcess = datControl, 
                       trControl = fitControl, 
                       tuneGrid = gridControl, 
                       ntree = 500)
    
    df_predictions[, 1] = predict(method_fit, group$Test$X)
    
    cat(1, "\n")
    
    method_fit = train(group$Train$X %>% scale(), factor(group$Train$Y), method = "lda", 
                       preProcess = datControl, trControl = fitControl)
    
    df_predictions[, 2] = predict(method_fit, newdata = group$Test$X %>% scale())
    
    cat(2, "\n")
    
    fitControl = trainControl(method = "cv", number = 2, search = "grid", allowParallel = TRUE)
    
    gridControl = expand.grid(cost = 2^(c(2, 4, 6)))
    
    datControl = NULL
    
    svm_fit = train(group$Train$X %>% scale(), factor(group$Train$Y), method = "svmLinear2", 
                    trControl = fitControl, tuneGrid = gridControl, 
                    preProcess = datControl)
    
    df_predictions[, 3] = predict(svm_fit, newdata = group$Test$X %>% scale())
    
    cat(3, "\n")
    
    fitControl = trainControl(method = "none", allowParallel = TRUE)
    
    gridControl = expand.grid(mtry = ncol(group$Train$X))
    
    method_fit = train(group$Train$X, factor(group$Train$Y),
                       method = 'rf',
                       preProcess = datControl, 
                       trControl = fitControl, 
                       tuneGrid = gridControl, 
                       ntree = 500)
    
    df_predictions[, 4] = predict(method_fit, newdata = group$Test$X %>% scale())
  
    cat(4, "\n")
  
    fitControl = trainControl(method = "cv", number = 2, search = "grid", allowParallel = TRUE)
    
    gridControl = expand.grid(C = 2^(c(2, 4, 6)), sigma = 0.0009765625)
    
    datControl = NULL
    
    svm_fit = train(group$Train$X %>% scale(), factor(group$Train$Y), method = "svmRadial", 
                    trControl = fitControl, tuneGrid = gridControl, 
                    preProcess = datControl)
    
    df_predictions[, 5] = predict(svm_fit, newdata = group$Test$X %>% scale())
    
    cat(5, "\n")
    
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
