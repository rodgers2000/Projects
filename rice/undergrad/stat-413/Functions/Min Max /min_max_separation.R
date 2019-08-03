min_max_separation <- function(X_tr = dat_X_tr, Y_tr = dat_Y_tr){
  # this function takes two matrices as inputs. it then finds separation 
  # based on min max using lower and upper bounds. it also calculates how many were on the other side 
  labels = unique(Y_tr) %>% sort()
  n_labels = length(labels)
  
  df_results = data.frame("separation" = ncol(X_tr) * n_labels, 
                          "number_infringed" = NA, "feature" = NA, 
                          "min_value" = NA, "max_value" = NA, 
                          "direction" = NA, "label" = NA)
  hold_me = 1
  
  for(label in labels){
    for(feature in 1:ncol(X_tr)){
      vec_label = X_tr[Y_tr == label, feature]
      vec_others = X_tr[Y_tr != label, feature]
      
      max_label = max(vec_label)
      min_label = min(vec_label)
      max_others = max(vec_others)
      min_others = min(vec_others)
      mean_labels = mean(vec_label)
      mean_others = mean(vec_others)
      
      separation = FALSE
      direction = NA
      max_value = NA
      min_value = NA
      var_name = colnames(X_tr)[feature]
      
      if(min_label > max_others){
        separation = TRUE
        direction = "min_label > max_others"
        min_value = min_label
        max_value = max_label
      }
      if(max_label < min_others){
        separation = TRUE
        direction = "max_label < min_others"
        min_value = min_others
        max_value = max_label
      }
      
      if(mean_labels > mean_others)
        number_infringed = sum(vec_others > min_label)
      else
        number_infringed = sum(vec_label > min_others)
      
      df_results[hold_me, ] = c(separation, number_infringed, var_name, min_value, max_value, direction, label)
      
      hold_me = hold_me + 1
    }
  }
  return(df_results)
}
