#!! ModName = poly_fit
#!! ModDisplayName = Polynomial Regression
#!! ModDescription = Given two numeric vectors, specify poynomial order and calculate (and plot) the best-fit polynomial equation.
#!! ModCitation = Baggins, Bilbo.  (2021). poly_fit. [Source code].
#!! ModActive = 1
#!! FunctionArg = x !! Vector of x-values !! numeric
#!! FunctionArg = y !! Vector of y-values !! numeric
#!! FunctionReturn = degree !! Degree of the fitted polynomial !! numeric
#!! FunctionReturn = coeff !! The coefficients of the fitted polynomial !! numeric

poly_fit_ui <- function(id) {
  # create the module's namespace 
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 4,
        numericInput(ns('degree'), 'Select Polynomial Degree', min = 1, max = 5, step = 1, value = 1),
      ),
      column(
        width = 6,
        plotOutput(ns('fig')),
        tableOutput(ns('fit_summary'))
      ),
    )
  )
}


poly_fit_server <- function(id, x, y) {
  moduleServer(id, function(input, output, session) {
    
    model <- reactive({
      req(x(), y())
      lm(y() ~ poly(x(), input$degree, raw = TRUE))
    })
    
    y_pred <- reactive(
      stats::predict(model())
    )
    
    g <- reactive(
      ggplot2::ggplot(data.frame(x = x(), y = y()), aes(x, y))
        + ggplot2::geom_point()
        + ggplot2::geom_line(
          data = data.frame(
            x = x()[order(x())],
            y = y_pred()[order(x())]
          ), 
          color = "red"
        ) 
        + ggplot2::xlim(range(x()))
        + ggplot2::ylim(range(c(y(), y_pred())))
    )
    
    output$fig <- renderPlot(g())
    
    model_info <- reactive({
      data.frame(
        degree = 0:input$degree,
        coeff = model()$coefficients
      )
    })
    
    output$fit_summary <- renderTable({
      model_info()
    })
  
    return(
      reactiveValues(
        degree = reactive(input$degree),
        coeff = model_info,
        g = reactive(g())
      )
    )
  })
}
