#!! ModName = make_linear_eq
#!! ModDisplayName = Create Linear Data
#!! ModDescription = Create a dataset of linearly correlated data.
#!! ModCitation = Baggins, Bilbo.  (2021). make_linear_eq. [Source code].
#!! ModActive = 1
#!! FunctionReturn = x !! Vector of x-values for dataset !! numeric
#!! FunctionReturn = y !! Vector of y-values for dataset !! numeric


make_linear_eq_ui <- function(id) {
  # create the module's namespace 
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 4,
        sliderInput(ns('slope'), 'Slope', min = -0.5, max = 0.5, step = 0.1, value = 0.1),
        sliderInput(ns('yIntercept'), 'y-intercept', min = -0.5, max = 0.5, step = 0.1, value = 0),
        numericInput(ns('nPts'), 'Number of points', min = 5, max = 20, step = 1, value = 5)
      ),
      column(
        width = 6,
        plotOutput(ns('fig'))
      ),
    )
  )
}


make_linear_eq_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    x <- reactive(1:input$nPts)
    y <- reactive(input$slope*x() + input$yIntercept)
    
    g <- reactive(
      ggplot2::ggplot(data.frame(x = x(), y = y()), aes(x, y))
      + ggplot2::geom_point()
      + ggplot2::xlim(0,length(x())+1)
      + ggplot2::ylim(-length(x())/2,length(x())/2)
      + ggplot2::ggtitle(paste0('y = ', input$slope, 'x + ', input$yIntercept))
    )
    
    output$fig <- renderPlot(g())
    
    return(
      reactiveValues(
        x = reactive(x()),
        y = reactive(y())
      )
    )
  })
}
