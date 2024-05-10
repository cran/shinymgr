iris_explorer_ui <- function(id) {
  
  ns <- NS(id)
  
  tagList(
    fluidPage(
      # output the iris_explorer app
      uiOutput(ns('test'))
    )
  )
}

# the server function for the iris_explorer app
iris_explorer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    # create the app ui
    output$test <- renderUI({
      tagList(
        tabsetPanel(
          id = ns("mainTabSet"),
          tabPanel(
            title = "K-means clustering", 
            iris_cluster_ui(ns("iris")),
          ),
          tabPanel(
            title = "Subset Rows", 
            subset_rows_ui(ns("subset"))
          )
        ) # end of tabsetPanel
      ) # end of tagList
    }) # end of renderUI
    
    # generate app outputs
    data1 <- iris_cluster_server("iris")
    data2 <- subset_rows_server("subset", dataset = data1$returndf)
    
  })
}
