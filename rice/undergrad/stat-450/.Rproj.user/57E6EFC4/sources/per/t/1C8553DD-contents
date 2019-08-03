create_temp_StockTable_df <- function(mega_DF, stock, n_test, n_train) {
  n = nrow(mega_DF)
  stock = rep(stock, n)
  n_test = rep(n_test, n)
  n_train = rep(n_train, n)
  temp_df = cbind(data.frame(stock, n_test, n_train), mega_DF)
  return(temp_df)
}