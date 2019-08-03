tune_svm_rbf <- function(X_tr = list3_X_tr$X_tr_group1 %>% scale(), Y_tr = list3_Y_tr$Y_tr_group1 %>% scale(),
                         cost_levels2 = 2^(3:10),
                         gamma_levels2 = 2^(-12:-6),
                         divide_and_conquer2 = 10,
                         k_fold_cv2 = 10,
                         gamma_star2 = .015625){
  library(e1071)
  divide_and_conquer <- function(cost_levels3 = cost_levels2,
                                 gamma_levels3 = gamma_levels2,
                                 divide_and_conquer3 = divide_and_conquer2,
                                 k_fold_cv3 = k_fold_cv2,
                                 gamma_star3 = gamma_star2){

    for(index_me in 1:divide_and_conquer3){
      svm_tune = tune(svm, train.x=X_tr, train.y=factor(Y_tr), ranges=list(cost=cost_levels3, gamma=gamma_star3), tunecontrol=tune.control(cross=k_fold_cv3), kernel="radial", scale=FALSE)
      # Divide and Conquer
      exp_star = log2(svm_tune$best.parameters$cost)
      range = (exp_star - 3):(exp_star + 3)
      cost_levels3 = 2^range
      cost_star3 = svm_tune$best.parameters$cost
      if(index_me == 1){
        cost_star_previous = cost_star3
      }
      else{
        if(cost_star_previous == cost_star3)
          break
        else
          cost_star_previous = cost_star3
      }
      cat(index_me, "\n")
    }

    for(index_me in 1:divide_and_conquer3){
      svm_tune = tune(svm, train.x=X_tr, train.y=factor(Y_tr), ranges=list(cost=cost_star3, gamma=gamma_levels3), tunecontrol=tune.control(cross=k_fold_cv3), kernel="radial", scale=FALSE)
      # Divide and Conquer
      exp_star = log2(svm_tune$best.parameters$gamma)
      range = (exp_star - 3):(exp_star + 3)
      gamma_levels3 = 2^range
      gamma_star3 = svm_tune$best.parameters$gamma
      if(index_me == 1){
        gamma_star_previous = gamma_star3
      }
      else{
        if(gamma_star_previous == gamma_star3)
          break
        else
          gamma_star_previous = gamma_star3
      }
      cat(index_me, "\n")
    }
    return(svm_tune)
  }

  mjr = divide_and_conquer()
  # # TEST!!!!
  # cost_levels = 2^(-1:2)
  # gamma_levels = 2^(-1:0)
  # divide_and_conquer = 10
  # k_fold_cv = 2
  # gamma_star = .00097
  # mjr = tune(svm, train.x = X_tr, train.y = factor(Y_tr), ranges=list(cost=cost_levels, gamma=gamma_levels), tunecontrol=tune.control(cross=k_fold_cv), kernel="radial", scale=FALSE)
  return(mjr)
}
