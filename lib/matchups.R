## Simulate season to date

batter_totals <- function(roster) {
    ## Calculate totals from roster
    totals <- colSums(roster[, batter_fields$raw], na.rm = T)
    if ('AVG' %in% batter_fields$stat) {
        AVG <- totals['H'] / totals['AB']
        names(AVG) <- NULL
        if (!'H' %in% batter_fields$stat) {
            totals <- totals[!totals %in% c('H', 'AB')]
        }
        totals <- c(totals, AVG=AVG)
    }
    totals
}

get_weekly_totals <- function(league) {
    llply(league, function(x) ddply(x, .(week), batter_totals))
}

get_opponent_totals <- function(weekly_totals, matchups) {
    ## Match opponent totals to team totals (by week)
    opponent_totals <- weekly_totals
    for (i in 1:nrow(matchups)) {
        matchup <- unlist(matchups[i,])
        if (matchup['week'] > nweeks) break
        opponent_totals[[matchup['team1']]][matchup['week'],] <- weekly_totals[[matchup['team2']]][matchup['week'],]
        opponent_totals[[matchup['team2']]][matchup['week'],] <- weekly_totals[[matchup['team1']]][matchup['week'],]
    }
    opponent_totals
}

calculate_record <- function(team_weekly_totals, team_opponent_totals) {
    team_stats <- team_weekly_totals[, unique(batter_fields$stat)]
    opp_stats <- team_opponent_totals[, unique(batter_fields$stat)]
    wins <- sum(team_stats > opp_stats)
    losses <- sum(team_stats < opp_stats)
    ties <- sum(team_stats == opp_stats)
    wlt <- c(wins = wins, losses = losses, ties = ties)
    win_percentage <- wlt %*% c(1,0, .5) / sum(wlt)
    wlt <- data.frame(t(wlt))
    cbind(wlt, win_percentage)
}

calculate_records <- function(weekly_totals, opponent_totals) {
    df <-  data.frame(matrix(vector(), 0, length(unique(batter_fields$stat)), dimnames = list(c(), unique(batter_fields$stat))))
    for (team in names(weekly_totals)) {
        df <- rbind(df, calculate_record(weekly_totals[[team]], opponent_totals[[team]]))
    }
    row.names(df) <- names(weekly_totals)
    df
}
