dashboardPage(skin="red",
    dashboardHeader(
        title = "Coronavirus"
    ),
    dashboardSidebar(disable=T,
        sidebarMenu(id="tabitems",
            tags$hr(),
            menuItem("Coronavirus Monitoring", tabName = "mon", icon = icon("chart-line")),
            tags$hr()
#            menuItem("The data presented in this webapp"),
#            menuItem("from https://www.who.int/emergen"),
#            menuItem("cies/diseases/novel-coronavirus-2"),
#            menuItem("019/situation-reports/ ")
        )
    ),
    dashboardBody(
        tags$head(includeHTML("google-analytics.html")),
        tabItems(
            ########################
            # DB monitoring module #
            ########################
            tabItem(tabName="mon",
                tags$style(HTML(".box.box-solid.box-primary>.box-header {  color:#fff;  background:#eb4034} .box.box-solid.box-primary{border-bottom-color:#eb4034;border-left-color:#eb4034;border-right-color:#eb4034;border-top-color:#eb4034;}")),
                fluidRow(
                    box(width=12, height=600, title="Tracking", status="primary", solidHeader=T,
                        p(),
                        p(),
                        p(),
                        column(9,
                            dygraphOutput("serie")
                        ),
                        column(3,
                            h4("Instructions:"),
                            HTML("<p>Hover over the graph to show in the box below the absolute frequencies of infected and death individuals, and the proportion of deaths in relation to the daily total of infected people.</p>"),
                            br(),
                            verbatimTextOutput("legendDivID"),
                            br(),
                            HTML("<p>The information shown in this web app comes from the <a href=https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/>World Health Organization daily reports</a>. It was built by <a href=https://datametrix.co/servicios/>Datametrix</a>, using shinydashboard and dygraphs, and the daily web scrapping of the reports is performed using RCurl and rvest.</p>"),
                            br(),
                            HTML("<p><b>Since February 17th the confirmed infected definition used by the chinese government to report its data to WHO has changed. That's why a dramatic increase in the total number of infected cases can be observed in comparisson with the quantity reported on February 16th and the previous days.</b></p>")
                        )
                    ),
                    box(width=12, height=831, title="World Health Organization Report", status="primary", solidHeader=T,
                            br(),
                            HTML("<p>Click over the above graph at any data point to load and consult the complete WHO public report.</p>"),
                            br(),
                        uiOutput("reporte")
                    )
                )
            )
        )
    )
)
