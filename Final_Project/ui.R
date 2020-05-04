library(rsconnect)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinythemes)

df<-read.csv("https://raw.githubusercontent.com/olgashiligin/data608/master/final_project/master.csv")
head(df)
str(df)
df$year<-as.factor(df$year)

shinyUI(navbarPage(title = "Analysis Of Suicide Rate Among Different Cohorts Globally",
                   theme = shinytheme("lumen"),
                   # first tab to display project info of the project markdown file
                   tabPanel("Project Information",
                            fluidPage(
                              includeMarkdown("project_information.Rmd"))),
                   # next tab to the right contains sidebar with controls and chart 
                   tabPanel("GDP vs Suicide Rate",
                            
                            fluidPage(   # this left side panel consists of two panels either of which is visible depending on selected sub tab of the main panel on the right
                              sidebarPanel(
                                # this panel contains chart controls
                                conditionalPanel(condition="input.gdppanels==1",
                                                 selectInput(inputId="selectedCountry", label="Select Country", choices=unique(df$country), selected="Albania")
                                ),
                                # empty panel, tags$style added to ovewrite shiny's default and make the panel invisible
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
                   
                   # next tab contains sidebar panel on its left and main panel taking the rest of the page
                   tabPanel("Dynamic Profile Of Suicides",
                            # left side
                            sidebarLayout(
                              sidebarPanel(
                                # chart controls
                                selectInput(inputId="cntry", label="Select Country", choices=unique(df$country), selected="Albania")
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
                   # similar to the above, displaying input data used. Because of size of the data, it takes a while for the page content to load up
                   tabPanel("Data Page", tableOutput("data")),
                   
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