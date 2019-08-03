library(Lahman)
library(tidyverse)
# load data 
data("Teams")

# select the features to erase
features_2_erase = colnames(Teams)[c(5:6, 11, 12, 24:26, 41:42, 46:48)]
# we don't want to keep the features so negate.
df_layman = Teams[, !(colnames(Teams) %in% features_2_erase)] 

# let's keep current data 
df_layman <- df_layman %>%
  filter(yearID >= 1901 & lgID %in% c("AL", "NL"))

# let's check to see NA values by features 
check_na = function (df = df_layman) apply(df, 2, function(x) sum(is.na(x)) / length(x))

check_na()

# fix NA values 
# if World Seris Win is NA, put No (N)
# if League Win is NA, put No (N)
# if Strike Out is NA, let's take the mean for the year
df_layman <- df_layman %>% 
  mutate(LgWin = if_else(is.na(LgWin), 'N', LgWin), 
         WSWin = if_else(is.na(WSWin), 'N', WSWin))

mean_4_year = function (feature, year, df) {
  # get the data for the year that is not a na or nan. 
  dat_temp = subset(df, yearID == year & !is.nan(SO) & !is.na(SO))
  # if their is no data for that year that fits the conditions, expand selection.
  if (nrow(dat_temp) == 0) {
    dat_temp = subset(df, yearID <= year & !is.nan(SO) & !is.na(SO))
  }
  # return the mean 
  return(mean(dat_temp$SO)) 
}

for (row in 1:nrow(df_layman)) {
  # get the critical point
  critical_pt = df_layman$SO[row]
  # if the the critical point is na or nan, compute the mean 
  if (is.na(critical_pt) | is.nan(critical_pt)) {
    critical_pt = mean_4_year('SO', df_layman$yearID[row], df_layman)
    # print(critical_pt)
    # print(row)
    # if (row == 67) {
    #   critical_pt = mean_4_year('SO', df_layman$yearID[row], df_layman)
    # }
  }
  # save the value
  df_layman$SO[row] = critical_pt
}


# compute stats based on the year and team. 
df_layman <- df_layman %>%
  group_by(yearID, teamID) %>%
  mutate(TB = H + X2B + 2 * X3B + 3 * HR,
         WinPct = W/G,
         RPG = R/G,
         HRPG = HR/G,
         TBPG = TB/G,
         KPG = SO/G,
         K2BB = SO/BB,
         WHIP = 3 * (H + BB)/IPouts)

# convert categorical features to binary 
df_layman$lgID = if_else(df_layman$lgID == 'AL', 1, 0)
df_layman$LgWin = if_else(df_layman$LgWin == 'Y', 1, 0)
df_layman$WSWin = if_else(df_layman$WSWin == 'Y', 1, 0)

# convert franchise abbreviation to franchise title 
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Game/Functions/franchise_title.R')

# produce the franchise title and save it.
# there are 30 unique franchises, we'll classify each team according to this. 
team = c()
for (row in 1:nrow(df_layman)) {
  tag = franchise_title(df_layman$franchID[row] %>% as.character())
  team = c(team, tag)
}

# remove unwanted columns and add the team label 
df_layman = df_layman[, -c(3, 4)]
df_layman$Team = team 

# set up raw data id, y, x 
df_layman = df_layman[, c(5:6, 1, 43, 2:4, 7:42)]

# we want to use the past end year data to predict next years record 
# we need to lead by 1 
# we need to adjust games for the seasons that have less than 162 games. 
# Do 162 - G = G_Add 
# Add equally to W and L
# 1. regression - predicting the amount of wins
# we round the prediciton to the nearest number and do L = 162 - W 
# 2. classifiation - predicting more wins than losses 
# we label 1 = W > L ; 0 = L > W

# get 2017 data 
library(readxl)
mlb_records_2017 <- read_excel("~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/mlb_records_2017.xlsx")

# combine it with layman
df_layman = bind_rows(df_layman, mlb_records_2017) # use bind_rows to fill missing columns with NA's

# calculate pythagorean expectation
num = 1
den = 1 + (df_layman$RA / df_layman$R)^2
df_layman$pythagorean = num / den

# calculate winning percent 
num = df_layman$W
den = df_layman$W + df_layman$L
df_layman$win_pct = num / den 

write_csv(df_layman, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/layman.csv')
