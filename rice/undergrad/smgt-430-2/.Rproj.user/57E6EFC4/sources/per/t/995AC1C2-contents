MegaLearner <- R6Class(
  'MegaLearner', 
  # attributes
  private = list(
    models = list(), 
    ts = NA
  ), 
  # methods
  public = list(
    initialize = function(this_ts) {
      # this needs to be a vector
      private$ts = this_ts
    }, 
    make_models = function(P) {
      # it searches for p and q a level up. bad style but it's okay
      model_index = 1
      for (p_o in 1:P[1]) {
        for (q_o in 1:P[2]) {
          # give data
          mjr = UnivTimeSeries$new(ts = private$ts, periods = 1)
          # train 
          mjr$manual_fit(O = c(p_o, 0, q_o), S = c(0, 0, 0))
          private$models[[model_index]] = mjr$get_model()
          model_index = model_index + 1
        }
      }
    }, 
    forecast_models = function(ahead) {
      yhats = data.frame()
      for (model in 1:length(private$models)) {
        yhat = forecast(private$models[[model]], level = c(95), h = ahead)
        yhat = PropTrans$public_methods$inverse(data.frame(yhat))
        yhats = rbind(yhats, yhat)
      }
      return(yhats)
    }, 
    get_models = function() {
      return(private$models)
    }
  )
)
