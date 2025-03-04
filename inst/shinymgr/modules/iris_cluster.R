#!! ModName = iris_cluster
#!! ModDisplayName = Iris K-Means Clustering
#!! ModDescription = Clusters iris data based on 2 attributes
#!! ModCitation = Baggins, Bilbo.  (2022). iris_cluster. [Source code].
#!! ModNotes = Demo module for the shinymgr package.
#!! ModActive = 1
#!! FunctionReturn = returndf !! selected attributes and their assigned clusters !! data.frame

iris_cluster_ui <- function(id){
  # create the module's namespace 
  ns <- NS(id)
  
  tagList(
    sidebarLayout(
      sidebarPanel(
        # add the dropdown for the X variable
        selectInput(
          ns("xcol"),
          label = "X Variable", 
          choices = c(
            "Sepal.Length", 
            "Sepal.Width", 
            "Petal.Length", 
            "Petal.Width"
          ),
          selected = "Sepal.Length"
        ),
        
        # add the dropdown for the Y variable
        selectInput(
          ns("ycol"), 
          label = "Y Variable", 
          choices = c(
            "Sepal.Length", 
            "Sepal.Width", 
            "Petal.Length", 
            "Petal.Width"
          ),
          selected = "Sepal.Width"
        ),
        # add input box for the cluster number
        
        numericInput(
          ns("clusters"), 
          label = "Cluster count", 
          value = 3, 
          min = 1, 
          max = 9
        )
      ), # end of sidebarPanel
      
      mainPanel(
        # create outputs
        plotOutput(
          ns("plot1")
        )
      ) # end of mainPanel
    ) # end of sidebarLayout
  ) # end of tagList
} # end of UI function

iris_cluster_server <- function(id) { 
  
  moduleServer(id, function(input, output, session) {
    
    # combine variables into new data frame
    selectedData <- reactive({
      iris[, c(input$xcol, input$ycol)]
    })
    
    # run kmeans algorithm 
    clusters <- reactive({
      stats::kmeans(
        x = selectedData(), 
        centers = input$clusters
      )
    })
    
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
    
    return(
      reactiveValues(
        returndf = reactive({
          cbind(
            selectedData(), 
            cluster = clusters()$cluster
          )
        })
      )
    )
    
  }) # end of moduleServer function
  
} # end of irisCluster function
