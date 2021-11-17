library(tidyverse)
library(scales)


plotRecv <- function(df, filetype = 'png', dir = '', depName = NA) {
  
  if (nrow(df) > 0) {
    
    filetype <- ifelse(is.na(filetype), 'png', filetype)
    
    dir <- ifelse(is.na(dir), '', dir)
    
    for (recvDep in unique(df$recvDeployID)) {
      
      df.tidy <-  df %>%
        filter((recvDeployID == recvDep  & !is.na(recvDep)) | 
                 (is.na(recvDep) & is.na(recvDeployID))) %>%
        arrange(port) %>%
        mutate(ts = as.POSIXct(ts, origin = '1970-01-01'),
               port = as_factor(port))
      
      depName <- ifelse(is.na(depName), as.character(unique(df.tidy$recvDeployName)), depName)
      
      ants <- tibble(factor = (unique(df.tidy$port)), index = 1:length(unique(df.tidy$port)))
      
      
      ants[ants$factor == df.tidy$port[2], ]$index
      
      p <- df.tidy %>%
        ggplot(aes(ts, fullID, color = port))+
        geom_point(aes(position=position_nudge(y = -0.2)), shape = 1, size = 2, stroke = 2)+
        scale_x_datetime(labels = date_format('%d %b %Y'), breaks = date_breaks("1 month"), minor_breaks = date_breaks("1 day"))+
        labs(title = paste0(ifelse(is.na(recvDep), 'Unregistered deployment', ifelse(is.na(depName), 'No deployment name', depName)),
                            ' - ', unique(df$recv), ', deployment: ', recvDep), x = 'Time', y = '', color = 'Antenna')+
        theme(panel.grid.minor.x = element_line(color = '#DDDDDD'),
              panel.grid.major.x = element_line(color = '#000000'),
              panel.grid.major.y = element_line(color = '#DDDDDD'),
              panel.background = element_rect(fill = '#FFFFFF'))
      
      print(p)
      
      nRows <- length(unique(df.tidy$fullID))
      nWeeks <- difftime(max(df.tidy$ts, na.rm = T), min(df.tidy$ts, na.rm = T), units = 'weeks')
      
      ggsave(plot = p, device = filetype, filename = paste0(dir, unique(df.tidy$recv), '_', depName, '_', recvDep, '.', ifelse(filetype == 'jpeg', 'jpg', filetype)), 
             width = ceiling(nWeeks/4) + 3, height = ceiling(nRows/10) + 1, units = 'in', limitsize = F)
      
    }
  } else {
    warning('Dataframe contains ZERO rows.')
  }
  
}
