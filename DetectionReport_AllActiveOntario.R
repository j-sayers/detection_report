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



# load helper functions
source('C:/GitHub/motus_scripts/helper_functions.R')


## directory for deployment summary, etc
datadir <- 'C:/users/dethier/OneDrive/R/StationSummary/ontario_deployment_summary/'
## define output directory for the reports
# outdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\automated_reports_ontario\)'
outdir <- 'C:/users/dethier/OneDrive/R/StationSummary/automated_reports_ontario/'



# load most recent summary of all Ontario deployments
# This is generated daily by
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



for (i in 1:nrow(stations)) {
  # Get the name of the station
  name = stations[i, 'station_name']
  # find and delete the most recent report of this station (should just be one)
  existing_file <- max(g7•tools::mixedsort(list.files(outdir, pattern = name, full.names = T)))
  
  ## only proceed if:
  ## - There is no such file already in the directory or
  ## - most_recent_date is newer than the date of the existing file
  
  
  if (file.exists(existing_file)){
    file.remove(existing_file)
  }
  rmarkdown::render(
    'C:/GitHub/detection_report/generate_detection_report.Rmd',
    output_file = paste0(outdir,
                         name,
                         '_',
                         Sys.Date(),
                         '.html')
  )
}
