<IMG SRC="https://code.usgs.gov/vtcfwru/shinymgr/raw/master/inst/extdata/shinymgr-hexsticker.png" alt="shinymgr_logo" width=150 align="right">

# shinymgr

**A Framework for Building, Managing, and Stitching Shiny Modules into Reproducible Workflows**

<IMG SRC= 'https://img.shields.io/static/v1?label=&message=Shiny&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=R&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=Modules&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=Automated Analysis&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=Reproducible Workflow&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=RMarkdown Reporting&color=<"green">'>
<IMG SRC= 'https://img.shields.io/static/v1?label=&message=VTCFWRU&color=<"green">'>

## Authors

Laurence Clarfeld, Caroline Tang, Therese Donovan

## Point of contact: 

Laurence Clarfeld (lclarfel@uvm.edu) and Therese Donovan (tdonovan@uvm.edu)

## Information

- Repository Type: Program R scripts
- Year of Origin:  2022
- Year of Version: 2024
- Version: 1.1.0
- Digital Object Identifier (DOI): https://doi.org/10.5066/P9UXPOBN
- USGS Information Product Data System (IPDS) no.: IP-144047 (internal agency tracking)

## Suggested Citation for Software

Clarfeld, L., Tang, C., and Donovan, T. shinymgr: A framework for building, managing, and stitching shiny modules into reproducible workflows. Version 1.1.0: U.S. Geological Survey software release. Reston, VA. https://doi.org/10.5066/P9UXPOBN

Clarfeld,L. Tang, C., and Donovan, T.  shinymgr: A Framework for building, managing, and stitching shiny modules into reproducible workflows.  The R Journal.  

## Overview

Welcome.  *shiny* is an R package that makes it easy to build interactive web apps, each with an intended purpose developed for an intended user audience. A shiny web app can permit an expedient analysis pipeline or workflow that is fully reproducible, allowing users to convey the results of an analysis to a target audience.

<p>
<IMG SRC="https://code.usgs.gov/vtcfwru/shinymgr/raw/master/inst/extdata/workflow.PNG" alt="Figure 1. Image of a typical data analysis workflow." width=600 />
<br>Figure 1. Image of a typical data analysis workflow.
</p>

From the developer perspective, complex shiny applications can result in many lines of code, creating challenges for collaborating, debugging, streamlining, and maintaining the overall product. Shiny modules are a solution to this problem. As stated by Winston Chang, "*A Shiny module is a piece of a Shiny app. It can’t be directly run, as a Shiny app can. Instead, it is included as part of a larger app . . .  Once created, a Shiny module can be easily reused – whether across different apps, or multiple times in a single app.*" -- source: https://shiny.rstudio.com/articles/modules.html.  

Developers of shiny apps that rely on a modularized system to guide a user through an analysis will naturally be faced with several questions:

1. Which modules have been written?
2. What are the module's inputs (arguments) and outputs (returns)?
3. Where are the modules stored?
4. For any given app, what is the order in which modules are presented to the Shiny user?
5. Can analysis outputs be saved as a fully reproducible workflow?
6. Can outputs be ingested into a R Markdown file for rapid reporting?


------------------------------------------------------------------------------------------
&#128073;&#127997; **The R package, *shinymgr*, was developed to meet these challenges.  The package itself includes a general framework for managing modules, stitching them together as individuals "apps", saving reproducible analysis outputs, and offering opportunities for rapid reporting. It can be used as a stand-alone Shiny application that is housed on a local machine or a server, or can be embedded within R packages for developers who wish to provide Shiny functionality for showcasing their own package.**

------------------------------------------------------------------------------------------



From the user's perspective, an “app” consists of a series of RShiny tabs that are presented in order, establishing an analysis workflow. The inputs and outputs of a given app can be saved as an .RDS file to ensure reproducibility. Further, the .RDS file may be loaded into an R Markdown (.Rmd) template for rapid reporting.  

<p>
<IMG SRC="https://code.usgs.gov/vtcfwru/shinymgr/raw/master/inst/extdata/appImage.PNG">
<br>Figure 2. A shinymgr "app" consists of a series of tabs that are executed in order, ending with the option to save the analysis steps as an RDS file.
</p>

From the developer's perspective, each tab in an "app" consists of one or more Shiny modules.   The *shinymgr* app builder "stitches" shiny modules together so that outputs from one module serve as inputs to the next, creating an analysis pipeline that is easy to implement and maintain.

In short, developers use the *shinymgr* framework to write modules and seamlessly combine them into shiny apps, and users of these apps can execute reproducible analyses that can be incorporated into reports for rapid dissemination. 

## Installation

For version 1.1.0:

```
install.packages("devtools")
devtools::install_git("https://code.usgs.gov/vtcfwru/shinymgr@1.1.0", dependencies = TRUE)
```

Alternatively, uses may download the compiled software from https://code.usgs.gov/vtcfwru/shinymgr/-/releases.  

On that page, Windows users can download shinymgr_1.1.0.zip, while Mac/Linux can download shinymgr_1.1.0.tar.gz.  Then, in R Studio, click on the Install button on the Packages tab, and select Install From Package Archive File, and navigate to the downloaded file.

## Getting Started

An overview of the package is found by typing:

```
library(shinymgr)
?shinymgr

```

Once installed, the developer must choose a directory that will store the 
shinymgr project.  Let's say that file path is defined as:

```
my_parentPath <- 'c:/my_shinymgr_project'
dir.create(my_parentPath)
```

Next, run the `shinymgr_setup` function to create the *shinymgr* project. 
*Note:* In the tutorials, 
you will specify `demo = TRUE` and explore the full functionality of *shinymgr*.

