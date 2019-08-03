get_svm_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "cv", number = 5)
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(cost = 2^(1:6))
  
  svm_fit = train(Core$Train$X, factor(Core$Train$Y), 
                    method = "svmLinear2", 
                    preProcess = datControl,
                    trControl = fitControl, 
                    tuneGrid = gridControl)
  
  Yhat = predict(svm_fit, newdata = Core$Test$X)
  return(Yhat)
}
