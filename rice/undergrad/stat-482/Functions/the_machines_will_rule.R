# run pipeline-1 first 
# lets eat carrots 

the_machines_will_rule <- function(Brain2 = Brain, start_year = 1980, end_year = 2016, n = 300){
  library(caret)
  library(parallel)
  library(doParallel)
  
  # cores
  cluster = makeCluster(detectCores() - 1)
  registerDoParallel(cluster)
  Core = list()
  length(Core) = end_year - start_year + 1
  names(Core) = seq(start_year, end_year, 1)
  
  year_holder = 1
  for (year in start_year:end_year) {
    # give a core and receive a core 
    Core[[year_holder]] = get_train_data(Brain2, Core[[year_holder]], year-2, n)
    Core[[year_holder]] = get_test_data(Brain2, Core[[year_holder]], year-1)
    Core[[year_holder]] = get_knn_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_naiveBayes_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_lda_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_lasso_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_svm_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_rf_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_gbm_predictions(Core[[year_holder]])
    Core[[year_holder]] = get_return_data(Brain2, Core[[year_holder]], year)
    Core[[year_holder]] = get_company_data(Brain2, Core[[year_holder]], year)
    year_holder = year_holder + 1
    cat(year, "\n")
  }
  
  stopCluster(cluster)
  return(Core)
}
