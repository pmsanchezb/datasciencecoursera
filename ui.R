#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Metric converter"),
  sidebarPanel(
    textInput(inputId="text1", label = "Farenheit"),
    textInput(inputId="text2", label = "Celsius"),
    sliderInput("Slider Temperature","Pick a value for celsius degrees",
                0,50,value = c(32)),
    submitButton("Convert!")
  ),
  mainPanel(
    p('Farenheit to Celsius'),
    textOutput('text1'),
    p('Celsius to Farenheit'),
    textOutput('text2'),
    p(''),
    plotOutput("plot1")
  )
))
