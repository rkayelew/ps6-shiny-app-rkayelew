library(shiny)
library(tidyverse)
library(plotly)

df <- read_delim("top_500.csv")

ui <- navbarPage("Analyzing the Rolling Stone's 500 Greatest Albums of All Time",
  tabPanel("About",
          p("This Shiny webpage provides an interactive display of the",
          a("Rolling Stone's 500 Greatest Albums of All Time",
          href= "https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/"),
          "from the years 1955-2019."),
          p("My chosen data frame provides information about the", em("artist, album name, label, critic, position, and year"),
          "for each respective album. Users can interact with the data to find the highest rated albums by year, and by record label."),
          img(src = "https://media2.fdncms.com/inlander/imager/u/original/20373104/rollingstonetop10.jpg", width = "600px", height = "400px")
  ),
  tabPanel("Best Albums by Year: Plot",
           sidebarLayout(
             sidebarPanel(
               selectInput("Year", "Select Year", 
                           choices = sort(df$Year), selected = "1955"),
               radioButtons("Color", "Select Color",
                            choices = c("red", "blue", "black"),
                            selected = "red")
             ),
             mainPanel(
               plotlyOutput(outputId = "plot"),
               textOutput("page_one_text")
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
      ggplot(aes(`Album Name`, Position, fill = Artist)) +
      geom_bar(color = input$Color, width = 0.5, stat = "identity") +
      labs(title=paste("Albums represented from the year,",input$Year)) +
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank())
  })
  best_album <- reactive({
    df %>% 
      filter(Year == input$Year) %>% 
      filter(Position == min(Position)) %>% 
      select(`Album Name`)
  })
  album_rank <- reactive({
    df %>% 
      filter(Year == input$Year) %>% 
      filter(Position == min(Position)) %>% 
      select(Position)
  })
  output$page_one_text <- renderText({
      paste("The best album from the year",input$Year,"is",best_album(),". This album is ranked ",album_rank(),"out of 500.")
  })
  output$table <- renderTable({
    df %>% 
      filter(Label == input$Label) %>% 
      select(Artist, `Album Name`, Position, Critic) %>% 
      arrange(Position)
  })
}

shinyApp(ui = ui, server = server)