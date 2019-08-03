rf_carrot <- function(group = Group$group1){
  
  fitControl = trainControl('oob', allowParallel = TRUE)
  
  datControl = "range"
  
  p = ncol(group$Train$X)
  
  gridContrl = expand.grid(mtry = c(1/2*sqrt(p), sqrt(p), 2*sqrt(p)))
  
  rf_fit = train(group$Train$X, factor(group$Train$Y), 
                 method = "rf", 
                 trControl = fitControl, 
                 tuneGrid = gridContrl, 
                 preProcess = datControl, 
                 ntree = 10000)
  
  conjures = predict(rf_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = rf_fit 
  return(group)
}
