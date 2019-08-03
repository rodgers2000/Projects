save_prediction_frequencies <- function(Nucleus2 = Nucleus, label2 = label){
  frequency_df = data.frame("Method" = names(Nucleus2$`1980`$Method)[-length(Nucleus2$`1980`$Method)])
  matrix = matrix(0, 1, length(Nucleus2))
  frequency_df = cbind(frequency_df, matrix)
  names(frequency_df)[-1] = names(Nucleus2)
  for (method in 1:(length(Nucleus2$`1980`$Method)-1)) {
    for (year in 1:length(Nucleus2)) {
      frequency_df[method, year+1] = length(Nucleus2[[year]]$Method[[method]]$Yhat[Nucleus2[[year]]$Method[[method]]$Yhat == label2])
    }
  }
  write_csv(frequency_df, paste0(getwd(), "/Results/Stock Count/Winners_", label2,".csv"))
}
