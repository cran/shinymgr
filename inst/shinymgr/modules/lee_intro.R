#!! ModName = lee_intro
#!! ModDisplayName = Linear Equation Explorer introduction Page
#!! ModDescription = This module is simply a page of text with instructions for the linear_equation_explorer app.
#!! ModCitation = Baggins, Bilbo.  (2022). lee_intro. [Source code].
#!! ModActive = 1


# the ui function
lee_intro_ui <- function(id) {
  ns <- NS(id)
  tagList(
    wellPanel(
      textOutput(ns("instructions"))
    )
  )
}


# the server function
lee_intro_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$instructions <- renderText({
      "These are instructions for the linear_equation_explorer app. On the next tab, you will be able to
      create a set of points on a line by specifying the slope, y-intercept, and number of points.
      The following page will allow you to add vertical noise to your points using a slider,
      and the following page will allow you to fit a polynomial to those points by specifying the degree
      of the polynomial. Finally, you can save your analysis as an .RDS file. 
      You can navigate between tabs using the 'Previous' and 'Next' buttons at the bottom
      of each tab."
    })
  })
}
