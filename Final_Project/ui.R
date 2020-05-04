library(rsconnect)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinythemes)

df<-read.csv("https://raw.githubusercontent.com/omerozeren/DATA608/master/Final_Project/master.csv")
head(df)
str(df)
df$year<-as.factor(df$year)

shinyUI(navbarPage(title = "Suicide Rate  Correlation Relationship",
                   theme = shinytheme("lumen"),
                   # Upload introduction rmd file
                   tabPanel("Project Introduction",
                            fluidPage(
                              includeMarkdown("introduction.Rmd"))),
                   tabPanel("GDP vs Suicide Rate",
                            
                            fluidPage(
                              sidebarPanel(
                                # this panel contains chart controls
                                conditionalPanel(condition="input.gdppanels==1",
                                                 selectInput(inputId="selectedCountry", label="Select Country", choices=unique(df$country), selected="United States")
                                ),

                                conditionalPanel(tags$style(".well {background-color:white; border:none; box-shadow:none}"), condition="input.gdppanels==2")
                              ),
                              mainPanel(
                                # two sub tabs, selection of each of these defines what conditional panels above to be visible
                                tabsetPanel(
                                  tabPanel("GDP vs Suiside Rate: By Country", value=1, plotlyOutput('GdpVsSuicide')),
                                  tabPanel("GDP vs Suiside Rate: Total", value=2, plotlyOutput('GdpVsSuicideTotal')),
                                  id = "gdppanels"
                                )
                              )
                            )
                            
                   ),
                   
                   tabPanel("Suicides Profile",
                            # left side
                            sidebarLayout(
                              sidebarPanel(
                                # chart controls
                                selectInput(inputId="cntry", label="Select Country", choices=unique(df$country), selected="United States")
                              ),
                              # main panel
                              mainPanel(plotlyOutput('bygender'))
                            )
                   ),
                   # this page has a single page
                   tabPanel("Suicide Rate Geo Map",
                            fluidPage(
                              plotlyOutput('geomap')
                            )
                   ),
                   tabPanel("Data", tableOutput("data")),
                   
                   # tags$style-s below is to overwrite shiny default colours
                   tags$style(
                     type = 'text/css',
                     HTML('
                          .navbar{background-color: #337ab7; border-color: #2e6da4}
                          ')),
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-default .navbar-brand {color: white; }
                                ')),
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-default .navbar-nav>li>a {color: white; }
                                ')),
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-default .navbar-nav>.active>a, .navbar-default .navbar-nav>.active>a:focus, .navbar-default .navbar-nav>.active>a:hover {color: black; }
                                ')),
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-default .navbar-nav>li>a:hover {color: #2299D4;}
                                ')),
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-header .navbar-brand:hover {color: #2299D4;}
                                ')),
                   
                   
                   tags$style(
                     type = 'text/css',
                     HTML('
                                   .navbar-default .navbar-nav>.active>a, .navbar-default .navbar-nav, .navbar-default .navbar-nav>a:hover {color: black; }
                                '))
                   
                   
                   
                   
                     ))