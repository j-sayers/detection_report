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



# ## Provincial Parks station(s) to summarize
# stations <- c(
#   11246, # Bronte Creek Provincial Park	
#   11418, # Komoka Provincial Park	        
#   11445, # MacGregor Point Provincial Park	
#   11541, # Point Farms Provincial Park   	
#   11573, # Rondeau Provincial Park     	
#   11587, # Sandbanks Provincial Park		
#   11604,  # Short Hills Provincial Park
#   10008, # Long Point PP
#   12203 # Old Cut
# )


## OPG Stations
stations <- c(
  10652, # Des Joachims
  10005, # Saunders
  11486, # Nanticoke
  11532, # Pickering
  10180, # Darlington
  10214 # Lennox
)


# connect to db to get station names to use in file names
source('C:/GitHub/motus_scripts/helper_functions.R')


# directory for taghits file etc
datadir <- 'C:/users/dethier/OneDrive/R/StationSummary/'
# define output directory for the reports
# outdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\Ontario Provincial Parks\)'
outdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\OPG\)'



all_recv_deps <- get_all_recv_deps()



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
