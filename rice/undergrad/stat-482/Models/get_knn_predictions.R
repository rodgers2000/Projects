get_knn_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(k = 1)
  
  knn_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                  method = "knn", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Core2$Method$KNN$Yhat = predict(knn_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
