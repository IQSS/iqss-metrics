library(googlesheets4)
library("rjson")
library(jsonlite)

# colors -----------------

iqssOrange <- '#d16103'
iqssDarkBlue <- '#152844'
iqssGrey <- '#555555'
iqssLighterBlue <- '#215990'
harvardCrimson <- '#A41034'
harvardBlack <-  '#000000'
harvardDarkGrey <- '#808285'
harvardLightGrey <- '#B6B6B6'


# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
harvardPalette <- c(harvardCrimson, harvardBlack, harvardDarkGrey, harvardLightGrey )
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
iqssPalette <- c(iqssOrange,iqssDarkBlue,iqssGrey,iqssLighterBlue, harvardCrimson, harvardBlack, harvardDarkGrey, harvardLightGrey,"#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7" )
# # To use for fills, add
# scale_fill_manual(values=cbPalette)
# 
# # To use for line and point colors, add
# scale_colour_manual(values=cbPalette)


# dashboard <- read.csv(file = 'assets/dashboard.csv', header = T, sep = ",", as.is = T)

dv_github <- fromJSON(txt="https://api.github.com/repos/IQSS/dataverse")
nr_dv_watchers <- dv_github$watchers_count
nr_open_issues <- dv_github$open_issues_count
nr_dv_subscribers <- dv_github$subscribers_count




# IQSS main-dashboard ----------------
iqssMetrics <- NULL
iqssMetrics <- read_sheet("https://docs.google.com/spreadsheets/d/1R-G5HeYi8687OK0OM3UwImyLiVXdy0_yEn_OsHLFkFg/edit?usp=sharing", 
                          sheet = "IQSS",
                          col_names = T,
                          col_types = "icccccclc")

iqssMetrics <- cbind(iqssMetrics, data.frame(Title=paste(iqssMetrics$Metric, 'in', iqssMetrics$Time_period)))

# Dataverse GITHUB 
# dvGitHub2 <- fromJSON(file='https://api.github.com/repos/IQSS/dataverse/issues') # needs to be paged, # only open issues

# CGA data -----------------------

# cgaLicenseReq <-  read_sheet("https://docs.google.com/spreadsheets/d/1e40rmc55hErUSIlOHLHGm40bzAya00FzRrI3oAx-kcs/edit#gid=842362239")


cgaAccessReq <- read_sheet("https://docs.google.com/spreadsheets/d/1_hD3ME9877rmHkyBK-PNlsiLRarqlio0A4cAy84luhw/edit#gid=1342530981")

cgaAccessReqShort <- data.frame(date = as.Date(cgaAccessReq[[1]]),
                             status = as.factor(cgaAccessReq[[6]]),
                             school = as.factor(cgaAccessReq[[7]]),
                             department = as.factor(cgaAccessReq[[8]]),
                             accessItem = as.factor(cgaAccessReq[[11]])) %>%
  mutate(year = getYear(date)) %>%
  filter(year == currentYear)

accessRequestsThisYear = nrow(cgaAccessReqShort)

### CGA Single Use license
cgaSULicenses <- read_sheet("https://docs.google.com/spreadsheets/d/1kJCQkbPCDQeLTNR1Jjnpox8i9QgTULc1Nywxi9KWJsI/edit#gid=0")

cgaSULicensesShort <- data.frame(product=cgaSULicenses$Product, 
                                 type=as.factor(cgaSULicenses$Type), 
                                 assigned=as.character(cgaSULicenses[[7]]))


reusableLic <- cgaSULicensesShort %>% 
  filter(type == "Reusable" & !is.na(assigned) & assigned !="NULL" ) %>%
  mutate(assigned=as.numeric(assigned))

suLic <- cgaSULicensesShort %>% 
  filter(type == "Single Use" & !is.na(assigned) & assigned !="NULL" )


totalLicensesAssigned <-  sum(reusableLic$assigned) + nrow(suLic)

