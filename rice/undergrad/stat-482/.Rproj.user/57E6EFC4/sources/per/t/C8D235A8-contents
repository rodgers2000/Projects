library(tidyverse)
library(R.utils)
library(readr)
library(lubridate)

dat_UNIV = read_csv(paste0(getwd(), "/Data/UNIVERSE.csv"))
dat_RETURNS = read_csv(paste0(getwd(), "/Data/RETURNS.csv"))

sourceDirectory(paste0(getwd(), '/Functions/'))
sourceDirectory(paste0(getwd(), '/Models/'))

Brain = list("Universe" = dat_UNIV, "Returns" = dat_RETURNS) # BRAIN is a list of tibbles, we pass this everywhere 

### stop 

Brain = adjust_high_returns(Brain, 3)
Brain = calculate_labels(Brain, 10)
Brain = adjust_Y(Brain)
Brain = remove_NA_returns(Brain)
Brain = adjust_IDYX(Brain)
Brain = adjust_return_features(Brain)



