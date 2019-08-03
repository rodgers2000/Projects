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
# sourceDirectory('~/Documents/Languages/R/Machine Learning/Models/')

# read
dat_train <- read_csv(paste0(getwd(), '/Data/cooked_training_data.csv'))
dat_test <- read_csv(paste0(getwd(), '/Data/cooked_test_data.csv'))

# split
Train = list('group1' = get_group_data(dat_train, group_labs = 1:3), 
             'group2' = get_group_data(dat_train, group_labs = 4:5), 
             'group3' = get_group_data(dat_train, group_labs = 6))

Test = split_test_data(dat_test)

Group = list('group1' = list('Train' = Train$group1, 'Test' = Test$group1), 
             'group2' = list('Train' = Train$group2, 'Test' = Test$group2), 
             'group3' = list('Train' = Train$group3, 'Test' = Test$group3))

start_time = proc.time()
# Group 1 
Group$group1 = machine_learning(Group$group1, no_feature_selection, svm_star)
# Group 2
Group$group2 = machine_learning(Group$group2, no_feature_selection, svm_star)
# Group 3 
Group$group3$Test$CrystalBall = 6
end_time = proc.time()

(end_time - start_time) / 60 / 60 # hours 

submit_predictions(Group, 'GBM AND RF')

stopCluster(cluster)

plot(Group$group1$Test$Method)
plot(Group$group2$Test$Method)
