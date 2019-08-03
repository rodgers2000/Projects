# # Data Structures
# # mapping     1. yhat  
# #       1. ts 2. truth 
# #             3. year 
# 
# # for each time series, main ts, do 
# # get the start year 
# # get other time series to use in model 
# # for each year in (start year to 2016) do 
# # fit model 
# # get and save predictions for main ts
# # get and save truths for main ts 
# 
# # calculate MSPE
# library(forecast)
# library(R6)
# 
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/MultiTimeSeries.R')
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/DifferenceTrans.R')
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/UnivTimeSeries.R')
# source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/calculate_mspe.R')
# 
# start_year = 2005
# end_year = 2017
# 
# Results = list()
# 
# this_team_index = 1
# for (this_team in names(TeamTimeSeries)) {
#   # we need to find TSs that have the same length 
#   length_to_match = length(TeamTimeSeries[[this_team]]$yearID)
#   if (length_to_match == 117) {
#     start_year = 2005
#   } else if (length_to_match >= 56) {
#     start_year = 2012
#   } else {
#     start_year = 2015
#   }
#   indices_to_keep = c()
#   available_series = names(TeamTimeSeries)[-this_team_index]
#   for (other_team in available_series) {
#     condition = length_to_match == length(TeamTimeSeries[[other_team]]$yearID)
#     if (condition) {
#       indices_to_keep = c(indices_to_keep, 1)
#     } else {
#       indices_to_keep = c(indices_to_keep, 0)
#     }
#   }
#   # we must keep the current ts in it 
#   my_love = available_series[as.logical(indices_to_keep)]
#   if (length(my_love) > 2) {
#     these_ones = my_love[sample(1:length(my_love), 2)] 
#   } else {
#     these_ones = my_love[sample(1:length(my_love), 1)] 
#   }
#   these_ones = c(these_ones, this_team)
#   # now we have our 3 teams! ready for model
#   TS_j = TeamTimeSeries[names(TeamTimeSeries) %in% these_ones]
#   this_team_index = this_team_index + 1  
#   ## now we have our ts, do backtest
#   y = c()
#   yhat = c()
#   yhat_upper = c()
#   yhat_lower = c()
#   year = c()
#   # yeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
#   for (this_year in start_year:end_year) {
#     TS_j_new = list()
#     for (other_team in names(TS_j)) {
#       TS_j_new[[other_team]] = subset(TS_j[[other_team]], yearID < this_year - 1)
#     }
#     mjr = MultiTimeSeries$new(TS = TS_j_new, periods = 1)
#     mjr$auto_fit()
#     omg = mjr$predict_it(n_ahead = 1)
#     omg = subset(omg, team == this_team)
#     yhat = c(yhat, omg$yhat)
#     yhat_upper = c(yhat_upper, omg$upper)
#     yhat_lower = c(yhat_lower, omg$lower)
#     year = c(year, this_year)
#     this_y = TeamTimeSeries[[this_team]][TeamTimeSeries[[this_team]]$yearID == this_year, 'win_pct']
#     y = c(y, this_y)
#   }
#   ## year we did it
#   Results[[this_team]]$y = y
#   Results[[this_team]]$yhat = yhat
#   Results[[this_team]]$yhat_upper = yhat_upper
#   Results[[this_team]]$yhat_lower = yhat_lower
#   Results[[this_team]]$year = year
#   cat('Current team: ', this_team, '\n')
# }
# 
# index = 1
# for (this in Results) {
#   cat(names(Results)[index], '\n')
#   cat('yhat: ', this$yhat, '\n')
#   cat('upper: ', this$yhat_upper, '\n')
#   cat('lower: ', this$yhat_lower, '\n')
#   cat('year: ', this$year, '\n')
#   index = index + 1
# }
# 

# Data Structures
# mapping     1. yhat  
#       1. ts 2. truth 
#             3. year 

# for each time series, main ts, do 
# get the start year 
# get other time series to use in model 
# for each year in (start year to 2016) do 
# fit model 
# get and save predictions for main ts
# get and save truths for main ts 

# calculate MSPE
library(forecast)
library(R6)

source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/MultiTimeSeries.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/DifferenceTrans.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/ProportionTrans.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Objects/UnivTimeSeries.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/calculate_mspe.R')

start_year = 2005
end_year = 2017

Results = list()

for (this_team in names(TeamTimeSeries)) {
  min_length = length(TeamTimeSeries[[1]]$yearID)
  for (ts in 2:length(TeamTimeSeries)) {
    this_length = length(TeamTimeSeries[[ts]]$yearID)
    if (this_length < min_length) {
      min_length = this_length
    }
  }
  TS_j = list()
  for (ts in 1:length(TeamTimeSeries)) {
    temp_df = TeamTimeSeries[[ts]]
    TS_j[[ts]] = temp_df[(nrow(temp_df) - min_length + 1):nrow(temp_df), ]
  }
  ## now we have our ts, do backtest
  y = c()
  yhat = c()
  yhat_upper = c()
  yhat_lower = c()
  year = c()
  # yeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  for (this_year in start_year:end_year) {
    TS_j_new = list()
    for (other_team in names(TS_j)) {
      TS_j_new[[other_team]] = subset(TS_j[[other_team]], yearID < this_year - 1)
    }
    mjr = MultiTimeSeries$new(TS = TS_j_new, periods = 1)
    mjr$auto_fit()
    omg = mjr$predict_it(n_ahead = 1)
    omg = subset(omg, team == this_team)
    yhat = c(yhat, omg$yhat)
    yhat_upper = c(yhat_upper, omg$upper)
    yhat_lower = c(yhat_lower, omg$lower)
    year = c(year, this_year)
    this_y = TeamTimeSeries[[this_team]][TeamTimeSeries[[this_team]]$yearID == this_year, 'win_pct']
    y = c(y, this_y)
  }
  ## year we did it
  Results[[this_team]]$y = y
  Results[[this_team]]$yhat = yhat
  Results[[this_team]]$yhat_upper = yhat_upper
  Results[[this_team]]$yhat_lower = yhat_lower
  Results[[this_team]]$year = year
  cat('Current team: ', this_team, '\n')
}

index = 1
for (this in Results) {
  cat(names(Results)[index], '\n')
  cat('yhat: ', this$yhat, '\n')
  cat('upper: ', this$yhat_upper, '\n')
  cat('lower: ', this$yhat_lower, '\n')
  cat('year: ', this$year, '\n')
  index = index + 1
}

