# YOLO 
Nucleus = the_machines_will_rule(Brain, n = 200)
cagr_df = get_cagrs(Nucleus, Brain)
save_accuracy_and_confusion_matrix(Nucleus, label = 5)

## COR PLOT 
library(RColorBrewer)
corrplot::corrplot(dat_UNIV[, 9:30] %>% cor(), method = "color", outline = T, addgrid.col = "darkgray")


Nucleus = readRDS(paste0(getwd(), "/Data/Nucleus.rds"))

## run pipeline-1
library(randomForest)

for (label in c(2, 5, 10, 20)) {
  
  Brain = list("Universe" = dat_UNIV, "Returns" = dat_RETURNS)
  Brain = adjust_high_returns(Brain, 3)
  Brain = calculate_labels(Brain, label)
  Brain = adjust_Y(Brain)
  Brain = remove_NA_returns(Brain)
  Brain = adjust_IDYX(Brain)
  Brain = adjust_return_features(Brain)
  
  indices = sample(1:nrow(Brain$Universe), 10000)
  rf = randomForest(Brain$Universe[indices, -(1:6)], factor(Brain$Universe$Y[indices]), mtry = sqrt(ncol(Brain$Universe[, -(1:6)])))
  pdf(paste0(label, ".pdf"), width = 10, height = 8)
  varImpPlot(rf, main = paste0("Feature Importance (n = ", label, ")"))
  dev.off()
}
