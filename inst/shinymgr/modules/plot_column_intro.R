#!! ModName = plot_column_intro
#!! ModDisplayName = Plot Column introduction Page
#!! ModDescription = This module is simply a page of text with instructions for the plot_column app.
#!! ModCitation = Baggins, Bilbo.  (2022). plot_column_intro. [Source code].
#!! ModActive = 1


# the ui function
plot_column_intro_ui <- function(id) {
  ns <- NS(id)
  tagList(
    wellPanel(
      textOutput(ns("instructions"))
    )
  )
}


# the server function
plot_column_intro_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$instructions <- renderText({
      "These are instructions for the plot_column app. On the next tab, you can upload a csv file
      to explore its contents. The following tab will allow you to randomly subset records from the uploaded
      file. Afterwards, you can view the distributions of columns in your data.
      The final tab allows you to save your analysis as an .RDS file. You can navigate between tabs
      using the 'Previous' and 'Next' buttons at the bottom of each tab."
    })
  })
}
