save_miss_rate_and_confusion_matrix <- function(Core2 = Nucleus){
  error_df = data.frame("Method" = names(Core2$`1980`$Method)[-length(Core2$`1980`$Method)], 
                        "Accuracy_ALL" = NA, 
                        "Accuracy_Winners" = NA, 
                        "Accuracy_Losers" = NA)
  for (method in 1:(length(Core2$`1980`$Method)-1)) {
    for (year in 1:length(Core2)) {
      if(year == 1){
        predictions = Core2[[year]]$Method[[method]]$Yhat  
        actual = Core2[[year]]$Book$Test$Y
      }
      else{
        predictions = c(Core2[[year]]$Method[[method]]$Yhat, predictions)
        actual = c(Core2[[year]]$Book$Test$Y, actual)
      }
    }
    error_df$Accuracy_ALL[method] = 1 - (sum(actual != predictions) / length(actual))
    
    labels = unique(Core2$`1980`$Book$Train$Y) %>% sort()
    winner_label = labels[length(labels)]
    actual_winners = actual[actual == winner_label]
    prediction_winners = predictions[actual == winner_label]
    actual_losers = actual[actual == 1]
    prediction_losers = predictions[actual == 1]
    
    error_df$Accuracy_Winners[method] = 1 - (sum(actual_winners != prediction_winners) / length(actual_winners))
    error_df$Accuracy_Losers[method] = 1 - (sum(actual_losers != prediction_losers) / length(actual_losers))
    
    # CONFUSION (columns are actualy, rows are predicted)
    # table(Core$Test$CrystalBall$Tree, Core$Test$Y)
    confusion = table(predictions, actual)
    write_csv(as.data.frame(confusion), paste0(getwd(), "/Results/Confusion Matrix/", names(Core2$`1980`$Method)[method], ".csv"))
  }
  
  write_csv(error_df, paste0(getwd(), "/Results/Accuracy/Methods.csv"))
}
