####################################################################################
#
#  Fri Jun 18 14:24:48 2021
#  Josh Sayers
#  -----------------------
#  Provides a map and summary of a project's tags
#
####################################################################################












## Define the project(s) whose tags to summarize
projects <- c(
  417  # Georgian Bay
)



# or provide a query file that will provide a list of tag deployment id
query_file <- 'C:/GitHub/motus_scripts/sql/scratchy/red knots with flags seen robert mercer.sql'




# define whether to summarize by project or custom tag list (query_file)
# 1) project list
# 2) custom list from query file
p_or_t <- 2




# specify how to get the site data
# 1) query det_taghits_daily based on sensor_deploy_id
# 2) download data via the R package
# 3) use the most recent allruns.RDS file for this site (if one exists)
data <- 1




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


source('C:/GitHub/motus_scripts/helper_functions.R')

# define output directory
outdir <- remoted('D:/OneDrive/R/StationSummary/')


for (project in projects) {
  name = paste0('Project_', project)
  rmarkdown::render(
    'C:/GitHub/station_report/generate_detection_report.Rmd',
    output_file = paste0(outdir,
                         name,
                         '_',
                         Sys.Date(),
                         '.html')
  )
}

