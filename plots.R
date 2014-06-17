plot_matchups <- function(stat, team_weekly_totals, team_opponent_totals, replaced_totals = NULL) {
    if (is.null(replaced_totals)) {
        df <- ldply(list(home = team_weekly_totals, away = team_opponent_totals))
    } else {
        df <- ldply(list(home = team_weekly_totals, away = team_opponent_totals, with_replacement = replaced_totals))
    }
    ggplot(df, aes_string('week', stat, color = '.id', group = '.id')) +
        geom_point() +
        geom_line()
}