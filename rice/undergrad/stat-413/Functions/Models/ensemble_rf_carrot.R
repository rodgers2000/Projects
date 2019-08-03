erf_carrot <- function(group = Group$group1){
  
  fitControl = trainControl(allowParallel = TRUE)
  
  gridControl = expand.grid(maxinter = 1000, 
                            mode = 'mean')
  
  datControl = NULL
  
  method_fit = train(group$Train$X, factor(group$Train$Y), 
                     method = "nodeHarvest", 
                     preProcess = datControl, 
                     tuneGrid = gridControl, 
                     trControl = fitControl)
  
  conjures = predict(method_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = method_fit
  return(group)
}
