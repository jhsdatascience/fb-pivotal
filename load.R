## Load and prepare data

load_batters <- function(file_loc) {
    df <- read.csv(file_loc)
    obs_to_drop <- !df$pos %in% c('BN', 'DL')
    df <- df[obs_to_drop, names(df) != 'AVG']
    split(df, df$team)
}

load_batter_fields <- function(file_loc) {
    read.csv(file_loc, colClasses = 'character')
}

load_matchups <- function(file_loc) {
    read.csv(file_loc)
}

load_teams <- function(file_loc) {
    read.csv(file_loc, colClasses = 'character')
}

get_nweeks <- function(df) {
    max(df$week)
}

get_stat <- function(long_name) {
    batter_fields[batter_fields$desc == long_name,][1]$stat
}

load_all <- function(base_dir = 'data') {
    batters <<- load_batters(paste(base_dir, 'batters.csv', sep = '/'))
    batter_fields <<- load_batter_fields(paste(base_dir, 'batter_fields.csv', sep = '/'))
    matchups <<- load_matchups(paste(base_dir, 'matchups.csv', sep = '/'))
    teams <<- load_teams(paste(base_dir, 'teams.csv', sep = '/'))
    nweeks <<- get_nweeks(batters[[1]])
}