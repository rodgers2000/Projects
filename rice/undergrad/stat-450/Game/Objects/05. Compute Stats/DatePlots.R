DatePlots <- R6Class(
  'DatePlots', 
  # attributes
  private = list(
    Nucleus = NA, 
    cash_date = NA
  ), 
  # methods
  public = list(
    initialize = function(Nucleus) {
      private$Nucleus = Nucleus
      # set shortcuts 
      Nucleus = private$Nucleus
      # compute the date we make money. if ahead = 1, then we make money on the same day we buy
      raw_date_indx = 1:length(Nucleus$Book$Raw$DF$date)
      # find where raw dates match regular dates 
      date_match_indx = which(Nucleus$Book$Raw$DF$date %in% Nucleus$Book$Cooked$DS$Regular$Test$Date)
      # shift the dates to find the dates we make money 
      date_match_indx = date_match_indx + Nucleus$Book$Params$ahead - 1
      # save the dates we make money if there is a predicted up 
      private$cash_date = Nucleus$Book$Raw$DF$date[date_match_indx]
      # source queue object to use for returns with ahead > 1 
      source('~/Documents/Education/Academics/Rice University/Semesters/Spring 2018/STAT 450/R/Up or Down/Game/Objects/5. Compute Stats/Queue.R')
    }, 
    plot_accuracy = function() {
      # initialize data 
      hold_dfs = list()
      df_index = 1
      # set shortcuts 
      Test = private$Nucleus$Book$Cooked$DS$Regular$Test
      # run through methods 
      for (method in names(private$Nucleus$Methods)) {
        # initialize accuracy rate 
        accuracy_rate = c()
        # get its predictions
        yhat = private$Nucleus$Methods[[method]]$Yhat
        n = 1 
        sum1 = 0 
        for (point in 1:nrow(Test$X)) {
          # hit the target?
          correct = yhat[point] == Test$Y$labels[point]
          # guess it didnt 
          accurate = 0 
          if (correct) {
            accurate = 1 
          }
          sum1 = sum1 + accurate
          value = sum1 / n 
          # save value 
          accuracy_rate = c(accuracy_rate, value)
          # next point 
          n = n + 1
        } 
        # save data 
        df = data.frame('accuracy_rate' = accuracy_rate, 'date' = private$cash_date)
        df$method = rep(method, nrow(df))
        hold_dfs[[df_index]] = df 
        df_index = df_index + 1
      }
      # combine dataframes to make tidy data 
      df = hold_dfs[[1]]
      for (temp in 2:length(hold_dfs)) {
        df = rbind(df, hold_dfs[[temp]])
      }
      # plot data 
      # set short cuts 
      Params = private$Nucleus$Book$Params
      my_caption = paste0(
        ' time = ', Params$time, 
        ', ahead = ', Params$ahead, 
        ', n_train = ', Params$n$train, 
        ', n_test = ', Params$n$test)
      
        ggplot(df, aes(x = date, y = accuracy_rate, color = method)) + geom_step() + 
        ylim(0, 1) + 
        scale_x_date(date_labels = "%b-%y") + 
        theme_bw() +
        labs(title = Params$transformation,
             subtitle = Params$stock, 
             caption = my_caption, 
             color = 'Method', 
             x = '', 
             y = 'Cumulative Accuracy')
      # save plot 
      path = paste0(getwd(), '/Results/Plots/Date/Accuracy/')
      ggsave(paste0(path, Params$stock, ', da,', my_caption, '.pdf'), width = 8, height = 6)
    }, 
    plot_dollar = function() {
      # initialize data 
      hold_dfs = list()
      df_index = 1
      # set shortcuts 
      Test = private$Nucleus$Book$Cooked$DS$Regular$Test
      ahead = private$Nucleus$Book$Params$ahead
      # run through methods 
      for (method in names(private$Nucleus$Methods)) {
        # initialize queue, $ahead dollar turns into
        Q = Queue$new()
        for (investment in 1:ahead) {
          Q$add(1) # add ones becauase we invest equally in each day 
        }
        running_value = c()
        # get its predictions and returns
        yhat = private$Nucleus$Methods[[method]]$Yhat
        returns = private$Nucleus$Book$Cooked$DS$Regular$Test$Y$returns
        for (point in 1:nrow(Test$X)) {
          # if we predicted up, 
          if (yhat[point] == 1) {
            # remove the value 
            value = Q$remove() 
            return = returns[point] # get return
            value = value * (return + 1) # change value based on win or lose 
            Q$add(value) # add the value back. this holds since we set queue to ahead values of 1
          }
          # get Queue sum. this is the total return for the period 
          investments = Q$get_Queue()
          sum_of_Q = 0 
          for (index in 1:length(investments)) {
            sum_of_Q = investments[[index]] + sum_of_Q
          }
          current_portfolio_value = sum_of_Q / ahead - 1 # we have the value of equal day investments
          running_value = c(running_value, current_portfolio_value)
        }
        # save data 
        df = data.frame('running_value' = running_value, 'date' = private$cash_date)
        df$method = rep(method, nrow(df))
        hold_dfs[[df_index]] = df 
        df_index = df_index + 1
      }
      # combine dataframes to make tidy data 
      df = hold_dfs[[1]]
      for (temp in 2:length(hold_dfs)) {
        df = rbind(df, hold_dfs[[temp]])
      }
      # plot data 
      # set short cuts 
      Params = private$Nucleus$Book$Params
      my_caption = paste0(
        ' time = ', Params$time, 
        ', ahead = ', Params$ahead, 
        ', n_train = ', Params$n$train, 
        ', n_test = ', Params$n$test)
      
      ggplot(df, aes(x = date, y = running_value, color = method)) + geom_step() + 
        scale_x_date(date_labels = "%b-%y") + 
        theme_bw() + 
        labs(title = Params$transformation,
             subtitle = Params$stock,
             caption = my_caption, 
             color = 'Method', 
             x = '', 
             y = 'Cumulative Return')
      # save plot 
      path = paste0(getwd(), '/Results/Plots/Date/Return/')
      ggsave(paste0(path, Params$stock, ', dr,', my_caption, '.pdf'), width = 8, height = 6)
    }, 
    get_Nucleus = function() {
      return(private$Nucleus)
    }
  )
)

# step5 = DatePlots$new(Nucleus)
# step5$plot_accuracy()
# step5$plot_dollar()