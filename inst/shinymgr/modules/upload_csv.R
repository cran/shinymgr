#!! ModName = upload_csv
#!! ModDisplayName = Upload CSV
#!! ModDescription = Upload a .csv file.
#!! ModCitation = Baggins, Bilbo.  (2021). upload_csv. [Source code].
#!! ModActive = 1
#!! FunctionReturn = my_df !! Dataframe of the uploaded csv !! data.frame
#!! FunctionReturn = filename !! File name of the uploaded csv !! character

upload_csv_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(
      ns("upload"), 
      NULL, 
      buttonLabel = "Upload...", 
      multiple = FALSE, 
      accept = ".csv"
    ),
    dataTableOutput(ns("confirm"))
  )
}

upload_csv_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    my_df <- reactive({
      req(input$upload)
      ext <- tools::file_ext(input$upload$name)
      switch(
        ext,
        csv = utils::read.csv(input$upload$datapath),
        validate("Invalid file; Please upload a .csv file")
      )
    })
    
    output$confirm <- renderDataTable(head(my_df()))
    
    return(
      reactiveValues(
        my_df = my_df,
        filename = reactive(input$upload)
      )
    )
  })
}
