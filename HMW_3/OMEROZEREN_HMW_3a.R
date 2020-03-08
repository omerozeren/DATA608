# Question 1:
# As a researcher, you frequently compare mortality rates from particular causes 
# across different States. You need a visualization that will let you see 
# (for 2010 only) the crude mortality rate, across all States, from one cause 
# (for example, Neoplasms, which are effectively cancers). Create a visualization 
# that allows you to rank States by crude mortality for each cause of death.

library(rsconnect)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

df<-read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv")
head(df)
str(df)
df$Year<-as.factor(df$Year)


ui<-fluidPage(
  titlePanel(h4("Q1: Mortality Rate By States By Causes (year 2010)", align = 'center')),
  sidebarPanel(
    selectInput("disease", "Select Disease", choices = unique(df$ICD.Chapter))
  ),
  mainPanel(
    plotOutput('plot1')
  )
)


server<-shinyServer(function (input, output){
  
  output$plot1 <- renderPlot({
    
    selectedData <- df %>%
      filter(Year=="2010", ICD.Chapter == input$disease)
    
    ggplot(selectedData, aes(x=reorder(State,Crude.Rate), y=Crude.Rate)) +
      geom_bar(stat="identity")+
      geom_col(aes(fill = Crude.Rate)) +
      geom_point(size=0.5, colour = "steelblue") +
      scale_fill_gradient2(low = "white", high = "steelblue") +
      theme_bw()+
      coord_flip() +
      theme(text = element_text(size = 9, color = "black")) +
      ggtitle ("Crude Mortality Rate By States (year 2010)") + ylab("Crude Mortality Rate") +
      theme(axis.title.y=element_blank()) +
      theme(legend.position="none")
    
  }
  )
  
}
)

shinyApp(ui = ui, server = server)
