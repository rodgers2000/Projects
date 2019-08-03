dat_mlb = readRDS('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/mlbgameday_2017.rds')

features = list()
index = 1 
for (ds in dat_mlb) {
  features[[index]] = colnames(ds)
  index = index + 1
}
for (ds in dat_mlb) {
  print(length(unique(ds$gameday_link)))
}

# dat_mlb2 = inner_join(dat_mlb$pitch, dat_mlb$atbat, by = c("num", "url"))
# dat_mlb3 = left_join(dat_mlb2, dat_mlb$runner, by = c('event' = 'event_num', 'url'))

# games 
games = unique(dat_mlb$atbat$gameday_link)
astros = str_subset(games, 'hou')

game_1 = list()
index = 1
for (ds in dat_mlb) {
  game_1[[index]] = subset(ds, ds$gameday_link == astros[2])
  index = index + 1
}
names(game_1) = names(dat_mlb)

# 

for (ds in game_1) {
  print(sort(unique(ds$event_num)))
}