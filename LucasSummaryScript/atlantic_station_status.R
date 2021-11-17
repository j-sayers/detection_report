

mapReceiverDeployments <- function(years = 2013, 
                                   excludeOthers = F,
                                   recv.deps = NULL,
                                   recv.deps.selected = NULL,
                                   bounds.view = list(c(-79, -53), c(40, 52)), # The area you want to display
                                   bounds.include = list(c(-67.16, -53), c(42, 49.63)), # The area you want to include,
                                   bounds.exclude= list(c(-67.16, -60), c(48, 49.63))# the area to exclude
                                   ) {
  
  require(motus)
  
  require(tidyverse)
  
  require(maps)
  require(rworldmap)
  require(rworldxtra)
  require(lubridate)

  
  Sys.setenv(tz = "GMT")
  
  dir <- 'D:/MotusDa'
  
  if (is.null(recv.deps)) {
    recv.deps <- read.csv(paste0(dir,'receiver-deployments.csv')) %>%
      mutate(tsStart = as.POSIXct(tsStart, origin = '1970-01-01'),
             tsEnd = as.POSIXct(tsEnd, origin = '1970-01-01'),
             dtStart = as.Date(dtStart),
             dtEnd = as.Date(dtEnd))
  }
  
  # Make a new high resolution map
  lakes <- map_data('lakes')
  lakes.df <- fortify(lakes)
  lakes <- NULL
  
  worldMap <- getMap(resolution = "high")
  # Connect up all the points so the polygons are closed
  worldMap.df <- fortify(worldMap)
  worldMap <- NULL
  
  
  # Get lat/lon bounding box around these sites
  #bounds.include <- list(c(-67.16, -53), c(42, 49.63))
  #latLonBounds.exclude <- list(c(-67.16, -60), c(48, 49.63))
  
  if (is.null(recv.deps.selected)) {
    recv.deps.selected <- recv.deps %>% 
      filter(
       # recvProjectID %in% c(2, 10, 78, 106, 197),
        between(longitude, bounds.include[[1]][1], bounds.include[[1]][2]) & 
        between(latitude, bounds.include[[2]][1], bounds.include[[2]][2]) & 
        !(between(longitude, bounds.exclude[[1]][1], bounds.exclude[[1]][2]) & 
        between(latitude, bounds.exclude[[2]][1], bounds.exclude[[2]][2])),
      )  %>%
      pull(recvDeployID)
  } 
  
  recv.deps %>%
    filter(is.na(dtEnd) | year(dtEnd) >= max(c(years)),
      year(dtStart) <= min(c(years))) %>%
    mutate(atlantic = recvDeployID %in% recv.deps.selected) %>%
    arrange(atlantic) %>%
    ggplot(aes(longitude, latitude)) +
    geom_polygon(data = worldMap.df, aes(long, lat,group=group), fill="#AAAAAA", colour="#000000")+
    geom_polygon(data = lakes.df, aes(long, lat,group=group), fill="#d1dbe5", colour="#000000")+
    geom_point(aes(fill = atlantic, size = atlantic), shape = 21, color = 'black', stroke = 2)+
    coord_fixed(xlim = bounds.view[[1]], ylim = bounds.view[[2]])+
    scale_fill_manual(values = c('#FFFF00', '#00FF00'))+
    scale_size_manual(values = c(2, 3))+
    theme_minimal()+
    guides(fill = "none", size = "none")
  
}
