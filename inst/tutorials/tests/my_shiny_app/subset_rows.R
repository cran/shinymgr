subset_rows_ui <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    
    # user inputs are set in the sidebar
    sidebarPanel(
      tagList(
        numericInput(
          inputId = ns("sample_num"),
          label = "Number of rows to sample",
          value = 10,
          min = 1
        ),
        actionButton(
          inputId = ns("resample"),
          label = "Re-sample"
        ),
        br(), 
        reactable::reactableOutput(ns("full_table"))
      )
    ), #end of sidebar panel
    
    # the main panel displays the main output 
    mainPanel(
      tagList(
        h2("These rows were randomly chosen:"),
        reactable::reactableOutput(ns("subset_table"))
      )
    ) #end of main panel
  ) #end of sidebar layout
} #end of ui function

subset_rows_server <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {
    
    # create the reactable object that displays full table
    output$full_table <- reactable::renderReactable({
      reactable::reactable(data = dataset(), rownames = TRUE)
    })
    
    # create a vector of random indices 
    index <- reactive({
      input$resample
      sample(
        x = 1:nrow(dataset()), 
        size = input$sample_num, 
        replace = FALSE)
    })
    
    # create the subset table as areactable object 
    output$subset_table <- reactable::renderReactable({
      reactable::reactable(dataset()[index(),], rownames = TRUE)
    })
    
    # all modules should return reactive objects
    return(
      reactiveValues(
        subset_data = reactive({
          dataset()[index(),]
        })
      )
    ) # end of return
    
  }) #end moduleServer function
} #end server function
