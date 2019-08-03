reg_rf_carrot <- function(group = Group$group1){
  
  fitControl = trainControl('cv', number = 2, allowParallel = TRUE)
  
  datControl = "range"
  
  p = ncol(group$Train$X)
  
  gridContrl = expand.grid(mtry = c(1/2*sqrt(p), sqrt(p), 2*sqrt(p)), coefReg = .8)
  
  reg_rf_fit = train(group$Train$X, factor(group$Train$Y), 
                 method = "RRFglobal", 
                 trControl = fitControl, 
                 tuneGrid = gridContrl, 
                 preProcess = datControl, 
                 ntree = 600)
  
  conjures = predict(reg_rf_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  group$Test$Method = reg_rf_fit 
  return(group)
}
