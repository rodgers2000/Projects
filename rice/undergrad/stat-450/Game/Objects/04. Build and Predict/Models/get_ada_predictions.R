get_ada_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "none", allowParallel = TRUE)
  
  datControl = c("range")
  
  gridControl = expand.grid(mfinal = 100, maxdepth = 4, coeflearn = 'Freund')
  
  ada_fit = train(Core$Train$X, factor(Core$Train$Y), 
                 method = "AdaBoost.M1", 
                 preProcess = datControl,
                 trControl = fitControl, 
                 tuneGrid = gridControl)
  
  Yhat = predict(ada_fit, newdata = Core$Test$X)
  return(Yhat)
}
