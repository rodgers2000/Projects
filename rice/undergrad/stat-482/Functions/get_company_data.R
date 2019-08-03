get_company_data <- function(Brain3 = Brain, Core2 = Core[[year_holder]], year2 = year){
  n_labels = unique(Core2$Book$Test$Y) %>% sort() %>% length()
  
  for (method in 1:(length(Core2$Method)-1)) {
    X = Core2$Book$Test$ID
    Yhat = Core2$Method[[method]]$Yhat
    dat_FULL = cbind(X, Yhat = Yhat)
    
    dat_YEAR_RETURNS = Brain3$Returns %>% subset(cyear == year2)
    # here a left join or inner join doesnt matter since we erased NA from our UNIVERSE 
    # we will drop NA returns any way in the calculation, so drop them with inner join 
    mjr = inner_join(dat_YEAR_RETURNS, dat_FULL, by = "GVKEY")
    mjr1 = mjr %>% subset(Yhat == 1)
    mjrn = mjr %>% subset(Yhat == n_labels)
    # save ID
    Core2$Method[[method]]$Companies$Winners = mjrn
    Core2$Method[[method]]$Companies$Losers = mjr1
    Core2$Method[[method]]$Companies$All = rbind(mjrn, mjr1)
  }
  
  return(Core2)
}
