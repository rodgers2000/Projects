get_lasso_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(decay = 1)
  
  lasso_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                  method = "multinom", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl, 
                  MaxNWts = 2000000)
  
  Core2$Method$LASSO$Yhat = predict(lasso_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
