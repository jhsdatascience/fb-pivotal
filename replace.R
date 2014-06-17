## Functions for working with replacement players

calc_replacement_player_stats <- function(league, q = .25) {
    roster <- ldply(league)
    player_week_df <- ddply(roster, .(week, player), function(x) {colSums(x[,names(x) %in% batter_fields$raw], na.rm = T)})[,-c(1,2)]
    stats <- sapply(player_week_df, quantile, q, na.rm = T) / 5
    names(stats) <- c(batter_fields$raw)
    stats
}

replace_player <- function(player, roster) {
    player_ind <- roster$player == player
    player_df <- roster[player_ind,]
    roster[player_ind,] <- ddply(player_df, .(week), replace_player_daily_stats)
    roster
}

replace_player_daily_stats <- function(week) {
    names_ind <- names(week) %in% batter_fields$raw
    for (i in 1:7) {
        r <- week[i,]
        if (all(!is.na(r[names_ind]))) week[i,names_ind] <- replacement_player
    }
    week
}

get_weekly_totals_with_replacement_player <- function(team, player_to_replace) {
    ddply(replace_player(player_to_replace, team), .(week), batter_totals)
}