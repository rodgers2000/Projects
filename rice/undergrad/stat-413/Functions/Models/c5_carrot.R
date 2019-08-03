c5_carrot <- function(group = Group){
  fitControl <- trainControl(
    method = "none",
    verboseIter = TRUE, 
    allowParallel = TRUE)
  
  datControl = "range"
  
  gridControl = expand.grid(trials = 100, 
                            model = "tree", 
                            winnow = FALSE)
  
  method_fit = train(group$Train$X, factor(group$Train$Y), 
                     method = 'C5.0',
                     preProcess = datControl, 
                     trControl = fitControl,
                     tuneGrid = gridControl)
  
  group$Test$CrystalBall = predict(method_fit, group$Test$X)
  group$Test$Methods = method_fit
  
  return(group)
}

# mjr = ada_carrot()
# mjr$Test$Methods$Ada %>% plot()