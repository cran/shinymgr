# This script was automatically generated by the shinymgr (vers. 1.0.0) R package's App Builder on 2023-05-31 11:40:15.92573.
# For more information, visit: https://code.usgs.gov/vtcfwru/shinymgr

library(ggplot2)
library(stats)

jscode <- "
shinyjs.disableTab = function(name) {
var tab = $('.nav li a[data-value=' + name + ']');
tab.bind('click.tab', function(e) {
e.preventDefault();
return false;
});
tab.addClass('disabled');
}

shinyjs.enableTab = function(name) {
var tab = $('.nav li a[data-value=' + name + ']');
tab.unbind('click.tab');
tab.removeClass('disabled');
}
"

css <- "
.nav li a.disabled {
background-color: #bbb !important;
border-color: #ccc !important;
cursor: not-allowed !important;
}"


linear_equation_explorer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      shinyjs::useShinyjs(),
      shinyjs::extendShinyjs(text = jscode, functions = c('disableTab','enableTab')),
      shinyjs::inlineCSS(css),
      actionButton(
        ns("start"),
        "Start New Analysis",
        onclick = "var $btn=$(this); setTimeout(function(){$btn.remove();},0);"
      ),
      uiOutput(ns('appUI'))
    )
  )
}
linear_equation_explorer_server <- function(id, userID, shinyMgrPath) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    observeEvent(input$start, {

      shinyjs::disable('start')

      output$appUI <- renderUI({
        tagList(
          tabsetPanel(
            id = ns("mainTabSet"),
            tabPanel(
              "Intro", 
              value = "tab1",
              lee_intro_ui(ns("mod1")),
              fluidRow(
                actionButton(ns('next_tab_1'), label = "Next")
              )
            ),
            tabPanel(
              "Choose Points", 
              value = "tab2",
              tags$br(),
              wellPanel(
                style = "background: skyblue",
                "Create a set of points by specifying the slope and y-intercept of a line, and the number of points in the set."
              ),
              make_linear_eq_ui(ns("mod2")),
              fluidRow(
                actionButton(ns('previous_tab_2'), label = "Previous"),
                actionButton(ns('next_tab_2'), label = "Next")
              )
            ),
            tabPanel(
              "Add Noise", 
              value = "tab3",
              tags$br(),
              wellPanel(
                style = "background: skyblue",
                "Use the slider to add uniform vertical noise to the points."
              ),
              add_noise_ui(ns("mod3")),
              fluidRow(
                actionButton(ns('previous_tab_3'), label = "Previous"),
                actionButton(ns('next_tab_3'), label = "Next")
              )
            ),
            tabPanel(
              "Fit Polynomial", 
              value = "tab4",
              tags$br(),
              wellPanel(
                style = "background: skyblue",
                "Fit a polynomial to your points by specifying the degree."
              ),
              poly_fit_ui(ns("mod4")),
              fluidRow(
                actionButton(ns('previous_tab_4'), label = "Previous"),
                actionButton(ns('next_tab_4'), label = "Next")
              )
            ),
            tabPanel(
              "Save",
              value = "tab5",
              save_analysis_ui(ns("mod5")),
              tags$br(),
              tags$br(),
              fluidRow(
                actionButton(ns("previous_tab_5"), label = "Previous")
              )
            )
          ),
          tags$p(tags$i('App created with shinymgr'), style = "text-align:right")
        )
      })
      shinyjs::delay(50, {
        shinyjs::js$disableTab("tab2")
        shinyjs::js$disableTab("tab3")
        shinyjs::js$disableTab("tab4")
        shinyjs::js$disableTab("tab5")
      })
    })

    lee_intro_server("mod1")
    data1 <- make_linear_eq_server("mod2")
    data2 <- add_noise_server("mod3", x = data1$x, y = data1$y)
    data3 <- poly_fit_server("mod4", x = data1$x, y = data2$y_perturbed)
    save_analysis_server("mod5",
      appName = "linear_equation_explorer",
      moduleInput = input,
      returns = list(
        data1 = list(
          x = data1$x(),
          y = data1$y()
        ),
        data2 = list(
          y_perturbed = data2$y_perturbed()
        ),
        data3 = list(
          degree = data3$degree(),
          coeff = data3$coeff()
        )
      ),
      metadata = list(
        appDescription = "Create a set of uniform points on a line, add uniform noise, and fit a polynomial distribution to the points",
        mod1 = list(
          dataset = "no returns",
          modName = "lee_intro",
          modDisplayName = "Linear Equation Explorer introduction Page",
          modDescription = "This module is simply a page of text with instructions for the linear_equation_explorer app.",
          modArguments = "This module has no additional arguments",
          modReturns = "This module has no returns",
          modPackages = "This module has no package dependencies"
        ),
        mod2 = list(
          dataset = "data1",
          modName = "make_linear_eq",
          modDisplayName = "Create Linear Data",
          modDescription = "Create a dataset of linearly correlated data.",
          modArguments = "This module has no additional arguments",
          modReturns = data.frame(
            name = c("x","y"),
            class = c("numeric","numeric"),
            description = c("Vector of x-values for dataset","Vector of y-values for dataset")
          ),
          modPackages = data.frame(
            name = c("ggplot2"),
            version = c("3.4.1")
          )
        ),
        mod3 = list(
          dataset = "data2",
          modName = "add_noise",
          modDisplayName = "Add Noise",
          modDescription = "Add uniform noise to a linear distribution and see how the correlation changes as a result.",
          modArguments = data.frame(
            name = c("x","y"),
            class = c("numeric","numeric"),
            description = c("x-values of linear data","y-values of linear data (noise to be added here)")
          ),
          modReturns = data.frame(
            name = c("y_perturbed"),
            class = c("numeric"),
            description = c("The y-values, with noise added")
          ),
          modPackages = data.frame(
            name = c("ggplot2"),
            version = c("3.4.1")
          )
        ),
        mod4 = list(
          dataset = "data3",
          modName = "poly_fit",
          modDisplayName = "Polynomial Regression",
          modDescription = "Given two numeric vectors, specify poynomial order and calculate (and plot) the best-fit polynomial equation.",
          modArguments = data.frame(
            name = c("x","y"),
            class = c("numeric","numeric"),
            description = c("Vector of x-values","Vector of y-values")
          ),
          modReturns = data.frame(
            name = c("degree","coeff"),
            class = c("numeric","numeric"),
            description = c("Degree of the fitted polynomial","The coefficients of the fitted polynomial")
          ),
          modPackages = data.frame(
            name = c("ggplot2","stats"),
            version = c("3.4.1","4.3.0")
          )
        ),
        lockfile = list(R = list(Version = "4.3.0", Repositories = list(CRAN = "https://cran.rstudio.com/")), Packages = list(rappdirs = list(Package = "rappdirs", Version = "0.3.3", Source = "Repository", Depends = "R (>= 3.2)", Repository = "CRAN", Hash = "5e3c5dc0b071b21fa128676560dbe94d"), sass = list(Package = "sass", Version = "0.4.2", Source = "Repository", Imports = c("fs", "rlang (>= 0.4.10)", "htmltools (>= 0.5.1)", "R6", "rappdirs"), Repository = "CRAN", Hash = "1b191143d7d3444d504277843f3a95fe"), utf8 = list(Package = "utf8", Version = "1.2.2", Source = "Repository", Depends = "R (>= 2.10)", Repository = "CRAN", 
    Hash = "c9c462b759a5cc844ae25b5942654d13"), renv = list(Package = "renv", Version = "0.15.5", Source = "Repository", Imports = "utils", Repository = "CRAN", Hash = "6a38294e7d12f5d8e656b08c5bd8ae34"), RSQLite = list(Package = "RSQLite", Version = "2.2.14", Source = "Repository", Depends = "R (>= 3.1.0)", Imports = c("bit64", "blob (>= 1.2.0)", "DBI (>= 1.1.0)", "memoise", "methods", "pkgconfig", "Rcpp (>= 1.0.7)"), LinkingTo = c("plogr (>= 0.2.0)", "Rcpp"), Repository = "CRAN", Hash = "086113da6af75461b8dc8d916dcf9620"), 
    lattice = list(Package = "lattice", Version = "0.21-8", Source = "Repository", Depends = "R (>= 4.0.0)", Imports = c("grid", "grDevices", "graphics", "stats", "utils"), Repository = "CRAN", Hash = "0b8a6d63c8770f02a8b5635f3c431e6b"), digest = list(Package = "digest", Version = "0.6.29", Source = "Repository", Depends = "R (>= 3.3.0)", Imports = "utils", Repository = "CRAN", Hash = "cf6b206a045a684728c3267ef7596190"), magrittr = list(Package = "magrittr", Version = "2.0.3", Source = "Repository", 
        Depends = "R (>= 3.4.0)", Repository = "CRAN", Hash = "7ce2733a9826b3aeb1775d56fd305472"), RColorBrewer = list(Package = "RColorBrewer", Version = "1.1-3", Source = "Repository", Depends = "R (>= 2.0.0)", Repository = "CRAN", Hash = "45f0398006e83a5b10b72a90663d8d8c"), fastmap = list(Package = "fastmap", Version = "1.1.0", Source = "Repository", Repository = "CRAN", Hash = "77bd60a6157420d4ffa93b27cf6a58b8"), blob = list(Package = "blob", Version = "1.2.3", Source = "Repository", Imports = c("methods", 
    "rlang", "vctrs (>= 0.2.1)"), Repository = "CRAN", Hash = "10d231579bc9c06ab1c320618808d4ff"), plogr = list(Package = "plogr", Version = "0.2.0", Source = "Repository", Repository = "CRAN", Hash = "09eb987710984fc2905c7129c7d85e65"), jsonlite = list(Package = "jsonlite", Version = "1.8.4", Source = "Repository", Depends = "methods", Repository = "CRAN", Hash = "a4269a09a9b865579b2635c77e572374"), Matrix = list(Package = "Matrix", Version = "1.5-4", Source = "Repository", Depends = c("R (>= 3.5.0)", 
    "methods"), Imports = c("graphics", "grid", "lattice", "stats", "utils"), Repository = "CRAN", Hash = "e779c7d9f35cc364438578f334cffee2"), DBI = list(Package = "DBI", Version = "1.1.3", Source = "Repository", Depends = c("methods", "R (>= 3.0.0)"), Repository = "CRAN", Hash = "b2866e62bab9378c3cc9476a1954226b"), promises = list(Package = "promises", Version = "1.2.0.1", Source = "Repository", Imports = c("R6", "Rcpp", "later", "rlang", "stats", "magrittr"), LinkingTo = c("later", "Rcpp"), Repository = "CRAN", 
        Hash = "4ab2c43adb4d4699cf3690acd378d75d"), mgcv = list(Package = "mgcv", Version = "1.8-42", Source = "Repository", Depends = c("R (>= 3.6.0)", "nlme (>= 3.1-64)"), Imports = c("methods", "stats", "graphics", "Matrix", "splines", "utils"), Repository = "CRAN", Hash = "3460beba7ccc8946249ba35327ba902a"), fansi = list(Package = "fansi", Version = "1.0.3", Source = "Repository", Depends = "R (>= 3.1.0)", Imports = c("grDevices", "utils"), Repository = "CRAN", Hash = "83a8afdbe71839506baa9f90eebad7ec"), 
    viridisLite = list(Package = "viridisLite", Version = "0.4.1", Source = "Repository", Depends = "R (>= 2.10)", Repository = "CRAN", Hash = "62f4b5da3e08d8e5bcba6cac15603f70"), scales = list(Package = "scales", Version = "1.2.1", Source = "Repository", Depends = "R (>= 3.2)", Imports = c("farver (>= 2.0.3)", "labeling", "lifecycle", "munsell (>= 0.5)", "R6", "RColorBrewer", "rlang (>= 1.0.0)", "viridisLite"), Repository = "CRAN", Hash = "906cb23d2f1c5680b8ce439b44c6fa63"), shinydashboard = list(
        Package = "shinydashboard", Version = "0.7.2", Source = "Repository", Depends = "R (>= 3.0)", Imports = c("utils", "shiny (>= 1.0.0)", "htmltools (>= 0.2.6)", "promises"), Repository = "CRAN", Hash = "e418b532e9bb4eb22a714b9a9f1acee7"), jquerylib = list(Package = "jquerylib", Version = "0.1.4", Source = "Repository", Imports = "htmltools", Repository = "CRAN", Hash = "5aab57a3bd297eee1c1d862735972182"), isoband = list(Package = "isoband", Version = "0.2.7", Source = "Repository", Imports = c("grid", 
    "utils"), Repository = "CRAN", Hash = "0080607b4a1a7b28979aecef976d8bc2"), cli = list(Package = "cli", Version = "3.6.0", Source = "Repository", Depends = "R (>= 3.4)", Imports = "utils", Repository = "CRAN", Hash = "3177a5a16c243adc199ba33117bd9657"), shiny = list(Package = "shiny", Version = "1.7.3", Source = "Repository", Depends = c("R (>= 3.0.2)", "methods"), Imports = c("utils", "grDevices", "httpuv (>= 1.5.2)", "mime (>= 0.3)", "jsonlite (>= 0.9.16)", "xtable", "fontawesome (>= 0.4.0)", 
    "htmltools (>= 0.5.2)", "R6 (>= 2.0)", "sourcetools", "later (>= 1.0.0)", "promises (>= 1.1.0)", "tools", "crayon", "rlang (>= 0.4.10)", "fastmap (>= 1.1.0)", "withr", "commonmark (>= 1.7)", "glue (>= 1.3.2)", "bslib (>= 0.3.0)", "cachem", "ellipsis", "lifecycle (>= 0.2.0)"), Repository = "CRAN", Hash = "fe12df67fdb3b1142325cc54f100cc06"), crayon = list(Package = "crayon", Version = "1.5.2", Source = "Repository", Imports = c("grDevices", "methods", "utils"), Repository = "CRAN", Hash = "e8a1e41acf02548751f45c718d55aa6a"), 
    rlang = list(Package = "rlang", Version = "1.0.6", Source = "Repository", Depends = "R (>= 3.4.0)", Imports = "utils", Repository = "CRAN", Hash = "4ed1f8336c8d52c3e750adcdc57228a7"), ellipsis = list(Package = "ellipsis", Version = "0.3.2", Source = "Repository", Depends = "R (>= 3.2)", Imports = "rlang (>= 0.3.0)", Repository = "CRAN", Hash = "bb0eec2fe32e88d9e2836c2f73ea2077"), commonmark = list(Package = "commonmark", Version = "1.8.0", Source = "Repository", Repository = "CRAN", Hash = "2ba81b120c1655ab696c935ef33ea716"), 
    bit64 = list(Package = "bit64", Version = "4.0.5", Source = "Repository", Depends = c("R (>= 3.0.1)", "bit (>= 4.0.0)", "utils", "methods", "stats"), Repository = "CRAN", Hash = "9fe98599ca456d6552421db0d6772d8f"), munsell = list(Package = "munsell", Version = "0.5.0", Source = "Repository", Imports = c("colorspace", "methods"), Repository = "CRAN", Hash = "6dfe8bf774944bd5595785e3229d8771"), base64enc = list(Package = "base64enc", Version = "0.1-3", Source = "Repository", Depends = "R (>= 2.9.0)", 
        Repository = "CRAN", Hash = "543776ae6848fde2f48ff3816d0628bc"), withr = list(Package = "withr", Version = "2.5.0", Source = "Repository", Depends = "R (>= 3.2.0)", Imports = c("graphics", "grDevices", "stats"), Repository = "CRAN", Hash = "c0e49a9760983e81e55cdd9be92e7182"), reactR = list(Package = "reactR", Version = "0.4.4", Source = "Repository", Imports = "htmltools", Repository = "CRAN", Hash = "75389c8091eb14ee21c6bc87a88b3809"), cachem = list(Package = "cachem", Version = "1.0.6", 
        Source = "Repository", Imports = c("rlang", "fastmap"), Repository = "CRAN", Hash = "648c5b3d71e6a37e3043617489a0a0e9"), yaml = list(Package = "yaml", Version = "2.3.5", Source = "Repository", Repository = "CRAN", Hash = "458bb38374d73bf83b1bb85e353da200"), memoise = list(Package = "memoise", Version = "2.0.1", Source = "Repository", Imports = c("rlang (>= 0.4.10)", "cachem"), Repository = "CRAN", Hash = "e2817ccf4a065c5d9d7f2cfbe7c1d78c"), colorspace = list(Package = "colorspace", Version = "2.0-3", 
        Source = "Repository", Depends = c("R (>= 3.0.0)", "methods"), Imports = c("graphics", "grDevices", "stats"), Repository = "CRAN", Hash = "bb4341986bc8b914f0f0acf2e4a3f2f7"), ggplot2 = list(Package = "ggplot2", Version = "3.4.1", Source = "Repository", Depends = "R (>= 3.3)", Imports = c("cli", "glue", "grDevices", "grid", "gtable (>= 0.1.1)", "isoband", "lifecycle (> 1.0.1)", "MASS", "mgcv", "rlang (>= 1.0.0)", "scales (>= 1.2.0)", "stats", "tibble", "vctrs (>= 0.5.0)", "withr (>= 2.5.0)"
    ), Repository = "CRAN", Hash = "d494daf77c4aa7f084dbbe6ca5dcaca7"), httpuv = list(Package = "httpuv", Version = "1.6.5", Source = "Repository", Depends = "R (>= 2.15.1)", Imports = c("Rcpp (>= 1.0.7)", "utils", "R6", "promises", "later (>= 0.8.0)"), LinkingTo = c("Rcpp", "later"), Repository = "CRAN", Hash = "97fe71f0a4a1c9890e6c2128afa04bc0"), sourcetools = list(Package = "sourcetools", Version = "0.1.7", Source = "Repository", Depends = "R (>= 3.0.2)", Repository = "CRAN", Hash = "947e4e02a79effa5d512473e10f41797"), 
    vctrs = list(Package = "vctrs", Version = "0.5.2", Source = "Repository", Depends = "R (>= 3.3)", Imports = c("cli (>= 3.4.0)", "glue", "lifecycle (>= 1.0.3)", "rlang (>= 1.0.6)"), Repository = "CRAN", Hash = "e4ffa94ceed5f124d429a5a5f0f5b378"), R6 = list(Package = "R6", Version = "2.5.1", Source = "Repository", Depends = "R (>= 3.0)", Repository = "CRAN", Hash = "470851b6d5d0ac559e9d01bb352b4021"), mime = list(Package = "mime", Version = "0.12", Source = "Repository", Imports = "tools", Repository = "CRAN", 
        Hash = "18e9c28c1d3ca1560ce30658b22ce104"), lifecycle = list(Package = "lifecycle", Version = "1.0.3", Source = "Repository", Depends = "R (>= 3.4)", Imports = c("cli (>= 3.4.0)", "glue", "rlang (>= 1.0.6)"), Repository = "CRAN", Hash = "001cecbeac1cff9301bdc3775ee46a86"), reactable = list(Package = "reactable", Version = "0.3.0", Source = "Repository", Depends = "R (>= 3.1)", Imports = c("digest", "htmltools", "htmlwidgets", "jsonlite", "reactR"), Repository = "CRAN", Hash = "377c52754f3e6c17673c79740e9296d7"), 
    fs = list(Package = "fs", Version = "1.5.2", Source = "Repository", Depends = "R (>= 3.1)", Imports = "methods", Repository = "CRAN", Hash = "7c89603d81793f0d5486d91ab1fc6f1d"), htmlwidgets = list(Package = "htmlwidgets", Version = "1.5.4", Source = "Repository", Imports = c("grDevices", "htmltools (>= 0.3)", "jsonlite (>= 0.9.16)", "yaml"), Repository = "CRAN", Hash = "76147821cd3fcd8c4b04e1ef0498e7fb"), bit = list(Package = "bit", Version = "4.0.4", Source = "Repository", Depends = "R (>= 2.9.2)", 
        Repository = "CRAN", Hash = "f36715f14d94678eea9933af927bc15d"), MASS = list(Package = "MASS", Version = "7.3-58.4", Source = "Repository", Depends = c("R (>= 4.3.0)", "grDevices", "graphics", "stats", "utils"), Imports = "methods", Repository = "CRAN", Hash = "a3142b2a022b8174ca675bc8b80cdc4e"), shinyjs = list(Package = "shinyjs", Version = "2.1.0", Source = "Repository", Depends = "R (>= 3.1.0)", Imports = c("digest (>= 0.6.8)", "jsonlite", "shiny (>= 1.0.0)"), Repository = "CRAN", Hash = "802e4786b353a4bb27116957558548d5"), 
    fontawesome = list(Package = "fontawesome", Version = "0.4.0", Source = "Repository", Depends = "R (>= 3.3.0)", Imports = c("rlang (>= 0.4.10)", "htmltools (>= 0.5.1.1)"), Repository = "CRAN", Hash = "c5a628c2570aa86a96cc6ef739d8bfda"), pkgconfig = list(Package = "pkgconfig", Version = "2.0.3", Source = "Repository", Imports = "utils", Repository = "CRAN", Hash = "01f28d4278f15c76cddbea05899c5d6f"), bslib = list(Package = "bslib", Version = "0.4.0", Source = "Repository", Depends = "R (>= 2.10)", 
        Imports = c("grDevices", "htmltools (>= 0.5.2)", "jsonlite", "sass (>= 0.4.0)", "jquerylib (>= 0.1.3)", "rlang", "cachem", "memoise"), Repository = "CRAN", Hash = "be5ee090716ce1671be6cd5d7c34d091"), pillar = list(Package = "pillar", Version = "1.8.1", Source = "Repository", Imports = c("cli (>= 2.3.0)", "fansi", "glue", "lifecycle", "rlang (>= 1.0.2)", "utf8 (>= 1.1.0)", "utils", "vctrs (>= 0.3.8)"), Repository = "CRAN", Hash = "f2316df30902c81729ae9de95ad5a608"), later = list(Package = "later", 
        Version = "1.3.0", Source = "Repository", Imports = c("Rcpp (>= 0.12.9)", "rlang"), LinkingTo = "Rcpp", Repository = "CRAN", Hash = "7e7b457d7766bc47f2a5f21cc2984f8e"), gtable = list(Package = "gtable", Version = "0.3.1", Source = "Repository", Depends = "R (>= 3.0)", Imports = "grid", Repository = "CRAN", Hash = "36b4265fb818f6a342bed217549cd896"), glue = list(Package = "glue", Version = "1.6.2", Source = "Repository", Depends = "R (>= 3.4)", Imports = "methods", Repository = "CRAN", Hash = "4f2596dfb05dac67b9dc558e5c6fba2e"), 
    Rcpp = list(Package = "Rcpp", Version = "1.0.9", Source = "Repository", Imports = c("methods", "utils"), Repository = "CRAN", Hash = "e9c08b94391e9f3f97355841229124f2"), shinymgr = list(Package = "shinymgr", Version = "1.0.0", Source = "GitLab", Depends = c("R (>= 3.5.0)", "DBI", "reactable", "renv", "RSQLite", "shiny", "shinyjs", "shinydashboard"), RemoteType = "gitlab", RemoteHost = "code.usgs.gov", RemoteRepo = "shinymgr", RemoteUsername = "vtcfwru", RemoteRef = "HEAD", RemoteSha = "751c2abfc1445eda0ff3917ce954e58aef6cb554", Hash = "6389ecd459619796fb3604547b99a873"), tibble = list(Package = "tibble", Version = "3.1.8", Source = "Repository", Depends = "R (>= 3.1.0)", 
        Imports = c("fansi (>= 0.4.0)", "lifecycle (>= 1.0.0)", "magrittr", "methods", "pillar (>= 1.7.0)", "pkgconfig", "rlang (>= 1.0.2)", "utils", "vctrs (>= 0.3.8)"), Repository = "CRAN", Hash = "56b6934ef0f8c68225949a8672fe1a8f"), farver = list(Package = "farver", Version = "2.1.1", Source = "Repository", Repository = "CRAN", Hash = "8106d78941f34855c440ddb946b8f7a5"), xtable = list(Package = "xtable", Version = "1.8-4", Source = "Repository", Depends = "R (>= 2.10.0)", Imports = c("stats", 
    "utils"), Repository = "CRAN", Hash = "b8acdf8af494d9ec19ccb2481a9b11c2"), htmltools = list(Package = "htmltools", Version = "0.5.2", Source = "Repository", Depends = "R (>= 2.14.1)", Imports = c("utils", "digest", "grDevices", "base64enc", "rlang (>= 0.4.10)", "fastmap"), Repository = "CRAN", Hash = "526c484233f42522278ab06fb185cb26"), nlme = list(Package = "nlme", Version = "3.1-162", Source = "Repository", Depends = "R (>= 3.5.0)", Imports = c("graphics", "stats", "utils", "lattice"), Repository = "CRAN", 
        Hash = "0984ce8da8da9ead8643c5cbbb60f83e"), labeling = list(Package = "labeling", Version = "0.4.2", Source = "Repository", Imports = c("stats", "graphics"), Repository = "CRAN", Hash = "3d5108641f47470611a32d0bdf357a72")))
      )
    )
    observeEvent(input$next_tab_1, {
      shinyjs::js$enableTab('tab2')
      shinyjs::js$disableTab('tab1')
      updateTabsetPanel(
        session, 'mainTabSet',
        selected = 'tab2'
      )
    })
    observeEvent(input$next_tab_2, {
      shinyjs::js$enableTab('tab3')
      shinyjs::js$disableTab('tab2')
      updateTabsetPanel(
        session, 'mainTabSet',
        selected = 'tab3'
      )
    })
    observeEvent(input$previous_tab_2, {
      shinyjs::delay(50, {
        shinyjs::js$enableTab('tab1')
        shinyjs::js$disableTab('tab2')
      })
      removeTab('mainTabSet','tab2',session)
      insertTab(
        inputId = 'mainTabSet',
        tab = tabPanel(
          title = "Choose Points",
          value = "tab2",
          make_linear_eq_ui(ns("mod2")),
          fluidRow(
            actionButton(ns('previous_tab_2'), label = "Previous"),
            actionButton(ns('next_tab_2'), label = "Next")
          )
        ),
        target = 'tab1',
        position = 'after'
      )
      updateTabsetPanel(
        session, 'mainTabSet',
                selected = 'tab1'
      )
    })
    observeEvent(input$next_tab_3, {
      shinyjs::js$enableTab('tab4')
      shinyjs::js$disableTab('tab3')
      updateTabsetPanel(
        session, 'mainTabSet',
        selected = 'tab4'
      )
    })
    observeEvent(input$previous_tab_3, {
      shinyjs::delay(50, {
        shinyjs::js$enableTab('tab2')
        shinyjs::js$disableTab('tab3')
      })
      removeTab('mainTabSet','tab3',session)
      insertTab(
        inputId = 'mainTabSet',
        tab = tabPanel(
          title = "Add Noise",
          value = "tab3",
          add_noise_ui(ns("mod3")),
          fluidRow(
            actionButton(ns('previous_tab_3'), label = "Previous"),
            actionButton(ns('next_tab_3'), label = "Next")
          )
        ),
        target = 'tab2',
        position = 'after'
      )
      updateTabsetPanel(
        session, 'mainTabSet',
                selected = 'tab2'
      )
    })
    observeEvent(input$next_tab_4, {
      shinyjs::js$enableTab('tab5')
      shinyjs::js$disableTab('tab4')
      updateTabsetPanel(
        session, 'mainTabSet',
        selected = 'tab5'
      )
    })
    observeEvent(input$previous_tab_4, {
      shinyjs::delay(50, {
        shinyjs::js$enableTab('tab3')
        shinyjs::js$disableTab('tab4')
      })
      removeTab('mainTabSet','tab4',session)
      insertTab(
        inputId = 'mainTabSet',
        tab = tabPanel(
          title = "Fit Polynomial",
          value = "tab4",
          poly_fit_ui(ns("mod4")),
          fluidRow(
            actionButton(ns('previous_tab_4'), label = "Previous"),
            actionButton(ns('next_tab_4'), label = "Next")
          )
        ),
        target = 'tab3',
        position = 'after'
      )
      updateTabsetPanel(
        session, 'mainTabSet',
                selected = 'tab3'
      )
    })
    observeEvent(input$previous_tab_5, {
      shinyjs::delay(50, {
        shinyjs::js$enableTab('tab4')
        shinyjs::js$disableTab('tab5')
      })
      updateTabsetPanel(
        session, 'mainTabSet',
                selected = 'tab4'
      )
    })
  })
}
