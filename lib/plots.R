library(RColorBrewer)
plot_matchups <- function(stat, team_weekly_totals, team_opponent_totals,
                          replaced_totals = NULL,
                          player_to_replace = NULL,
                          roster = NULL) {
    stat_long <- get_stat_desc(stat)
    home <- rep('Home', nrow(team_weekly_totals))
    away <- rep('Away', nrow(team_opponent_totals))
    if (is.null(replaced_totals)) {
        df <- ldply(list(Team = team_weekly_totals,
                         Opponent = team_opponent_totals))
        home_away <- c(home, away)
        df <- cbind(df, home_away)
        df$.id <- factor(df$.id, levels=c('Team', 'Opponent'), labels = c('Team', 'Opponent'))
    } else {
        active_during_week <- sapply(split(roster, roster$week), function(x) any(x$player == player_to_replace))
        replaced_totals[!active_during_week, ] <- ddply(replaced_totals[!active_during_week,],
                                                        .(week),
                                                        function(x) rep(NA, ncol(x) - 1 ))
        df <- ldply(list(Team = team_weekly_totals,
                         'Team with replacement level player' = replaced_totals,
                         Opponent = team_opponent_totals))
        home_away <- c(home, home, away)
        df <- cbind(df, home_away)
        df$.id <- factor(df$.id, levels=c('Team', 'Team with replacement level player', 'Opponent'),
                         labels = c('Team', 'Team with replacement level player', 'Opponent'))
    }
    group_colors <- brewer.pal(3, 'Paired')
    names(group_colors) <- c('Team', 'Team with replacement level player', 'Opponent')
    ggplot(df, aes_string('week', stat, color = '.id', group = '.id', linetype = 'home_away')) +
        geom_point() +
        geom_line() +
        scale_linetype_manual(values = c('dashed', 'solid')) +
        scale_color_manual(values = group_colors) +
#                              breaks = legend_breaks) +
        guides(linetype = FALSE) +
#        scale_color_brewer(type = 'qual') +
        theme_bw() + 
        theme(legend.position="bottom",
              legend.title=element_blank()) +
        #guide_legend(nrow = 2, ncol = 2) +
        labs(x = 'Week',
             y = stat_long,
             color = 'Team')
}