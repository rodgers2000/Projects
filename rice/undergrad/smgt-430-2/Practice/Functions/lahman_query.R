library(Lahman)
library(tidyverse)
data("Teams")

# There are 30 unique franchises, we'll classify each team according to this. 
teams <- Teams %>%
  filter(yearID >= 1901 & lgID %in% c("AL", "NL")) %>%
  group_by(yearID, teamID) %>%
  mutate(TB = H + X2B + 2 * X3B + 3 * HR,
         WinPct = W/G,
         RPG = R/G,
         HRPG = HR/G,
         TBPG = TB/G,
         KPG = SO/G,
         K2BB = SO/BB,
         WHIP = 3 * (H + BB)/IPouts)


