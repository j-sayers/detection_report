####################################################################################
#
#  Fri Jun 18 14:24:48 2021
#  Josh Sayers
#  -----------------------
#  Generate station summaries
#  Provide a vector of site names (must be exact phrase)
#  and specify the Project number
#
####################################################################################



## set to T in orde to re-render all reports
render_all = F



## wd needs to be explicitly set for the scheduled task
setwd('C:/GitHub/detection_report')

## this is only a placeholder since generate_detection_report wants it
summarize_by <- 1
to_remove <- c()
tracks_from_db <- T


library(tidyverse)

## load helper functions
source('C:/GitHub/motus_scripts/helper_functions.R')


## define directories
# rootdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\
rootdir <- 'C:/users/dethier/OneDrive/R/StationSummary/'

## directory for deployment summary, etc
datadir <- paste0(rootdir, 'ontario_deployment_summary/')

## define output directory for the reports
outdir <- paste0(rootdir, 'automated_reports_ontario/')


## FTP creds
ftp1 <- keyring::key_list("ftp2")[1,2]
ftp2 <- keyring::key_get("ftp2", keyring::key_list("ftp2")[1,2])
ftp3 <- '67.223.118.27'


## load most recent summary of all Ontario deployments
## This is generated daily by
stations <- max(gtools::mixedsort(
  list.files(datadir,
             pattern = 'ontario_deployment_summary',
             full.names = T)
)) %>% read.csv() 


## filtering only stations that active, in Project 1, or in Ontario
## and that are not test stations, and that have valid location 
## (I'm not sure if location is relevant anymore...)
stations <- stations %>%
  filter(!is.na(deployment_id),
         is_test != 1,
         status == 2,
         !is.na(latitude),
         !is.na(longitude)) %>% # only take active non-test deployments
  filter(project_id == 1 | statprov_code == 'CA.ON') 


all_recv_deps <- get_all_recv_deps()


for (i in 1:nrow(stations)) {
  ## Get the name of the station
  name = stations[i, 'station_name']
  # find and delete the most recent report of this station (should just be one)
  existing_file <-
    max(gtools::mixedsort(list.files(
      outdir, pattern = name, full.names = T
    )))
  ## only proceed if:
  ## - There is no such file already in the directory or
  ## - most_recent_date is newer than the date of the existing file
  proceed = F
  if (!file.exists(existing_file)) {
    proceed = T
  } else if (is.na(stations[i, 'most_recent_batch'])){
    proceed = F
  } else {
    existing_date <-
      stringr::str_extract(existing_file, '[0-9]{4}-[0-9]{2}-[0-9]{2}')
    new_date <- as.Date(stations[i, 'most_recent_batch'])
    if (new_date > existing_date) {
      proceed == T
      file.remove(existing_file)
    }
  }
  
  
  ## sometimes I want to redo them all 
  if (render_all == T) proceed = T
  
  
  if (proceed == T) {
    station <- stations[i, "station_id"]
    output_file = paste0(outdir,
                         name,
                         '_',
                         Sys.Date(),
                         '.html')
    rmarkdown::render(
      'C:/GitHub/detection_report/generate_detection_report.Rmd',
      output_file = output_file)
    message(paste0('rendered ', name))
    ## Save the file to the hosting account
    ftp <- paste0(
      'ftp://',
      ftp1,
      ':',
      ftp2,
      '@',
      ftp3,
      '/public_html/ontario_station_reports/',
      paste0(name, '.html')
    )
    Sys.sleep(10)
    x <- RCurl::ftpUpload(what = output_file,
                          to = ftp)
  } else message(paste0('skipping ', name))
}


## remove ftp creds
rm(ftp1)
rm(ftp2)
rm(ftp3)
rm(ftp)



