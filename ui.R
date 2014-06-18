library(shiny)

shinyUI(
    
    fluidPage(    
        
        titlePanel("Fantasy Baseball Player Values"),
        
        sidebarLayout(      
            
            sidebarPanel(
                selectInput("team", "Team:", 
                            choices=team_choices),
                hr(),
                selectInput("category", "Category:", 
                            choices=category_choices),
                hr(),
                htmlOutput('playerSelect')
            ),
            
            mainPanel(
                plotOutput("matchupPlot"),
                tableOutput("standings"),
                textOutput("fwar")
                
            )
            
        )
    )
)