lda_mass <- function(group = Group$group1){
  library(MASS)
  
  model = lda(x = group$Train$X %>% scale(), grouping = factor(group$Train$Y))
  conjures = predict(model, group$Test$X %>% scale())$class
  group$Test$CrystalBall = conjures
  return(group)
}
