#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)

df <- read_delim("top_500.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Analyzing the Rolling Stones Top 500 Albums"),
             sidebarLayout(
               
               # Sidebar panel for inputs
               sidebarPanel(
                 selectInput("Year", "Select Year", 
                             choices = sort(df$Year), selected = "1955")
               ),
               
               # Main panel for displaying outputs
               mainPanel(
                 plotlyOutput(outputId = "plot")
                 
               )
             )    
    )
    

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$plot <- renderPlotly({
      df %>% 
        arrange(desc(Year)) %>%       
        filter(Year == input$Year) %>%
        ggplot(aes(`Album Name`, Position, fill = Artist, width = 0.5)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x=element_blank(),
              axis.ticks.x=element_blank())
    })
}
 
# Run the application 
shinyApp(ui = ui, server = server)