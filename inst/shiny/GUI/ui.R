ui <- shiny::fluidPage(
  shiny::titlePanel("Markov Chain analysis and rendering tools", "MCtools"),
  shiny::tabsetPanel(
    shiny::tabPanel(title = "Manual input",  shiny::uiOutput("mi")),
    shiny::tabPanel(title = "Dataset input", shiny::uiOutput("datai")),
    shiny::tabPanel(title = "Graph",         shiny::plotOutput("graph")),
    shiny::tabPanel(title = "Summary",       shiny::htmlOutput("smry")),
    shiny::tabPanel(title = "Simulation",    shiny::uiOutput("ui_sim"))
  )
)
