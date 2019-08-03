library(tidyverse)
library(R6)
df_layman = read.csv('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/layman.csv')
team_names = unique(df_layman$Team)
# for each team 
# create winning percentage
# sort by date
# save ts 

TeamTimeSeries = list()

for (team in team_names) {
  df_temp = subset(df_layman, Team == team, select = c('win_pct', 'yearID', 'Team'))
  # sort by yearID # most recent in first entry 
  df_temp = arrange(df_temp, yearID)
  # save TS 
  TeamTimeSeries[[team]] = select(df_temp, .data$win_pct, .data$yearID)
}
