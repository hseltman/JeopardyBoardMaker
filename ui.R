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
  useShinyjs(),
  titlePanel("Jeopardy Board Maker"),
  
  sidebarLayout(
    
    sidebarPanel(
      radioButtons("newOrOld", "New or old game?", choices=c("New Game", "Old Game"),
                   selected="New Game", inline=TRUE),
      fluidRow(tags$div("Filename: ", textOutput("gameNameText"))),
      textInput("newName", "Name the new file:"),
      hidden(shinyFilesButton("oldFile", "Select an existing game",
                              "Please select a game file", 
                              multiple=FALSE)),
      selectInput("AQSeparator", "Separator between Answer and Question",
                   choices=c("|", "/", "\\", "&"), selected="|", selectize=TRUE), 
      actionButton("Save", "Save Current Jeopardy Board"),
      actionButton("quitApp", "Quit Jeopardy")
    ),  # end sidebarPanel
    
    mainPanel(
      
    )  # end mainPanel()
  )  # end sidebarLayout()
)  # end fluidPage()

