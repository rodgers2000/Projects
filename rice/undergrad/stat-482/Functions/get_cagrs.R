get_cagrs <- function(Nucleus2 = Nucleus, Brain2 = Brain){
  cagr_df = data.frame("Method" = names(Nucleus2$`1980`$Method), "CAGR" = NA, "CAGR_DV" = NA, "CAGR_SE" = NA)
  
  for (year in 1:length(Nucleus2)) {
    for (method in 1:(length(Nucleus2$`1980`$Method)-1)) {
      if(year == 1){
        cagr_df$CAGR[method] = Nucleus2[[year]]$Method[[method]]$Returns$Mean$Winners + 1
        cagr_df$CAGR_DV[method] = Nucleus2[[year]]$Method[[method]]$`Dividend Returns`$Mean$Winners + 1
      }
      else{
        cagr_df$CAGR[method] = prod(Nucleus2[[year]]$Method[[method]]$Returns$Mean$Winners + 1, cagr_df$CAGR[method])
        cagr_df$CAGR_DV[method] = prod(Nucleus2[[year]]$Method[[method]]$`Dividend Returns`$Mean$Winners + 1, cagr_df$CAGR_DV[method])
      }
    }
  }
  
  for (year in 1:length(Nucleus2)) {
    index_id = length(Nucleus2$`1980`$Method)
    if(year == 1){
      cagr_df$CAGR[index_id] = Nucleus2[[year]]$Method[[index_id]]$Returns$Mean + 1
      cagr_df$CAGR_DV[index_id] = Nucleus2[[year]]$Method[[index_id]]$`Dividend Returns`$Mean + 1
    }
    else{
      cagr_df$CAGR[index_id] = prod(Nucleus2[[year]]$Method[[index_id]]$Returns$Mean + 1, cagr_df$CAGR[index_id])
      cagr_df$CAGR_DV[index_id] = prod(Nucleus2[[year]]$Method[[index_id]]$`Dividend Returns`$Mean + 1, cagr_df$CAGR_DV[index_id])
    }
  }
  
  cagr_df$CAGR = cagr_df$CAGR^(1/length(Nucleus2)) - 1
  cagr_df$CAGR_DV = cagr_df$CAGR_DV^(1/length(Nucleus2)) - 1

  for (method in 1:(length(Nucleus$`1980`$Method)-1)) {
    cagr_vec = NA
    for(boot_strap in 1:100){
      for (year in 1:length(Nucleus)) {
        return_sample = sample(Nucleus[[year]]$Method[[method]]$Returns$Raw$Winners, length(Nucleus[[year]]$Method[[method]]$Returns$Raw$Winners), replace = TRUE)
        if(year == 1)
          means_vec = mean(return_sample)
        else
          means_vec = c(means_vec, mean(return_sample))
      }
      if(boot_strap == 1)
        cagr_vec = prod(means_vec + 1)^(1/length(Nucleus)) - 1
      else 
        cagr_vec = c(prod(means_vec + 1)^(1/length(Nucleus)) - 1, cagr_vec)
    }
    cagr_df$CAGR_SE[method] = sd(cagr_vec)
  }
  
  for (boot_strap in 1:100) {
    for (year in 1:length(Nucleus2)) {
      year_returns = Brain2$Returns %>% subset(cyear == 1979+year) 
      year_returns = year_returns$return
      return_sample = sample(year_returns,length(year_returns), replace = TRUE)
      if(year == 1)
        means_vec = mean(return_sample)
      else
        means_vec = c(means_vec, mean(return_sample))
    }
    if(boot_strap == 1)
      cagr_vec = prod(means_vec + 1)^(1/length(Nucleus)) - 1
    else 
      cagr_vec = c(prod(means_vec + 1)^(1/length(Nucleus)) - 1, cagr_vec)
  }
  cagr_df$CAGR_SE[length(Nucleus2$`1980`$Method)] = sd(cagr_vec)

  return(cagr_df)
}
