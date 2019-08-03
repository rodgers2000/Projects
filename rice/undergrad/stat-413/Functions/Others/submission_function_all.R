create_submission_file <- function(file_name, predictions) {
  prediction_path = paste0(getwd(), "/Predictions/")
  
  if (length(predictions) != 3926) {
    warning("Have either too many or too few predictions for test data!")
  }
  
  tibble(Id = seq_along(predictions), Prediction = predictions) %>%
    write_csv(paste0(prediction_path, file_name, ".csv"))
}
