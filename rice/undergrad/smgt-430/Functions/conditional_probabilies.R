conditional_probabilities <- function(dat_temp = dat_raw_counts){
  # we can condition on anything and calculate the probabilies this way. 
  # here we condition on the count and take the frequencies for each pitch 
  # so each count will sum to 1 
  dat_temp = dat_temp %>% subset(pitch != 'UN')
  dat_results = dat_temp %>% group_by(count, pitch) %>% 
    summarise(n = n()) %>% 
    mutate(freq = n / sum(n))
  dat_results$count = paste0('(', dat_results$count, ')')
  dat_results = dat_results[,c(1, 2, 4, 3)]
  return(dat_results)
}
