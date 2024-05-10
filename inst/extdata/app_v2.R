library(shiny)
source("irisCluster_with_output.R")
source("subset_rows.R")

UI <- fluidPage(
  
  # add a level 1 header
  h1("Master App"),
  
  # each module will have its own tab
  tabsetPanel(
    
    #k-means clustering tab
    tabPanel(
      title = "K-means clustering",
      irisClusterUI("hello")
    ),
    
    #subset rows tab
    tabPanel(
      title = "Subset Rows",
      subset_rows_ui("subset")
    )
  )
  
) # end of fluidPage

# create the R server function
SF <- function(input, output, session, ...){
  
  # store the output from the irisCluster module that has hello as its namespace
  dataset <- irisClusterServer("hello")
  
  # call the server function, setting the reactive return as the input
  subset_rows_server("subset", dataframe = dataset$returndf)
  
} # end of server function


# Run the application 
shinyApp(ui = UI, server = SF)
