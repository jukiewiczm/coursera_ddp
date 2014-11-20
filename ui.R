library(shiny)
extract_help <- function(pkg, fn = NULL, to = c("txt", "html", "latex", "ex"))
{
        ## this function is from
        ## http://stackoverflow.com/questions/9192589/how-can-i-extract-text-from-rs-help-command
        to <- match.arg(to)
        rdbfile <- file.path(find.package(pkg), "help", pkg)
        rdb <- tools:::fetchRdDB(rdbfile, key = fn)
        convertor <- switch(to, 
                            txt   = tools::Rd2txt, 
                            html  = tools::Rd2HTML, 
                            latex = tools::Rd2latex, 
                            ex    = tools::Rd2ex
        )
        f <- function(x) capture.output(convertor(x))
        if(is.null(fn)) lapply(rdb, f) else f(rdb)
}

shinyUI(
        navbarPage(
                "Developing Data Products (Coursera.org)",
                tabPanel("Home",
                         sidebarLayout(
                                 sidebarPanel(
                                         selectInput("outcome", "Choose outcome variable", 
                                                     names(mtcars)),
                                         selectInput("regressor", "Choose regressor variable", 
                                                     names(mtcars)),
                                         actionButton("drawButton", "Draw plot & regression line!"),
                                         width = 3
                                 ),
                                 mainPanel(
                                         h3("Motor Trend Cars Linear Regression Application"),
                                         p(paste0("This application draws a scatter plot and",
                                                  " a regression line between the two user-chosen",
                                                  " aspects of automobile design/performance using",
                                                  " Motor Trend Car Road Tests data.",
                                                  " It also allows user to predict the outcome of",
                                                  " chosen aspect given the inserted regressor value.")),
                                         p(paste0("If you have any problems with using the application",
                                                  " or want more information about the data set it",
                                                  " operates on, refer to the documentation tab.")),
                                         conditionalPanel(
                                                 "input.drawButton",
                                                 wellPanel(
                                                         p(textOutput("choiceMessage"))
                                                 )
                                         ),
                                         plotOutput("regplot"),
                                         conditionalPanel(
                                                 "input.drawButton",
                                                 wellPanel(
                                                         p(paste0("Predict the outcome", 
                                                                  " for your value of choice.")),
                                                         numericInput("predictionInput", 
                                                                      'Predict for value of:', 
                                                                      0,
                                                                      step = 0.01),
                                                         actionButton("predictButton", "Predict!"),
                                                         p("Result:",
                                                           textOutput("predictionOutput"))
                                                 )
                                         )
                                 )
                         )
                ),
                tabPanel("Documentation",
                         h3("Application documentation"),
                         p(paste0("To start using the application, you need to",
                                  " choose two car aspects from the select inputs.",
                                  " After that, you're ready to click the 'Draw",
                                  " plot & regression line!' button. The scatter",
                                  " plot of relationship between two car aspects",
                                  " and a regression line (describing their ",
                                  " computed linear relationship) will then be drawn.")),
                         p(paste0("If you're unfamiliar with linear regression",
                                  " subject, refer to the Wikipedia page for alot",
                                  " of details. Briefly speaking, the car aspects",
                                  " you choose are used to draw a straight line",
                                  " that describe the relationship of the car aspects",
                                  " as good as it possibly can using the data given", 
                                  " (the blue circles). The computed relationship is",
                                  " presented by the red line and it's interpreted as",
                                  " 'the value of the outcome given the value of the",
                                  " regressor'.")),
                         p(paste0("After drawing the plot, you can compute the outcome",
                                  " value given your regressor value of choice by inserting",
                                  " the regressor value in the numeric input and clicking the",
                                  " 'Predict!' button. You can insert any numeric value you",
                                  " want (including values not shown by the red line), but be",
                                  " aware that not every value can be reasonably interpreted.")),
                         p(paste0("Note: I'm aware that some car aspects available are categorical",
                                  " rather than numerical and should not be regressed this way,",
                                  " but this is just a sample application, therefore there is no",
                                  " urgency of absolute correctness.")),
                         h3("Dataset description"),
                         h5(paste0("Forgive me the format, this is a parsed",
                                   " copy of R's help(mtcars) command.")),
                         p(extract_help("datasets", "mtcars"))
                )
        )
        
)
