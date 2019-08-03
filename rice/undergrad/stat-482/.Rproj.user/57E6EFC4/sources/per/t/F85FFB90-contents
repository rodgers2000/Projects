calculate_labels <- function(Brain2 = Brain, labels = 5){
  years = unique(Brain2$Universe$cyear) %>% sort()
  # we must initialize the column to save returns 
  Brain2$Universe$return_label = NA
  
  for(year in years){
    vec_returns = Brain2$Universe$return[Brain2$Universe$cyear == year]
    
    vec_quantile =  quantile(vec_returns, probs = seq(0, 1, by = 1 / labels), na.rm = TRUE)
    
    get_labels <- function(vec_returns2 = vec_returns, labels2 = labels){
      vec_labels = NA
      for(label in 1:labels2){
        for(return in 1:length(vec_returns2)){
          current_return = vec_returns2[return]
          if(is.na(current_return))
            vec_labels[return] = NA
          else {
            if(current_return >= vec_quantile[label] & current_return <= vec_quantile[label + 1])
              vec_labels[return] = label 
            else 
              next 
          }
        }
      }
      return(vec_labels)
    }
    
    labels_return = get_labels(vec_returns, labels)
    Brain2$Universe$return_label[Brain2$Universe$cyear == year] = labels_return
  }
  # we dont need this bc we have a return db 
  Brain2$Universe = Brain2$Universe %>% subset(select = -return)
  return(Brain2)
}

