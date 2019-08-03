get_gbm_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "cv", number = 2, allowParallel = TRUE)
  
  datControl = c("range")
  
  gridControl = expand.grid(n.trees = 1000, 
                            interaction.depth = c(4, 6, 8),
                            shrinkage = .1, 
                            n.minobsinnode = 20)
  
  gbm_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                 method = "gbm", 
                 preProcess = datControl,
                 trControl = fitControl, 
                 tuneGrid = gridControl)
  
  Core2$Method$GBM$Yhat = predict(gbm_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
