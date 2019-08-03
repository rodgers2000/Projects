fastball_or_offspeed <- function(dat_temp = dat_raw_counts){
  dat_hold = dat_temp
  dat_hold$pitch = if_else(dat_temp$pitch %in% c('FF', 'FT'), 'F', 'O')
  return(dat_hold)
}
