#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/

library(shiny)
library(shinythemes)
library(shinyFiles)
library(shinyalert)
library(shinyjs)


###########################
## Create User Interface ##
###########################

ui = fluidPage(
  
  titlePanel("Jeopardy Board Maker"),
  
  sidebarLayout(
    
    sidebarPanel(
      textOutput("gameNameText"), 
      shinyFilesButton("inputFile", "Select a game",
                       "Please select a game file", 
                       multiple=FALSE),
      selectInput("AQSeparator", "Separator between Answer and Question",
                   choices=c("|", "/", "\\", "&"), selected="|", selectize=TRUE), 
      actionButton("Save", "Save Current Jeopardy Board"),
      actionButton("quitApp", "Quit Jeopardy")
    ),  # end sidebarPanel
    
    mainPanel(
    )  # end mainPanel()    )
  )  # end sidebarLayout()
)  # end fluidPage()

