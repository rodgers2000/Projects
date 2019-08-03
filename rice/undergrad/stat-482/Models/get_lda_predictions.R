get_lda_predictions <- function(Core2 = Core[[year_holder]]){
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = NULL
  
  lda_fit = train(Core2$Book$Train$X, factor(Core2$Book$Train$Y), 
                  method = "lda", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  Core2$Method$LDA$Yhat = predict(lda_fit, newdata = Core2$Book$Test$X)
  return(Core2)
}
