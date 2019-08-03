step_lda_carrot <- function(group = Group){
  
  fitControl = trainControl(allowParallel = TRUE)
  
  datControl = NULL
  
  gridControl = NULL
  
  method_fit = train(group$Train$X %>% scale(), factor(group$Train$Y), 
                     method = "Linda",
                     preProcess = datControl, 
                     trControl = fitControl, 
                     tuneGrid = gridControl)
  
  conjures = predict(method_fit, newdata = group$Test$X %>% scale())
  group$Test$CrystalBall = conjures
  group$Test$Method = method_fit
  return(group)
}
