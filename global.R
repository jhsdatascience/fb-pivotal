library(plyr)
library(ggplot2)
source('lib/load.R')
source('lib/matchups.R')
source('lib/replace.R')
source('lib/plots.R')
load_all('data')
weekly_totals <<- get_weekly_totals(batters)
opponent_totals <<- get_opponent_totals(weekly_totals, matchups)

league_standings <<- calculate_records(weekly_totals, opponent_totals)

team_choices <- as.list(teams$id)
names(team_choices) <- teams$team
category_choices <- as.list(batter_fields$stat)
names(category_choices) <- batter_fields$desc

rosters <<- get_rosters()