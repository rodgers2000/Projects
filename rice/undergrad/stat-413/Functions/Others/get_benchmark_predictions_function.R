compare_2_benchmark <- function(name = "The Tree of Michael (No Feature Selection and Scaled, Benchmark)", my_preds){
  path = paste0(getwd(), "/Predictions/")
  preds = read_csv(paste0(path, name, ".csv"))
  sum(my_preds != preds$Prediction)
}
