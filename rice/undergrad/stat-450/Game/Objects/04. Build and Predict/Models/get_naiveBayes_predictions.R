get_naiveBayes_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(fL = 0, usekernel = TRUE, adjust = FALSE)
  
  nb_fit = train(Core$Train$X, factor(Core$Train$Y), 
                  method = "naive_bayes", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Yhat = predict(nb_fit, newdata = Core$Test$X)
  return(Yhat)
}
