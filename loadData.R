library(googlesheets4)
library("rjson")
library(jsonlite)

# mongod DB source have been moved here:
source(file = 'mongo.R')

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
iqssPalette <- c(iqssOrange,iqssDarkBlue,iqssGrey,iqssLighterBlue, harvardCrimson, harvardBlack, harvardDarkGrey, harvardLightGrey,
                 "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7" )

# # To use for fills, add
# scale_fill_manual(values=cbPalette)
# 
# # To use for line and point colors, add
# scale_colour_manual(values=cbPalette)



dv_github <- fromJSON(txt="https://api.github.com/repos/IQSS/dataverse")
nr_dv_watchers <- dv_github$watchers_count
nr_open_issues <- dv_github$open_issues_count
nr_dv_subscribers <- dv_github$subscribers_count



# Dataverse metrics from odum institute  -----------
dvMetricsBaseURL <- 'https://dataversemetrics.odum.unc.edu/dataverse-metrics/'

dv_file_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'files-toMonth.tsv'), header = T, sep = "\t", as.is = T))
dv_download_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'downloads-toMonth.tsv'), header = T, sep = "\t", as.is = T))  %>% 
  arrange(desc(month))
dv_by_category <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'dataverses-byCategory.tsv'), header = T, sep = "\t", as.is = T))
dv_datasets_month <- as.data.frame(read.csv(file = paste0(dvMetricsBaseURL, 'datasets-toMonth.tsv'), header = T, sep = "\t", as.is = T))

nr_downloads_last_month <- dv_download_month[1,]$count - dv_download_month[2,]$count
downloads_month <- dv_download_month[1,]$month

# Harvard Dataverse installations ---------------

mapData <- NULL

r2 <- fromJSON("https://raw.githubusercontent.com/IQSS/dataverse-installations/master/data/data.json", flatten=TRUE)
mapData <- r2$installations
mapData["description"] <- paste(paste0("<b>", mapData$name, "</b>"), mapData$description, sep = "<br/>")

nr_installations <- nrow(mapData)


