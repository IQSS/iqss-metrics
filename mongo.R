# mongo db connection
require(mongolite)
library(dplyr)
source('helperFunctions.R')

# Database connection
mongoURL <-  "mongodb://metricsadmin:B4CFkS9Rza3dyRB@ds011734.mlab.com:11734/metrics-dashboard"
mongoDatabase <- "metrics-dashboard"


#  Dataverse TV -------------
# load google dataverse TV spreadsheet
dv_tv <- mongo(collection = "dataverse_tv",
              db = mongoDatabase,
              url = mongoURL)$find()
nr_dv_tv <- nrow(dv_tv)


# Business Operations  ------------------
boDB <- mongo(collection = "bo",
                    db = mongoDatabase,
                    url = mongoURL)
boData <- boDB$find()
latest <- sort(boData$date, decreasing = T)[1]
bo <- boData[boData$date == latest,]

# Social media -------------------
socMediaDB <- mongo(collection = "socmedia", 
              db = mongoDatabase, 
              url = mongoURL)

socMediaData <- socMediaDB$find()
socialMedia <- socMediaData[order(socMediaData$date, decreasing = T),][1:4,]


# CGA ------------------

# TODO: we can move part of these transformations to ETL process
sheets <- c(
  "cgaContact",
  "cgaWorkshopEvaluation",
  "cgaGISApplication",
  "cgaEventRegistration",
  "cgaTrainingRegistration",
  "cgaLicenseRequest",
  "cgaSULicenses",
  "cgaAccessReq"
)

cgaData <- list()

for (s in sheets) {
  collection <- mongo(collection = s,
                db = mongoDatabase,
                url = mongoURL)
  cgaData[[s]] <- collection$find()
}


