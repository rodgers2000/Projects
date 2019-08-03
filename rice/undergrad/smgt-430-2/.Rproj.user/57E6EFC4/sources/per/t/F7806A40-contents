AFTER <- R6Class(
  'AFTER', 
  # attributes
  private = list(
    models = NA,
    iteration = 1
  ),
  # methods
  public = list(
    update_weights = function(forecast_models) {
      # first step 
      if (private$iteration == 1) {
        n_models = length(forecast_models)
        # initialize list
        map_models = vector(mode = 'list', length = n_models)
        # set initial value
        for (this_model in 1:n_models) {
          map_models[this_model] = 1
        }
        # set value
        for (this_model in 1:n_models) {
          map_models[[this_model]] = list('num' = 1, 'weight' = 1/n_models)
        }
        private$models = map_models
      }
      # all other steps
      if (private$iteration > 1) {
        den = 0 
        for (model_index in 1:length(forecast_models)) {
          # get model object
          model_obj = forecast_models[[model_index]]
          # calculate new numerator 
          new_num = exp(-12 * t(model_obj$residuals) %*% model_obj$residuals / length(model_obj$residuals)) 
          # update model num 
          private$models[[model_index]]$num = private$models[[model_index]]$num * new_num
          # update model weight 
          private$models[[model_index]]$weight = private$models[[model_index]]$num
          # update den
          den = private$models[[model_index]]$num + den
        }
        # now we have the correct den, must convex weights
        for (model_index in 1:length(private$models)) {
          private$models[[model_index]]$weight = private$models[[model_index]]$weight / den 
        }
      }
      # update iteration 
      private$iteration = private$iteration + 1
    }, 
    get_weights = function() {
      weights = c()
      for (this_model in 1:length(private$models)) {
        weights = c(weights, private$models[[this_model]]$weight)
      }
      return(weights)
    }
  )
)

# after = AFTER$new()
# after$update_weights(1:10)
# after$get_weights()
# after$update_weights(1:10)
