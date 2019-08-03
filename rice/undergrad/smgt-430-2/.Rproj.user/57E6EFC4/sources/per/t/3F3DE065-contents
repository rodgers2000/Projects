Results = list()

naive_weighted_majority <- function(this_ts) {
  yhats_everything = data.frame()
  # it searches for p and q a level up. bad style but it's okay
  for (p_o in 1:P_o) {
    for (q_o in 1:Q_o) {
      for (p_s in 1:P_s) {
        for (q_s in 1:Q_s) {
          # give data
          mjr = UnivTimeSeries$new(ts = this_ts, periods = (p_s+q_s)/2)
          # train 
          mjr$manual_fit(O = c(p_o, 0, q_o), S = c(p_s, 0, q_s))
          # predict
          omg = mjr$predict_it(n_ahead = 1)
          yhats_everything = rbind(yhats_everything, omg)
        }
      }
    }
  }
  return(yhats_everything)
}

start_year = 2005
end_year = 2016
P_o = 2
Q_o = 2
P_s = 2
Q_s = 2

for (this_team in names(TeamTimeSeries)) {
  this_ts = TeamTimeSeries[[this_team]]
  # initialize data
  y = c()
  year = c()
  yhat = c()
  yhat_upper = c()
  yhat_lower = c()
  for (this_year in start_year:end_year) {
    # use all data but limit its year to the current year
    this_Y = subset(this_ts, yearID < this_year)
    # take naive majority
    yhats_everything = naive_weighted_majority(this_Y$win_pct)
    omg = apply(yhats_everything, 2, mean)
    # save data 
    y = c(y, this_ts[this_ts$yearID == this_year, 'win_pct'])
    yhat = c(yhat, omg[1])
    yhat_lower = c(yhat_lower, omg[2])
    yhat_upper = c(yhat_upper, omg[3])
    year = c(year, this_year)
  }
  Results[[this_team]]$yhat = yhat
  Results[[this_team]]$yhat_upper = yhat_upper
  Results[[this_team]]$yhat_lower = yhat_lower
  Results[[this_team]]$y = y
  Results[[this_team]]$year = year
  cat('Team: ', this_team, '\n')
}


mspe = c()
for (team in names(Results)) {
  mspe = c(mspe, calculate_mspe(yhat = Results[[team]]$yhat, y = Results[[team]]$y))
}

MSPE = data.frame('team' = names(Results), 'mspe' = mspe)

write_csv(MSPE, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/MSPE/naive_majority_univariate_mspe.csv')
