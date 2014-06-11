## Load and prepare data

load_batters <- function() {
    df <- read.csv('data/20140331-20140611-batters.csv')
    obs_to_drop <- !df$pos %in% c('BN', 'DL')
    df <- df[obs_to_drop,]
    split(df, df$team)
}

load_batter_fields <- function() {
    read.csv('data/batter_fields.csv', colClasses = 'character')
}

load_matchups <- function() {
    read.csv('data/matchups.csv')
}