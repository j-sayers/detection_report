

mapTagDeployments <- function(year = 2020) {
  require(tidyverse)
  require(lubridate)
  
  year <- c(year)
  
  latLonBounds <- list(c(-83.124715, -78.935855), c(46.128556, 41.753899))
  
  tag.deps <- read.csv("D:/OneDrive/R/StationSummary/tag-deployments.csv") %>%
    mutate(ts_start = as.POSIXct(tsStart, origin = '1970-01-01'))
  
  ac.tag.deps.2020 <- tag.deps %>%
    filter(!is.na(ts_start) & year(ts_start) > min(year) - 1 & year(ts_start) < max(year) + 1,
           between(longitude, latLonBounds[[1]][1], latLonBounds[[1]][2]), 
           between(latitude, latLonBounds[[2]][1], latLonBounds[[2]][2]))
  
  # Make a new high resolution map
  lakes <- map_data('lakes')
  lakes.df <- fortify(lakes)
  lakes <- NULL
  
  worldMap <- getMap(resolution = "high")
  # Connect up all the points so the polygons are closed
  worldMap.df <- fortify(worldMap)
  worldMap <- NULL
  
  ac.tag.deps.2020 %>%
    mutate(lon.rounded = round(longitude*5)/5,
           lat.rounded = round(latitude*5)/5) %>%
    group_by(lon.rounded, lat.rounded) %>%
    summarise(Count = n()) %>%
    ggplot(aes(lon.rounded, lat.rounded)) +
    geom_polygon(data = worldMap.df, aes(long, lat,group=group), fill="#AAAAAA", colour="#000000")+
    geom_polygon(data = lakes.df, aes(long, lat,group=group), fill="#d1dbe5", colour="#000000")+
    geom_point(aes(size = Count, fill = Count), shape = 21, color = 'black', stroke = 1)+
    coord_fixed(xlim = latLonBounds[[1]], ylim = latLonBounds[[2]])+
    #scale_color_viridis_c()+
    scale_fill_gradient(low = '#00AAAA', high = '#FFFF00')+
    scale_size_continuous(range = c(4,10))+
    theme_minimal()+
    guides(size = F)+
    labs(x = '', y = '', title = paste0('Atlantic Canadian tag deployments in ', year))

}
