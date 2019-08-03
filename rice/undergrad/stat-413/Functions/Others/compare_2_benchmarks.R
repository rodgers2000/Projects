compare_2_benchmark <- function(my_preds, name = "The Tree of Michael (No Feature Selection and Scaled, Benchmark)"){
  path = paste0(getwd(), "/Predictions/")
  preds = read_csv(paste0(path, name, ".csv"))
  cat(sum(my_preds != preds$Prediction), "\n")
}
