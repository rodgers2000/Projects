split_test_data <- function(dat_temp = dat_test){
  dat_temp$group = NA
  # we must assign identification to each point 
  dat_temp$I.D. = 1:nrow(dat_temp)
  # this is a marble drop. the test point will fall in the group it belongs to. 
  for(test_point in 1:nrow(dat_temp)){
    # drop test point 
    crit_pt_1_point = dat_temp$`tGravityAcc-min()-X`[test_point]
    upper_bound_6 = 0.010037503
    lower_bound_others = 0.196309438
    margin_6_upper = abs(upper_bound_6 - crit_pt_1_point)
    margin_6_lower = abs(lower_bound_others - crit_pt_1_point)
    
    if(crit_pt_1_point <= upper_bound_6){
      # it is a 6 
      group = 3
    }
    else{
      if(crit_pt_1_point >= lower_bound_others){
        # it is 1, 2, 3, 4, 5
        crit_pt_2_point = dat_temp$`tBodyAccJerk-max()-X`[test_point]
        upper_bound_group2 = -0.777542601
        lower_bound_group1 = -0.776478817
        
        if(crit_pt_2_point < upper_bound_group2){
          # it is a 4 or 5 
          group = 2
        }
        else{
          # it is a 1, 2, or 3 
          group = 1
        }
      }
      else{
        if(margin_6_upper < margin_6_lower){
          # is it closer to 6
          group = 3
        }
        else{
          # it is closer to 1, 2, 3, 4, 5 
          crit_pt_2_point = dat_temp$`tBodyAccJerk-max()-X`[test_point]
          upper_bound_group2 = -0.777542601
          lower_bound_group1 = -0.776478817
          
          if(crit_pt_2_point < upper_bound_group2){
            # it is a 4 or 5
            group = 2
          }
          else{
            # it is a 1, 2, or 3
            group = 1
          }
        }
      }
    }
    dat_temp$group[test_point] = group
  }
  # we want to work with lists and matrices 
  group1 = dat_temp %>% subset(group == 1, select = -group) %>% as.matrix()
  group2 = dat_temp %>% subset(group == 2, select = -group) %>% as.matrix()
  group3 = dat_temp %>% subset(group == 3, select = -group) %>% as.matrix()
  Test = list("group1" = list("X" = group1 %>% subset(select = -I.D.), "I.D." = group1 %>% subset(select = I.D.)), 
              "group2" = list("X" = group2 %>% subset(select = -I.D.), "I.D." = group2 %>% subset(select = I.D.)), 
              "group3" = list("X" = group3 %>% subset(select = -I.D.), "I.D." = group3 %>% subset(select = I.D.))
              )
  return(Test)
}
