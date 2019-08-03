submit_predictions <- function(group = Group, title = "DirtyMike"){
  
  create_submission_file <- function(file_name, predictions) {
    prediction_path = paste0(getwd(), "/Predictions/")
    
    if (length(predictions) != 3926) {
      warning("Have either too many or too few predictions for test data!")
    }
    
    tibble(Id = seq_along(predictions), Prediction = predictions) %>%
      write_csv(paste0(prediction_path, file_name, ".csv"))
  }
  # kill factors 
  group$group1$Test$CrystalBall = group$group1$Test$CrystalBall %>% as.character() %>% as.double()
  group$group2$Test$CrystalBall = group$group2$Test$CrystalBall %>% as.character() %>% as.double()
  group$group3$Test$CrystalBall = group$group3$Test$CrystalBall %>% as.character() %>% as.double()
  
  crystal_ball1 = cbind(group$group1$Test$CrystalBall, group$group1$Test$I.D.)
  crystal_ball2 = cbind(group$group2$Test$CrystalBall, group$group2$Test$I.D.)
  crystal_ball3 = cbind(group$group3$Test$CrystalBall, group$group3$Test$I.D.)
  
  crystal_ball = rbind(crystal_ball1, crystal_ball2, crystal_ball3)
  
  crystal_ball = crystal_ball[order(crystal_ball[, 2]), ]
  crystal_ball = crystal_ball %>% subset(select = -I.D.)
  
  # compare to benchmark 
  benchmark = read_csv(paste0(getwd(), "/Predictions/The Tree of Michael (No Feature Selection and Scaled, Benchmark).csv"))
  cat("I have", sum(benchmark$Prediction != crystal_ball %>% as.vector()), "differences!!!!")
  
  create_submission_file(title, crystal_ball %>% as.vector())
}
