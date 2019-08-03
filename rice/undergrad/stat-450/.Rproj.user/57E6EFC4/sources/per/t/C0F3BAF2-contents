CaretModel <- R6Class(
  'CaretModel', 
  private = list(
    Core = NA, 
    Defaultmodel = NA
  ), 
  public = list(
    initialize = function(Core){
      # input: a mapping to the train and test X, Y data.
      # outputs: predictions
      library(caret)
      private$Core = Core
      private$Defaultmodel = list('fitcontrol' = trainControl(method = 'none'), 
                                  'datcontrol' = NULL, 
                                  'gridcontrol' = expand.grid(k = 1), 
                                  'method' = 'knn')
    }, 
    build_and_predict = function(params = private$Defaultmodel){
      # input: mapping for parameters (train control, dat control, grid control, method)
      # set shortcut 
      C = private$Core  
      # set settings 
      fitControl = params$fitcontrol
      datControl = params$datcontrol
      gridControl = params$gridcontrol
      # build model 
      method_fit = train(C$Train$X, factor(C$Train$Y$labels), 
                      method = params$method, 
                      preProcess = datControl,
                      trControl = fitControl, 
                      tuneGrid = gridControl)
      # predict model
      Yhat = predict(method_fit, newdata = C$Test$X)
      return(Yhat)
    }
  )
)

# a = mjr3$get_Book()
# 
# yolo = CaretModel$new(a$Cooked$DS$Regular)
# yolo$build_and_predict(
  # list(
  # 'fitcontrol'  = trainControl(method = 'cv', number = 5),
  # 'datcontrol'  = NULL,
  # 'gridcontrol' = expand.grid(k = c(5, 10)),
  # 'method'      = 'knn'
  #     )
#   )