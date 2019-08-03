get_naiveBayes_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(fL = 0, usekernel = TRUE, adjust = FALSE)
  
  nb_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                  method = "naive_bayes", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Core2$Method$NB$Yhat = predict(nb_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
