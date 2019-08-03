get_return_data <- function(Brain3 = Brain, Core2 = Core[[year_holder]], year2 = year){
  n_labels = unique(Core2$Book$Test$Y) %>% sort() %>% length()
  
  for (method in 1:length(Core2$Method)) {
    X = Core2$Book$Test$ID
    Yhat = Core2$Method[[method]]
    dat_FULL = cbind(X, Yhat)
    
    dat_YEAR_RETURNS = Brain3$Returns %>% subset(cyear == year2)
    # here a left join or inner join doesnt matter since we erased NA from our UNIVERSE 
    # we will drop NA returns any way in calculation, so drop them with inner join 
    mjr = inner_join(dat_YEAR_RETURNS, dat_FULL, by = "GVKEY")
    mjr1 = mjr %>% subset(Yhat == 1)
    mjrn = mjr %>% subset(Yhat == n_labels)
    # save returns 
    Core2$Method[[method]]$Returns$Raw$Winners = mjrn$return
    Core2$Method[[method]]$Returns$Raw$Losers = -1*mjr1$return
    Core2$Method[[method]]$Returns$Raw$All = c(mjrn$return, -1*mjr1$return)
    Core2$Method[[method]]$`Dividend Returns`$Raw$Winners = mjrn$return_div
    Core2$Method[[method]]$`Dividend Returns`$Raw$Losers = -1*mjr1$return_div
    Core2$Method[[method]]$`Dividend Returns`$Raw$All = c(mjrn$return_div, -1*mjr1$return_div)
    # save means 
    Core2$Method[[method]]$Returns$Mean$Winners = mjrn$return %>% mean()
    Core2$Method[[method]]$Returns$Mean$Losers = -1*mjr1$return %>% mean()
    Core2$Method[[method]]$Returns$Mean$All = c(mjrn$return, -1*mjr1$return) %>% mean()
    Core2$Method[[method]]$`Dividend Returns`$Mean$Winners = mjrn$return_div %>% mean()
    Core2$Method[[method]]$`Dividend Returns`$Mean$Losers = -1*mjr1$return_div %>% mean()
    Core2$Method[[method]]$`Dividend Returns`$Mean$All = c(mjrn$return_div, -1*mjr1$return_div) %>% mean()
  }
  
  # lets index!! 
  Core2$Method$INDEX$Returns$Mean = dat_YEAR_RETURNS$return %>% mean()
  Core2$Method$INDEX$`Dividend Returns`$Mean = dat_YEAR_RETURNS$return_div %>% mean()
  
  return(Core2)
}
