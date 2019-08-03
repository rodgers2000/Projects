get_test_data <- function(Brain3 = Brain, Core2 = Core[[year_holder]], year2 = year-1){
  Test = list()
  dat_YEAR = Brain3$Universe %>% subset(cyear == year2)
  Test$X = dat_YEAR[, 7:71] %>% as.matrix()
  Test$Y = dat_YEAR[, 6] %>% as.matrix()
  Test$ID = dat_YEAR[, 1:5]
  Core2$Book$Test = Test
  return(Core2)
}
