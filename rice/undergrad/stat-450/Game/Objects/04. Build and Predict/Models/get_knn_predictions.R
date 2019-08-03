get_knn_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(k = 1)
  
  knn_fit = train(Core$Train$X, factor(Core$Train$Y), 
                  method = "knn", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Yhat = predict(knn_fit, newdata = Core$Test$X)
  return(Yhat)
}
