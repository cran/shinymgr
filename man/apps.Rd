% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpfiles.R
\docType{data}
\name{apps}
\alias{apps}
\title{Sample data for the shinymgr.sqlite table, "apps"}
\format{
A data frame with 3 observations on the following 10 variables.
}
\usage{
data(demo_data)
}
\description{
Sample data imported to the shinymgr SQLite database
 by the function \code{\link{shiny_db_populate}}.
}
\details{
-----------------------------------------------------------

New records to the "apps" table are added to the shinymgr.sqlite 
database 
via the "App Builder" interface within shinymgr's Developer section.
}
\section{Fields}{

\describe{
\item{\code{pkAppName}}{Name of the app; primary key.}

\item{\code{appDisplayName}}{Name that is displayed on app.}

\item{\code{appDescription}}{A description of the app.}

\item{\code{appVideoURL}}{A link to a video if desired.}

\item{\code{appCSS}}{The css file to style the app.}

\item{\code{appNotes}}{Developer notes about the app.}

\item{\code{appActive}}{Logical. Is the app active?}

\item{\code{fkParentAppName}}{References previous version of app.}

\item{\code{appCitation}}{The official citation of the app.}
}}

\examples{

# read in the demo data
data(demo_data)

# look at the structure
str(apps)

}
\seealso{
Other data: 
\code{\link{appReports}},
\code{\link{appStitching}},
\code{\link{appTabs}},
\code{\link{modFunctionArguments}},
\code{\link{modFunctionReturns}},
\code{\link{modPackages}},
\code{\link{modules}},
\code{\link{reports}},
\code{\link{tabModules}},
\code{\link{tabs}}
}
\concept{data}
