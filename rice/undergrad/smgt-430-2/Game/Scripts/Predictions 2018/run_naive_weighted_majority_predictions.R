# for each time series
# fit the model 
# get and save the predictions
# convert this to W-L record 
# save Win %, W, L

P_o = 2
Q_o = 2
P_s = 2
Q_s = 2

the_records = data.frame()

for (this_team in names(TeamTimeSeries)) {
  this_Y = TeamTimeSeries[[this_team]]
  # take naive majority
  yhats_everything = naive_weighted_majority(this_Y$win_pct)
  omg = apply(yhats_everything, 2, mean)
  this_team_record = data.frame()
  for (pt in omg) {
    this_rec = wpct_to_wlwpct(pt)
    this_team_record = rbind(this_team_record, this_rec)
  }
  team_id = rep(this_team, nrow(this_team_record))
  switch = this_team_record[2, ]
  this_team_record[2, ] = this_team_record[1, ]
  this_team_record[1, ] = switch
  switch = this_team_record[3, ]
  this_team_record[3, ] = this_team_record[1, ]
  this_team_record[1, ] = switch
  ci_id = c('High 95', 'Yhat', 'Low 95')
  this_team_record = cbind(cbind(team_id, ci_id), this_team_record)
  colnames(this_team_record) = c('Team','Type', 'W', 'L', 'W%')
  # join to main df 
  the_records = rbind(the_records, this_team_record)
  cat('Team: ', this_team, '\n')
}

write_csv(the_records, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/2018/naive_weights_univariate_predictions.csv')