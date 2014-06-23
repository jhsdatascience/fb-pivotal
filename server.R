library(shiny)

shinyServer(function(input, output) {

    replacement_player <- reactive({
        calc_replacement_player_stats(batters, input$replacement_quantile)
    })

    output$playerSelect <- renderUI({
        team_name <- get_team_by_id(input$team)
        selectInput('player', paste0(team_name,"'s Roster:"),
                    choices = c('---None---', rosters[[input$team]]))
    })

    replaced_totals <- reactive({
        if (is_player_selected()) {
            replaced_totals <- get_weekly_totals_with_replacement_player(batters[[input$team]], input$player, replacement_player())
        } else {
            replaced_totals <- NULL
        }
    })

    standings <- reactive({
        standings <- league_standings[input$team,]
        if (is_player_selected()) {
            standings <- rbind(standings, calculate_record(replaced_totals(),
                                                           opponent_totals[[input$team]]))
            row.names(standings) <- c("Actual record",
                                      paste0("Record without ", input$player))
        } else {
            row.names(standings) <- c("Record")
        }
        standings
    })

    output$matchupPlot <- renderPlot({
        team <- input$team
        stat <- input$category
        print(plot_matchups(stat, weekly_totals[[team]], opponent_totals[[team]], team,
                            replaced_totals(),
                            selected_player(),
                            batters[[team]]))
    })

    output$standings <- renderTable({
        standings()
    })

    output$fwar <- renderText({
        if (is_player_selected()) {
            standings_ <- standings()
            fwar <- standings_[1,1] - standings_[2,1] + .5 * (standings_[1,3] - standings_[2,3])
            out <- paste0(input$player,
                         ' has been pivotal in ',
                         fwar,
                         ' win(s) this season. Calculated using a player in the ',
                         input$replacement_quantile,
                         'th quantile as his replacement.')
        } else {
            out <- "Choose a player from the roster on the left to calculate their value this season."
        }
        out
    })

    output$dailydata <- renderDataTable({
        ldply(batters)
    })

    output$weeklydata <- renderDataTable({
        ldply(weekly_totals)
    })

    output$teams <- renderDataTable({
        teams
    })

    is_player_selected <- reactive({
        if (!is.null(input$player)) {
            is_selected <- input$player != '---None---'
        } else {
            is_selected <- FALSE
        }
        is_selected
    })

    selected_player <- reactive({
        if(is_player_selected()) {
            player <- input$player
        } else {
            player <- NULL
        }
    })

})