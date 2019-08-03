machine_learning <- function(group = Group$group1, feature_selection = use_p_features_feature_selection, 
                             model = svm_radial_carrot){
  group = feature_selection(group)
  group = model(group)
  return(group)
}
