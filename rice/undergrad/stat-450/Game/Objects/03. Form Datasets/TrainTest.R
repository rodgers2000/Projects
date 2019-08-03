TrainTest <- R6Class(
  'TrainTest', 
  # attributes
  private = list(
    Book = NA
  ),
  # methods
  public = list(
    initialize = function(train_percent = .7, test_percent = .3, Book = NA){
      # error handling 
      if(train_percent + test_percent != 1){
        message('please use all data')
      }
      private$Book = Book
      private$Book$Params$Percents$train = train_percent
      private$Book$Params$Percents$test = test_percent
    }, 
    form_regular_datasets = function(){
      # set shortcuts 
      X = private$Book$Raw$DS$X
      labels = private$Book$Raw$DS$Y$labels
      returns = private$Book$Raw$DS$Y$returns
      Date = private$Book$Raw$DS$Date
      n = nrow(X)
      tr_pct = private$Book$Params$Percents$train
      ts_pct = private$Book$Params$Percents$test
      is_n_even = n %% 2
      # if n is odd, erase a point
      if (!is_n_even) {
        n = n - 1
      }
      # do splits 
      critical_pt = round(tr_pct*n) 
      # the most recent time is row 1, so split from top down
      # we want to use the past to predict the future 
      tr_indices = 1:critical_pt
      ts_indices = (critical_pt+1):n
      # save data in cooked datasets.
      # train
      private$Book$Cooked$DS$Regular$Train$X = X[tr_indices, ]
      private$Book$Cooked$DS$Regular$Train$Y$labels = labels[tr_indices]
      private$Book$Cooked$DS$Regular$Train$Y$returns = returns[tr_indices]
      private$Book$Cooked$DS$Regular$Train$Date = Date[tr_indices]
      # test
      private$Book$Cooked$DS$Regular$Test$X = X[ts_indices, ]
      private$Book$Cooked$DS$Regular$Test$Y$labels = labels[ts_indices]
      private$Book$Cooked$DS$Regular$Test$Y$returns = returns[ts_indices]
      private$Book$Cooked$DS$Regular$Test$Date = Date[ts_indices]
      # now the data is ready for modeling
    }, 
    form_daily_datasets = function(){
      # call this function ONLY if form regular datasets has been called 
      # get the unique days 
      date = private$Book$Raw$DS$Date
      week_days = wday(date, label = TRUE)
      day_labels = unique(week_days) %>% sort()
      # for the train and test data sets, compute the daily data 
      for (ds in c('Train', 'Test')) {
        # get unique days, Mon-Fri
        date = private$Book$Cooked$DS$Regular[[ds]]$Date
        temp_days = wday(date, label = TRUE)
        for (day in day_labels) {
          # get indices for the day 
          indices = temp_days == day
          # save the data 
          private$Book$Cooked$DS$Daily[[day]][[ds]]$X = private$Book$Cooked$DS$Regular[[ds]]$X[indices, ]
          private$Book$Cooked$DS$Daily[[day]][[ds]]$Y$labels = private$Book$Cooked$DS$Regular[[ds]]$Y$labels[indices]
          private$Book$Cooked$DS$Daily[[day]][[ds]]$Y$returns = private$Book$Cooked$DS$Regular[[ds]]$Y$returns[indices]
          private$Book$Cooked$DS$Daily[[day]][[ds]]$Date = private$Book$Cooked$DS$Regular[[ds]]$Date[indices]
        }
      }
    }, 
    get_Book = function(){
      return(private$Book)
    }
  )
)

# mjr = QueryQuantmod$new('GOOG')
# mjr$query()
# mjr2 = Cubism$new(2, 2, mjr$get_Book())
# mjr2$compute_Y()
# mjr2$compute_X()
# mjr3 = TrainTest$new(.7, .3, mjr2$get_Book())
# mjr3$form_regular_datasets()
# mjr3$form_daily_datasets()
# mjr3$get_Book() %>% str()