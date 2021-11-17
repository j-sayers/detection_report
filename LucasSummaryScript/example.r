
#######################################
##### Plot Receiver Tag Hits Data #####
#######################################
#
# Lucas Berrigan
# October 30, 2019
#                                     
#######################################
################ USAGE ################
#######################################
# 
# Recreate plots made on sgdata.motus.org
#
# Because this isn't a package, you must include this function
# in your script by loading it to the environment with the
# following line:
#
# > if(!exists("plotRecv", mode="function")) source("plotRecv.R")
#
#######################################
############## STRUCTURE ##############
#######################################
#
# plotRecv(df, filetype = 'png', dir = '', depName = NA)
#
# Required libraries:
# - tidyverse
# - scales
#
# Variables:
# - df = Motus 'alltags' data frame
#   - Must include columns: ts, fullID, recv, recvDeployID, recvDeployName
# - filetype = filetype of grapic
#   - Can be: "eps", "ps", "tex" (pictex), "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf"
# - dir = Directory for graphic output
# - depName = alternative name for all receiver deployments
#
#######################################

# Load function from file
if(!exists("plotRecv", mode="function")) source("plotRecv.R")

# Read in 'alltags' data frame
df <- read.csv('../Data/projSG-4001BBBK2330.csv')

# Plot all deployments
plotRecv(df)
