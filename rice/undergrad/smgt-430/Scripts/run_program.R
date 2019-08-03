path <- function(file_name) paste0(getwd(), '/Scripts/', file_name, '.R')
source(path('get_player_markov'))
source(path('get_player_frequencies'))
source(path('get_player_stats'))
