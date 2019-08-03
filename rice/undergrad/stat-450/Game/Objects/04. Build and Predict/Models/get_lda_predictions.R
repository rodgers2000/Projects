get_lda_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = NULL
  
  lda_fit = train(Core$Train$X, factor(Core$Train$Y), 
                  method = "lda", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Yhat = predict(lda_fit, newdata = Core$Test$X)
  return(Yhat)
}
