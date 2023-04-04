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




# Define what detections to summarize
# 1) List of stations
# 2) A project's tags
# 3) A custom query
summarize_by <- 1



# provide a list of station(s) to summarize
stations <- c(
  # 11209, # Aylmer
  # 11917 # Blackwell
  # 11240 # Breakwater
  # 11244 # Bright
  # 10004 # Brighton
  # 9907 # Conestogo
  # 11039 # Cryderman
  # 10180 # Darlington
  # 10585 # Friday Harbour
  # 11352 # Gerdau
  # 10226, # Hentz
  # 12131, # Holiday Beach
  # 11426, # Lemoine Point
  # 10132 # Maple Leaf
  # 11467 # Merlin
  # 11512 # Otter Lake
  # 11356 # Glass
  # 10287 # North Gwillimbury Forest
  # 11512 # Otter Lake
  # 11532 # Pickering
  # 11534 # Pinery
  # 11555 # Prince Edward Point
  # 11578, # Russel Reid
  # 9912 # Walsingham
  # 9913 # West Port Bruce
  # 11255 ## Onondaga
  # 11618 ## St Clair
  # 11137 # Priceville
  # 11541 # Point Farms
  9824 # Moosenee
)



# specify a project whose tags to summarize
projects <- c(
  # 417 ## Georgian Bay
  # 116 ## Migration in Song Sparrows
  # 213 ## MPG Ranch
  # 419 ## New England Monarchs
  # 101 ## Morningstar bats
  # 145 ## Kirtland warbler
  85 ## Snow bunting
  # 532 # bats of georgian bay
) 



# specify the query to use for custom tags
# NOTE: should have everything but the where clause commented out
q <- 'where a.tag_id in
(
59305,
59306,
59307,
59308,
59309,
59310,
59311,
59312,
59313,
59314
)'



# specify whether to try to get taghits_tracks 
# directly from the db (TRUE)
# or from local file (FALSE)
# if TRUE the prepared query will be supplied
# in the event that the taghits_tracks has to be 
# obtained from the remote server
tracks_from_db <- T




# define tag deploy ID's to skip
# this is a hack to remove obvious false positives 
# prior to having the chance to flag them in the db
to_remove <- c(
  #  28152 # https://motus.org/data/tagDeploymentDetections?id=28152
  # ,10301 # https://motus.org/data/tagDeploymentDetections?id=10301
  # ,20451 # https://motus.org/data/tagDeploymentDetections?id=20451
  # ,22776 # https://motus.org/data/tagDeployment?id=10273
  # ,24771 # https://motus.org/data/tagDeploymentDetections?id=24771
  # ,24728 # https://motus.org/data/track?tagDeploymentId=24728
  # ,25456 # https://motus.org/data/tagDeploymentDetections?id=25456
  # ,10283 # https://motus.org/data/track?tagDeploymentId=10283
  # ,22643 # https://motus.org/data/track?tagDeploymentId=22643
  # ,22638 # https://motus.org/data/track?tagDeploymentId=22638
  # ,33054 # https://motus.org/data/track?tagDeploymentId=33054      TEMPORARY.
  # ,1948 # https://motus.org/data/tagDeploymentDetections?id=1958
  # ,24749 # https://motus.org/data/track?tagDeploymentId=24749
  # ,21731 # https://motus.org/data/tagDeploymentDetections?id=21731
  # ,32117 # https://motus.org/data/track?tagDeploymentId=32117
  # ,24747 # https://motus.org/data/track?tagDeploymentId=24747
  # ,34661 # https://motus.org/data/track?tagDeploymentId=34661
  # ,24936 # https://motus.org/data/tagDeploymentDetections?id=24936
  # ,34038 # https://motus.org/data/track?tagDeploymentId=34038
  # ,28207 # https://motus.org/data/track?tagDeploymentId=28207
  # ,28214 # https://motus.org/data/track?tagDeploymentId=28214
  )


# connect to db to get station names to use in file names
source('C:/GitHub/motus_scripts/helper_functions.R')


# directory for taghits file etc
rootdir <- 'C:/users/dethier/OneDrive/R/StationSummary/'
# define output directory for the reports
# outdir <- r'(J:\.shortcut-targets-by-id\0B17GutSl-qqiWmhRZ0dydDM4aVk\Motus\Station Reports\Ontario Provincial Parks\)'
outdir <- rootdir
datadir <- rootdir


if (summarize_by == 1) {
  
  all_recv_deps <- get_all_recv_deps()
  
  for (station in stations) {
    name = all_recv_deps[station_id == station, station_name][1]
    rmarkdown::render(
      'C:/GitHub/detection_report/generate_detection_report.Rmd',
      output_file = paste0(outdir,
                           name,
                           '_',
                           Sys.Date(),
                           '.html')
    )
  }
  
} else if (summarize_by == 2) {
  for (project in projects) {
    name = paste0('Project_', project)
    rmarkdown::render(
      'C:/GitHub/detection_report/generate_detection_report.Rmd',
      output_file = paste0(outdir,
                           name,
                           '_',
                           Sys.Date(),
                           '.html')
    )
  }
  
} else if (summarize_by == 3) {
    rmarkdown::render(
      'C:/GitHub/detection_report/generate_detection_report.Rmd',
      output_file = paste0(outdir,
                           'Report',
                           '_',
                           Sys.Date(),
                           '.html')
    )
  }


