get_train_data <- function(Brain3 = Brain2, Core2 = Core[[year_holder]], year2 = year-2, n2 = 100){
  ### lets forget about this mistake 
  Train = list()
  dat_YEARS = Brain3$Universe %>% subset(cyear <= year2)
  n_labels = unique(dat_YEARS$Y) %>% length()
  labels = unique(dat_YEARS$Y) %>% sort()
  
  while ((n2 %% n_labels) != 0) {
    n2 = n2 + 1
  }
  
  for (class in labels) {
    dat_CLASS = dat_YEARS %>% subset(Y == class)
    index = sample(1:nrow(dat_CLASS), n2 / n_labels)
    if (class == 1) {
      Train$X = dat_CLASS[index, 7:71]
      Train$Y = dat_CLASS[index, 6]
      Train$ID = dat_CLASS[index, 1:5]
    }
    else {
      Train$X = rbind(Train$X, dat_CLASS[index, 7:71])
      Train$Y = rbind(Train$Y, dat_CLASS[index, 6])
      Train$ID = rbind(Train$ID, dat_CLASS[index, 1:5])
    }
  }
  
  Train$X = Train$X %>% as.matrix()
  Train$Y = Train$Y %>% as.matrix()
  Core2$Book$Train = Train
  return(Core2)
}
