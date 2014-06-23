library(shiny)

shinyUI(

    navbarPage("Fantasy Baseball Player Values",
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
                    helpText("Choose the quantile from which to select a replacement level player. See the about page for more detail.")
                ),

                mainPanel(
                    plotOutput("matchupPlot"),
                    tableOutput("standings"),
                    textOutput("fwar")
                )
            )
        ),
        tabPanel('About',
            HTML('<h1>Welcome</h1>'),
            HTML("<p>This app allows you to explore the performance of your* fantasy baseball team over the course of the season. In particular, it lets you test the proposition <em> How has player X contributed to my team this season?</em> We present a measure of a player's value based on how many wins they were <em>pivotal</em> in producing for your team: how many wins does the team have that can be directly attributed to that player's presence? But we're getting ahead of ourselves. Let's take things in order . . ."),
            HTML('<h2>What is fantasy baseball?</h2>'),
            HTML("<a href = 'http://en.wikipedia.org/wiki/Fantasy_baseball'>Fantasy baseball</a> is a roster management game in which players (or <em>owners</em>) build teams of <a href = 'http://en.wikipedia.org/wiki/MLB'>Major League Baseball</a> players and compete based on various statistics produced by those MLB players. Typical statistics include <a href = 'http://en.wikipedia.org/wiki/Run_(baseball)'>Runs Scored</a>, <a href = 'http://en.wikipedia.org/wiki/Home_run'>Home Runs</a>, or <a href = 'http://en.wikipedia.org/wiki/Stolen_base'>Steals</a>. There are various formats for fantasy baseball leagues: they vary by the number of teams, by the statistical categories are used to determine points and by whether they are head-to-head or not.</p>
                 <p>The example league used in this app is a head-to-head league that works as follows. Each week, two teams compete across eight categories: runs, doubles, home runs, runs batted in, stolen bases, walks, batting average, and grand slams. At the end of the week, the team that is leading a particular category is awarded a 'win', the team that trails a category gets a 'loss'. 'Ties' are also possible. Match ups switch the next week. The team that has the highest winning percentage at the end of the 25 week long MLB season wins. For the purposes of determining winning percentage, a tie is worth half a win.</p>
                <p>Here is an example from the first week: that week, The Felix Hernandezes matced up against the Edwin Encarnacions. At the end of the week, the standings were:</p>
                <table>
<tr><th>Team</th><th>Runs</th><th>Doubles</th><th>Home Runs</th><th>Runs Batted In</th><th>Stolen Bases</th><th>Walks</th><th>Batting Average</th><th>Grand Slams</th></tr>
<tr><td>The Felix Hernandezes</td><td><em>53</em></td><td><em>28</em></td><td>7</td><td>41</td><td><em>10</em></td><td>35</td><td>.266</td><td>0</td></tr>
<tr><td>The Edwin Encarnacions</td><td>52</td><td>18</td><td><em>12</em></td><td><em>49</em></td><td>6</td><td><em>40</em></td><td><em>.303</em></td><td>0</td></tr>
</table>
                <p>Thus at the end of the week The Edwin Encarnacions led in 3 categories, trailed in 4, and tied 1. Their winning percentage for that week was <code>(3 + .5) / 8 = 0.4375</code>. The Edwin Encarnacions' winning percentage was <code>0.5625</code>. The next week The Felix Hernandezes played the Miguel Cabreras, winning 6 categories, losing 1, and tying 1, for a cummulative winning percentage of <code>0.625</code> after two weeks. To see the cummulative records of each team to date, use the app.</p>
                 "),
            HTML('<p>*Well, actually not <em>your</em> team yet--for now you are limited to the data from the example league.</p>'),
            HTML('<h2>How to use this app, part 1</h2>'),
            HTML('<p>Start by exploring how different teams have performed against their opponents each week:</p>'),
            HTML('INSERT BASE PIC'),
            HTML('INSERT DROPDOWN PIC'),
            HTML('INSERT CHANGED TEAM PIC'),
            HTML("<p>You can change the category that is being displayed in order to see each team's strengths and weeknesses:</p>"),
            HTML('INSERT STAT DROPDOWN PIC'),
            HTML("INSERT NEW STAT PIC"),
            HTML('<h2>How pivotal has a player been?</h2>'),
            HTML("<p>Now we come to the question of how to measure a player's contribution to a fantasy team. Call a player <em>pivotal</em> if for some week and some category a team wins that category if with the player on the roster but would not win that category if the player were replaced by a player of 'common skill' (see below). As an example, recall that in the first week, The Edwin Encarnacions won the Runs category by one Run. On their roster that week was Albert Pujols, who scored three of the teams 53 runs. Without him on the team, the Edwin Encarnacion's would have lost that category. Because they didn't, we say that Albert Pujols was pivotal in that category. Also on the Edwin Encarnacions that week was Carlos Beltran but Beltran didn't score a run that week so he was not pivotal in that category.</p>"),
            HTML("<p>One way of measuring a player's value to a fantasy team is to add up all the categories in which they have been pivotal over the course of the season. However, it doesn't make sense to simply subtract the player from a given roster for a week. We ought to consider how they performed compared to a hypothetical <a href = 'http://en.wikipedia.org/wiki/Value_over_replacement_player'>replacement level player</a>. Intuitively, a replacement level player is one whose skills are so unremarkable a player of his caliber is always available to teams in need of filling a roster spot. Though much work has been done to determine what exactly replacement level stats are in real baseball, that work doesn't translate exactly to fantasy baseball. This app takes an agnostic approach to the determination of replacement level: it defines replacement level as a player performing at the <i>q</i>th percentile in each category and lets you adjust <i>q</i> when doing your visualizations.</p>")

        )
    )
)