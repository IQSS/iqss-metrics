# boTablPanel

infos <- list()

for(i in 1:nrow(bo)) {
  infos[[i]] <- customInfoBox(
    title = bo[i,]$Metric,
    value =  bo[i,]$Total,
    subtitle = bo[i,]$Period,
    icon = icon( bo[i,]$Icon),
    fill = T,
    color = bo[i,]$Color
  )
}

socialMediaIB <- list()

for(i in 1:nrow(socialMedia)) {
  socialMediaIB[[i]] <- customInfoBox(
    title = socialMedia[i,]$metric,
    value =  socialMedia[i,]$value,
    subtitle = socialMedia[i,]$unit,
    icon = icon( socialMedia[i,]$icon),
    fill = F,
    color = 'blue'
  )
}


boTabPanel <- tabPanel(
  "Business Operations",
  h2("Sponsored Research Support"),
  fluidRow(
    infos[[1]],
    infos[[2]],
    infos[[3]]
  ), 
  fluidRow(
    infos[[4]],
    infos[[5]],
    infos[[6]]
  ),
  h2('Community'),
  fluidRow(
    socialMediaIB[[1]],
    socialMediaIB[[2]],
    socialMediaIB[[3]]
  ),
  fluidRow(
    socialMediaIB[[4]],
    infos[[7]],
    infos[[8]]
  )
)