```
# Create the shinymgr directory structure
shinymgr::shinymgr_setup(parentPath = my_parentPath, demo = TRUE)

# Set your working directory to the newly created shinymgr folder
setwd('c:/my_shinymgr_project/shinymgr')
```

The newly created *shinymgr* project directory provides a relative path 
for running *shinymgr*'s
user interface, so it is necessary to set this path as your working directory 
to launch the UI, or declare this path as your `shinyMgrPath`. 

The `shinymgr_setup()` function copies several folders and associated files to the *shinymgr* directory in a user-specified folder.  If you set "demo" = TRUE, each directory will include several demo files.  

```
# Look at the file structure of a shinymgr project
list.files(path = 'c:/my_shinymgr_project/shinymgr')
```

- The **analyses** folder may be used to store previously run analyses as RDS files.  

- The **data** folder stores RData files that can be used by various apps (e.g., "iris.RData").

- The **database** folder stores the *shinymgr* SQLite database, named "shinymgr.sqlite". The 
database tracks all modules, their arguments (inputs), returns (outputs), and how they are combined into an "app". 

- The **modules** folder stores stand-alone modules. These files are largely written by hand by
the *shinymgr* developer.

- The **modules_app** folder stores modules that are *shinymgr* "apps" -- the stitching together of modules into a tab-based layout that provides an analysis workflow. These files are written
by *shinymgr*'s app builder.

-  The **modules_mgr** folder stores modules that build the default *shinymgr* framework that you see when you run `launch_shinymgr()`.  

- The **reports** folder stores R Markdown (.Rmd) files that serve as canned reports. These markdown files allow a user to navigate to a previously stored analysis (an RDS file) and use the results in the report itself, allowing for rapid reporting.  

- The **tests** folder stores both *testthat* and *shinytest* code testing scripts.

- The **www** folder stores images that may be used by a shiny app.  

- In the main *shinymgr* directory, there are three files. Briefly, these files generate the Shiny app and the code is pasted into the next few sections.  

  1. **ui.R** - This file contains code to set the user interface for the master *shinymgr* app (ui = user interface). 
  
  2. **server.R** - The master server file. 
  
  3. **global.R** - The global.R file is sourced into the server.R file at start-up.  It simply instructs R to read in all of the modules within the *shinymgr* framework.


Now, you're ready
to launch the *shinymgr* UI:

```
shinymgr::launch_shinymgr('c:/my_shinymgr_project/shinymgr')
```

In summary, the `shinymgr_setup()` function  creates the directory structure and underlying database needed for building and running Shiny apps with *shinymgr*. You can create as many *shinymgr* projects on your machine as you'd like.  In each case, the *shinymgr* project is simply a fixed directory structure with three R files (ui.R, server.R, and global.R), and a series of subdirectories that contain the apps and modules that you develop, along with a database for tracking everything.  YOU will develop your own modules and use the *shinymgr* "App Builder" to create apps that stitch your modules together and guide your user through a tabbed workflow.

Once you have finished with module and app development, you can remove all dependencies on the *shinymgr* framework and copy it into your own package or deploy it on a server.  

The package's cheatsheet can be found with the code:

```
browseURL(paste0(find.package("shinymgr"), "/extdata/shinymgr_cheatsheet.pdf"))
```


## Tutorials

The *shinymgr* package comes with 12 learnr tutorials to guide users through the app-building 
process, including writing modules, "stitching" modules into apps, using apps to 
run analyses, and generating reports from a saved analysis. Tutorials should be
executed in the following order: 

```
library(learnr)

learnr::run_tutorial(name = "intro", package = "shinymgr")
learnr::run_tutorial(name = "shiny", package = "shinymgr")
learnr::run_tutorial(name = "modules", package = "shinymgr")
learnr::run_tutorial(name = "app_modules", package = "shinymgr")
learnr::run_tutorial(name = "tests", package = "shinymgr")
learnr::run_tutorial(name = "shinymgr", package = "shinymgr")
learnr::run_tutorial(name = "database", package = "shinymgr")
learnr::run_tutorial(name = "shinymgr_modules", package = "shinymgr")
learnr::run_tutorial(name = "apps", package = "shinymgr")
learnr::run_tutorial(name = "analyses", package = "shinymgr")
learnr::run_tutorial(name = "reports", package = "shinymgr")
learnr::run_tutorial(name = "deployment", package = "shinymgr")
```

## Contributing

Please join our community and consider submitting issues and/or contributions!

Contributions are welcome from the community. Questions can be asked on the
[issues page][1]. Before creating a new issue, please take a moment to search
and make sure a similar issue does not already exist. If one does exist, you
can comment (most simply even with just a `:+1:`) to show your support for that
issue. Alternatively, create a new issue by sending  an email to 
gs_gitlab_servicedesk+vtcfwru-shinymgr-5231-issue-@usgs.gov.

If you have direct contributions you would like considered for incorporation
into the project you can [fork this repository][2] and
[submit a pull request][3] for review.

## Disclaimer

This software has been approved for release by the U.S. Geological Survey (USGS). Although the software has been subjected to rigorous review, the USGS reserves the right to update the software as needed pursuant to further analysis and review. No warranty, expressed or implied, is made by the USGS or the U.S. Government as to the functionality of the software and related material nor shall the fact of release constitute any such warranty. Furthermore, the software is released on condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from its authorized or unauthorized use.

## Code of Conduct

All contributions to- and interactions surrounding- this project will abide by 
the [USGS Code of Scientific Conduct][4].

[1]: https://code.usgs.gov/vtcfwru/shinymgr/-/issues
[2]: https://docs.gitlab.com/ee/user/project/repository/forking_workflow.html#project-forking-workflow
[3]: https://code.usgs.gov/vtcfwru/shinymgr/-/merge_requests
[4]: https://www.usgs.gov/office-of-science-quality-and-integrity/scientific-integrity


