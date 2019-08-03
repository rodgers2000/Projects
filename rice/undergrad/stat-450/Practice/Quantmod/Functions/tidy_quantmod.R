tidy_quantmod <- function(stock = 'GOOG'){
  ## algorithm: tidy quantmod
  ## input: a ticker 
  ## output: the ticker's data
  ## summary: this function takes a ticker, gets its data, tidys its data, and returns it. 
  library(quantmod)
  library(tidyverse)
  # upload its data 
  getSymbols(stock)
  # convert to dataframe and move row names to feature 
  my_stock = get(stock) %>% data.frame()
  date = rownames(my_stock)
  my_stock$date = date
  # change close to adjusted price 
  my_stock$GOOG.Close = my_stock$GOOG.Adjusted
  # erase adjusted 
  my_stock = my_stock[, -6]
  # change names 
  colnames(my_stock) = c('open', 'high', 'low', 'close', 'volume', 'date')
  # rearrange columns
  my_stock = my_stock[, c('date', 'open', 'close', 'high', 'low', 'volume')]
  # get rid of row names 
  rownames(my_stock) = NULL
  return(my_stock)
}