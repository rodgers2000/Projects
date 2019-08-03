deepboost_carrot <- function(group = Group$group1){
  fitControl <- trainControl(
    method = "cv",
    number = 10,
    search = 'grid', 
    verboseIter = TRUE, 
    allowParallel = TRUE)
  
  deepGrid <-  expand.grid(num_iter = seq(1000, 2000, 100), 
                          tree_depth = 5, 
                          beta = c(0, .5, 1), 
                          lambda = c(.0025, .025, .25), 
                          loss_type = "l")
  
  gbm_fit = train(group$Train$X, factor(group$Train$Y), method = 'deepboost',  
                  trControl = fitControl, tuneGrid = deepGrid)
  
  conjures = predict(gbm_fit, newdata = group$Test$X)
  group$Test$CrystalBall = conjures
  return(group)
}
