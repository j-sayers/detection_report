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



## Define the station(s) to summary
stations <- c(
  11568 # Project 247 -- Red Tail 
)



# specify how to get the site data
# 1) query det_taghits_daily based on sensor_deploy_id
# 2) download data via the R package
# 3) use the most recent allruns.RDS file for this site (if one exists)
data <- 2



# must define a project since the same site name 
# may exist in multiple projects
proj <- 1



# specify whether to try to get taghits_tracks 
# directly from the db (TRUE)
# or from local file (FALSE)
# if TRUE the prepared query will be supplied
# in the event that the taghits_tracks has to be 
# obtained from the remote server
tracks_from_db <- T



# define output directory
outdir <- 'D:/OneDrive/R/StationSummary/'



# define tag deploy ID's to skip
# this is a hack to remove obvious false positives 
# prior to having the chance to flag them in the db
to_remove <- c(
   28152 # https://motus.org/data/tagDeploymentDetections?id=28152
  ,10301 # https://motus.org/data/tagDeploymentDetections?id=10301 
  ,20451 # https://motus.org/data/tagDeploymentDetections?id=20451
  ,22776 # https://motus.org/data/tagDeployment?id=10273
  ,24771 # https://motus.org/data/tagDeploymentDetections?id=24771
  ,24728 # https://motus.org/data/track?tagDeploymentId=24728
  ,25456 # https://motus.org/data/tagDeploymentDetections?id=25456
  ,10283 # https://motus.org/data/track?tagDeploymentId=10283
  ,22643 # https://motus.org/data/track?tagDeploymentId=22643
  ,22638 # https://motus.org/data/track?tagDeploymentId=22638
  ,33054 # https://motus.org/data/track?tagDeploymentId=33054      TEMPORARY. 
  ,1948 # https://motus.org/data/tagDeploymentDetections?id=1958
  ,24749 # https://motus.org/data/track?tagDeploymentId=24749
  ,21731 # https://motus.org/data/tagDeploymentDetections?id=21731
  ,32117 # https://motus.org/data/track?tagDeploymentId=32117
  ,24747 # https://motus.org/data/track?tagDeploymentId=24747
  )


for (station in stations){
  rmarkdown::render('C:/GitHub/station_report/generate_station_report.Rmd',
                    output_file = paste0(outdir,
                                         station,
                                         '_',
                                         Sys.Date(),
                                         '.html'))
}

