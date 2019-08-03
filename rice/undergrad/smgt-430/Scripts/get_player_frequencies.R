my_fav_pitchers = c("Justin Verlander", 'Lance McCullers')
path_data = paste0(getwd(), '/Data/Freqs/')

for (player in my_fav_pitchers) {
  dat_raw_counts = pitch_frequency(player, dat_pitches)
  dat_freqs = conditional_probabilities(dat_raw_counts)
  save_data(dat_freqs, paste0(path_data, player))
}