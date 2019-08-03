# we want to test how the model complexity and weight updates changes the mspe
cat("After Output ......................................................", '\n', file = "after_weights.txt")
for (start_year in c(2005)) {
  for (complexity in list(c(2,2), c(4,4))) {
    cat(paste0('Start Year: ', start_year, '\n'), file = "after_weights.txt", append = TRUE)
    cat(paste0('Complexity: ', complexity[1],'-', complexity[2], '\n'), file = "after_weights.txt", append = TRUE)
    Results = after_weights(my_TS = AvailableTimeSeries, START_YEAR = start_year, model_complexity = complexity)
    # calcualte mspe 
    mspe = data.frame()
    preds_2018 = data.frame()
    for (team_index in 1:length(Results$Results)) {
      df_results = Results$Results[[team_index]]
      n = length(df_results$yhats)
      mspe = rbind(mspe, calculate_mspe(yhat = df_results$yhats$Point.Forecast[-n], y = df_results$ys[-n]))
      preds_2018 = rbind(preds_2018, df_results$yhats[n, ])
    }
    team_labels = names(Results$Results)
    mspe = cbind(team_labels, mspe)
    preds_2018 = cbind(team_labels, preds_2018)
    colnames(mspe) = c('team', 'mspe')
    write_csv(mspe, paste0('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/MSPE/after_', start_year, '_', complexity[1], complexity[2], '.csv'))
    my_preds = data.frame()
    for (team in 1:nrow(preds_2018)) {
      team_df_this = data.frame()
      for (col in c(4,2,3)) {
        team_df_this = rbind(team_df_this, wpct_to_wlwpct(preds_2018[team, col]))
      }
      this_team_labels = rep(preds_2018[team, 1], 3)
      team_df_this = cbind(this_team_labels, c('High 95', 'Yhat', 'Low 95'), team_df_this)
      colnames(team_df_this) = c('Team', 'Type', 'W', 'L', 'W%')
      my_preds = rbind(my_preds, team_df_this)
    }
    write_csv(my_preds, paste0('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/2018/after_', start_year, '_', complexity[1], complexity[2], '.csv'))
  }
}


