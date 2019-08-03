run_backtest <- function(time, ahead, n_test, n_train, stock) {
  # 1. get data 
  step1 = QueryQuantmod$new(stock = stock)
  step1$query()
  # 2. get X, Y
  step2 = Cubism$new(time = time, ahead = ahead, Book = step1$get_Book())
  step2$compute_X()
  step2$compute_Y()
  Book = step2$get_Book()
  # 3. get datasets: train, test
  test_percent = n_test / nrow(Book$Raw$DS$X) # solve for the test percent 
  Book$Params$n$test = n_test
  # do step 3. 
  step3 = TrainTest$new(train_percent = 1 - test_percent, test_percent = test_percent, Book = Book)
  step3$form_regular_datasets()
  # 4. get core
  Book = step3$get_Book()
  Core = Book$Cooked$DS$Regular
  # 5. get predictions 
  Book$Params$n$train = n_train
  step4 = VanillaModels$new(Core, n_train = n_train)
  step4$base_learners()
  Methods = step4$get_Methods()
  # 6. get statistics 
  Nucleus = list()
  Nucleus$Book = Book 
  Nucleus$Methods = Methods
  step5 = DatePlots$new(Nucleus)
  step5$plot_accuracy()
  step5$plot_dollar()
  # return nucleus for mega plot  
  return(step5$get_Nucleus())
}

# Nucleus = run_backtest(3, 1, 100, 100, 'GOOG')