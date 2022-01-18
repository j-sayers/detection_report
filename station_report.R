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



# define the site(s) to summarize
# must use the exact name here
sites <- c(
  # 'Aldverville Black Oak Savanna',
  # 'Arkey\'s Acres',
  'Auzins'
  # 'Aylmer',
  # 'Binbrook Conservation Area',
  # 'Bolin_Port_Burwell',
  # 'Cabot_Head',
  # 'Conestogo',
  # 'Darlington OPG',
  # 'Des Joachims OPG',
  # 'Earl_Rowe_PP',
  # 'Gerdau'
  # 'Hagersville_Landfill',
  # 'Hentz',
  # 'Hullet Provincial Wildlife Area',
  # 'Koffler',
  # 'Lennox OPG',
  # 'Magnetawan',
  # 'Merlin',
  # 'Mosaic Port Maitland',
  # 'Nanticoke',
  # 'Peers',
  # 'Pickering OPG',
  # 'Point Farms Provincial Park',
  # 'Prince Edward Point Bird Observatory',
  # 'Old Cut'
  # 'Camp Onondaga - THFC'
  # 'Rathwell',
  # 'Russell Reid PS'
  # 'Ruthven',
  # 'Saunders',
  # 'Short Hills Provincial Park',
  # 'SpruceHaven',
  # 'Wolfe',
  # 'Tommy Thompson Park',
  # 'Turkey Point',
  # 'Wilmot Creek',
  # 'Zorad',
  # 'Werden'
)


# must define a project since the same site name 
# may exist in multiple projects
proj <- 1



# Are you on the BSC network? If so, then the database
# will be queried directly
bsc_network <- T



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


for (site in sites){
  rmarkdown::render(r'(C:\GitHub\station_report\generate_report.Rmd)',
                    output_file = paste0(outdir,
                                         site,
                                         '_',
                                         Sys.Date(),
                                         '.html'))
}

