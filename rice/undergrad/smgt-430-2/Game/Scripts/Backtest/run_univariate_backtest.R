# Data Structures
# mapping     1. yhat  
#       1. ts 2. truth 
#             3. year 

# for each time series, main ts, do 
# get the start year 
# for each year in (start year to 2016) do 
# fit model 
# get and save predictions for main ts
# get and save truths for main ts

library(R6)

# calculate MSPE
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Scripts/create_ts_for_each_team.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/UnivTimeSeries.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/calculate_mspe.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/w_to_record.R')

Results = list()

start_year = 2005
end_year = 2016

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
    # give data
    mjr = UnivTimeSeries$new(ts = this_Y$win_pct, periods = 1)
    # train 
    mjr$auto_fit()
    # predict
    omg = mjr$predict_it(n_ahead = 1)
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

write_csv(MSPE, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/MSPE/univariate_mspe.csv')