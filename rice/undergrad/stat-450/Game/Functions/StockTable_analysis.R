StockTable = readRDS('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Data/StockTable.rds')

stocks = unique(StockTable$Accuracy$stock)
methods = unique(StockTable$Accuracy$method)
aheads = unique(StockTable$Accuracy$ahead)
times = unique(StockTable$Accuracy$time)
n_tests = unique(StockTable$Accuracy$n_test)

compute_general_stats <- function (this_vector) {
  this_mean = mean(this_vector)
  this_median = median(this_vector)
  this_std = sd(this_vector)
  this_max = max(this_vector)
  this_min = min(this_vector)
  this_df = data.frame(this_mean, this_median, this_std, this_max, this_min)
  colnames(this_df) = c('mean', 'median', 'std', 'max', 'min')
  return(this_df)
}

calculate_stats_on_df = function(df, vector_name) {
  MethodStatsDf = data.frame()
  for (my_method in methods) {
    for (my_n_test in n_tests) {
      for (my_time in times) {
        for (my_ahead in aheads) {
          this_subset = subset(df, method == my_method & 
                                 n_test == my_n_test & 
                                 time == my_time &
                                 ahead == my_ahead)
          this_stats = compute_general_stats(this_subset[, vector_name])
          my_df = data.frame('method' = my_method, 'n_test' = my_n_test, 'time' = my_time, 'ahead' = my_ahead)
          new_df = cbind(my_df, this_stats)
          MethodStatsDf = rbind(MethodStatsDf, new_df) 
        }
      }
    }
  }
  return(MethodStatsDf)
}

## Let's do it 
path = '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Results/Tables/'

write_csv(calculate_stats_on_df(StockTable$Accuracy, 'accuracy'), paste0(path, 'Stats/Stats_Accuracy.csv'))

write_csv(calculate_stats_on_df(StockTable$Return, 'return'), paste0(path, 'Stats/Stats_Return.csv'))

## save regular data 
write_csv(StockTable$Accuracy, paste0(path, 'Raw/Raw_Accuracy.csv'))
write_csv(StockTable$Return, paste0(path, 'Raw/Raw_Return.csv'))


####################################################################################
### OLD ###
# # compute the best and worst model 
# StockModelsDf = data.frame()
# 
# for (my_stock in stocks) {
#   if (my_stock != 'FB') {
#     n_tests = unique(StockTable$Accuracy$n_test)
#   } else {
#     n_tests = c(120, 240, 480)
#   }
#   for (my_n_test in n_tests) {
#     # select data 
#     subset_of_data = subset(StockTable$Accuracy, stock == my_stock & n_test == my_n_test)
#     # find min and max 
#     row_max = which.max(subset_of_data$accuracy)
#     # save data and combine 
#     temp_df = rbind(subset_of_data[row_max, ])
#     StockModelsDf = rbind(StockModelsDf, temp_df)
#   }
# }

# for each stock 
# for each n_test 
## compute the mean, median, std, min, max
# for (my_stock in stocks) {
#   if (my_stock != 'FB') {
#     n_tests = unique(StockTable$Accuracy$n_test)
#   } else {
#     n_tests = c(120, 240, 480)
#   }
#   for (my_n_test in n_tests) {
#     for (my_method in methods) {
#       # select data 
#       subset_of_data = subset(StockTable$Accuracy, stock == my_stock & n_test == my_n_test & method == my_method)
#       # calculate stats
#       this_mean = mean(subset_of_data$accuracy)
#       this_median = median(subset_of_data$accuracy)
#       this_std = sd(subset_of_data$accuracy)
#       this_min = min(subset_of_data$accuracy)
#       this_max = max(subset_of_data$accuracy)
#       # save data and combine 
#       temp_df = data.frame(my_stock, my_method, my_n_test, this_mean, this_median, this_std, this_min, this_max)
#       colnames(temp_df) = c('stock', 'method', 'n_test', 'mean', 'median', 'std', 'min', 'max')
#       StockStatsDf = rbind(StockStatsDf, temp_df)
#     }
#   }
# }

# for each test n
  # for each stock
    # for each method
        # find min and max accuracy
        # find the parameters
        # find the return
find_min_or_max = function(df, my_func) {
  for (this_test_n in n_tests) {
    for (this_stock in stocks) {
      this_df_a = subset(StockTable$Accuracy, n_test == this_test_n & stock == this_stock)
      this_df_r = subset(StockTable$Return, n_test == this_test_n & stock == this_stock)
      crit_pt_max = my_func(this_df_a$accuracy)
      crit_a = this_df_a[crit_pt_max, ]
      values_2_match = crit_a[, c('method', 'time', 'ahead')]
      crit_r = subset(this_df_r,  time == values_2_match$time & 
                        ahead == values_2_match$ahead &
                        method == values_2_match$method)
      crit_a = cbind(crit_a, 'return' = crit_r$return)
      df = rbind(df, crit_a)
    }
  }
  return(df)
}
MaxDF = find_min_or_max(data.frame(), which.max)
MinDF = find_min_or_max(data.frame(), which.min)


write_csv(MaxDF, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Results/Tables/Stats/Max_Accuracy.csv')
write_csv(MinDF, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Results/Tables/Stats/Min_Accuracy.csv')
