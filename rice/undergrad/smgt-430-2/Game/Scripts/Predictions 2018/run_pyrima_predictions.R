# for each time series
# fit the model 
# get and save the predictions
# convert this to W-L record 
# save Win %, W, L

the_records = data.frame()

for (this_team in names(TeamTimeSeries)) {
  this_layman = subset(df_layman, Team == this_team)
  past_X = subset(this_layman, yearID < 2017)
  mjr = UnivTimeSeries$new(ts = TeamTimeSeries[[this_team]]$win_pct[-1])
  mjr$xreg_fit(xregs = past_X$pythagorean)
  omg = mjr$predict_it(n_ahead = 1, xregs = this_layman[this_layman$yearID == 2017, 'pythagorean'])
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
}

write_csv(the_records, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/2018/pyrima_predictions.csv')