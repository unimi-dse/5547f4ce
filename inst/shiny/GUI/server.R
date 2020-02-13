# 09.02.20 Formattare meglio la pagina di summary e inserire link con linguaggio HTML
#' Defines the server logic
#' @import markovchain
server <- function(input, output, session) {

  '%then%' <- shiny:::'%OR%'
  predata <- c("cerepJCRA", "cerepICAP", "cerepCRA", "cerepDBRS", "cerepCIR")

  v <- shiny::reactiveValues()

  ### INPUT and UI OUTPUT-INPUT ###

  ## Input Validation ##

  # Dimension Validation #
  n_val <- shiny::reactive({
    shiny::validate(
      shiny::need(input$n != "" && is.numeric(input$n) && input$n %% 1 == 0 && input$n > 0,
           "Please, insert a positive integer") %then%
      shiny::need(input$n < 10, "Matrix is too large to fit in this page ! Try with a smaller integer :)")
    )
    return(input$n)
  })

  # States auto-fill #
  st_reac <- shiny::reactive({
    if(!is.null(input$states)) {
      filledStates <- input$states[1,]
      ind <- which(input$states[1,] == "")
      filledStates[ind] <- paste("State", ind, sep = " ")
      return(filledStates)
    }
    return(NULL)
  })

  # Matrix input initial value and update #
  M_reac <- reactive({
    M <- diag(n_val())
    sts <- st_reac()
    dimnames(M) <- list(sts, sts)
    M
  })


  ## Input UIs ##

  # Manual input UI #
  output$mi <- renderUI({
    shiny::fluidPage(
      shinyalert::useShinyalert(),
      shiny::fluidRow(
        # Dimension input
        shiny::column(2,
               shiny::numericInput(inputId = "n", label = "Insert the number of states", value = 0,
                            min = 0, max = 30, step = 1)
        ),
        # States names input (as UI)
        shiny::column(10,
               shiny::h4("Insert the states names"),
               shiny::uiOutput("ui_states")
        )
      ),
      # Transition matrix input (as UI)
      shiny::wellPanel(
        shiny::h4("Insert the transition matrix"),
        shiny::uiOutput("ui_mat")
      ),
      # Manual entered MC creation button
      shiny::actionButton(inputId = "c_manual", label = "Create")
    )
  })

  # States' names input (dep. on dimension) #
  output$ui_states <- shiny::renderUI({
    stHeader <- paste("State", c(1:n_val()))
    # This "matrix" is just one row input
    shinyMatrix::matrixInput(inputId = "states", value = matrix("", nrow = 1, ncol = input$n,
                                                   dimnames = list(NULL, stHeader)),
                rows = list(names=F), cols = list(names=T))
  })

  # Matrix input (dep. on dimension and names of states) #
  output$ui_mat <- shiny::renderUI({
    shinyMatrix::matrixInput(inputId = "mat", value = M_reac(), class = "numeric",
                paste = T, copy = T, rows = list(names=T),
                cols = list(names=T))
  })

  # Input from file #
  output$datai <- shiny::renderUI({
    shiny::fluidPage(
      shinyjs::useShinyjs(),
      shinyalert::useShinyalert(),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          shiny::selectInput(inputId = "preset", label = "Choose a preset dataset",
                             c("",predata)),
          shiny::helpText("-------- or --------", align = "center"),
          shiny::fileInput(inputId = "file", label = "Select a file in your Explorer"),
          shiny::helpText("All files must be imported from
                          https://cerep.esma.europa.eu/cerep-web/statistics/transitionMatrice.xhtml
                          using 'export as .csv'"),
          shiny::fluidRow(
            shiny::actionButton(inputId = "c_data", label = "Create"),
            shiny::textOutput("success")
          )
        ),
        shiny::mainPanel(
          shiny::tableOutput("tmat")
        )
      )
    )
  })


  ### ------- RENDERING -------- ###

  ## Reactive update of v ##

  # Manual input #
  shiny::observeEvent(input$c_manual, {
    v$tm <- input$mat
    v$s <- st_reac()
    v$n <- "Manually entered Markov Chain"

    mVal <- mat_val(v$tm)
    if( class(mVal) == 'character' ) {
      shinyalert::shinyalert("Unable to create MC", mVal)
      v$tm <- NULL
    }
  })

  # Input from file #
  file_path <- shiny::reactiveValues(data = NULL)
  observe({
    if(!is.null(input$file))
      file_path$data <- input$file$datapath
  })
  shiny::observeEvent(input$c_data, {

    no_file <- is.null(file_path$data)
    no_pres <- (input$preset == "")
    if(!no_file) {
      path <- file_path$data
      output$success <- shiny::renderText({
        "MC from file successfully created"
      })
    } else if(!no_pres) {
      path <- system.file('extdata', paste(input$preset, "csv", sep = "."),
                  package = 'mctools')
      output$success <- shiny::renderText({
        "MC from preset dataset successfully created"
      })
    }

    if(no_file && no_pres) {
      v$n <- NULL
      v$tm <- NULL
      v$s <- NULL
      shinyalert::shinyalert("Unable to create MC", "No data has been selected")
    } else {
      parsed <- ESMAtransRateReader(path)
      v$n <- parsed$title
      v$tm <- parsed$mat
      v$s <- colnames(v$tm)
    }

    shinyjs::reset("preset")
    shinyjs::reset("file")
    file_path$data <- NULL

  })

  ## All renderings/tools (depending on 'mc') ##
  # Function for generating diagram boxes' colors
  color_genr <- function(n)
  {
    qual_col_pals = RColorBrewer::brewer.pal.info[RColorBrewer::brewer.pal.info$category == 'qual',]
    col_vector = unlist(mapply(RColorBrewer::brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

    col_vector[c(1:n)]
  }

  shiny::observe({
    # Markov Chain dynamically assigned
    if(!(is.null(v$s) || is.null(v$tm) || is.null(v$n))) {
      mc <- new('markovchain', states = v$s, transitionMatrix = unname(v$tm),
                name = v$n)

      # SUMMARY OUTPUT #
      output$smry <- shiny::renderUI({
        shiny::HTML(paste(
          paste("Homogeneous Markov Chain named \"", markovchain::name(mc),
                "\" with states {",
                paste(markovchain::states(mc), collapse = ", "),
                # "} and transition matrix {",
                #paste(mc[,], collapse = " "),
                "}",
                sep = ""),
          paste("Irreducible", markovchain::is.irreducible(mc), sep = ": "),
          paste("Regular", markovchain::is.regular(mc), sep = ": "),
          paste("Period", markovchain::period(mc), sep = ": "),
          paste("Recurrent states: {",
                paste(markovchain::recurrentStates(mc), collapse = ", "),
                "}  of which absorbing states: {",
                paste(markovchain::absorbingStates(mc), collapse = ", "),
                "}", sep = ""),
          paste("Stationary distribution(s):",
                mctools::printRows(round(markovchain::steadyStates(mc),4))),
          paste("Mean recurrence times:",
                mctools::printVecNames(round(markovchain::meanRecurrenceTime(mc),4))),
          paste("Mean absorption times:",
                mctools::printVecNames(round(markovchain::meanAbsorptionTime(mc),4))),
          sep = "<br/>"
        )
        )
      })


      # SIMULATION UI AND OUTPUT #
      # Reaction to "Generate" button
      genrVals <- shiny::eventReactive(input$gnr, {
        # Usage of RCPP form performance optimization
        if( input$state0 == "(random)")
          markovchain::rmarkovchain(input$size, mc, what = list, useRCpp = T,
                       parallel = T, num.cores = parallel::detectCores() - 1)
        else
          markovchain::rmarkovchain(input$size, mc, what = list, t0 = input$state0, useRCpp = T,
                       parallel = T, num.cores = parallel::detectCores() - 1)
      })
      # Simulation UI
      output$ui_sim <- shiny::renderUI({
        shiny::sidebarLayout(
          shiny::sidebarPanel(
            shiny::sliderInput(inputId = "size", label = "Insert sample size", value = 0,
                        min = 1, max = 200, step = 1),
            shiny::selectInput(inputId = "state0", label = "Select initial state",
                        choices = unname(c("(random)",markovchain::states(mc)))),
            shiny::actionButton(inputId = "gnr", label = "Generate")
          ),
          shiny::mainPanel(
            shiny::tableOutput("sample")
          )
        )
      })
      # Simulation output
      output$sample <- shiny::renderTable(t(genrVals()), hover = T, colnames=T)

      # GRAPH OUTPUT #
      output$graph <- shiny::renderPlot({
        diagram::plotmat(A=t(mc[,]), name = markovchain::states(mc),
                         box.col = color_genr(dim(mc)),
                         self.lwd = 2, arr.pos = 0.6, txt.font = 15,
                         box.cex = 1.2, cex.txt = 1.2, shadow.size = 0.008,
                         arr.type = "simple", relsize = 0.6, dtext = 0.5,
                         arr.lcol = 'darkgrey', self.cex = 0.6, box.size = 0.09)
      })

      # MATRIX OUTPUT (inside file input panel) #
      output$tmat <- shiny::renderTable({
        if(markovchain::name(mc) != "Manually entered Markov Chain")
          mc[,]
      }, rownames = T, colnames = T)
    }
  })

}
