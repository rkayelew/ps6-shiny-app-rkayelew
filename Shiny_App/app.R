library(shiny)
library(tidyverse)
library(plotly)
library(shinythemes)

df <- read_delim("top_500.csv")

ui <- navbarPage("Analyzing the Rolling Stone's 500 Greatest Albums of All Time",
  tabPanel("About",
          sidebarLayout(
            sidebarPanel(
              p("This Shiny app provides an interactive display of the", em(a("Rolling Stone's 500 Greatest Albums of All Time",
              href= "https://www.rollingstone.com/music/music-lists/best-albums-of-all-time-1062063/")), "from the years 1955-2019."),
              p("My chosen data frame, which I accessed from", strong("Kaggle"), ", provides information about the", 
              em("position, artist, album name, label, year, and critic"),"for each respective album."),
              p("Users can observe the highest rated albums by year, displayed as a bar graph, and by record label, displayed as a table."),
              img(src = "https://media2.fdncms.com/inlander/imager/u/original/20373104/rollingstonetop10.jpg", width = "400px", height = "250px"),              
            ),
            mainPanel(
              h4("Random Sample of 3 Rows of Data"),
              tableOutput("figure")
            )
          )
  ),
  tabPanel("Best Albums by Year: Plot",
           sidebarLayout(
             sidebarPanel(
               selectInput("Year", "Select Year", 
                           choices = sort(df$Year), selected = "1955"),
               radioButtons("Border_Color", "Select Border_Color",
                            choices = c("red", "blue", "black"),
                            selected = "red")
             ),
             mainPanel(
               plotlyOutput(outputId = "plot"),
               textOutput("page_one_text")
             )
           )
  ),    
  tabPanel("Best Albums by Record Label: Table",
           sidebarLayout(
             sidebarPanel(
               radioButtons("Label", "Select Label",
                            choices = unique(df$Label))
             ),
             mainPanel(
               textOutput("page_two_text_pt1"),
               textOutput("page_two_text_pt2"),
               tableOutput("table")
             )
           )
  ),
  theme = shinytheme("united"),
)

server <- function(input, output) {
  output$figure <- renderTable({
    df %>% 
      sample_n(3)
  }, digits = 0)
  output$plot <- renderPlotly({
  df %>% 
      filter(Year == input$Year) %>%
      ggplot(aes(`Album Name`, Position, fill = Artist)) +
      geom_bar(color = input$Border_Color, width = 0.5, stat = "identity") +
      labs(y = "Rank", title=paste0("Albums represented from the year, ",input$Year)) +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
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
  
  artist_name <- reactive({
    df %>% 
      filter(Year == input$Year) %>% 
      filter(Position == min(Position)) %>% 
      select(Artist)
  })
  
  output$page_one_text <- renderText({
      paste0("The highest rated album from the year ",input$Year," is ",best_album()," by ",artist_name(),
            ". This album is ranked ",album_rank()," out of 500.")
  })
  
  output$table <- renderTable({
    df %>% 
      filter(Label == input$Label) %>% 
      select(Year, Artist, `Album Name`, Position, Critic) %>% 
      arrange(Position)
  }, digits = 0)
  
  average_ranking <- reactive({
    df %>% 
      filter(Label == input$Label) %>% 
      mutate(average = round(mean(Position), 2)) %>% 
      distinct(average) %>% 
      select(average)
  })
  
  output$page_two_text_pt1 <- renderText({
    paste0(input$Label," has an average ranking of ",average_ranking(),".")
  })
  
  output$page_two_text_pt2 <- renderText({
    if(average_ranking() > 100) {
      paste0("This label is not very impressive.")
    } else {
      paste0("This label is very impressive!")
    }
  })
}
shinyApp(ui = ui, server = server)