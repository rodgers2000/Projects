library(R6)
# load objects 
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/1. Query Data/QueryQuantmod.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/2. Transform Data/Cubism.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/3. Form Datasets/TrainTest.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/4. Build and Predict/Objects/CaretModel.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/4. Build and Predict/Simulation/VanillaModels.R')
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/5. Compute Stats/DatePlots.R')
# load functions
source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Functions/run_backtest.R')
# count the process
index = 1
for (stock in c('GOOG', 'AAPL')) {
  for (ahead in c(1, 5, 10, 20, 60)) {
    for (time in c(3, 5, 10, 20)) {
      for (n_test in c(100, 250, 500, 750, 1000)) {
        for (n_train in c(100, 200, 300)) {
          run_backtest(time = time, ahead = ahead, n_test = n_test, n_train = n_train, stock = stock)
          print(index)
          index = index + 1
        }
      }
    }
  }
}