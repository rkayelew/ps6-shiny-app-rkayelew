# ps6-shiny-app-rkayelew

### Description of the data
This data is accessed from the **Kaggle** online database, and the data itself is gathered from Rolling Stone's 500 Greatest Albums of All Time.
As the name of the lsit suggests, there are 500 rows, one for each album represented on the list. This dataset has six variables, or columns, those being, *Artist, Album Name, Label, Critic, Position, and Year.* Position and Year are of type double and the other variables are of type char. This dataset was relatively simple to manipulate which made plotting and analyzing more straight forward. I used the packages shiny, tidyverse, plotly, and shinythemes to help produce my Shiny app. 

### Widgets and Panels

#### Plot
On page two of my Shiny app, there is an interactive bar graph plot that is controlled by user input using two widgets. The page layout
is split between a side panel, which contains the widgets, and main panel, which contains the plot and text output, which changes from user input.
The first widget, *selectInput()*, allows the user to choose which year the data will represent on the plot. Each year corresponds to unique albums rated aspart of the top 500. The second widget I made use of for this page, *radioButtons()*, allows the user to adjust the border color of the bars displayed
on the plot. I decided against changing the "fill =" of my bar graph as I wanted the fill color to be based on *Artist*. Additionally, as 
outlined in the instructions, I used reactives in order to have *renderText()* and *textOutput()* produce textual output based on user input with
the *selectInput()* widget. This text describes the highest ranked album from the selected year, and its ranking out of 500.

#### Table
On page three of my Shiny app, there is an interative table  that is controlled by user input using one widget. The page layout is split between a side
panel, which contains the widget, and main panel, which contains the table and text output. I used *radioButtons()* as a widget for this page. This widget
allows users to quickly cycle between different record labels in order to observe the changing data displayed on the table. When a record label is chosen
by selecting one of the radio buttons, the albums represented for the chosen label appear on the table, including the year they were released, the name
of the artist and album, the position of the album, and a critic of the album. I used reactives in order to have *renderText()* and *textOutput()* produce textual output based on the *radioButtons()* widget. This text describes the average ranking of the chosen record label and outputs
if the record label is "impressive", or "not very impressive", depending on if the average ranking is above or below 100.

##### Links
- [Shiny App](https://rkayelew.shinyapps.io/ps6_rkayelew/)
- [Dataset](https://www.kaggle.com/datasets/darthnox456/rolling-stones-500-greatest-albums-of-all-time)

> *This PS took me roughly 6-8 hours to complete*