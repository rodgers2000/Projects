library(tidyverse)
library(R6)
df_layman = read.csv('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/layman.csv')

df_pythagorean = df_layman[, colnames(df_layman) %in% c('win_pct', 'yearID', 'Team', 'pythagorean')]

start_year = 2005
end_year = 2017

# R = runs scored
# RA = runs allowed 

# Data Structures
# mapping       1. yhat  
#       1. team 2. truth 
#               3. year 

Results = list()

for (team in unique(df_pythagorean$Team)) {
  # get data 
  # sort data 
  # predictions for year are equal to lead pythagorean
  # the truth is equal to the win_pct for year 
  df_temp = subset(df_pythagorean, Team == team & yearID >= start_year - 1)
  df_temp = arrange(df_temp, yearID)
  Results[[team]] = list()
  yhat = c()
  y = c()
  year = c()
  for (row in 1:(nrow(df_temp)-1)) {
    this_year = df_temp$yearID[row] + 1
    this_yhat = df_temp$pythagorean[row]
    this_y = df_temp$win_pct[row + 1]
    year = c(year, this_year)
    yhat = c(yhat, this_yhat)
    y = c(y, this_y)
  }
  Results[[team]]$yhat = yhat
  Results[[team]]$y = y
  Results[[team]]$year = year
}

mspe_col = c()
teams_col = unique(names(Results))
for (team in teams_col) {
  n = length(Results[[team]]$y)
  mspe = calculate_mspe(yhat = Results[[team]]$yhat, y = Results[[team]]$y)
  mspe_col = c(mspe_col, mspe)
}

MSPE = data.frame('team' = teams_col, 'mspe' = mspe_col)

write_csv(MSPE, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/MSPE/pythagorean_expectation.csv')
