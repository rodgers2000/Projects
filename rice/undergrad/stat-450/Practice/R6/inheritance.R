library(R6)

Class1 <- R6Class(
  'Class1',
  public = list(
    w = NA, 
    x = NA, 
    initialize = function(w = NA, x = NA){
      self$w = w
      self$x = x 
    }
  )
)

Class2 <- R6Class('Class2',
  inherit = Class1, 
  public = list(
    y = NA, 
    initialize = function(w, x, y = NA){
      super$initialize(w, x)
      self$y = y
    }
  )
)

Class3 <- R6Class('Class3',
  inherit = Class2, 
  public = list(
    z = NA, 
    initialize = function(w, x, y, z = NA){
      super$initialize(w, x, y)
      self$z = z
    },
    show_attributes = function(){
      m1 = paste0('w = ', self$w)
      m2 = paste0('x = ', self$x)
      m3 = paste0('y = ', self$y)
      m4 = paste0('z = ', self$z)
      cat(m1, '\n')
      cat(m2, '\n')
      cat(m3, '\n')
      cat(m4, '\n')
    }
  )
  
)

mjr = Class3$new(1, 2, 3, 4)
 
# Class3$debug('show_attributes')
# Class3$undebug('show_attributes')

mjr$show_attributes()