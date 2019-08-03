library(R6)

Class1 <- R6Class(
  'Class1',
  public = list(
    x = NA,
    set_x = function(a) self$x = a,
    print_x = function() print(self$x)
  )
)

mjr = Class1$new()

mjr$set_x(10)
mjr$print_x()
