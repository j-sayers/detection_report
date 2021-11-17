
## Load scripts
library(motus)
library(tidyverse)

# Set session time to GMT
Sys.setenv(tz = "GMT")

# Select a receiver
projRecv <-  "SG-F783RPI36B63" # Horton High

# Select a folder where data is stored
dir <- '../Data/'

# OPTIONAL: Does new data exist?
# tellme(projRecv = projRecv, dir = dir)

# Download new database
sql <- tagme(projRecv = projRecv, new = T, update = T, forceMeta = T, dir = dir)

# Flatten to 2d table
df <- sql %>% tbl('alltags') %>% collect() %>% as_tibble()

# Save an RDS file (compact, faster loading)
saveRDS(df, paste0(dir, projRecv, ".rds"))

# Save a CSV (easily accessible outside of R)
write.csv(df, paste0(dir, projRecv, ".csv"))