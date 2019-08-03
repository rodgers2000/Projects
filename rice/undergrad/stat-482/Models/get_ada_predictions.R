get_ada_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none", allowParallel = TRUE)
  
  datControl = c("range")
  
  gridControl = expand.grid(mfinal = 100, maxdepth = 4, coeflearn = 'Freund')
  
  ada_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                 method = "AdaBoost.M1", 
                 preProcess = datControl,
                 trControl = fitControl, 
                 tuneGrid = gridControl)
  
  Core2$Method$ADA$Yhat = predict(ada_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
