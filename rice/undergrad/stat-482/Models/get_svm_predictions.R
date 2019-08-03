get_svm_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "cv", number = 5)
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(cost = 2^(1:6))
  
  svm_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                    method = "svmLinear2", 
                    preProcess = datControl,
                    trControl = fitControl, 
                    tuneGrid = gridControl)
  
  Core2$Method$SVM$Yhat = predict(svm_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
