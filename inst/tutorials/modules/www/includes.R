# load required packages
library(learnr)


# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"

# load the iris data
data(iris)

# fill in the pageWithSidebar with input widgets
irisClusterUI <- fluidPage( 
  
  # add a title with the titlePanel function
  titlePanel("Iris k-means clustering"),
  
  # set up the page with a sidebar layout
  sidebarLayout(
    
    # add a sidebar panel to store user inputs
    sidebarPanel(
      
      # add the dropdown for the X variable
      selectInput(
        inputId = "xcol", 
        label = "X Variable", 
        choices = c(
          "Sepal.Length", 
          "Sepal.Width", 
          "Petal.Length", 
          "Petal.Width"),
        selected = "Sepal.Length"
      ),
      
      # add the dropdown for the Y variable
      selectInput(
        inputId = "ycol", 
        label = "Y Variable", 
        choices = c(
          "Sepal.Length", 
          "Sepal.Width", 
          "Petal.Length", 
          "Petal.Width"),
        selected = "Sepal.Width"
      ),
      
      # add input to store cluster number
      numericInput(
        inputId = "clusters", 
        label = "Cluster count", 
        value = 3, 
        min = 1, 
        max = 9
      )
      
    ), # end of sidebarPanel function
    
    # add a main panel & scatterplot placeholder
    mainPanel(
      plotOutput(
        outputId = "plot1"
      )
      
    ) # end of mainPanel function
    
  ) # end of sidebarLayout function
  
) # end of fluidPage function


# the server function
irisCluster <- function(input, output){ 
  
  # subset the iris data
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })
  
  # run the kmeans clustering 
  clusters <- reactive({
    kmeans(
      x = selectedData(), 
      centers = input$clusters
    )
  })
  
  # produce the scatterplot
  output$plot1 <- renderPlot({
    oldpar <- par('mar')
    par(mar = c(5.1, 4.1, 0, 1))
    p <- plot(
      selectedData(),
      col = clusters()$cluster,
      pch = 20, 
      cex = 3
    )
    par(mar=oldpar)
    p
  })
} # end of server function
