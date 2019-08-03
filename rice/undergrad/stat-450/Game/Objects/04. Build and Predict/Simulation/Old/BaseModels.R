BaseModels <- R6Class(
  'BaseModels',
  # attributes
  private = list(
    Nucleus = list()
  ), 
  # methods
  public = list(
    initialize = function(n, Book){
      # load packages for functions
      library(caret)
      private$Nucleus$Book = Book 
      private$Nucleus$Method$BaseModels$Params$n = n
      # set training indices 
      shortcut = Book$Cooked$DS$Regular$Train
      N = nrow(shortcut$X)
      indices = sample(1:N, n, replace = FALSE)
      # save data 
      private$Nucleus$Book$Cooked$DS$Regular$Train$X = shortcut$X[indices, ]
      private$Nucleus$Book$Cooked$DS$Regular$Train$Y$returns = shortcut$Y$returns[indices]
      private$Nucleus$Book$Cooked$DS$Regular$Train$Y$labels = shortcut$Y$labels[indices]
      private$Nucleus$Book$Cooked$DS$Regular$Train$Date = shortcut$Date[indices]
    }, 
    knn = function(){
    
      fitControl = trainControl(method = "cv", number = 5)
      
      datControl = NULL
      
      gridControl = expand.grid(k = c(1, 5, 10, 15, 20, 100))
      
      shortcut = private$Nucleus$Book$Cooked$DS$Regular
      
      method_fit = train(shortcut$Train$X, factor(shortcut$Train$Y$labels), 
                      method = "knn", 
                      preProcess = datControl,
                      trControl = fitControl, 
                      tuneGrid = gridControl)
      
      private$Nucleus$Method$BaseModels$Model$KNN$Yhat$Test = predict(method_fit, newdata = shortcut$Test$X)
      private$Nucleus$Method$BaseModels$Model$KNN$Yhat$Train = predict(method_fit, newdata = shortcut$Train$X)
    }, 
    rf = function(){
      
      shortcut = private$Nucleus$Book$Cooked$DS$Regular
      
      fitControl = trainControl(method = "none")
      
      datControl = NULL
      
      gridControl = expand.grid(mtry = sqrt(ncol(shortcut$Train$X)))
      
      method_fit = train(shortcut$Train$X, factor(shortcut$Train$Y$labels), 
                      method = "rf", 
                      preProcess = datControl,
                      trControl = fitControl, 
                      tuneGrid = gridControl)
      
      private$Nucleus$Method$BaseModels$Model$RF$Yhat$Test = predict(method_fit, newdata = shortcut$Test$X)
      private$Nucleus$Method$BaseModels$Model$RF$Yhat$Train = predict(method_fit, newdata = shortcut$Train$X)
    }, 
    svm_linear = function(){
      fitControl = trainControl(method = "cv", number = 5)
      
      datControl = NULL
      
      gridControl = expand.grid(C = 2^(2:8))
      
      shortcut = private$Nucleus$Book$Cooked$DS$Regular
      
      method_fit = train(shortcut$Train$X, factor(shortcut$Train$Y$labels), 
                         method = "svmLinear", 
                         preProcess = datControl,
                         trControl = fitControl,
                         tuneGrid = gridControl)
      
      private$Nucleus$Method$BaseModels$Model$SVM$Yhat$Test = predict(method_fit, newdata = shortcut$Test$X)
      private$Nucleus$Method$BaseModels$Model$SVM$Yhat$Train = predict(method_fit, newdata = shortcut$Train$X)
    },
    naiveBayes = function(){
      fitControl = trainControl(method = "none")
      
      datControl = NULL
      
      gridControl = expand.grid(fL = 0, usekernel = TRUE, adjust = FALSE)
      
      shortcut = private$Nucleus$Book$Cooked$DS$Regular
      
      method_fit = train(shortcut$Train$X, factor(shortcut$Train$Y$labels), 
                         method = "naive_bayes", 
                         preProcess = datControl,
                         trControl = fitControl,
                         tuneGrid = gridControl)
      
      private$Nucleus$Method$BaseModels$Model$NB$Yhat$Test = predict(method_fit, newdata = shortcut$Test$X)
      private$Nucleus$Method$BaseModels$Model$NB$Yhat$Train = predict(method_fit, newdata = shortcut$Train$X)
    }, 
    get_Nucleus = function(){
      return(private$Nucleus)
    }
  )
)

# test code 
# library(R6)
# mjr = QueryQuantmod$new('GOOG')
# mjr$query()
# mjr2 = Cubism$new(3, 1, mjr$get_Book()) # time, ahead, pass the book!
# mjr2$compute_X()
# mjr2$compute_Y()
# mjr3 = TrainTest$new(.7, .3, mjr2$get_Book()) # train, test, pass the book!
# mjr3$form_regular_datasets() # call regular first 
# mjr4 = BaseModels$new(150, mjr3$get_Book()) # n, pass the book!
# mjr4$knn()
