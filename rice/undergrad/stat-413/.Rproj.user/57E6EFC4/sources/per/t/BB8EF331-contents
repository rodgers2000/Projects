gbm_carrot <- function(group = Group){
  
  group$Train$Y = if_else(group$Train$Y == 1, "a", 
                          if_else(group$Train$Y == 2, "b", 
                                  if_else(group$Train$Y == 3, "c", 
                                          if_else(group$Train$Y == 4, "d", 
                                                  if_else(group$Train$Y == 5, "e", "f")))))
  
  
  fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 3,
    repeats = 1, 
    verboseIter = TRUE, 
    classProbs = TRUE, 
    allowParallel = TRUE, 
    summaryFunction = multiClassSummary)
  
  datControl = NULL
  
  gbmGrid <-  expand.grid(interaction.depth = c(4, 6, 8), 
                          n.trees = c(1000, 1500, 2000), #(5:30)*50
                          shrinkage = 0.01,
                          n.minobsinnode = 20)
  
  gbm_fit = train(group$Train$X, group$Train$Y, 
                  method = 'gbm',  
                  trControl = fitControl, 
                  tuneGrid = gbmGrid,
                  preProcess = datControl, 
                  metric = "logLoss", #logLoss
                  maximize = FALSE)
  
  conjures = predict(gbm_fit, newdata = group$Test$X)
  conjures = if_else(conjures == "a", 1, 
                     if_else(conjures == "b", 2,
                             if_else(conjures == "c", 3, 
                                     if_else(conjures == "d", 4, 
                                             if_else(conjures == "e", 5, 6)))))
  group$Test$CrystalBall = conjures
  group$Test$Method = gbm_fit
  return(group)
}
