MegaPlots <- R6Class(
  'MegaPlots',
  private = list(
    MegaDF_A = NA, 
    MegaDF_R = NA, 
    counter_A = 1, # this is used to create or add the DF 
    counter_R = 1
  ), 
  public = list(
    initialize = function() {
      # do nothing 
    }, 
    get_MegaDF_A = function() {
      return(private$MegaDF_A)
    },
    get_MegaDF_R = function() {
      return(private$MegaDF_R)
    }, 
    compute_mega_accuracy = function(Nucleus) {
      # set params 
      time = Nucleus$Book$Params$time
      ahead = Nucleus$Book$Params$ahead
      # get truths 
      y = Nucleus$Book$Cooked$DS$Regular$Test$Y$labels
      # initialize temp data 
      hold_accuracy = c()
      hold_methods = c()
      # compute final accuracy for each method 
      for (method in names(Nucleus$Methods)) {
        # get predictions 
        yhat = Nucleus$Methods[[method]]$Yhat
        # compute accuracy 
        accuracy = sum(yhat == y) / length(y)
        # store accuracy and method
        hold_accuracy = c(hold_accuracy, accuracy)
        hold_methods = c(hold_methods, method)
      }
      if (private$counter_A == 1) {
        # make df 
        df = data.frame('accuracy' = hold_accuracy, 'method' = hold_methods)
        df$time = rep(time, nrow(df))
        df$ahead = rep(ahead, nrow(df))
        # save and make df 
        private$MegaDF_A = df 
      }
      else {
        # make df 
        df = data.frame('accuracy' = hold_accuracy, 'method' = hold_methods)
        df$time = rep(time, nrow(df))
        df$ahead = rep(ahead, nrow(df))
        # save and modify df 
        private$MegaDF_A = rbind(private$MegaDF_A, df)
      }
      # change counter to stop if statement 
      private$counter_A = 2
    }, 
    compute_mega_return = function(Nucleus) {
      # set params
      time = Nucleus$Book$Params$time
      ahead = Nucleus$Book$Params$ahead
      # set shortcuts 
      Test = Nucleus$Book$Cooked$DS$Regular$Test
      # get truths 
      y = Nucleus$Book$Cooked$DS$Regular$Test$Y$labels
      # initialize temp data 
      hold_returns = c()
      hold_standard_errors = c()
      hold_methods = c()
      model_returns = c()
      for (method in names(Nucleus$Methods)) {
        # initialize queue, $ahead dollar turns into
        Q = Queue$new()
        for (investment in 1:ahead) {
          Q$add(1) # add ones becauase we invest equally in each day 
        }
        # get its predictions and returns
        yhat = Nucleus$Methods[[method]]$Yhat
        returns = Nucleus$Book$Cooked$DS$Regular$Test$Y$returns
        for (point in 1:nrow(Test$X)) {
          # if we predicted up, 
          if (yhat[point] == 1) {
            # remove the value 
            value = Q$remove() 
            return = returns[point] # get return
            model_returns = c(model_returns, return) # store model's return for standard error calc
            value = value * (return + 1) # change value based on win or lose 
            Q$add(value) # add the value back. this holds since we set queue to ahead values of 1
          }
        }
        # get Queue sum. this is the total return for the period 
        investments = Q$get_Queue()
        sum_of_Q = 0 
        for (index in 1:length(investments)) {
          sum_of_Q = investments[[index]] + sum_of_Q
        }
        total_return = sum_of_Q / ahead - 1 # we have the value of final porfolio
        #         compute standard errors 
        # for 500 times, compute 500 total returns, take standard error 
        times = 5
        sim_total_returns = c()
        for (sim in 1:times) {
          sim_returns = sample(x = model_returns, size = length(model_returns), replace = TRUE) # bootin'
          # compute final value
          # initialize queue, $ahead dollar turns into
          Q = Queue$new()
          for (investment in 1:ahead) {
            Q$add(1) # add ones becauase we invest equally in each day
          }
          for (point in 1:length(sim_returns)) {
            # for each point, we always predict up since the model predicted these already
            # remove the value
            value = Q$remove()
            return = sim_returns[point] # get return
            value = value * (return + 1) # change value based on win or lose
            Q$add(value) # add the value back. this holds since we set queue to ahead values of 1
          }
          # get Queue sum. this is the total return for the period
          investments = Q$get_Queue()
          sum_of_Q = 0
          for (index in 1:length(investments)) {
            sum_of_Q = investments[[index]] + sum_of_Q
          }
          temp_total_return = sum_of_Q / ahead - 1 # we have the value of final porfolio
          sim_total_returns = c(sim_total_returns, temp_total_return)
        }
        # simulation done
        standard_error = sd(sim_total_returns)
        # save data
        hold_returns = c(hold_returns, total_return)
        hold_standard_errors = c(hold_standard_errors, standard_error)
        hold_methods = c(hold_methods, method)
      }
      # outside of each method
      # form data frames 
      if (private$counter_R == 1) {
        # make df 
        df = data.frame('return' = hold_returns, 
                        'standard_error' = hold_standard_errors, 
                        'method' = hold_methods)
        df$time = rep(time, nrow(df))
        df$ahead = rep(ahead, nrow(df))
        # save df 
        private$MegaDF_R = df
      } else {
        # make df 
        df = data.frame('return' = hold_returns, 
                        'standard_error' = hold_standard_errors, 
                        'method' = hold_methods)
        df$time = rep(time, nrow(df))
        df$ahead = rep(ahead, nrow(df))
        # save and modify df 
        private$MegaDF_R = rbind(private$MegaDF_R, df)
      }
      # change counter for if statement
      private$counter_R = 2
    }, 
    plot = function(Nucleus) {
      df_A = private$MegaDF_A
      df_R = private$MegaDF_R
      # set shortcut 
      Params = Nucleus$Book$Params
      my_caption = paste0(
        'n_train = ', Params$n$train, 
        ', n_test = ', Params$n$test)
      
      # calculate significance for returns
      critical_pt = 1 # 68% by chebyshev's theorem
      condition = (df_R$return - critical_pt * df_R$standard_error) > 0 # if we have a lower bound greater than one, then positive return!
      df_R$significant = if_else(condition, '+', '-')
      # change time colname for facet 
      colnames(df_A)[3] = 'Time'
      colnames(df_R)[4] = 'Time'
      # plot data 
      ggplot(df_A, aes(x = ahead, y = accuracy, color = method)) + 
        geom_point(size = 2) + 
        facet_grid(. ~ Time, labeller = label_both) + 
        theme_bw() + 
        labs(title = Params$transformation,
             subtitle = Params$stock, 
             caption = my_caption, 
             color = 'Method', 
             x = 'Ahead', 
             y = 'Terminal Accuracy')
      
      path = paste0(getwd(), '/Results/Plots/Mega/Accuracy/')
      ggsave(paste0(path, Params$stock, ', ma, ', my_caption, '.pdf'), width = 8, height = 6)
      
      # plot data 
      ggplot(df_R, aes(x = ahead, y = return, color = method)) + 
        geom_point(size = 2) + 
        facet_grid(. ~ Time, labeller = label_both) + 
        theme_bw() + 
        labs(title = Params$transformation,
             subtitle = Params$stock, 
             caption = my_caption, 
             color = 'Method', 
             x = 'Ahead', 
             y = 'Terminal Return')
      
      path = paste0(getwd(), '/Results/Plots/Mega/Return/')
      ggsave(paste0(path, Params$stock, ', mr, ', my_caption, '.pdf'), width = 8, height = 6)
    }
  )
)

# stock = 'GOOG'
# n_test = 100
# n_train = 100
# time = 3
# ahead = 2
# 
# step1 = MegaPlots$new()
# for (ahead in c(1, 3)) {
#   for (time in c(3, 5)) {
#     Nucleus = run_backtest(time = time, ahead = ahead, n_test = n_test, n_train = n_train, stock = stock)
#     step1$compute_mega_accuracy(Nucleus)
#     step1$compute_mega_return(Nucleus)
#     }
#   }

# step1$plot(Nucleus)
