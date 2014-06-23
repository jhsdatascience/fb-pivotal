library(shiny)

shinyUI(

    navbarPage("Fantasy Baseball Player Value",
        tabPanel('App',
            sidebarLayout(

                sidebarPanel(
                    h5('Explore team performance'),
                    selectInput("team", "Team:",
                                choices=team_choices),
                    selectInput("category", "Category:",
                                choices=category_choices),
                    hr(),
                    h5('Explore player value'),
                    htmlOutput('playerSelect'),
                    helpText("Choose a player from the roster to calculate their value."),
                    sliderInput('replacement_quantile', 'Replacement level player quality:',
                                value = .25,
                                min = 0,
                                max = 1,
                                step = .05),
                    helpText("Choose the quantile from which to select a replacement level player. See the About page for more detail.")
                ),

                mainPanel(
                    plotOutput("matchupPlot"),
                    tableOutput("standings"),
                    textOutput("fwar")
                )
            )
        ),
        tabPanel('Data',
                 tabsetPanel(
                    tabPanel('Daily Data', dataTableOutput('dailydata')),
                    tabPanel('Weekly Data', dataTableOutput('weeklydata')),
                    tabPanel('Team IDs', dataTableOutput('teams'))
                )
        ),
        tabPanel('About',
            h1('Welcome'),
            HTML("This app allows you to explore the performance of your* fantasy baseball team over the course of the season. In particular, it lets you test the proposition <em> How has player X contributed to my team this season?</em> We present a measure of a player's value based on how many wins they were <em>pivotal</em> in producing for your team: how many wins does the team have that can be directly attributed to that player's presence? But we're getting ahead of ourselves. Let's take things in order . . ."),
            h2('What is fantasy baseball?'),
            HTML("<a href = 'http://en.wikipedia.org/wiki/Fantasy_baseball'>Fantasy baseball</a> is a roster management game in which players (or <em>owners</em>) build teams of <a href = 'http://en.wikipedia.org/wiki/MLB'>Major League Baseball</a> players and compete based on various statistics produced by those MLB players. Typical statistics include <a href = 'http://en.wikipedia.org/wiki/Run_(baseball)'>Runs Scored</a>, <a href = 'http://en.wikipedia.org/wiki/Home_run'>Home Runs</a>, or <a href = 'http://en.wikipedia.org/wiki/Stolen_base'>Steals</a>. There are various formats for fantasy baseball leagues: they vary by the number of teams, by the statistical categories used to determine points and by whether teams compete head-to-head each week or against the entire league over the course of a season.</p>
                 <p>The example league used in this app is a head-to-head league that works as follows:</p>
                <ul>
                    <li>Each week, two teams compete across eight categories: runs, doubles, home runs, runs batted in, stolen bases, walks, batting average, and grand slams.</li>
                    <li>At the end of the week, the team that is leading a particular category is awarded a 'win' while the team that trails a category gets a 'loss'. 'Ties' are also possible.</li>
                    <li>Match ups change each week.</li>
                    <li>The team that has the highest winning percentage at the end of the 25 week long MLB season wins. For the purposes of determining winning percentage, a tie is worth half a win.</li>
                </ul>
                <h4>An example</h4>
                <p>In the first week of the example data, the Felix Hernandezes matched up against the Edwin Encarnacions. At the end of the week, the standings were:</p>
                <table border = 1>
<tr><th>Team</th><th>Runs</th><th>Doubles</th><th>Home Runs</th><th>Runs Batted In</th><th>Stolen Bases</th><th>Walks</th><th>Batting Average</th><th>Grand Slams</th></tr>
<tr><td>The Felix Hernandezes</td><td><strong>53</strong></td><td><strong>28</strong></td><td>7</td><td>41</td><td><strong>10</strong></td><td>35</td><td>.266</td><td>0</td></tr>
<tr><td>The Edwin Encarnacions</td><td>52</td><td>18</td><td><strong>12</strong></td><td><strong>49</strong></td><td>6</td><td><strong>40</strong></td><td><strong>.303</strong></td><td>0</td></tr>
</table>
                <br>
                <p>Thus at the end of the week the Edwin Encarnacions led in 3 categories, trailed in 4, and tied 1. Their winning percentage for that week was <code>(3 + .5) / 8 = 0.4375</code>. The Edwin Encarnacions' winning percentage was <code>0.5625</code>. The next week the Felix Hernandezes played the Miguel Cabreras, winning 6 categories, losing 1, and tying 1, for a cummulative winning percentage of <code>0.625</code> after two weeks. We could go on, but you can also just use the app to see the cummulative records of each team to date . . .</p>
                 "),
            h3('How to use this app, part 1'),
            HTML('<p>Start by exploring how different teams have performed against their opponents each week:</p>'),
            HTML('<img src = "cabrera-runs.png"/>'),
            p("The light blue dots represent the team's weekly performance in the given category. The red dots represent the performance of their opponent each week. If the blue point is above the red point, the team won that category that week."),
            p('You can see the performance for different teams . . .'),
            HTML('<img src = "hernandez-runs.png"/>'),
            p(". . . or you can change the category that is being displayed in order to see each team's strengths and weaknesses:"),
            HTML('<img src = "cabrera-runs-dropdown.png"/>'),
            h2('How pivotal has a player been?'),
            HTML("<p>Now we come to the question of how to measure a player's contribution to a fantasy team. Call a player <em>pivotal</em> if, for some week and some category, the player's team wins that category with the player on its roster but would not win that category if the player were replaced by <a href = 'http://en.wikipedia.org/wiki/Value_over_replacement_player'>replacement level player</a>.</p>"),
            h4("An example"),
            HTML("<p>Recall that in the first week, the Edwin Encarnacions won the Runs category by one run. On their roster that week was Albert Pujols, who scored three of the teams 53 runs. Without him on the team, the Edwin Encarnacions would have lost that category. Because they didn't, we say that Albert Pujols was pivotal in that category. Also on the Edwin Encarnacions that week was Carlos Beltran but Beltran didn't score a run that week so he was not pivotal in that category.</p>"),
            h4('What does it mean to be replacement level?'),
            HTML("<p>One way of measuring a player's value to a fantasy team is to add up all the categories in which they have been pivotal over the course of the season. However, it doesn't make sense to simply subtract the player from a given roster for a week. We ought to consider how they performed compared to a hypothetical replacement level player. Intuitively, a replacement level player is one whose skills are so unremarkable that a player of his caliber is always available to teams in need of filling a roster spot. Though much work has been done to determine what exactly replacement level stats are in real baseball, that work doesn't translate exactly to fantasy baseball. This app takes an agnostic approach to the determination of replacement level: it defines replacement level as a player performing at the <i>q</i>th quantile in each category and lets you adjust <i>q</i> when doing your visualizations.</p>"),
            h3("How to use this app, part 2"),
            HTML("<p>Besides exploring the teams performances, you can use this app to explore the value of each player on the teams' rosters, as measured by how pivotal they were in generating wins for that team. The first step is to select a player from the roster . . .</p>"),
            HTML("<img src = 'hosmer-dropdown.png'/>"),
            p("The plot should immediately update with a dark blue graph representing how the team would have performed without the player you just selected. The new graph may be discontinuous--if it is, that means that the player was not on the roster for the missing weeks. You will also see the table below the graph update to reflect what the team's record would have been without the selected player."),
            p("You can also adjust the quality of the replacement level player against which players on the roster will be evaluated:"),
            HTML("<img src = 'replacement-player-closeup.png'/>"),
            p("This quality is represented by the quantile at which the replacement level player performs. The default is .25, meaning that the player selected in the roster slot will be replaced by a player with stats in the 25th percentile in each category. By setting this quantile to be higher, you can see how the relative value of the player in question decreases . . ."),
            HTML("<img src = 'replacement-player-high.png'/>"),
            p('while by setting the quantile lower, you can see their relative value increase:'),
            HTML("<img src = 'replacement-player-low.png'/>"),
            h2('Some final thoughts'),
            p('This app is simultaneously a proof of concept and a work in progress. If you have feedback, let me know. The full code, which is very raw at the moment, is available on <a href = "https://github.com/jhsdatascience/fb-pivotal">github</a>. Some features I would like to add eventually:'),
            HTML("<ul>
                    <li>Pitchers!</li>
                    <li>More granular control over replacement levels.</li>
                    <li>The ability to upload data from other leagues.</li>
                 </ul>"),
            h3('About the data'),
            p('The example data used for this project comes from a small fantasy baseball league of which I am a part. Many thanks to my league-mates for letting me crunch the numbers on our league and show them to the world.'),
            hr(),
            HTML('<p>*Well, actually not <em>your</em> team yet--for now you are limited to the data from the example league.</p>')
        )
    )
)