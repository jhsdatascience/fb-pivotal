## Functions for working with replacement players

calc_replacement_player_stats <- function(league, q = .25) {
    roster <- ldply(league)
    player_week_df <- ddply(roster, .(week, player), function(x) {colSums(x[,names(x) %in% batter_fields$raw], na.rm = T)})[,-c(1,2)]
    stats <- sapply(player_week_df, quantile, q, na.rm = T) / 5
    names(stats) <- c(batter_fields$raw)
    stats
}

replace_player <- function(player, replacement_player, roster) {
    player_ind <- roster$player == player
    player_df <- roster[player_ind,]
    roster[player_ind,] <- ddply(player_df, .(week), function(x) replace_player_daily_stats(x, replacement_player))
    roster
}

replace_player_daily_stats <- function(week, replacement_player_stats) {
    names_ind <- names(week) %in% batter_fields$raw
    for (i in 1:7) {
        if (all(!is.na(week[i,names_ind]))) week[i,names_ind] <- replacement_player_stats
    }
    week
}

#d_ply(roster, .(week), function(x) print(any(x$player == player)))
# sapply(split(roster, roster$week), function(x) any(x$player == player))

get_weekly_totals_with_replacement_player <- function(team, player_to_replace, replacement_player) {
    ddply(replace_player(player_to_replace, replacement_player, team), .(week), batter_totals)
}