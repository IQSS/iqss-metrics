dataverseTabPanel <- tabPanel(
  "Dataverse",
  h2("Dataverse"),
  h3(
    paste(nr_installations, "Dataverse installations around the world")
  ),
  splitLayout(leafletOutput("dvmap"),
              plotOutput("dvCountryDataPlot")),
  fluidRow(
    h3("Basic Metrics"),
  ),
  fluidRow(
    customInfoBox(
      title = "Dataverse Worldwide",
      value = nr_installations,
      subtitle = "Dataverse installations",
      icon = icon("globe"),
      fill = T
    ),
    customInfoBox(
      title = "Building a community",
      value = nr_dv_tv,
      subtitle="Dataverse-TV Videos",
      icon = icon("video"),
      fill = T,
      href = "https://iqss.github.io/dataverse-tv/"
    ),
    customInfoBox(
      title = "Number of downloads last month",
      value = formatLargeNumber(nr_downloads_last_month),
      subtitle= paste('Month: ', downloads_month),
      icon = icon("download"),
      fill = T
    )
  ),
  fluidRow(
    h3("Github Metrics"),
  ),
  fluidRow(
    customInfoBox(
      title = "Dataverse on GitHub",
      value = nr_dv_watchers,
      subtitle = "Number of watchers",
      icon = icon("eye"),
      fill=F
    ),
    customInfoBox(
      title = "Dataverse on GitHub",
      value = nr_open_issues,
      subtitle = "Number of open issues",
      icon = icon("ticket-alt"),
      fill=F
    ),
    customInfoBox(
      title = "Dataverse on GitHub",
      value = nr_dv_subscribers,
      subtitle = "Number of subscribers",
      icon = icon("users"),
      fill=F
    )
  ),
  fluidRow(
    column(6,
      h3("Total number of Files"),
      plotOutput("dvFileMonthPlot")),
    column(6,
      h3("Dataverses by Category"),
      plotOutput("dvCategoryPlot")
    )
  ),
  fluidRow(
    h3("Total datasets"),
    plotlyOutput("dvDataSets")
  )
)
