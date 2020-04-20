# CGA plot definitions ---------------

cgaLicensePlot <- cgaLicenseRequestShort %>%
  filter(year ==currentYear - 1) %>%
  group_by(software) %>%
  summarise(n=n()) %>%
  top_n(10) %>%
  ggplot(aes(x=reorder(software,n), y=n)) +
    geom_bar(stat="identity",  fill=iqssOrange) +
    ylab(label = "Number of license requests") +
    xlab(label = "Software Product") + 
    theme(axis.title=element_text(face="bold")) +
    guides(fill=guide_legend(title="Software product")) +
    coord_flip()+
    theme(legend.position="none")


cgaTrainingPlot <- cgaTrainingShort %>%
  filter(date >= getLast12Months() & dateTraining < Sys.Date()) %>%
  group_by(trainingName, order) %>%
  summarise(n=n()) %>%
  filter(n>=5) %>%
  ggplot(aes(x=reorder(trainingName, order), y=n, fill=trainingName)) + 
    geom_bar(stat='identity', na.rm = T) + 
    ylab(label = "Number of registrations") +
    xlab(label = "Training") + 
    theme(legend.position="none") +
    theme(axis.title=element_text(size=15,face="bold")) +
    scale_fill_manual(values=iqssPalette)
# ,axis.text.x = element_text(angle = 45, hjust = 1)
# guides(fill=guide_legend(title=paste("Training in", currentYear)))


cgaEventPlot <-   cgaEventAtt  %>%
  ggplot(aes(x=school, y=n, fill=school)) + 
    geom_bar(stat='identity', na.rm = T ) + 
    xlab(label = "School affiliation") +
    ylab(label = "Number of registrations") +
    theme(legend.position="none") + 
    theme(axis.title=element_text(size=15,face="bold")) +
    scale_fill_manual(values=harvardPalette)

# theme(axis.title=element_text(face="bold"))   +
# coord_flip()
# guides(fill=guide_legend(title="Event"))

cgaRequestStatus <- cgaContactShort %>% 
  filter(date < getPreviousMonth() & date > getLast12Months()) %>%
  group_by(status) %>%
  summarise(nr_calls = n()) %>%
  ggplot(aes(x=reorder(status,nr_calls), y=nr_calls)) +
    geom_bar(stat="identity", fill=iqssOrange) +
    coord_flip() +
    ylab("Number of requests") +
    xlab("Harvard status/appointment")
# ggtitle("Number of requests last 12 months") +

cgaEvaluationsPlot <- ggplot(data = cgaEvaluations) +
  geom_boxplot(aes(y=value, fill=metric))+
  scale_y_continuous(limits = c(0,5)) + 
  scale_x_discrete() + facet_wrap(metric~.)+
  theme(legend.position = "none") + 
  scale_fill_manual(values=iqssPalette)

cgaRequest <- cgaContactShort %>% 
  filter(date < getPreviousMonth() & date > getLast12Months()) %>%
  group_by(year_month) %>%
  summarise(nr_calls = n()) %>%
  ggplot(aes(x=year_month, y=nr_calls, group="")) +
    geom_point(stat = "identity" , color=iqssOrange,size = 4) +
    geom_smooth(method = 'loess', color = iqssGrey, linetype="dashed") +
    geom_line(color = iqssOrange, size = 2) +
    theme(axis.title=element_text(face="bold"),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab("Month") +
    ylab("Total requests")
# ggtitle("Number of requests last 12 months") +

# cgaTabPanel ---------------

cgaTabPanel <- tabPanel(
  "CGA",
  h2("Center for Geographic Analysis"),
    # h3("Requests"),
  fluidRow(
    column(6,
           h3("Number of requests in last 12 months"),
           plotOutput("cgaRequest")
           ),
    column(6,
           h3("Number of request the last 12 months"),
           plotOutput("cgaRequestStatus")
          )
  ),
  fluidRow(
    column(4,
      h3("Course evaluations"),
      plotOutput("cgaEvaluations")
    ), 
    column(4, 
       # h3(paste("Training in", currentYear)),
       h3("Training last 12 months"),
       plotOutput("cgaTrainingPlot")
    ),
    column(4, 
      h3(paste("Registrations for CGA Conference ", currentYear-1)),
      plotOutput("cgaEventPlot")
    )
  ),
  fluidRow(
    h2("CGA Metrics"),
  ),
  fluidRow(
    customInfoBox(
      title = "Applications",
      value = nrow(cgaGISApplicationThisYear),
      subtitle = paste("Applications for GIS Institute in ", currentYear),
      icon = icon("university"),
      fill = T,
      color = "blue"
    ),
    customInfoBox(
      title = "CGA Events",
      value = cgaEventApplicationsLastYear,
      subtitle = paste("Registrations for CGA Conference ", currentYear-1),
      icon = icon("calendar-alt"),
      fill = T,
      color = "orange"
    ),
    customInfoBox(
      title = "Access",
      value = accessRequestsThisYear,
      subtitle = paste("Access requests in ", currentYear),
      icon = icon("key"),
      fill = T,
      color = "blue"
    )
    
  ),
  fluidRow(
    column(6,
           h3(paste("Top 10 license Requests in", currentYear-1)),
           plotOutput("cgaLicensePlot")
    ), 
    column(6, 
           # h3(paste("Training in", currentYear)),
           # h3("TBD"),
           includeMarkdown("cga.md")
           # plotOutput("cgaTrainingPlot")
    ),

  )
)
