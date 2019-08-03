# features_heart = c("start_speed", "end_speed", 'px', 'pz', "vx0", "vy0", "vz0", 'ax', 
#                    'ay', 'az', 'breaky', 'break_angle', 'break_length', 
#                    'nasty', 'spin_dir', 'spin_rate')
features_heart = c("start_speed", "end_speed", 'break_angle', 'break_length', 
                   'nasty', 'spin_dir', 'spin_rate')
my_stats = c('min', 'max', "mean", "median", 'sd', 'skewness', 'kurtosis')

for (player in my_fav_pitchers){
  dat_player = dat_mlb %>% subset(pitcher_name == player)
  pitches = unique(dat_player$pitch_type)
  pitches = pitches[!is.na(pitches) & pitches != 'UN']
  for (pitch in pitches){
    dat_pitch = dat_player %>% subset(pitch_type == pitch)
    dat_feat = get_ideal_features(dat_pitch, features_heart)
    dat_stats = calculate_stats(dat_feat, my_stats)
    save_data(dat_stats, paste0(getwd(), "/Data/Stats/", player,' ', pitch))
  }
}