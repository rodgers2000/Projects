lda_carrot <- function(group = Group){
  
  fitControl = trainControl(allowParallel = TRUE)
  
  datControl = c("center", "scale")
  
  method_fit = train(group$Train$X, factor(group$Train$Y), method = "lda", 
                  preProcess = datControl, trControl = fitControl)
  
  conjures = predict(method_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = method_fit
  return(group)
}
