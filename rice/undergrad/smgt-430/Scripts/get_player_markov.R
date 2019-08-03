library(tidyverse)
data_path = paste0(getwd(), "/Data/") # create general path for data file 
file_name = paste0(data_path, "mlb_2017_regular_season.csv")
dat_mlb = read_csv(file_name)

# load functions 
library(R.utils)
sourceDirectory(paste0(getwd(), '/Functions/'))

# subset of dat mlb 
dat_pitches = dat_mlb %>% select(type, des.x, pitch_type, event, inning.y, batter_name, pitcher_name)

my_fav_pitchers = c('Justin Verlander', 'Lance McCullers')
path_data = paste0(getwd(), '/Data/Markov/')

for (player in my_fav_pitchers) {
  dat_raw_counts = pitch_frequency(player, dat_pitches)
  dat_ForO = fastball_or_offspeed(dat_raw_counts) 
  for (order in 1:5) {
    dat_patterns = get_markov_chain(dat_ForO, order) 
    save_data(dat_patterns, paste0(path_data, player, ' ', order))
  }
}