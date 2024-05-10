library(testthat)
library(shiny)
source("subset_rows.R")

test_that("rows are being randomly subset", {
  
  #subset_rows takes a reactive dataframe as an argument
  #so we make a reactive version of the iris dataset as our fake data
  reactiveIris <- reactive({iris})
  testServer(subset_rows_server, args = list(dataset = reactiveIris), {
    
    #set seed before changing the inputs to ensure the same results for random sampling of rows
    set.seed(1)
    #sample 20 rows from the dataset
    session$setInputs(sample_num = 20)
    
    set.seed(1)
    #the iris dataset has 150 rows so we sample 20 numbers from 1 to 150
    index_expected <- sample(1:150, size = 20, replace = FALSE)
    
    #expect same random subset of 20 numbers
    expect_equal(index(), index_expected)
    #expect the same rows to be selected
    expect_equal(dataset()[index(),], iris[index_expected,])
    
    #expect a change in sample_num to change the length of index
    session$setInputs(sample_num = 10)
    expect_length(index(), 10)
    
    #expect the button click to do nothing to the length but re-select the numbers
    set.seed(2)
    index_expected <- sample(1:150, size = 10, replace = FALSE)
    set.seed(2)
    session$setInputs(resample = 1)
    expect_length(index(), 10)
    expect_equal(index(), index_expected)
  })
})
