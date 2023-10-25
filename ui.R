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
    
    sidebarPanel(width=3,
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
      radioButtons("gameStage", "Game stage:", 
                   choices=c("Jeopardy", "Double Jeopardy", "Final Jeopardy"),
                   selected="Jeopardy", inline=TRUE),
      radioButtons("categoryNum", "Category", choices=1:6, selected="1",
                   inline=TRUE),
      textInput("categoryName", "Category Name: "),
      tags$head(tags$style(type="text/css", "#categoryName {width: 750px}")),
      hidden(tags$div(fluidRow(column(width=6, textInput("fjAnswer", "Answer:")),
                               column(width=6, textInput("fjQuestion", "Question:"))
                               ),  # end fluidRow()
                      id="oneQA") # end tags$div
             ),
      tags$head(tags$style(type="text/css", "#fjAnswer {width: 350px}")),
      tags$head(tags$style(type="text/css", "#fjQuestion {width: 350px}")),
      tags$div(fluidRow(column(width=6,
                               tags$b("Answer"),
                               textInput("jA1", NULL),
                               textInput("jA2", NULL),
                               textInput("jA3", NULL),
                               textInput("jA4", NULL),
                               textInput("jA5", NULL)),
                        column(width=6,
                               tags$b("Question"),
                               textInput("jQ1", NULL),
                               textInput("jQ2", NULL),
                               textInput("jQ3", NULL),
                               textInput("jQ4", NULL),
                               textInput("jQ5", NULL))
              ),  # end fluidRow()
              id="sixQAs"),  # end tags$div()
      tags$head(tags$style(type="text/css", "#jA1 {width: 350px}"),
                tags$style(type="text/css", "#jA2 {width: 350px}"),
                tags$style(type="text/css", "#jA3 {width: 350px}"),
                tags$style(type="text/css", "#jA4 {width: 350px}"),
                tags$style(type="text/css", "#jA5 {width: 350px}"),
                tags$style(type="text/css", "#jQ1 {width: 350px}"),
                tags$style(type="text/css", "#jQ2 {width: 350px}"),
                tags$style(type="text/css", "#jQ3 {width: 350px}"),
                tags$style(type="text/css", "#jQ4 {width: 350px}"),
                tags$style(type="text/css", "#jQ5 {width: 350px}")
      ),
      
    )  # end mainPanel()
  )  # end sidebarLayout()
)  # end fluidPage()

