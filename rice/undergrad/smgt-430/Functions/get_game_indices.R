get_game_indices <- function(dat_temp = dat_ForO){
  # make a sequence
  indices_hold = vector('double')
  # make a mapping 
  games = list()
  # set game to 1
  game = 1
  # for each row 
  for (pitch in 1:nrow(dat_temp)) {
    # store row in sequence
    indices_hold = c(indices_hold, pitch)
    if (pitch == nrow(dat_temp)) {
      games[[game]] = indices_hold
      break 
    }
    current_inning = dat_temp$inning[pitch]
    next_inning = dat_temp$inning[pitch+1]
    # if inning decreases, we have a new game 
    if (current_inning > next_inning){
      # store sequence in list 
      games[[game]] = indices_hold
      # increment game 
      game = game + 1
      # make a new sequence  
      indices_hold = vector('double')
    }
  }
  return(games)
}
