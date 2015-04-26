library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    
    df <- reactive({
        switch(input$dist,
        "runif"={ x <- runif(input$obs,min=input$xmin, max=input$xmax) 
                  y <- runif(input$obs,min=input$ymin, max=input$ymax) },
        "rnorm"={ x <- rnorm(input$obs,mean=input$xmean, sd=input$xsd) 
                  y <- rnorm(input$obs,mean=input$ymean, sd=input$ysd) },
        "rbinom"={ x <- rbinom(input$obs, size=input$size,prob=input$prob) 
                   y <- rbinom(input$obs, size=input$size,prob=input$prob) },
        "rpois"={ x <- rpois(input$obs, lambda=input$lambda) 
                  y <- rpois(input$obs, lambda=input$lambda) },
        )
        data.frame(x=x,y=y)
    })
    
    kl <- reactive({
        d <- df()
        kmeans(d, centers=input$centr, iter.max=input$itermax, 
                nstart=input$nstart)            
    })
    
    output$elbowPlot <- renderPlot({
        d <- df()
        wss <- (nrow(d)-1)*sum(apply(d,2,var))
        for (i in 2:input$clusters) wss[i] <- sum(kmeans(d,centers=i)$withinss)
        plot(1:input$clusters, wss, type="b", xlab="Number of Clusters",
             ylab="Within groups sum of squares")
    })
    
    output$kmeansPlot <- renderPlot({
        data <- df()
        klust <- kl()
        data$cluster <- factor(klust$cluster)       
        g <- ggplot(data, aes(x,y, color=cluster)) + geom_point()
        g
    })
    
})