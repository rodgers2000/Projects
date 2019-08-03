pitch_frequency <- function(pitcher_name_2 = "Justin Verlander", dat_X = dat_pitches){
  ## this function returns the pitch thrown given the count and inning
  ## it gives the count, pitch type, and inning
  
  # create subset for player 
  dat_game = dat_X %>% subset(pitcher_name == pitcher_name_2)
  # create new dataframe to hold results 
  dat_results = data.frame(
    1:nrow(dat_game), 1:nrow(dat_game), 1:nrow(dat_game), 1:nrow(dat_game)
  )
  colnames(dat_results) = c("balls", "strikes", "pitch", "inning")
  
  # now we can create the data. the data is sequential, so we can loop through rows to gather each pitch for an atbat. 
  balls = 0; strikes = 0 
  for (pitch in 1:nrow(dat_game)){
    # store balls and strikes
    dat_results$balls[pitch] = balls
    dat_results$strikes[pitch] = strikes
    # store pitch type
    dat_results$pitch[pitch] = dat_game$pitch_type[pitch]
    # store inning
    dat_results$inning[pitch] = dat_game$inning.y[pitch]
    # update balls and strikes
    if (dat_game$type[pitch] == "S" & strikes < 2){
      strikes = strikes + 1
    }
    else if (dat_game$type[pitch] == "B" & balls < 3){
      balls = balls + 1
    } # if the batter is out, or if the batter name changes, reset count 
    else if ((dat_game$type[pitch] == "X") | (dat_game$batter_name[pitch] != dat_game$batter_name[pitch+1])){
      balls = 0; strikes = 0 
    }
    
  }
  # lets give what we promised
  dat_results$count = paste0(dat_results$balls, "-", dat_results$strikes)
  # lets remove NA values, since they are inrelevant 
  dat_results = dat_results %>% subset(!is.na(pitch))
  return(dat_results)
}
