team_query <- function(team = 'astros', season_type = 'r', dates = list('start' = '2017-09-01', 'end' = '2017-10-01')){
  library(mlbgameday)
  # this loads the urls 
  game_ids_custom <- search_gids(team = team, start = dates$start, end = dates$end, game_type = season_type)
  
  # Run larger requests in parallel.
  library(doParallel)
  library(foreach)
  no_cores <- detectCores() - 1
  cl <- makeCluster(no_cores)
  registerDoParallel(cl)
  # this creates data for both team. very raw 
  df <- get_payload(game_ids = game_ids, dataset = "inning_all")
  stopImplicitCluster()
  rm(cl)
  
  return(df)
}