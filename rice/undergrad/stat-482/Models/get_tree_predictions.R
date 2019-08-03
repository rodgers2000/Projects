get_tree_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("range")
  
  gridControl = expand.grid(maxdepth = 29)
  
  tree_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                  method = "rpart2", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Core2$Method$TREE$Yhat = predict(tree_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
