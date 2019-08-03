library(tidyverse)
library(caret)
library(R.utils)
library(parallel)
library(doParallel)

# cores
cluster = makeCluster(detectCores() - 1)
registerDoParallel(cluster)

# source
sourceDirectory(paste0(getwd(), '/Functions/Feature Selection/'))
sourceDirectory(paste0(getwd(), '/Functions/Models/'))
sourceDirectory(paste0(getwd(), '/Functions/Pipeline/'))
sourceDirectory(paste0(getwd(), '/Functions/Split into Groups/'))
sourceDirectory(paste0(getwd(), '/Functions/Others/'))

# read
dat_train <- read_csv(paste0(getwd(), '/Data/cooked_training_data.csv'))
dat_test <- read_csv(paste0(getwd(), '/Data/cooked_test_data.csv'))

Train = get_group_data(dat_train, group_labs = 1:6)
Test = list("X" = dat_test)

Group = list("Train" = Train, "Test" = Test)

start_time = proc.time()

Group = machine_learning(Group, importance_selection, the_stack_carrot)

end_time = proc.time()

(end_time - start_time) / 60 / 60 # hours 

compare_2_benchmark(Group$Test$CrystalBall)

create_submission_file("THE STACK (FINAL!!!!!)", Group$Test$CrystalBall)

stopCluster(cluster)



