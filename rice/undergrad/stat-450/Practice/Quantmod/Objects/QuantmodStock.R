library(R6)

QuantmodStock <- R6Class(
  'QuantmodStock',
  # attributes
  private = list(
    DF = NA,
    stock = NA
  ), 
  # methods
  public = list(
    initialize = function(stock = 'GOOG') {
      # load packages for object
      library(quantmod)
      library(tidyverse)
      library(lubridate)
      # we need the ticker!
      private$stock = stock
    },
    query_quantmod = function() {
      # upload its data
      getSymbols(private$stock)
      # convert to dataframe and move row names to feature
      my_stock = get(private$stock) %>% data.frame()
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
      # arrange by date, we want the most recent point to be first 
      my_stock = my_stock[order(my_stock$date, decreasing = TRUE), ]
      # save data
      private$DF = my_stock
    }, 
    get_DF = function(){
      return(private$DF)
    }
  )
)

# test code
# mjr = QuantmodStock$new('GOOG')
# QuantmodStock$debug('query_quantmod')
# mjr$query_quantmod()
# str(mjr$DF)
