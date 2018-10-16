#' @title Speed Date!
#'
#' @importFrom shiny
#' @importFrom miniUI
#' @export
speed_date <- function() {
  require(shiny)
  require(miniUI)


  ui <- miniPage(
    gadgetTitleBar("Speed Date"),
    miniContentPanel(
      padding = 25,
      fillCol(
        flex = 1,
        fillRow(
          flex = c(1, 3),
          tags$h3(strftime(as.POSIXct(1136239445.987654, origin = "1970-01-01"),
                           "%A %B %e, %H:%M:%OS6 %G %z", tz = "MST"))
        ),
        fillRow(
          textInput("text_date", "Using the date above, write out an example of your desired format",
                    width = "100%", placeholder = "Mon 1/02/06 15:04 MST")
        ),
        fillRow(
          verbatimTextOutput("date_format")
        ),
        fillRow(
          uiOutput("test_date")
        )
      )
    )
  )

  server <- function(input, output, session) {

    guessed_format <- reactive({
      req(input$text_date)
      guess_format(input$text_date, frontpad_single_digits = FALSE)
    })

    random_date <- reactive({
      req(isolate(input$text_date))
      input$new_random_date

      as.POSIXct(
        runif(1, 1, as.integer(Sys.time()) * 1.25),
        origin = "1970-01-01"
      )
    })

    output$date_format <- renderPrint({
      req(input$text_date)
      cat('"', guessed_format(), '"', sep = "")
    })

    output$test_date <- renderUI({
      req(input$text_date)
      formatted_date <- strftime(random_date(), guessed_format())
      tagList(
        fluidRow(
          column(width = 4, strftime(random_date(), "%F %H:%M:%OS6 %Z")),
          column(width = 4, h4(formatted_date)),
          column(width = 4, actionButton("new_random_date", "New Date"))
        )
      )
    })

    observeEvent(input$done, {
      if (!is.null(guessed_format())) {
        rstudioapi::sendToConsole(paste0('"', guessed_format(), '"'), FALSE)
      }
      stopApp(TRUE)
    })
  }


  runGadget(ui, server, viewer = paneViewer())
}
