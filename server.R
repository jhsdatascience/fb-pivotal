library(shiny)

shinyServer(function(input, output) {
    
    output$playerSelect <- renderUI({
        selectInput('player', 'Player',
                    choices = c('---None---', rosters[[input$team]]))
    })
    
    replaced_totals <- reactive({
        if (is_player_selected()) {
            replaced_totals <- get_weekly_totals_with_replacement_player(batters[[input$team]], input$player)
        } else {
            replaced_totals <- NULL
        }
    })
    
    standings <- reactive({
        standings <- league_standings[input$team,]
        if (is_player_selected()) {
            standings <- rbind(standings, calculate_record(replaced_totals(),
                                                           opponent_totals[[input$team]]))
            row.names(standings) <- c("Current standings",
                                      paste0("Standings without ", input$player))
        } else {
            row.names(standings) <- c("Current standings")
        }
        standings
    })
    
    output$matchupPlot <- renderPlot({
        team <- input$team
        stat <- input$category
        print(plot_matchups(stat, weekly_totals[[team]], opponent_totals[[team]], replaced_totals()))
    })
    
    output$standings <- renderTable({
        standings()
    })
    
    output$fwar <- renderText({
        if (is_player_selected()) {
            standings_ <- standings()
            fwar <- standings_[1,1] - standings_[2,1] + .5 * (standings_[1,3] - standings_[2,3])
            out <- paste(input$player, 'has been worth ', fwar, 'win(s) above replacement this season.')
        } else {
            out <- "Choose a player from the roster on the left to calculate their value this season."
        }
        out
    })
    
    is_player_selected <- reactive({
        if (!is.null(input$player)) {
            is_selected <- input$player != '---None---'
        } else {
            is_selected <- FALSE
        }
        is_selected
    })
    
})