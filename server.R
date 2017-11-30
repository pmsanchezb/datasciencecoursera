#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(
  function(input, output) {
    output$text1 <- renderText({(as.numeric(input$text1)-32)*5/9})
    output$text2 <- renderText({(as.numeric(input$text2)*9/5)+32})
    output$plot1 <- renderPlot({
      pf <- c(input$`Slider Temperature`,(as.numeric(input$`Slider Temperature`)*9/5+32))
      curve(x*(9/5)+32, from=1, to=50,xlab="Celsius", ylab="Farenheit",
            main = "Farenheit - Celsius",lwd=2);grid()
      points(t(pf), pch=19,col="blue",cex=3)
      
    })
  }
)
