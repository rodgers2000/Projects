# load the beginnining of pipeline-1
# we need dat_UNIV and dat_RETURNS in global 

start_time = proc.time()
for (label in c(2, 5, 10, 20)) {
  
  Brain = list("Universe" = dat_UNIV, "Returns" = dat_RETURNS)
  
  Brain = adjust_high_returns(Brain, 3)
  Brain = calculate_labels(Brain, label)
  Brain = adjust_Y(Brain)
  Brain = remove_NA_returns(Brain)
  Brain = adjust_IDYX(Brain)
  Brain = adjust_return_features(Brain)
  
  Nucleus = the_machines_will_rule(Brain, n = 500)
  
  save_accuracy_and_confusion_matrix(Nucleus, label)
  save_company_frequencies(Nucleus, label)
  save_prediction_frequencies(Nucleus, label)
  
  cagr_df = get_cagrs(Nucleus)
  
  write_csv(cagr_df, paste0(getwd(), "/Results/CAGRS/methods_", label, ".csv"))
  
  cat(label, "\n")
}

end_time = proc.time()
(end_time - start_time) / 60 / 60 ## Hours 
