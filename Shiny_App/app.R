library(shiny)
library(tidyverse)
library(plotly)

df <- read_delim("top_500.csv")

ui <- navbarPage("Analyzing the Rolling Stone's 500 Greatest Albums of All Time",
  tabPanel("Best Albums by Year: Plot",
           sidebarLayout(
             sidebarPanel(
               selectInput("Year", "Select Year", 
                           choices = sort(df$Year), selected = "1955")
             ),
             mainPanel(
               plotlyOutput(outputId = "plot")
             )
           )
  ),    
  tabPanel("Best Albums by Label: Table",
           sidebarLayout(
             sidebarPanel(
               radioButtons("Label", "Select Label",
                                  choices = unique(df$Label))
             ),
             mainPanel(
               tableOutput("table")
             )
           )
  )
)

server <- function(input, output) {
  output$plot <- renderPlotly({
    df %>% 
      filter(Year == input$Year) %>%
      ggplot(aes(`Album Name`, Position, fill = `Album Name`, width = 0.5)) +
      geom_bar(stat = "identity") +
      labs(title=paste("Albums represented from the year,", input$Year)) +
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank())
  })
  output$table <- renderTable({
    df %>% 
      filter(Label == input$Label) %>% 
      select(Artist, `Album Name`, Position, Critic) %>% 
      arrange(Position)
  })
}

shinyApp(ui = ui, server = server)