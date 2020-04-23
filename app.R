library(shinydashboard)
library(shinythemes)
library(leaflet)
library(ggplot2)
library(dplyr)
library(treemap)
library(plotly)

# TODO: change directory for Shiny on the server
# user <- Sys.getenv('USER')
# if( user == 'erikbuunk') {
#   # setwd("~/Documents/Computer/iqss/heroku-docker-r-example-app")
#   setwd("/Volumes/GoogleDrive/My Drive/Metrics/IQSS Metrics Dashboard")
#   options(shiny.port = 8100)
# } else {
#   setwd("/app")
# }

# load R files ------------
source("helperFunctions.R")
source("loadData.R")
source("customWidgets.R")
source("mainTabPanel.R")
source("dataverseTabPanel.R")
source("cgaTabPanel.R")
source("boTabPanel.R")

# ui ---------------------
ui <- 
  dashboardPage(
  dashboardHeader(title = "IQSS Metrics", disable = T),
  dashboardSidebar(disable = T),
  dashboardBody(
    fluidPage(
      theme = "iqss.css",
      tabsetPanel(
        mainTabPanel,
        dataverseTabPanel,
        cgaTabPanel,
        boTabPanel
        # tabPanel(
        #   "Finance & Adminstration",
        #   h2("Finance and administration")
        # ) 
        # tabPanels
      ) # tabset
    ) # fluidpage
  ) # dashboard body
) # dashboard page

# server -----------------------
server <- function(input, output) {
  output$dvmap <- renderLeaflet({
    leaflet(data = mapData) %>%
      addTiles() %>% # Add default OpenStreetMap map tiles
      addMarkers(~lng, ~lat, popup = ~description)
  })

  # Dataverse plots -------------
  output$dvCountryDataPlot <- renderPlot({
    countryData <- as.data.frame(mapData) %>%
      filter(!is.na(country) & country !='NA') %>%
      count(country) %>%
      ggplot(aes(x = reorder(country, n), y = n)) +
      geom_bar(stat = "identity", fill = iqssLighterBlue) +
      ylab("Number of installations") +
      xlab("Country") +
      scale_y_continuous(breaks = 0:100) +
      geom_text(aes(label = n), nudge_y = -0.15, color = "white", size = 3.5) +
      coord_flip()
    print(countryData)
  })
  
  output$dvFileMonthPlot <- renderPlot({
    dvFileMonthPlot <- top_n(dv_file_month,10) %>%
      ggplot(aes(x=month, y=count), col=count) +
      geom_col(fill = iqssLighterBlue) + 
      scale_y_continuous(labels=scales::comma) +
      theme(axis.text=element_text(size=14),
            axis.title=element_text(size=14,face="bold"),
            axis.text.x = element_text(angle = 45, hjust = 1))
    
    print (dvFileMonthPlot)
  })
  
  output$dvCategoryPlot <- renderPlot({
    dvCategoryPlot <- treemap(dv_by_category,
                              index="name",
                              vSize="count",
                              type="index", 
                              title =""
                              
                      )
    
    dvCategoryPlot
  })
  
  output$dvDataSets <- renderPlotly({
    dvDataSetsPlot <- ggplot(aes(x=month, y=count, group = 1), data = dv_datasets_month) +
      geom_line(color=iqssOrange,size = 1.2)+
      # geom_point(color=iqssOrange, size=2) +
      scale_y_continuous(labels=scales::comma) +
      scale_x_discrete() +
      theme(axis.title=element_text(face="bold"),
            axis.text.x = element_text(angle = 45, hjust = 1))

    p <- ggplotly(dvDataSetsPlot)
    p
  })
  
  output$dvFileMonthPlot <- renderPlot({
    dvFileMonthPlot <- top_n(dv_file_month,10) %>%
      ggplot(aes(x=month, y=count), col=count) +
      geom_col(fill = iqssLighterBlue) + 
      scale_y_continuous(labels=scales::comma) +
      theme(axis.text=element_text(size=14),
            axis.title=element_text(size=14,face="bold"),
            axis.text.x = element_text(angle = 45, hjust = 1))
    
    print (dvFileMonthPlot)
  })
  
  # CGA plots-----------------
  output$cgaRequest <- renderPlot({
   
    
    print(cgaRequest)
  })
  
  output$cgaRequestStatus <- renderPlot({
   
  
    print(cgaRequestStatus)
  })
  
  output$cgaEvaluations <- renderPlot({
    
    print(cgaEvaluationsPlot)
  })
  
  output$cgaTrainingPlot <- renderPlot({
    print(cgaTrainingPlot)
  })
  
  output$cgaEventPlot <- renderPlot({
    print(cgaEventPlot)
  })
  
  output$cgaLicensePlot <- renderPlot({
    print (cgaLicensePlot)
  })
}

# main -----------
shinyApp(ui, server)
