library(shiny)
shinyServer(
        function(input, output) {
                output$regplot <- renderPlot({
                        if (input$drawButton) {
                                isolate({
                                        outcomeName <- input$outcome
                                        regressorName <- input$regressor
                                })
                                output$choiceMessage <- 
                                        renderText(c("You've chosen to draw ", 
                                                     outcomeName,
                                                     "according to ",
                                                     regressorName,
                                                     "."))
                                outcome <- mtcars[, outcomeName]
                                regressor <- mtcars[, regressorName]
                                fit <- lm(outcome ~ regressor)
                                plot(regressor, outcome, 
                                     type = "p",
                                     col = "blue",
                                     xlab = regressorName,
                                     ylab = outcomeName,
                                     main = paste("Plot & regression line for",
                                                  outcomeName,
                                                  "according to",
                                                  regressorName))
                                abline(fit, col = "red", lwd = 2)
                                legend("topright", 
                                       legend = c("data points", "regression line"),
                                       col = c("blue", "red"),
                                       pch = c(1,NA),
                                       lwd = c(NA, 2),
                                       lty = c(NA, 1))
                        }
                        
                        if (input$predictButton) {
                                pred <- isolate(data.frame(regressor = input$predictionInput))
                                result <- predict(fit, pred)
                                output$predictionOutput <- renderText(result)
                        }
                })
        }
)

