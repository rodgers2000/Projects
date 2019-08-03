gbm_h2o_carrot <- function(group = Group){
  fitControl <- trainControl(## 5-fold CV
    method = "cv",
    number = 3,
    search = "grid", 
    verbose=FALSE, 
    allowParallel = TRUE)
  
  datControl = "range"
  
  gbmGrid <-  expand.grid(ntrees = 100,
                          max_depth = c(3, 7, 12), 
                          learn_rate = .01, 
                          min_rows = 20, 
                          col_sample_rate = .5) 
  
  gbm_fit = train(group$Train$X, factor(group$Train$Y), method = 'gbm_h2o',  
                  trControl = fitControl, tuneGrid = gbmGrid, preProcess = datControl)
  
  conjures = predict(gbm_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = gbm_fit
  return(group)
}
