library(shiny)
shinyServer(function(input, output) {
    USArrests$Murdersp <- ifelse(USArrests$Murder - 10 > 0, 
                                 USArrests$Murder - 10, 0)
    model1 <- lm(UrbanPop ~ Murder, data = USArrests)
    model2 <- lm(UrbanPop ~ Murdersp + Murder, data = USArrests)
    
    model1pred <- reactive({
        crimeInput <- input$sliderCrime
        predict(model1, newdata = data.frame(Murder = crimeInput))
    })
    
    model2pred <- reactive({
        crimeInput <- input$sliderCrime
        predict(model2, newdata = data.frame(Murder = crimeInput,
                                             Murdersp = ifelse(crimeInput -  10 > 0,
                                                               crimeInput - 10, 0)))
    })
    
    output$plot1 <- renderPlot ({
        crimeInput <- input$sliderCrime
        
        plot(USArrests$Murder, USArrests$UrbanPop, xlab = "Murder Arrests (per 100,000)",
             ylab = "Urban Population Percentage", bty = "n", pch = 16,
             xlim = c(0,20), ylim = c(30, 95))
        
        if(input$showModel1){
            abline(model1, col = "red", lwd = 2)
        }
        
        if(input$showModel2){
            model2lines <- predict(model2, newdata = data.frame(Murder = 0:20,
                                                                Murdersp = ifelse(0:20 - 10 > 0,
                                                                                  0:20 - 10, 0)))
            lines(0:20, model2lines, col = "blue", lwd = 2)
        }
        
        
        points(crimeInput, model1pred(), col = "red", pch = 16, cex = 2)
        points(crimeInput, model2pred(), col = "blue", pch = 16, cex = 2)
        
        legend("topright", c("Model 1 Prediction", "Model 2 Prediction"), pch = 16,
               col = c("red", "blue"), bty = "n", cex = 1.2)
    })
    
    output$pred1 <- renderText({
        model1pred()
    })
    
    output$pred2 <- renderText({
        model2pred()
    })
    
    output$doc <- renderText({
        "This Shiny app uses a linear regression model to predict the Urban Population
        percentage based on the number of Murder Arrests per 100,000 for each of the 50
        US states in 1973. The data is from the R dataset 'USArrests'. Model 1 is a normal 
        linear regression model with Murder Rate as the regressor and Urban Population as
        the regressand. Model 2 is a linear regression model with an added spline term at 
        a Murder Rate of 10 so that we can have a broken stick graph. Use the slider bar
        to choose a murder rate from 0 to 20. The two check boxes will show/hide the 
        regression line from the models."
    })
})