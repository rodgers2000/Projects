knn_carrot <- function(group = Group$group1){
  fitControl = trainControl(method = "none")
  
  datControl = c("center", "scale")
  
  gridControl = expand.grid(k = 10)
  
  knn_fit = train(group$Train$X, factor(group$Train$Y), 
                  method = "knn", 
                  preProcess = datControl,
                  trControl = fitControl, 
                  tuneGrid = gridControl)
  
  group$Test$CrystalBall = predict(knn_fit, newdata = group$Test$X)
  return(group)
}

# mjr = knn_carrot()
# compute_ce(mjr$Test$CrystalBall)
