library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
    titlePanel(h3("kmeans clustering")),
    
    sidebarLayout(
        sidebarPanel(
            
            selectInput("dist", label = h4("Distribution"), 
                        choices = c("runif", "rnorm", "rbinom","rpois")
                                    , selected = "runif"),
            conditionalPanel(
                condition = "input.dist == 'rpois'",
                numericInput("lambda", 
                    label = h6("Lambda"), 
                    value = 5)  
            ),
            
            conditionalPanel(
                condition = "input.dist == 'rbinom'",
                splitLayout(
                    numericInput("size", 
                        label = h6("Size"), 
                        value = 10),
                    numericInput("prob", 
                        label = h6("Prob"), 
                        value = 0.5)
                )
            ),    
            
            conditionalPanel(
                condition = "input.dist == 'runif'",
                splitLayout(
                    numericInput("xmin", 
                        label = h6("Min.X"), 
                        value = 40),  
                    numericInput("xmax", 
                        label = h6("Max.X"), 
                        value = 200),
                    numericInput("ymin", 
                        label = h6("Min.Y"), 
                        value = 0),
                    numericInput("ymax", 
                        label = h6("Max.Y"), 
                        value = 100)     
                )    
            ),
            
            conditionalPanel(
                condition = "input.dist == 'rnorm'",
                splitLayout(
                    numericInput("xmean", 
                        label = h6("Mean.X"), 
                        value = 15),  
                    numericInput("xsd", 
                        label = h6("Sd.X"), 
                        value = 10),
                    numericInput("ymean", 
                        label = h6("Mean.Y"), 
                        value = 0),
                    numericInput("ysd", 
                        label = h6("Sd.Y"), 
                        value = 1)
                )
            ),
            
            sliderInput("obs",
                        h4("Number of observations:"),
                        min = 10,
                        max = 1000,
                        value = 500),
            
                                         
            h4("K-Means"),
            splitLayout(
                numericInput("itermax", 
                    label = h6("iter.max"), 
                    value = 10),  
                numericInput("nstart", 
                    label = h6("nstart"),
                    value = 1),
                numericInput("centr", 
                    label = h6("centers"), 
                    value = 4)
            ),
            
            sliderInput("clusters",
                        h4("Elbow method (n clusters)"),
                        min = 2,
                        max = 20,
                        value = 10),
            
            submitButton("Submit")
        ),
        
        mainPanel(
            tabsetPanel(type = "tabs", 
                tabPanel("KMeans",plotOutput("kmeansPlot")),
                tabPanel("Elbow",plotOutput("elbowPlot"))                
            )
        )
    )
))