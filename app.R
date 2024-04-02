#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)

# Dummy data
data <- data.frame(
  Nationality = c("Jewish", "Polish", "Soviet POW", "Romani", "Other"),
  Number = c(1000000, 70000, 70000, 14000, 12000)
)

# Define UI
ui <- fluidPage(
  titlePanel("victims killed at Auschwitz concentration camp"),
  sidebarLayout(
    sidebarPanel(
      selectInput("group", "Select Group:",
                  choices = c("All", unique(data$Nationality)))
    ),
    mainPanel(
      plotOutput("barplot"),
      dataTableOutput("table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$barplot <- renderPlot({
    filtered_data <- switch(input$group,
                            "All" = data,
                            data[data$Nationality == input$group, ])
    ggplot(filtered_data, aes(x = Nationality, y = Number, fill = Nationality)) +
      geom_bar(stat = "identity") +
      labs(title = "Number of Holocaust Victims by Nationality",
           x = "Nationality",
           y = "Number of Victims") +
      theme_minimal()
  })
  
  output$table <- renderDataTable({
    filtered_data <- switch(input$group,
                            "All" = data,
                            data[data$Nationality == input$group, ])
    filtered_data
  })
}

# Run the application
shinyApp(ui = ui, server = server)
