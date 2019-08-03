# Data Structures
# mapping     1. yhat  
#       1. ts 2. truth 
#             3. year 

# for each time series, main ts, do 
# get the start year 
# get the pythagoreans
# for each year in (start year to 2016) do 
# fit model; # we train on a lagged pythagorean
# get and save predictions for main ts; # we regress on the most recent pythagoren
# get and save truths for main ts

library(R6)

# calculate MSPE
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Scripts/create_ts_for_each_team.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/UnivTimeSeries.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/calculate_mspe.R')

Results = list()

start_year = 2005
end_year = 2016

for (this_team in names(TeamTimeSeries)) {
  this_ts = TeamTimeSeries[[this_team]]
  this_layman = subset(df_layman, Team == this_team, select = c('yearID', 'pythagorean'))
  # initialize data
  y = c()
  year = c()
  yhat = c()
  yhat_upper = c()
  yhat_lower = c()
  for (this_year in start_year:end_year) {
    # use all data but limit its year to the current year
    past_Y = subset(this_ts, yearID < this_year)
    past_X = subset(this_layman, yearID < this_year - 1)
    # lag Y , so Yt lines up with Xt-1 for regression
    # so add 1 to X time and you get Yt = Xt = Xt-1+1
    past_X$yearID = past_X$yearID + 1
    past_D = merge(past_X, past_Y, by = 'yearID')
    # give data  
    mjr = UnivTimeSeries$new(ts = past_D$win_pct, periods = 1)
    # train data 
    mjr$xreg_fit(xreg = past_D$pythagorean)
    # predict data 
    omg = mjr$predict_it(n_ahead = 1, xregs = past_X[past_X$yearID == this_year - 1, 'pythagorean']) # this works because of how we set up our time
    # save data 
    y = c(y, this_ts[this_ts$yearID == this_year, 'win_pct'])
    yhat = c(yhat, omg$Point.Forecast)
    yhat_upper = c(yhat_upper, omg$Hi.95)
    yhat_lower = c(yhat_lower, omg$Lo.95)
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

write_csv(MSPE, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/MSPE/pyrima_multivariate_mspe.csv')