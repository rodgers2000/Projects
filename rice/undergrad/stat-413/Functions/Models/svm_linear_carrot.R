svm_linear_carrot <- function(group = Group$group1){
  fitControl = trainControl(method = "cv", number = 5, search = "grid", allowParallel = TRUE)
  
  gridControl = expand.grid(cost = 2^(c(2, 4, 6)))
  
  datControl = NULL
  
  svm_fit = train(group$Train$X %>% scale(), factor(group$Train$Y), method = "svmLinear2", 
                  trControl = fitControl, tuneGrid = gridControl, 
                  preProcess = datControl)
  
  conjures = predict(svm_fit, newdata = group$Test$X %>% scale())
  group$Test$CrystalBall = conjures
  group$Test$Method = svm_fit
  return(group)
}
