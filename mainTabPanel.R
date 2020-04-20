mainTabPanel <- tabPanel(
  "IQSS",
  fluidRow(
    h2("Main Metrics"),
  ),
  fluidRow(
    customInfoBox(
      title = "Dataverse Worldwide",
      value = nr_installations,
      subtitle = "Dataverse installations Worldwide",
      icon = icon("globe"),
      tab = "Dataverse",
      fill = T,
      color = "orange"
    ),
    customInfoBox(
      title = "Harvard Dataverse",
      value = 700,
      subtitle = "New Harvard Dataverses in FY19",
      icon = icon("database"),
      tab = "Dataverse",
      fill = T,
      color = "orange"
    ),
    customInfoBox(
      title = "Center for Geographic Analysis",
      value = nrow(cgaGISApplicationThisYear),
      subtitle = paste("Applications for GIS Institute in ", currentYear),
      icon = icon("map-marked-alt"),
      fill = T,
      color = "orange",
      tab = "CGA",
    ),

  ),
  fluidRow(
    customInfoBox(
      title = "Sponsored Research Support",
      value = bo$Total[1],
      icon = icon(bo$Icon[1]),
      subtitle = paste(bo$Metric[1], "in", bo$Period[1]),
      fill = T,
      tab = "Finance",
      color = "blue"
    ),
    customInfoBox(
      title = "IT Client Support Services",
      value = 3895,
      subtitle = "Tickets resolved in FY19",
      icon = icon("ticket"),
      fill = T
    ),
    customInfoBox(
      title = "Administration & Finance",
      value = 24,
      subtitle = "Travel Grants Awarded in FY19",
      icon = icon("plane"),
      fill = T
    ),
  ),
  fluidRow(
    customInfoBox(
      title = "RCE Batch",
      value = "12%",
      subtitle = "Increase in RCE Batch Users in FY18",
      icon = icon("server"),
      fill = T
    ),
    customInfoBox(
      title = "Data Management & Curation",
      value = 25,
      subtitle = "Datasets Curated",
      icon = icon("pencil"),
      fill = T
    ),
    customInfoBox(
      title = "Data Science Services",
      value = 621,
      subtitle = "Data Consulting requests in 2019",
      icon = icon("question"),
      fill = T
    )
  ),
  fluidRow(
    customInfoBox(
      title = "RCE Interactive",
      value = "9%",
      subtitle = "Increase in RCE Interactive Users in FY18",
      icon = icon("users"),
      fill = T
    ),
    customInfoBox(
      title = "IQSS Computer Lab",
      value = 370,
      icon = icon("desktop"),
      subtitle = "New accounts in FY18",
      fill = T
    ),
    customInfoBox(
      title = "Program on Survey Research",
      value = 108,
      subtitle = "PSR Advisees in Calendar 2018",
      icon = icon("calendar"),
      fill = T
    )
  ),
  fluidRow(
    includeMarkdown("iqss.md")
    
  ) # fluid row
)
# tabpanel main