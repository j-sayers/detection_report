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

# get all deployments
all_recv_deps <- get_all_recv_deps()


# provide a list of station(s) to summarize
# in this case stations in Ontario which are also active
stations <- all_recv_deps %>%
  filter(!is.na(recv_deploy_id),
         deploy_test != 1,
         deploy_status == 2,
         !is.na(latitude),
         !is.na(longitude)) %>% # only take active non-test deployments
  filter(project_id == 1 | statprov_code == 'CA.ON')


# directory for taghits file etc
datadir <- 'C:/users/dethier/OneDrive/R/StationSummary/'
# define output directory for the reports
# outdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\automated_reports_ontario\)'
outdir <- 'C:/users/dethier/OneDrive/R/StationSummary/automated_reports_ontario/'




for (station in stations) {
  # Get the name of the station
  name = all_recv_deps[station_id == station, station_name][[1]]
  # find and delete the most recent report of this station (should just be one)
  existing_file <- max(gtools::mixedsort(list.files(outdir, pattern = name, full.names = T)))
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
