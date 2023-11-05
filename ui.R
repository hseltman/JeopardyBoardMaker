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
      actionButton("quitApp", "Quit Jeopardy Board Maker")
    ),  # end sidebarPanel
    
    mainPanel(
      radioButtons("gameStage", "Game stage:", 
                   choices=c("Jeopardy", "Double Jeopardy", "Final Jeopardy"),
                   selected="Jeopardy", inline=TRUE),
      radioButtons("categoryNum", "Category", choices=1:6, inline=TRUE),
      textInput("categoryName", "Category Name: ", emptyGameData$sjCategories[1]),
      tags$head(tags$style(type="text/css", "#categoryName {width: 750px}")),
      hidden(tags$div(fluidRow(column(width=6, textInput("fjAnswer", "Answer:")),
                               column(width=6, textInput("fjQuestion", "Question:"))
                               ),  # end fluidRow()
                      id="oneQA") # end tags$div
             ),
      tags$head(tags$style(type="text/css", "#fjAnswer {width: 350px}")),
      tags$head(tags$style(type="text/css", "#fjQuestion {width: 350px}")),
      tags$div(fluidRow(column(width=6, tags$b("Answer")),
                        column(width=6, tags$b("Question"))),
               fluidRow(column(width=6, textInput("jA1", NULL)),
                        column(width=6, textInput("jQ1", NULL))),
               fluidRow(column(width=6, textInput("jA2", NULL)),
                        column(width=6, textInput("jQ2", NULL))),
               fluidRow(column(width=6, textInput("jA3", NULL)),
                        column(width=6, textInput("jQ3", NULL))),
               fluidRow(column(width=6, textInput("jA4", NULL)),
                        column(width=6, textInput("jQ4", NULL))),
               fluidRow(column(width=6, textInput("jA5", NULL)),
                        column(width=6, textInput("jQ5", NULL))),
               id="sixQAs"),  # end tags$div()
      fluidRow(tags$b("Completion Status")),
      fluidRow(column(width=2, tags$b("Jeopardy:", class="rj")),
               column(width=2, textOutput("sjComplete")),
               column(width=2, tags$b("Double Jeopardy:", class="rj")),
               column(width=2, textOutput("djComplete")),
               column(width=2, tags$b("Final Jeopardy:", class="rj")),
               column(width=2, textOutput("fjComplete"))),
      tags$head(tags$style(type="text/css", ".rj {text-align: right}")),
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

