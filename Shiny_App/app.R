library(shiny)
library(tidyverse)
library(plotly)

df <- read_delim("top_500.csv")

# Define UI for application that draws a histogram
ui <- navbarPage("Analyzing the Rolling Stones Top 500 Albums",
  # Application title
  tabPanel("Top 10 Countries by Population",
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
  ),    
  tabPanel("Top 10 Countries by Population",
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

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- renderPlotly({
    df %>% 
      filter(Year == input$Year) %>%
      ggplot(aes(`Album Name`, Position, fill = Artist, width = 0.5)) +
      geom_bar(stat = "identity") +
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank())
  })
  output$table <- renderTable({
    df %>% 
      filter(Label == input$Label) %>% 
      select(Year, Artist, `Album Name`, Position, Critic) %>% 
      arrange(Position)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)