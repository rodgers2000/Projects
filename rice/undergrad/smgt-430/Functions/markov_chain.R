get_markov_chain <- function(dat_temp = dat_ForO, order = 3){
  ## this is the a continuous setting and does not condition on the batter, but rather the running total
  # create 1-2-1 transformation
  # create an empty mapping 
  markov_chain = list()
  # create indices for each game  
  games = get_game_indices(dat_temp)
  # for each game
  for (game in 1:length(games)) {
    dat_game = dat_temp[games[[game]],] # get data 
    # for each pitch that order allows, get a chain
    for (pitch in (order+1):nrow(dat_game)) {
      pattern = dat_game$pitch[(pitch-order):(pitch-1)]
      # concatenate vector 
      string = ""
      for (letter in pattern) {
        string = paste0(string, letter)
      }
      yhat = if_else(dat_game$pitch[pitch] == 'F', 1, 2)
      # if count hasnt been made, initialize it 
      if (!(string %in% names(markov_chain))) {
        markov_chain[[string]] = tibble('pitch' = c('F', 'O'), 'n' = c(0,0))
        markov_chain[[string]]$"n"[yhat] = 1
      # else, increment it by 1
      } else {
        markov_chain[[string]]$"n"[yhat] = markov_chain[[string]]$"n"[yhat] + 1
      }
    }
  }
  # save n and standarize
  n = length(markov_chain)
  # for each element in mapping 
  for (seq in 1:n) {
    df = markov_chain[[seq]]
    # total = F+0
    total = sum(df$n)
    # initialize freq 
    df$freq = NA
    # freq = F / total 
    df$freq[1] = df$n[1] / total 
    # freq = O / total 
    df$freq[2] = df$n[2] / total 
    markov_chain[[seq]] = df
  }
  # convert list to df
  pattern = tibble('past' = 1:(2*n), 'pitch' = 0, 'n' = 0, 'freq' = 0)
  # index <- 1:2
  index = 1:2
  labels = names(markov_chain)
  # for each element in mapping 
  for (seq in 1:n) {
    # name <- element name 
    name = labels[seq]
    # df <- element df
    df = markov_chain[[seq]]
    # pattern{index} = [name df]
    pattern[index, 1] = rep(name, 2)
    pattern[index, 2:4] = df 
    # index <- index + 2
    index = index + 2
  }
  # get freq as 3rd column
  pattern = pattern[order(pattern$past), c(1, 2, 4, 3)]
  return(pattern)
}

