mlb_query <- function(start = '2017-04-02', end = '2017-10-01', season_type = 'r'){
  library(mlbgameday)
  # this loads the urls 
  game_ids <- search_gids(start = start, end = end, game_type = season_type)
  
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
