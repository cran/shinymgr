source("iris_cluster.R")
source("iris_explorer.R")
source("subset_rows.R")

library(shiny)
library(reactable)
library(shinytest)


UI <- fluidPage(
  
  # we keep the header from earlier
  h1("Master App"),
 
  # call iris_explorer_ui function
  iris_explorer_ui(id = "iris_explorer")
 
) # end of fluidPage


# create the R server function
SF <- function(input, output, session, ...){
  
  # call the iris_explorer_server function
  iris_explorer_server(id = "iris_explorer")
  
} # end of server function

shiny::shinyApp(
  ui = UI, 
  server = SF
)

