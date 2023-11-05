#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyFiles)
library(shinyalert)
library(shinyjs)


# Define server logic required to draw a histogram
function(input, output, session) {
  #observe({cat("gameStage =", input$gameStage, "\n")})
  #observe({cat("categoryNum =", input$categoryNum, "\n")})
  
  # Startup code
  categoryNum <- reactiveVal(1)
  gameStage <- reactiveVal("Jeopardy")  # Previous value of input$gameStage
  gameData <- reactiveValues(sjCategories = emptyGameData$sjCategories,
                             djCategories = emptyGameData$djCategories,
                             fjCategory = emptyGameData$fjCategory,
                             sjAnswers = emptyGameData$sjAnswers,
                             sjQuestions = emptyGameData$sjQuestions,
                             djAnswers = emptyGameData$djAnswers,
                             djQuestions = emptyGameData$djQuestions,
                             fjAnswer = emptyGameData$fjAnswer,
                             fjQuestion = emptyGameData$jfQuestion) 
  output$sjComplete <- renderText(0)
  output$djComplete <- renderText(0)
  output$fjComplete <- renderText(0)

  # End the app
  observeEvent(input$quitApp, {stopApp()})
  gameName = reactiveVal(value="")
  
  # Old file selection
  shinyFileChoose(input, "oldFile", roots=roots, session=session, filetype="txt")
  observeEvent(input$oldFile, {
    gameName(basename(parseFilePaths(roots, input$oldFile)$datapath))
  })
  
  # Handle change from New to Old game or vice versa
  observeEvent(input$newOrOld, {
    gameName(NULL)
    if (input$newOrOld == "New Game") {
      hide("oldFile")
      show("newName")
    } else {
      hide("newName")
      show("oldFile")
    }
  })
  
  
  # Handle change of game stage
  observeEvent(input$gameStage, {
    catNum = as.numeric(input$categoryNum)
    # Store visible data based on prior game state
    if (gameStage() == "Jeopardy") {
      gameData$sjCategories[catNum] <- input$categoryName
      gameData$sjAnswers[, catNum] <- c(input$jA1, input$jA2, input$jA3,
                                        input$jA4, input$jA5)
      gameData$sjQuestions[, catNum] <- c(input$jQ1, input$jQ2, input$jQ3,
                                          input$jQ4, input$jQ5)
    } else if (gameStage() == "Double Jeopardy") {
      gameData$djCategories[catNum] <- input$categoryName
      gameData$djAnswers[, catNum] <- c(input$jA1, input$jA2, input$jA3,
                                        input$jA4, input$jA5)
      gameData$djQuestions[, catNum] <- c(input$jQ1, input$jQ2, input$jQ3,
                                          input$jQ4, input$jQ5)
    } else {  # gameStage() == "Final Jeopardy"
      gameData$fjCategory <- input$categoryName
      gameData$fjAnswer <- input$fjAnswer
      gameData$fjQuestion <- input$fjQuestion
    }  # end storing visible data based on prior game state
    
    # Fill in new data
    if (input$gameStage == "Final Jeopardy") {
      hide("sixQAs")
      show("oneQA")
      updateTextInput(session, "categoryName", value=gameData$fjCategory)
      updateTextInput(session, "fjAnswer", value=gameData$fjAnswer)
      updateTextInput(session, "fjQuestion", value=gameData$fjQuestion)
      gameStage("Final Jeopardy")
    } else if (input$gameStage == "Jeopardy") {  
      if (gameStage() == "Final Jeopardy") {
        hide("oneQA")
        show("sixQAs")
      }
      updateTextInput(session, "categoryName", value=gameData$sjCategories[catNum])
      updateTextInput(session, "jA1", value=gameData$sjAnswers[1, catNum])
      updateTextInput(session, "jA2", value=gameData$sjAnswers[2, catNum])
      updateTextInput(session, "jA3", value=gameData$sjAnswers[3, catNum])
      updateTextInput(session, "jA3", value=gameData$sjAnswers[4, catNum])
      updateTextInput(session, "jA5", value=gameData$sjAnswers[5, catNum])
      updateTextInput(session, "jQ1", value=gameData$sjQuestions[1, catNum])
      updateTextInput(session, "jQ2", value=gameData$sjQuestions[2, catNum])
      updateTextInput(session, "jQ3", value=gameData$sjQuestions[3, catNum])
      updateTextInput(session, "jQ4", value=gameData$sjQuestions[4, catNum])
      updateTextInput(session, "jQ5", value=gameData$sjQuestions[5, catNum])
      gameStage("Jeopardy")
    } else {  # switch to Double Jeopardy
      if (gameStage() == "Final Jeopardy") {
        hide("oneQA")
        show("sixQAs")
      }
      updateTextInput(session, "categoryName", value=gameData$djCategories[catNum])
      updateTextInput(session, "jA1", value=gameData$djAnswers[1, catNum])
      updateTextInput(session, "jA2", value=gameData$djAnswers[2, catNum])
      updateTextInput(session, "jA3", value=gameData$djAnswers[3, catNum])
      updateTextInput(session, "jA4", value=gameData$djAnswers[4, catNum])
      updateTextInput(session, "jA5", value=gameData$djAnswers[5, catNum])
      updateTextInput(session, "jQ1", value=gameData$djQuestions[1, catNum])
      updateTextInput(session, "jQ2", value=gameData$djQuestions[2, catNum])
      updateTextInput(session, "jQ3", value=gameData$djQuestions[3, catNum])
      updateTextInput(session, "jQ4", value=gameData$djQuestions[4, catNum])
      updateTextInput(session, "jQ5", value=gameData$djQuestions[5, catNum])
      gameStage("Double Jeopardy")
    }  # end filling in new data
  },  # end "handlerExpr"
  ignoreInit=TRUE)  # end observeEvent(input$gameStage) 
  
  # Handle change of game stage
  observeEvent(input$categoryNum, {
    ocn = categoryNum()  # old category number
    ncn = as.numeric(input$categoryNum)
    # Store visible data based on prior game state and category number
    if (gameStage() == "Jeopardy") {
      gameData$sjCategories[ocn] <- input$categoryName
      gameData$sjAnswers[, ocn] <- c(input$jA1, input$jA2, input$jA3,
                                        input$jA4, input$jA5)
      gameData$sjQuestions[, ocn] <- c(input$jQ1, input$jQ2, input$jQ3,
                                          input$jQ4, input$jQ5)
      updateTextInput(session, "categoryName", value=gameData$sjCategories[ncn])
      updateTextInput(session, "jA1", value=gameData$sjAnswers[1, ncn])
      updateTextInput(session, "jA2", value=gameData$sjAnswers[2, ncn])
      updateTextInput(session, "jA3", value=gameData$sjAnswers[3, ncn])
      updateTextInput(session, "jA4", value=gameData$sjAnswers[4, ncn])
      updateTextInput(session, "jA5", value=gameData$sjAnswers[5, ncn])
      updateTextInput(session, "jQ1", value=gameData$sjQuestions[1, ncn])
      updateTextInput(session, "jQ2", value=gameData$sjQuestions[2, ncn])
      updateTextInput(session, "jQ3", value=gameData$sjQuestions[3, ncn])
      updateTextInput(session, "jQ4", value=gameData$sjQuestions[4, ncn])
      updateTextInput(session, "jQ5", value=gameData$sjQuestions[5, ncn])
    } else if (gameStage() == "Double Jeopardy"){
      gameData$djCategories[ocn] <- input$categoryName
      gameData$djAnswers[, ocn] <- c(input$jA1, input$jA2, input$jA3,
                                     input$jA4, input$jA5)
      gameData$djQuestions[, ocn] <- c(input$jQ1, input$jQ2, input$jQ3,
                                       input$jQ4, input$jQ5)
      updateTextInput(session, "categoryName", value=gameData$djCategories[ncn])
      updateTextInput(session, "jA1", value=gameData$djAnswers[1, ncn])
      updateTextInput(session, "jA2", value=gameData$djAnswers[2, ncn])
      updateTextInput(session, "jA3", value=gameData$djAnswers[3, ncn])
      updateTextInput(session, "jA4", value=gameData$djAnswers[4, ncn])
      updateTextInput(session, "jA5", value=gameData$djAnswers[5, ncn])
      updateTextInput(session, "jQ1", value=gameData$djQuestions[1, ncn])
      updateTextInput(session, "jQ2", value=gameData$djQuestions[2, ncn])
      updateTextInput(session, "jQ3", value=gameData$djQuestions[3, ncn])
      updateTextInput(session, "jQ4", value=gameData$djQuestions[4, ncn])
      updateTextInput(session, "jQ5", value=gameData$djQuestions[5, ncn])
    }
    categoryNum(ncn)  # update old category number
  }, # end of change of category number
  ignoreInit=TRUE)  # end observeEvent(input$categoryNum)
  
  
  
  # observeEvent(input$newName, {
  #   cat("observe event newName\n")
  # })
  
  #gameName = reactive({
  #  req(input$inputFile)
  #  if (input$newOrOld == "New")
  #  parseFilePaths(roots, input$inputFile)$datapath
  #})
  
  # When input file name changes, read in new game board data
  loadData <- function() {
    req(gameName())
    fName = gameName()
    
    # read data and delete blank lines and comment lines
    inData = readLines(fName)
    inData = inData[!grepl("(^\\s*$)|(^\\s*#)", inData)]
    
    # Guess that user totally forgot data format
    if (length(inData) < 12) {
      shinyalert("Bad input",
                 paste0("File must contain 12 sets of 6 lines each ",
                       "(where line 1 is a Category Name, and lines ",
                       "2 to 5 are 'answer", input$AQSeparator, "question' pairs), ",
                       "followed by a Final Jeopardy Category, and then a Final ",
                       "Jeopardy 'answer", input$AQSeparator, "question' pair."),
                 type="error")
      return(NULL)
    } 
    
    # Find which lines have a single bar (or 'AQSeparator')
    singleBar = grepl(paste0("^([^", input$AQSeparator, "]+?)[", input$AQSeparator,
                             "]([^", input$AQSeparator, "]+)$"), inData)

    # Handle correct pattern
    if (length(singleBar) == length(sbPattern) && all(singleBar==sbPattern)) {
      sjCatLoc = seq(1, by=6, length.out=6)
      sjCategories = inData[sjCatLoc]
      djCatLoc = seq(37, by=6, length.out=6)
      djCategories = inData[djCatLoc]
      fjCategory = inData[73]
      tc = textConnection(inData[1:36][-sjCatLoc])
      sjAQ = read.table(tc, sep=input$AQSeparator, quote="",
                        col.names=c("Answer", "Question"))
      close(tc)
      tc = textConnection(inData[37:72][-sjCatLoc]) # [sic]
      djAQ = read.table(tc, sep=input$AQSeparator, quote="",
                        col.names=c("Answer", "Question"))
      close(tc)
      temp = strsplit(inData[74], input$AQSeparator)[[1]]
      fjAQ = data.frame(Answer=temp[1], Question=temp[2])
      return(list(sjCategories=sjCategories,
                  djCategories=djCategories,
                  fjCategory=fjCategory,
                  sjAQ=sjAQ,
                  djAQ=djAQ,
                  fjAQ=fjAQ))
    }
    
    # Handle first part of pattern not 'FTTTTTF'
    if (singleBar[1]) {
      shinyalert("Bad input",
                 paste0("First line of game file must contain a category name ",
                       "(no '", input$AQSeparator, "')."),
                 type="error")
      return(NULL)
    }
    if (!all(singleBar[2:6])) {
      shinyalert("Bad input",
                 paste0("Lines 2 to 6 of game file must contain 'answer",
                        input$AQSeparator, "question' pairs."),
                 type="error")
      return(NULL)
    }
    if (singleBar[7]) {
      shinyalert("Bad input",
                 paste0("Line 7 of game file must contain a category name (no '",
                        input$AQSeparator, "')."),
                 type="error")
      return(NULL)
    }
    
    # Use run length encoding to characterize pattern of categories and A|Q pairs
    catAQPair = rle(singleBar)
    temp = catAQPair$lengths[catAQPair$values==FALSE]
    if (length(temp) != 13) {
      shinyalert("Bad input",
                 paste("File must contain 6 Jeopardy Categories, 6 Double",
                       "Jeopardy Categories, and one Final Jeopary Category.",
                       "You have", length(temp), "categories."),
                 type="error")
      return(NULL)
    }
    if (any(temp != 1)) {
      index = which(temp != 1)[1]
      shinyalert("Bad input",
                 paste0("It appears that the '", input$AQSeparator,
                        "' is missing in 'Answer", input$AQSeparator, "Question' for",
                        " category number ", index, "."),
                 type="error")
      return(NULL)
    }
    temp = catAQPair$lengths[catAQPair$values==TRUE]
    if (length(temp) != 13) {
      shinyalert("Bad input",
                 paste0("File must contain 6 groups of 5 'Answer", input$AQSeparator,
                       "Question' pairs ",
                       "for Jeopardy, 6 groups of 5 'Answer", input$AQSeparator,
                       "Question' pairs for Double Jeopardy, and one Final ",
                       "Jeopary 'Answer", input$AQSeparator, "Question' pair ",
                       "for a total of 61 pairs.  ",
                       "You have", sum(temp), "pairs in ", length(temp), "groups."),
                 type="error")
      return(NULL)
    }
    if (temp[13] != 1) {
      shinyalert("Bad input",
                 paste0("There should be just one Final Jeopary 'Answer",
                 input$AQSeparator, "Question' pair."),
                 type="error")
      return(NULL)
    }
    if (any(temp[1:12] != 5)) {
      index = which(temp != 5)[1]
      shinyalert("Bad input",
                 paste0("Category ", index, " has ", temp[index], " 'Answer",
                 input$AQSeparator, "Question' pairs."),
                 type="error")
      return(NULL)
    }
    shinyalert("Bad input", "Unhandled exception", type="error")
    return(NULL)
  } # end definition of gameData() reactive function
  
  # Add headers to Jeopardy board
  # lapply(1:6, function(column) {
  #   outputId <- paste0("jbs", LETTERS[column])
  #   output[[outputId]] <- renderText(gameData()[["sjCategories"]][column])
  # })  
  

  # Show game board file
  output$gameNameText <- renderText({
    tName <- gameName()
    tName <- ifelse(isTruthy(tName), basename(tName), "None")
    paste("Game board file:", tName)
  })

  # output$categoryReminder <- renderText({"Nothing selected"})
  

} # end server function
