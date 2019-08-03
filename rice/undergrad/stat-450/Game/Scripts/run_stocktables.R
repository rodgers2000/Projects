library(R6)
# load objects 
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/1. Query Data/QueryQuantmod.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/2. Transform Data/Cubism.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/3. Form Datasets/TrainTest.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/4. Build and Predict/Objects/CaretModel.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/4. Build and Predict/Simulation/VanillaModels.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/5. Compute Stats/DatePlots.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/5. Compute Stats/MegaPlots.R')
# load functions
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Functions/run_backtest.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Functions/create_temp_StockTable_df.R')
index = 1 
# create a stock table for the whole test
StockTable = list()
StockTable$Accuracy = data.frame()
StockTable$Return = data.frame()
# 'AAPL', 'GOOG', 'MSFT', 'AMZN', 'IBM', 'FB'
for (stock in c('SPY')) {
  for (n_test in c(120, 240, 480, 960, 1920)) {
    for (n_train in c(250)) {
      # we want a mega plot for each of the above values 
      step1 = MegaPlots$new()
      for (ahead in c(1, 5, 10, 20)) {
        for (time in c(3, 5, 10, 20)) {
          Nucleus = run_backtest(time = time, ahead = ahead, n_test = n_test, n_train = n_train, stock = stock)
          step1$compute_mega_accuracy(Nucleus)
          step1$compute_mega_return(Nucleus)
          print(index)
          index = index + 1
        }
      }
      # we have all the data for the params 
      step1$plot(Nucleus)
      # save the data for the params
      StockTable_accuracy_temp = create_temp_StockTable_df(step1$get_MegaDF_A(), stock, n_test, n_train)
      StockTable$Accuracy = rbind(StockTable$Accuracy, StockTable_accuracy_temp)
      StockTable_returns_temp = create_temp_StockTable_df(step1$get_MegaDF_R(), stock, n_test, n_train)
      StockTable$Return = rbind(StockTable$Return, StockTable_returns_temp)
    }
  }
}

# now we have all the data, save it 
# saveRDS(StockTable, '/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Data/StockTable.rds')
