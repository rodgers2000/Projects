source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Final Project/Practice/Functions/mlb_query.R')
library(tidyverse)

for (year in c(2016, 2017)) {
  start_time = proc.time()
  dat_mlb = mlb_query(start = paste0(year, '-01-01'), end = paste0(year, '-12-31'), season_type = 'r')
  end_time = proc.time()
  total_time = (end_time - start_time) / 60 # 17 minutes
  ## games = 162 * 30 / 2 = 2430
  for (ds in dat_mlb) {
    print(length(unique(ds$gameday_link)))
  }
  
  games = unique(dat_mlb$atbat$gameday_link)
  astros = str_subset(games, 'hou')
  length(astros) # should be 162 
  
  file_path = '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/'
  file = paste0(file_path, paste0('mlbgameday_', year, '.rds'))
  saveRDS(dat_mlb, file)
}