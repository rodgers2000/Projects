library(tidyverse)

dat_train <- read_csv(paste0(getwd(), "/Data/cooked_training_data.csv"))
dat_test <- read_csv(paste0(getwd(), "/Data/cooked_test_data.csv"))

dat_X_tr = dat_train %>% subset(select = -activity) %>% as.matrix()
dat_Y_tr = dat_train %>% subset(select = activity) %>% as.matrix()

dat_1vs2 = dat_train %>% filter(activity != 6) %>% mutate(new_label = if_else(activity %in% 1:3, 1, 2))
dat_X_tr_1vs2 = dat_1vs2 %>% subset(select = -c(activity, new_label)) %>% as.matrix()
dat_Y_tr_1vs2 = dat_1vs2 %>% subset(select = new_label) %>% as.matrix()

source(paste0(getwd(), "/Functions/min_max_separation.R"))
sep_point_group1group2vsgroup3 = min_max_separation(dat_X_tr, dat_Y_tr)
sep_point_group1vsgroup2 = min_max_separation(dat_X_tr_1vs2, dat_Y_tr_1vs2)

source(paste0(getwd(), "/Functions/get_group_data.R"))

dat_group1 = get_group_data(group_labs = 1:3)
dat_group2 = get_group_data(group_labs = 4:5)
dat_group3 = get_group_data(group_labs = 6)