# CGA license Request ---- 
cgaLicenseRequest <- read_sheet("https://docs.google.com/spreadsheets/d/1e40rmc55hErUSIlOHLHGm40bzAya00FzRrI3oAx-kcs/edit#gid=842362239")
cgaLicenseRequestShort <- data.frame(date = as.Date(cgaLicenseRequest[[1]]),
                                    status = as.factor(cgaLicenseRequest[[6]]),
                                    school = as.factor(cgaLicenseRequest[[7]]),
                                    department = as.factor(cgaLicenseRequest[[8]]),
                                    software = as.factor(cgaLicenseRequest[[11]])) %>%
  mutate(year = getYear(date))




# CGA Training ------------

cgaTrainingRegistration <- read_sheet("https://docs.google.com/spreadsheets/d/15b3O2wkUoq4TqJ-_T4qB-Jypqe2_zemupHo_s-QCZm4/edit#gid=2068274999")

cgaTrainingShort <- data.frame(date = as.Date(cgaTrainingRegistration[[1]]),
                              basicTrainingName = as.factor(cgaTrainingRegistration[[2]]),
                              trainingName = as.factor(paste(cgaTrainingRegistration[[2]], '\n',format(cgaTrainingRegistration[[3]],"%B %Y"))),
                              dateTraining = as.Date(cgaTrainingRegistration[[3]]),
                              status = as.factor(cgaTrainingRegistration[[7]]),
                              school = as.factor(cgaTrainingRegistration[[8]]),
                              department = as.factor(cgaTrainingRegistration[[9]]),
                              order  = as.numeric(format(cgaTrainingRegistration[[3]],"%Y")) + 
                                (as.numeric(format(cgaTrainingRegistration[[3]], "%m"))-1)/12 +
                                (as.numeric(format(cgaTrainingRegistration[[3]], "%d"))-1)/31 * 1/12) 







## CGA Events --------------

cgaEventRegistration <-  read_sheet("https://docs.google.com/spreadsheets/d/1UiOKlYcum5s3Vlyj4f4zzlxJ7UMiqeY_yu1JXgylxMI/edit#gid=340045856")



cgaEventRegistrationShort <- data.frame(date = as.Date(cgaEventRegistration[[1]]),
                                        eventName = as.factor(cgaEventRegistration[[2]]),
                                        year = as.numeric(substr(cgaEventRegistration[[2]], nchar(cgaEventRegistration[[2]])-3, nchar(cgaEventRegistration[[2]]))),
                                        status = as.factor(cgaEventRegistration[[6]]),
                                        school = as.factor(cgaEventRegistration[[7]]),
                                        department = as.factor(cgaEventRegistration[[8]]))

cgaEventRegistrationShortSelect <-
  cgaEventRegistrationShort %>% 
  filter(year == currentYear - 1) %>%
  group_by(school) %>%
  summarise(n=n())


nonHarvard <- sum(cgaEventRegistrationShortSelect[cgaEventRegistrationShortSelect["school"] != "Non-Harvard",]$n)
harvard <- cgaEventRegistrationShortSelect[cgaEventRegistrationShortSelect["school"] == "Non-Harvard",]$n

cgaEventAtt <- data.frame(school=c("Harvard", "Non-Harvard"), n=c(harvard, nonHarvard))


cgaEventApplicationsLastYear <- cgaEventRegistrationShort %>% 
  filter(year == currentYear - 1) %>%
  summarise(n=n()) %>% 
  pull()

## CGA GIS Institute Application ----------------
cgaGISApplication <-  read_sheet("https://docs.google.com/spreadsheets/d/1dZFh4Zyws9pwND992_NpZGfJ9IlFQwHW-f6FiQ_M1cA/edit#gid=1021617292")
cgaGISApplicationShort <- data.frame(date = as.Date(cgaGISApplication[[1]]),
                                     startDate = as.Date(cgaGISApplication[[2]]),
                                     status = as.factor(cgaGISApplication[[6]]),
                                     school = as.factor(cgaGISApplication[[7]]),
                                     department = as.factor(cgaGISApplication[[8]]),
                                     experience = as.factor(cgaGISApplication[[11]])
                                     )

cgaGISApplicationThisYear <- cgaGISApplicationShort %>%
  filter(startDate >= as.Date(paste0(currentYear,"-01-01")))


