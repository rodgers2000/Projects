df_layman = read.csv('/Users/DirtyMike/Documents/Education/Academics/Rice University/Semesters/Spring 2018/SMGT 430/Project/Data/FP/layman.csv')

start_year= 1950
feature_star = 'win_pct'
teams_star = c('Houston Astros', 'New York Yankees', 'Los Angeles Dodgers')
teams_star = 'Houston Astros'
# subset data 
df_plot = subset(df_layman, yearID > start_year - 1, select = c('win_pct', 'yearID', 'Team', 'lgID'))

team_plot = subset(df_plot, Team %in% teams_star)

ggplot(team_plot, aes(x = yearID, y = win_pct, color = Team)) + geom_line()