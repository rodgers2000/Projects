get_rf_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "none")
  
  datControl = c("range")
  
  gridControl = expand.grid(mtry = sqrt(ncol(Core$Train$X)))
  
  rf_fit = train(Core$Train$X, factor(Core$Train$Y), 
                    method = "rf", 
                    preProcess = datControl,
                    trControl = fitControl, 
                    tuneGrid = gridControl)
  
  Yhat = predict(rf_fit, newdata = Core$Test$X)
  return(Yhat)
}
