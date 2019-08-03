library(tidyverse)
library(R6)
df_layman = read.csv('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/layman.csv')

df_pythagorean = df_layman[, colnames(df_layman) %in% c('win_pct', 'yearID', 'Team', 'pythagorean')]

df_temp = subset(df_pythagorean, yearID == 2017)

df_temp = subset(df_temp, select = c('Team', 'pythagorean'))

# now we have the predicted 2018 winning percentage
new_df = data.frame()
for (this_row in 1:nrow(df_temp)) {
  omg = wpct_to_wlwpct(df_temp$pythagorean[this_row])
  new_df = rbind(new_df, omg)
}

colnames(new_df) = c('W', 'L', "W%")
new_df = cbind(df_temp$Team, new_df)

write_csv(new_df, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Results/2018/pythagorean_predictions.csv')

