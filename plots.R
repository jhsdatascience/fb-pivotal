plot_matchups <- function(stat, team_weekly_totals, team_opponent_totals, replaced_totals = NULL) {
    stat_long <- get_stat_desc(stat)
    home <- rep('Home', nrow(team_weekly_totals))
    away <- rep('Away', nrow(team_opponent_totals))
    if (is.null(replaced_totals)) {
        df <- ldply(list(Team = team_weekly_totals, Opponent = team_opponent_totals))
        home_away <- c(home, away)
        df <- cbind(df, home_away)
    } else {
        df <- ldply(list(Team = team_weekly_totals, Opponent = team_opponent_totals, 'Team with replacement level player' = replaced_totals))
        home_away <- c(home, away, home)
        df <- cbind(df, home_away)
    }
    ggplot(df, aes_string('week', stat, color = '.id', group = '.id', linetype = 'home_away')) +
        geom_point() +
        geom_line() +
        scale_linetype_manual(values = c('dashed', 'solid')) +
        guides(linetype = FALSE) +
        scale_color_brewer(type = 'qual') +
        theme_bw() +
        labs(x = 'Week',
             y = stat_long,
             color = 'Team')
}