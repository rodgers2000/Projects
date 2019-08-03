get_gbm_predictions <- function(Core){
  # input: a mapping to the train and test X, Y data.
  # outputs: predictions 
  fitControl = trainControl(method = "cv", number = 2, allowParallel = TRUE)
  
  datControl = c("range")
  
  gridControl = expand.grid(n.trees = 1000, 
                            interaction.depth = c(4, 6, 8),
                            shrinkage = .1, 
                            n.minobsinnode = 20)
  
  gbm_fit = train(Core$Train$X, factor(Core$Train$Y), 
                 method = "gbm", 
                 preProcess = datControl,
                 trControl = fitControl, 
                 tuneGrid = gridControl)
  
  Yhat = predict(gbm_fit, newdata = Core$Test$X)
  return(Yhat)
}
