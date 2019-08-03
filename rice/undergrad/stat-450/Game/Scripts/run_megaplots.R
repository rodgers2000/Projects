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
index = 1 
for (stock in c('GOOG', 'AAPL')) {
  for (n_test in c(120, 240, 480, 960, 1920)) {
    for (n_train in c(500)) {
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
    }
  }
}

# stock = 'GOOG'
# n_test = 100
# n_train = 100
# time = 3
# ahead = 2