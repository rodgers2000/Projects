dat_G = data.frame(
  rnorm(100),
  sample(c(1, -1), 100, replace = TRUE), 
  sample(c("A", "B", "C"), 100, replace = TRUE)
  )

colnames(dat_G) = c("X", "Y", "Group")

library(R6)
library(tidyverse)

DayModel <- R6Class("DayModel",
                    public = list(
                      day = NA,
                      dat = NA, 
                      initialize = function(day, dat){
                        self$day = day 
                        self$dat = dat 
                      }, 
                      report = function(){
                        mean = mean(self$dat$X)
                        std = sd(self$dat$X)
                        max = max(self$dat$X)
                        min = min(self$dat$X)
                        return(data.frame("stat" = c("mean", "std", "max", "min"), 
                                          "value" = c(mean, std, max, min),
                                          "class" = rep(self$day, 4)))
                      }
                    ))

day_models = list()
for (group in unique(dat_G$Group)) {
  day_models[[group]] = DayModel$new(group, dat_G %>% subset(Group == group))
}

day_models$A$report()
day_models$B$report()
day_models$C$report()


