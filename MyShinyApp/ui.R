library(shiny)
shinyUI(fluidPage(
    titlePanel("Predict Urban Population Percentage from Murder Rate"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderCrime", "What is the murder rate?", 0, 20, value = 10),
            checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
            checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
            submitButton("Submit")
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Plot", plotOutput("plot1"),
                                 h3("Predicted Urban Population from Model 1:"),
                                 textOutput("pred1"),
                                 br(),
                                 h3("Predicted Urban Population from Model 2:"),
                                 textOutput("pred2")),
                        tabPanel("Documentation", textOutput("doc")))
        )
    )
))