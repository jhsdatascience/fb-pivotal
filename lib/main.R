library(plyr)
library(ggplot2)
source('lib/load.R')
source('lib/matchups.R')
source('lib/replace.R')
source('lib/plots.R')

load_all('data/')

weekly_totals <- get_weekly_totals(batters)
opponent_totals <- get_opponent_totals(weekly_totals, matchups)

team1 <- batters$`1`
team_weekly_totals <- weekly_totals[[1]]
team_opponent_totals <- opponent_totals[[1]]
player <- 'Mike Napoli'
replacement_player <- calc_replacement_player_stats(batters)
replaced_totals <- get_weekly_totals_with_replacement_player(team1, player)
plot_matchups('R', team_weekly_totals, team_opponent_totals, replaced_totals, player, team1)