# Dataverse TSVs -----------
dvMetricsBaseURL <- 'https://dataversemetrics.odum.unc.edu/dataverse-metrics/'

dv_file_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'files-toMonth.tsv'), header = T, sep = "\t", as.is = T))
dv_download_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'downloads-toMonth.tsv'), header = T, sep = "\t", as.is = T))  %>% 
  arrange(desc(month))
dv_by_category <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'dataverses-byCategory.tsv'), header = T, sep = "\t", as.is = T))
dv_datasets_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'datasets-toMonth.tsv'), header = T, sep = "\t", as.is = T))

nr_downloads_last_month <- dv_download_month[1,]$count - dv_download_month[2,]$count
downloads_month <- dv_download_month[1,]$month


## CGA Evaluations -------------
cgaWorkshopEvaluation <- read_sheet("https://docs.google.com/spreadsheets/d/1j495c7dZ5blPjwwzXsn_vl21lg9CHKJWT-5sUZWLnvk/edit#gid=1803423154")
cgaWorkshopEvaluationShort <- data.frame(date = as.Date(cgaWorkshopEvaluation$Timestamp),
                                         name = as.factor(cgaWorkshopEvaluation$`Name of the training workshop`),
                                         Technical.Depth = cgaWorkshopEvaluation$`Technical Depth`,
                                         Content.Relevance = cgaWorkshopEvaluation$`Content Relevance`,
                                         Course.Material.Organization = cgaWorkshopEvaluation$`Course Material Organization`,
                                         Balance = cgaWorkshopEvaluation$`Balance of Lecture, Demo and Exercise`,
                                         Engagement.with.Students = cgaWorkshopEvaluation$`Engagement with Students`,
                                         Training.Duration = cgaWorkshopEvaluation$`Training Duration`, 
                                         Training.Pace = cgaWorkshopEvaluation$`Training Pace`,
                                         Presentation.Effectiveness = cgaWorkshopEvaluation$`Presentation Effectiveness`,
                                         Question.and.Problem.Resolution = cgaWorkshopEvaluation$`Question & Problem Resolution`
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

# Dataverse TV ----------------------------
# load google dataverse TV spreadsheet
dv_tv <- read_sheet("https://docs.google.com/spreadsheets/d/1uVk_57Ek_A49sLZ5OKdI6QASKloWNzykni3kcYNzpxA/edit#gid=0")
nr_dv_tv <- nrow(dv_tv)


## CGA Contact ------------

cgaContact <- read_sheet("https://docs.google.com/spreadsheets/d/1bd7VPF2fLKfcnjjlZU4PxfaS75x3d_C7P0a_rb4FP1M/edit#gid=279615175")
cgaContactShort <- data.frame(date = as.Date(cgaContact[[1]]), 
                              status=as.factor(cgaContact[[6]]), 
                              school = as.factor(cgaContact[[7]]), 
                              department =cgaContact[[8]] )

cgaContactShort <- cgaContactShort %>%
  mutate(year = format(date, "%Y"), year_month = format(date, "%Y-%m"))




# Harvard Dataverse installations ---------------
# load JSON File with  dataverse installation info

mapData <- NULL

r2 <- fromJSON("https://raw.githubusercontent.com/IQSS/dataverse-installations/master/data/data.json", flatten=TRUE)
mapData <- r2$installations
mapData["description"] <- paste(paste0("<b>", mapData$name, "</b>"), mapData$description, sep = "<br/>")

nr_installations <- nrow(mapData)


# Business Operations  ------------------
# value-column is imported as character so the formatting is preserved. There won't be any recalcualation of this data field
bo <- data.frame(read_sheet("https://docs.google.com/spreadsheets/d/1TXGcNBAPYmAgITwJ7dBAP2cB3Kkfigss_Kcr2A6jwUE/edit#gid=0", 
                 sheet = "Sponsored Research", col_types = "ccccccc"))
          
bo$Group <-  as.factor(bo$Group)

# Social media ---------------
socialMedia = read.csv(file = 'assets/socialMedia.tsv', header = T, sep = '\t')

