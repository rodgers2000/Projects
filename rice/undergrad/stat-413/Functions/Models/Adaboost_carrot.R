Adaboost_carrot <- function(group = Group){
  fitControl <- trainControl(## 5-fold CV
    method = "cv",
    number = 5,
    search = "grid", 
    verboseIter = TRUE, 
    allowParallel = TRUE)
  
  datControl = "range"
  
  gbmGrid <-  expand.grid(mfinal = c(500,1000, 2000, 4000, 6000), 
                          maxdepth = c(4, 6, 8), 
                          coeflearn = c('Freund', 'Breiman', 'Zhu'))
  
  gbm_fit = train(group$Train$X, factor(group$Train$Y), method = 'AdaBoost.M1',  
                  trControl = fitControl, tuneGrid = gbmGrid, preProcess = datControl)
  
  conjures = predict(gbm_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = gbm_fit
  return(group)
}