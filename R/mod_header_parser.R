#' @name mod_header_parser
#' @aliases mod_header_parser
#' @title Parse the header of module modules to add to the database
#' @description This is a helper function that parses the header of modules to
#' pending addition to the shinymgr.sqlite database. This is used as a helper 
#' function by \code{\link{mod_register}} and \code{\link{check_mod_info}} to convert 
#' the data in headers into dataframes.
#' @param filePath The file path to the R module script to be added.
#' @usage mod_header_parser(filePath)
#' @return  A list containing dataframes that can be used to update the shinyMgr
#' database. These include:
#'   1. Data for the modules table
#'   2. Data for updating the modFunctionArguments table
#'   3. Data for updating the modFunctionReturns table
#' @family module
#' @export
#' @examples
#'
#' # establish the path to a built-in shinymgr module
#' filePath <- file.path(find.package('shinymgr'), 'shinymgr/modules/poly_fit.R')
#'
#' # Parse the header and return associated data as a list of dataframes.
#' data_to_add <- mod_header_parser(filePath)
#' 
#' # look at the result
#' str(data_to_add)
#' 
mod_header_parser <- function(filePath) {
  if (!file.exists(filePath)) {
    stop(paste0('The specified file, "', filePath, '", does not exist.'))
  }
  
  # Read in the specified R script and store by line
  conn <- file(filePath, open = "r")
  linn <- readLines(conn)
  close(conn)
  
  # Initialize table with data for the modules table
  newMod <- data.frame(
    pkModuleName = "",
    modDisplayName = "",
    modDescription = "",
    modCitation = "",
    modNotes = "",
    modActive = "",
    dateCreated = "",
    stringsAsFactors = FALSE
  )
  
  # Initialize table with data for the modFunctionArguments table
  newModFunctionArguments <- data.frame(
    functionArgName = character(0),
    functionArgClass = character(0),
    description = character(0),
    stringsAsFactors = FALSE
  )
  
  # Initialize table with data for the modFunctionReturns table
  newModFunctionReturns <- data.frame(
    functionReturnName = character(0),
    functionReturnClass = character(0),
    description = character(0),
    stringsAsFactors = FALSE
  )
  
  # Cycle trough each line
  for (l in linn) {
    # Keep parsing until we don't see the "#!!" at the start of the line
    if (substr(l, 1, 3) == "#!!") {
      cmpts <- strsplit(substr(l, 5, nchar(l)), "=")[[1]] # components of line to be parsed
      
      switch(
        trimws(cmpts[1]),
        "ModName" = {
          newMod$pkModuleName <- trimws(cmpts[2])
        },
        "ModDisplayName" = {
          newMod$modDisplayName <- trimws(cmpts[2])
        },
        "ModDescription" = {
          newMod$modDescription <- trimws(cmpts[2])
        },
        "ModCitation" = {
          newMod$modCitation <- trimws(cmpts[2])
        },
        "ModNotes" = {
          newMod$modNotes <- trimws(cmpts[2])
        },
        "ModActive" = {
          newMod$modActive <- trimws(cmpts[2])
        },
        "FunctionArg" = {
          cmpts2 <- strsplit(substr(l, 19, nchar(l)), "!!")[[1]]
          newModFunctionArguments <- {
            rbind(
              newModFunctionArguments,
              data.frame(
                functionArgName = trimws(cmpts2[1]),
                functionArgClass = trimws(cmpts2[3]),
                description = trimws(cmpts2[2]),
                stringsAsFactors = FALSE
              ),
              stringsAsFactors = FALSE
            )
          }
        },
        "FunctionReturn" = {
          cmpts2 <- strsplit(substr(l, 22, nchar(l)), "!!")[[1]]
          newModFunctionReturns <- {
            rbind(
              newModFunctionReturns,
              data.frame(
                functionReturnName = trimws(cmpts2[1]),
                functionReturnClass = trimws(cmpts2[3]),
                description = trimws(cmpts2[2]),
                stringsAsFactors = FALSE
              ),
            stringsAsFactors = FALSE
            )
          }
        }
      )
    } else {
      break
    }
  }
  
  return(
    list(
      newMod,
      newModFunctionArguments,
      newModFunctionReturns
    )
  )
}
