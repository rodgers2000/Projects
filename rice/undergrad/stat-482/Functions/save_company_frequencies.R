save_company_frequencies <- function(Nucleus2 = Nucleus, label2 = label){
  for (method in 1:(length(Nucleus2$`1980`$Method)-1)) {
    for (year in 1:length(Nucleus2)) {
      if(year == 1){
        company_winners_vec = Nucleus2[[year]]$Method[[method]]$Companies$Winners$conm.x
        company_losers_vec = Nucleus2[[year]]$Method[[method]]$Companies$Losers$conm.x
        company_winners_vec_gv = Nucleus2[[year]]$Method[[method]]$Companies$Winners$GVKEY
        company_losers_vec_gv = Nucleus2[[year]]$Method[[method]]$Companies$Losers$GVKEY
      }
      else{
        company_winners_vec = c(Nucleus2[[year]]$Method[[method]]$Companies$Winners$conm.x, company_winners_vec)
        company_losers_vec = c(Nucleus2[[year]]$Method[[method]]$Companies$Losers$conm.x, company_losers_vec)
        company_winners_vec_gv = c(Nucleus2[[year]]$Method[[method]]$Companies$Winners$GVKEY, company_winners_vec_gv)
        company_losers_vec_gv = c(Nucleus2[[year]]$Method[[method]]$Companies$Losers$GVKEY, company_losers_vec_gv)
      }
    }
    winners = as.data.frame(table(company_winners_vec))
    winners = winners[order(winners$Freq, decreasing = TRUE), ]
    losers = as.data.frame(table(company_losers_vec))
    losers = losers[order(losers$Freq, decreasing = TRUE), ]
    
    write_csv(winners, paste0(getwd(), "/Results/Companies/winners_", names(Nucleus2$`1980`$Method)[method],"_", label2 ,".csv"))
    write_csv(losers, paste0(getwd(), "/Results/Companies/losers_", names(Nucleus2$`1980`$Method)[method], "_", label2, ".csv"))
  }
}
