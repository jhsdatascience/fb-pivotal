source('load.R')
source('matchups.R')

batters <- load_batters()
batter_fields <- load_batter_fields()
matchups <- load_matchups()
nweeks <- get_nweeks(batters[[1]])

weekly_totals <- get_weekly_totals(batters)
opponent_totals <- get_opponent_totals(weekly_totals, matchups)
wlt <- calculate_wins(weekly_totals[[2]], opponent_totals[[2]])