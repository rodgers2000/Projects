VanillaModels <- R6Class(
  'VanillaModels', 
  private = list(
    Core = NA, 
    Brain = NA,
    Methods = list()
  ), 
  public = list(
    initialize = function(Core, n_train){
      # initialize the train and test datasets for brain
      X = Core$Train$X
      N = nrow(X)
      if (n_train > N) {
        n_train = N
      }
      if (n_train %% 2 != 0) {
        n_trian = n_train + 1 # it is an odd and make it even
      }
      # randomly sample training examples 
      # get 50% ups and 50% downs 
      indices_down = which(Core$Train$Y$labels == 0)
      indices_up = which(Core$Train$Y$labels == 1)
      indices_down = sample(x = indices_down, size = n_train / 2, replace = FALSE)
      indices_up = sample(x = indices_up, size = n_train / 2, replace = FALSE)
      indices = c(indices_down, indices_up)
      # adjust the values 
      Core$Train$X = X[indices, ]
      Core$Train$Y$labels = Core$Train$Y$labels[indices]
      Core$Train$Y$returns = Core$Train$Y$returns[indices]
      Core$Train$Date = Core$Train$Date[indices]
      # make the brain
      private$Brain = CaretModel$new(Core = Core)
      # set the core 
      private$Core = Core
    }, 
    base_learners = function(){
      # KNN
      private$Methods$KNN$Yhat = private$Brain$build_and_predict(
        list(
          'fitcontrol'  = trainControl(method = 'cv', number = 5),
          'datcontrol'  = NULL,
          'gridcontrol' = expand.grid(k = c(10, 30, 50, 100, 200)),
          'method'      = 'knn'
        )
      )
      
      # NB 
      private$Methods$NB$Yhat = private$Brain$build_and_predict(
        list(
          'fitcontrol'  = trainControl(method = "none"),
          'datcontrol'  = NULL,
          'gridcontrol' = expand.grid(fL = 0, usekernel = TRUE, adjust = FALSE),
          'method'      = "naive_bayes"
        )
      )
      
      # LDA 
      private$Methods$LDA$Yhat = private$Brain$build_and_predict(
        list(
          'fitcontrol'  = trainControl(method = "none"),
          'datcontrol'  = NULL,
          'gridcontrol' = NULL,
          'method'      = "lda"
        )
      )
      
      # RF 
      private$Methods$RF$Yhat = private$Brain$build_and_predict(
        list(
          'fitcontrol'  = trainControl(method = "none"),
          'datcontrol'  = NULL,
          'gridcontrol' = expand.grid(mtry = sqrt(ncol(private$Core$Train$X))),
          'method'      = "rf"
        )
      )
      
      # SVM 
      private$Methods$SVM$Yhat = private$Brain$build_and_predict(
        list(
          'fitcontrol'  = trainControl(method = "cv", number = 5),
          'datcontrol'  = NULL,
          'gridcontrol' = expand.grid(C = 2^(2:8)),
          'method'      = "svmLinear"
        )
      )
      
      # RG (Randomly Guessing)
      private$Methods$RG$Yhat = sample(x = c(0, 1), size = length(private$Methods$KNN$Yhat), replace = TRUE)
      
    }, 
    get_Methods = function(){
      return(private$Methods)
    }
  )
)

# test code
# mjr = VanillaModels$new(Core, n_train = 100)
# mjr$get_base_learners()
# mjr$get_Methods() %>% str()