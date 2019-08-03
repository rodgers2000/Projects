QueryQuantmod <- R6Class(
  'QueryQuantmod',
  # attributes
  private = list(
    Book = list()
  ), 
  # methods
  public = list(
    initialize = function(stock = 'GOOG') {
      # this produces a regular time matrix, where time increases. so the most recent point is at the end
      # load packages for object
      library(quantmod)
      library(tidyverse)
      library(lubridate)
      # we need the ticker!
      private$Book$Params$stock = stock
    },
    query = function() {
      # upload its data
      ticker = private$Book$Params$stock
      getSymbols(ticker)
      # convert to dataframe and move row names to feature
      my_stock = get(ticker) %>% data.frame()
      date = rownames(my_stock)
      my_stock$date = ymd(date)
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
      # get rid of NA values, if they exist 
      na_indices = complete.cases(my_stock)
      if(sum(!na_indices) > 10){
        message('There are alot of missing values!')
      }
      my_stock = my_stock[na_indices, ]
      # save data
      private$Book$Raw$DF = my_stock
    }, 
    get_Book = function(){
      return(private$Book)
    }
  )
)