library(tidyverse)
start_time = proc.time()
dat_mlb = mlb_query(start = '2017-04-02', end = '2017-10-01')
end_time = proc.time()
total_time = (end_time - start_time) / 60 # 17 minutes

data_path = paste0(getwd(), "/Data/") # create general path for data file 
file_name = paste0(data_path, "mlb_2017_regular_season.csv")

dat_mlb2 = inner_join(dat_mlb$pitch, dat_mlb$atbat, by = c("num", "url"))
# save and load data
# write_csv(dat_mlb, file_name)
dat_mlb = read_csv(file_name)

dat_pitches = dat_mlb %>% select(type, des.x, pitch_type, event, inning.y, batter_name, pitcher_name)

my_fav_pitcher = "Justin Verlander"

dat_JV = pitch_frequency(my_fav_pitcher, dat_pitches)
results_JV = conditional_probabilities(dat_JV, my_fav_pitcher)

