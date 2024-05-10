#!! ModName = add_noise
#!! ModDisplayName = Add Noise
#!! ModDescription = Add uniform noise to a linear distribution and see how the correlation changes as a result.
#!! ModCitation = Baggins, Bilbo.  (2021).  add_noise.  [Source code].
#!! ModActive = 1
#!! FunctionArg = x !! x-values of linear data !! numeric
#!! FunctionArg = y !! y-values of linear data (noise to be added here) !! numeric
#!! FunctionReturn = y_perturbed !! The y-values, with noise added !! numeric

add_noise_ui <- function(id) {
  # create the module's namespace 
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 4,
        sliderInput(ns('noise'), 'Select Noise Level', min = 0, max = 1, step = 0.05, value = 0),
      ),
      column(
        width = 6,
        plotOutput(ns('fig'))
      ),
    )
  )
}


add_noise_server <- function(id, x, y) {
  moduleServer(id, function(input, output, session) {
    
    r <- reactive(runif(length(y()))-0.5)
    
    y_perturbed <- reactive(y() + length(y())*r()*input$noise)
    
    g <- reactive(
      ggplot2::ggplot(data.frame(x = x(), y = y_perturbed()), aes(x, y))
      + ggplot2::geom_point()
      + ggplot2::xlim(0,length(x())+1)
      + ggplot2::ylim(-length(x())/2,length(x())/2)
      + ggplot2::ggtitle(paste('Correlation:', cor(x(), y_perturbed())))
    )
    
    output$fig <- renderPlot(g())

    return(
      reactiveValues(
        y_perturbed = reactive(y_perturbed())
      )
    )
  })
}