# CGA Contact -------------------
cgaContactShort <- data.frame(date = as.Date(cgaData[["cgaContact"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")), 
                              status=as.factor(cgaData[["cgaContact"]]$`Your Harvard status/appointment`), 
                              school = as.factor(cgaData[["cgaContact"]]$`Your primary affiliated school at Harvard`), 
                              department =cgaData[["cgaContact"]]$`Your Harvard Department/Unit/Center/Program` )

cgaContactShort <- cgaContactShort %>%
  mutate(year = format(date, "%Y"), year_month = format(date, "%Y-%m"))


# CGA License Request ---- 

cgaLicenseRequestShort <- data.frame(date = as.Date(cgaData[["cgaLicenseRequest"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                                     status=as.factor(cgaData[["cgaLicenseRequest"]]$`Your Harvard status/appointment`), 
                                     school = as.factor(cgaData[["cgaLicenseRequest"]]$`Your primary affiliated school at Harvard`), 
                                     department =cgaData[["cgaLicenseRequest"]]$`Your Harvard Department/Unit/Center/Program`,
                                     software = as.factor(cgaData[["cgaLicenseRequest"]]$`Software product which you need a license for`)) %>%
  mutate(year = getYear(date))




trainingdates <- as.Date(cgaData[["cgaTrainingRegistration"]]$`Date of the training workshop`, tryFormats = c("%m/%d/%Y"))

cgaTrainingShort <- data.frame(date = as.Date(cgaData[["cgaTrainingRegistration"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                               basicTrainingName = as.factor(cgaData[["cgaTrainingRegistration"]]$`Name of the training workshop`),
                               trainingName = as.factor(paste(cgaData[["cgaTrainingRegistration"]]$`Name of the training workshop`, '\n',format(trainingdates,"%B %Y"))),
                               dateTraining = trainingdates,
                               status = as.factor(cgaData[["cgaTrainingRegistration"]]$`Your Harvard status/appointment`),
                               school = as.factor(cgaData[["cgaTrainingRegistration"]]$`Your primary affiliated school at Harvard`),
                               department = as.factor(cgaData[["cgaTrainingRegistration"]]$`Your Harvard Department/Unit/Center/Program`),
                               order  = as.numeric(format(trainingdates,"%Y")) + 
                                 (as.numeric(format(trainingdates, "%m"))-1)/12 +
                                 (as.numeric(format(trainingdates, "%d"))-1)/31 * 1/12) 

rm(trainingdates)
## CGA Events --------------


cgaEventRegistrationShort <- data.frame(date = as.Date(cgaData[["cgaEventRegistration"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                                        eventName = as.factor(cgaData[["cgaEventRegistration"]]$`The event name`),
                                        year = as.numeric(substr(cgaData[["cgaEventRegistration"]]$`The event name`, nchar(cgaData[["cgaEventRegistration"]]$`The event name`)-3, 
                                                                 nchar(cgaData[["cgaEventRegistration"]]$`The event name`))),
                                        status = as.factor(cgaData[["cgaEventRegistration"]]$`Your Harvard status/appointment`),
                                        school = as.factor(cgaData[["cgaEventRegistration"]]$`Your primary affiliated school at Harvard`),
                                        department = as.factor(cgaData[["cgaEventRegistration"]]$`Your Harvard Department/Unit/Center/Program`))

cgaEventRegistrationShortSelect <-
  cgaEventRegistrationShort %>% 
  filter(year == currentYear- 1) %>%
  group_by(school) %>%
  summarise(n=n())


nonHarvard <- sum(cgaEventRegistrationShortSelect[cgaEventRegistrationShortSelect["school"] != "Non-Harvard",]$n)
harvard <- cgaEventRegistrationShortSelect[cgaEventRegistrationShortSelect["school"] == "Non-Harvard",]$n

cgaEventAtt <- data.frame(school=c("Harvard", "Non-Harvard"), n=c(harvard, nonHarvard))

cgaEventApplicationsLastYear <- cgaEventRegistrationShort %>% 
  filter(year == currentYear - 1) %>%
  summarise(n=n()) %>% 
  pull()

rm(nonHarvard,harvard)


## CGA GIS Institute Application ----------------

cgaGISApplicationShort <- data.frame(date = as.Date(cgaData[["cgaGISApplication"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                                     startDate = as.Date(cgaData[["cgaGISApplication"]]$`Please enter the start date of the GIS Institute which you are applying to attend`, tryFormats = c("%m/%d/%Y")),
                                     status = as.factor(cgaData[["cgaGISApplication"]]$`Your Harvard status/appointment`),
                                     school = as.factor(cgaData[["cgaGISApplication"]]$`Your primary affiliated school at Harvard`),
                                     department = as.factor(cgaData[["cgaGISApplication"]]$`Your Harvard Department/Unit/Center/Program`))


cgaGISApplicationThisYear <- cgaGISApplicationShort %>%
  filter(startDate >= as.Date(paste0(currentYear,"-01-01")))


## CGA Evaluations -------------

cgaWorkshopEvaluationShort <- data.frame(date = as.Date(cgaData[["cgaWorkshopEvaluation"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                                         name = as.factor(cgaData[["cgaWorkshopEvaluation"]]$`Name of the training workshop`),
                                         Technical.Depth = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Technical Depth`),
                                         Content.Relevance = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Content Relevance`),
                                         Course.Material.Organization = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Course Material Organization`),
                                         Balance = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Balance of Lecture, Demo and Exercise`),
                                         Engagement.with.Students = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Engagement with Students`),
                                         Training.Duration = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Training Duration`), 
                                         Training.Pace = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Training Pace`),
                                         Presentation.Effectiveness = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Presentation Effectiveness`),
                                         Question.and.Problem.Resolution = as.numeric(cgaData[["cgaWorkshopEvaluation"]]$`Question & Problem Resolution`)
)

cgaEvaluations <- list()

for(field in c("Technical.Depth", "Content.Relevance", "Course.Material.Organization", 
               "Balance", "Engagement.with.Students", "Training.Duration", 
               "Training.Pace", "Presentation.Effectiveness", 
               "Question.and.Problem.Resolution")) {
  dfTmp <- data.frame(date = as.Date(cgaWorkshopEvaluationShort$date),
                      name = cgaWorkshopEvaluationShort$name,
                      metric = field,
                      value = cgaWorkshopEvaluationShort[,field]
  )
  
  
  
  cgaEvaluations <- rbind(cgaEvaluations, dfTmp)    
  
}


# CGA Access Request -----------------

cgaAccessReqShort <- data.frame(date = as.Date(cgaData[["cgaAccessReq"]]$Timestamp, tryFormats = c("%m/%d/%Y %H:%M:%S")),
                                status = as.factor(cgaData[["cgaAccessReq"]]$`Your Harvard status/appointment`),
                                school = as.factor(cgaData[["cgaAccessReq"]]$`Your primary affiliated school at Harvard`),
                                department = as.factor(cgaData[["cgaAccessReq"]]$`Your Harvard Department/Unit/Center/Program`),
                                accessItem = as.factor(cgaData[["cgaAccessReq"]]$`Pick the item you are requesting access to`)) %>%
  mutate(year = getYear(date)) %>%
  filter(year == currentYear)

accessRequestsThisYear = nrow(cgaAccessReqShort)


# CGS Single Use Licenses
# cgaSULicenses <- read_sheet("https://docs.google.com/spreadsheets/d/1kJCQkbPCDQeLTNR1Jjnpox8i9QgTULc1Nywxi9KWJsI/edit#gid=0")

# cgaSULicensesShort <- data.frame(product=cgaData[["cgaSULicenses"]]$Product, 
#                                  type=as.factor(cgaData[["cgaSULicenses"]]$Type), 
#                                  assigned=as.character(cgaData[["cgaSULicenses"]]$`Assigned date`))
# 
# 
# reusableLic <- cgaSULicensesShort %>% 
#   filter(type == "Reusable" & !is.na(assigned) & assigned !="NULL" ) %>%
#   mutate(assigned=as.numeric(assigned))
# 
# suLic <- cgaSULicensesShort %>% 
#   filter(type == "Single Use" & !is.na(assigned) & assigned !="NULL" )
# 
# 
# totalLicensesAssigned <-  sum(reusableLic$assigned) + nrow(suLic)

