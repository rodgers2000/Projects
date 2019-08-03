AvailableTimeSeries = list()
index = 1
names = c()
for (this_ts in 1:length(TeamTimeSeries)) { #  & names(TeamTimeSeries)[index] != 'San Francisco Giants'
  if (length(TeamTimeSeries[[this_ts]]$yearID) > 19) {
    AvailableTimeSeries[[index]] = TeamTimeSeries[[this_ts]]
    names = c(names, names(TeamTimeSeries)[this_ts])
    index = index + 1
  }
}

names(AvailableTimeSeries) = names

after_weights = function(my_TS, START_YEAR = 1960, model_complexity = c(4, 4)) {
  Results = list()
  After = list()
  P_o = model_complexity
  
  for (this_ts in 1:length(my_TS)) {
    # set this_team 
    this_team = names(my_TS)[this_ts]
    # print team
    cat('Team: ', this_team, '\n\n', file = "after_weights.txt", append = TRUE)
    after = AFTER$new()
    yhats_df = data.frame()
    years = c()
    ys = c()
    df = my_TS[[this_ts]]
    for (this_year in START_YEAR:2017) {
      # get data thta we have avaiable
      subset_ts = subset(df, yearID < this_year)
      # build learners
      mjr = MegaLearner$new(this_ts = subset_ts$win_pct)
      mjr$make_models(P = P_o)
      # update our weights
      after$update_weights(mjr$get_models())
      # get predictions
      yhats = mjr$forecast_models(ahead = 1)
      # linear algebra!!
      yhat = t(after$get_weights()) %*% as.matrix(yhats) ## sick
      if (this_year >= 2004) {
        yhats_df = rbind(yhats_df, yhat)
        years = c(years, this_year + 1)
        ys = c(ys, df[df$yearID == this_year, 'win_pct'])
      }
      cat('Year: ', this_year, '\n', file = "after_weights.txt", append = TRUE)
      cat('Weights: ', after$get_weights(), '\n\n', file = "after_weights.txt", append = TRUE)
    }
    Results[[this_team]]$yhats = yhats_df
    Results[[this_team]]$ys = ys
    Results[[this_team]]$years = years
    After[[this_team]]$after = after
  }
  return(list('Results' = Results, 'After' = After))
}
