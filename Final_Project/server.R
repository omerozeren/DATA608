library(rsconnect)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(countrycode)

shinyServer(function(input, output, session) {
  globaldf<-read.csv("https://raw.githubusercontent.com/omerozeren/DATA608/master/Final_Project/master.csv")
  
  
  output$data <- renderTable({
    globaldf
  })
  
  
  # preparing data 
  
  output$bygender <- renderPlotly({
    df<-globaldf
    df_q3<- df %>%
      group_by(year, age, sex, country) %>%
      dplyr::summarise(avg_rate = mean(suicides.100k.pop)) %>%
      arrange(year, desc(avg_rate)) %>%
      filter(country==input$cntry) %>%
      as.data.frame()
    df_q3$avg_rate<-as.integer(df_q3$avg_rate)
    df_q3$age <- as.character(df_q3$age)
    # renaming the value in order to get a right order of values on the xaxis
    df_q3$age[df_q3$age == "5-14 years"] <- "05-14 years"
    df_q3$age <- as.factor(df_q3$age)
    
    # creating  suicide profile graph
    
    df_q3 %>%
      plot_ly(
        x = ~age,
        y = ~avg_rate,
        color = ~sex,
        size = ~avg_rate,
        frame = ~year,
        text = ~sex,
        hoverinfo = "text",
        type = 'scatter',
        mode = 'markers'
      ) %>%
      layout( 
        xaxis = list(title = "age",
                     categoryorder="category ascending",
                     categoryarray = ~age),
        title = "Suicide Rate By Age, Year and Sex"
      ) %>%
      animation_opts(
        1000, easing = "elastic", redraw = FALSE
      ) %>%
      animation_button(
        x = 1, xanchor = "right", y = 0, yanchor = "bottom"
      ) %>%
      animation_slider(
        currentvalue = list(prefix = "YEAR ", font = list(color="red"))
      )
    
    
  })
  
  
  # for display of geo map 
  output$geomap <- renderPlotly({
    df<-globaldf
    
    
    #  creating a map 
    
    df_g1<- df %>%
      group_by(country) %>%
      summarise(suicides_per100 = round(mean(suicides.100k.pop)),0) %>%
      as.data.frame()
    
    df_g1$country<-as.character(df_g1$country)
    df_g1$code<-countrycode(c(df_g1$country), origin = "country.name", destination = 'genc3c')
    
    
    #  grey boundaries
    l <- list(color = toRGB("grey"), width = 0.5)
    
    # specify map projection
    g <- list(
      showframe = FALSE,
      showcountries=TRUE,
      countrycolor = toRGB("grey"),
      showcoastlines = TRUE,
      coastlinecolor = toRGB("grey"),
      projection = list(type = 'Mercator')
    )
    
    plot_geo(df_g1) %>%
      add_trace(
        z = ~suicides_per100,
        color = ~suicides_per100,
        colors = 'Blues',
        text =  ~country,
        locations = ~code,
        marker = list(line = l)
      ) %>%
      colorbar(title = 'Suicide Rate Per Country', tickprefix = '') %>%
      layout(
        title = 'Suicide Rate Per Country',
        geo = g
      )
  })
  
  output$GdpVsSuicide <- renderPlotly({
    
    df<-globaldf
    
    
    # preparing data set 
    
    df_g2<- df %>%
      group_by(country, year) %>%
      dplyr::summarise(avg_suicides_per100 = round(mean(suicides.100k.pop),0), avg_gdp_per_capita = round(mean(gdp_per_capita....),0)) %>%
      select(country,year,avg_suicides_per100, avg_gdp_per_capita) %>%
      filter(country==input$selectedCountry) %>%
      as.data.frame()
    head(df_g2)
    
    
    # creating the graph 
    
    p <- plot_ly(df_g2) %>%
      add_trace(x = ~year, y = ~avg_suicides_per100, type = 'bar', name = 'suicide rate',
                marker = list(color = 'blues', opacity = 0.3),
                hoverinfo = "text",
                text = ~paste('suicide rate: ',avg_suicides_per100)) %>%
      add_trace(x = ~year, y = ~avg_gdp_per_capita, type = 'scatter', mode = 'lines', name = 'GDP per capita', yaxis = 'y2',
                line = list(color = '#45171D'),
                hoverinfo = "text",
                text = ~paste('GDP Per Capita: ',avg_gdp_per_capita)) %>%
      layout(title = 'Suicide Rate vs GDP Per Capita',
             xaxis = list(title = ""),
             yaxis = list(side = 'left', title = 'suicide rate', showgrid = FALSE, zeroline = FALSE),
             yaxis2 = list(side = 'right', overlaying = "y", title = 'GDP per capita', showgrid = FALSE, zeroline = FALSE))
  })
  # # creating a graph for average suicide rate vs GDP per capital
  
  output$GdpVsSuicideTotal <- renderPlotly({
    
    df<-globaldf
    
    
    # preparing data set
    
    df_g2<- df %>%
      group_by(year) %>%
      dplyr::summarise(avg_suicides_per100 = round(mean(suicides.100k.pop),0), avg_gdp_per_capita = round(mean(gdp_per_capita....),0)) %>%
      select(year,avg_suicides_per100, avg_gdp_per_capita) %>%
      as.data.frame()
    head(df_g2)
    
    
    # creating the graph
    
    p <- plot_ly(df_g2) %>%
      add_trace(x = ~year, y = ~avg_suicides_per100, type = 'bar', name = 'suicide rate',
                marker = list(color = 'blues', opacity = 0.3),
                hoverinfo = "text", 
                text = ~paste('suicide rate: ',avg_suicides_per100)) %>%
      add_trace(x = ~year, y = ~avg_gdp_per_capita, type = 'scatter', mode = 'lines', name = 'GDP per capita', yaxis = 'y2',
                line = list(color = '#45171D'),
                hoverinfo = "text",
                text = ~paste('GDP Per Capita: ',avg_gdp_per_capita)) %>%
      layout(title = 'Suicide Rate vs GDP Per Capita',
             xaxis = list(title = ""),
             yaxis = list(side = 'left', title = 'suicide rate', showgrid = FALSE, zeroline = FALSE),
             yaxis2 = list(side = 'right', overlaying = "y", title = 'GDP per capita', showgrid = FALSE, zeroline = FALSE))
    
  }) 
  
  # SUMMARY  
  output$summary <- renderPrint({
    summary(mtcars)
  })
  
})