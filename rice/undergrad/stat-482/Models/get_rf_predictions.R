get_rf_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("range")
  
  gridControl = expand.grid(mtry = sqrt(ncol(Core2$Book$Train$X)))
  
  rf_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                    method = "rf", 
                    preProcess = datControl,
                    trControl = fitControl, 
                    tuneGrid = gridControl)
  
  Core2$Method$RF$Yhat = predict(rf_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
