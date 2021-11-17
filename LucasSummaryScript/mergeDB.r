########################## Lucas's version ####################
##
##  MERGE TAG DATABASES
##
##########################
##
##  Lucas Berrigan
##
##  October 2, 2019
##
##########################
##
##  INSTRUCTIONS:
##
##  Modify the following variables to specify what you would like to merge.
##  
##  - dir = directory where database is stored
##  - tagDBFilenames = a list of tag database filenames
##  - allTagsDBFilename = the filename for the merged database
##
##########################


# Load required libraries

library(motus)
library(tidyverse)


## Folder where are your databases are stored
setwd('D:\\OneDrive\\BSC\\Projects\\193')

## List of database filenames
tagDBFilenames <- c('project_193_2018-4_tag_database.sqlite',
                    'project_193_2019-2_tag_database.sqlite',
                    'project_193_2019-4_tag_database.sqlite')

## Name of merged tag database
allTagsDBFilename <- 'project_193_2020-02-11_tags_database.sqlite'

## Make the TagDB Merge Function
mergeDB <- function(tagDBFilenames, allTagsDBFilename, dir = '', overwrite = T) {
  
  allTagsDF <- data.frame()
  
  for (DB_filename in tagDBFilenames) {
    
    tagDB <- DBI::dbConnect(RSQLite::SQLite(), DB_filename)
    
    df <- tbl(tagDB, 'tags') %>%
      collect() %>% as.data.frame()
    
    allTagsDF <- rbind(allTagsDF, df)
    
    message(paste0('Added ', nrow(df), ' rows from ', DB_filename))
    
  }
  
  allTagsDB <- DBI::dbConnect(RSQLite::SQLite(), allTagsDBFilename)
  
  DBI::dbWriteTable(allTagsDB, 'tags', allTagsDF, overwrite = overwrite)
  
  message(paste0('Merged ', nrow(allTagsDF), ' rows from ', length(tagDBFilenames), ' databases.'))
  message(paste0('Saved database in ', allTagsDBFilename))

}


## Run this function to merge them! Make sure 
mergeDB(tagDBFilenames, allTagsDBFilename, dir = dir)







############################## Adam Smith's version ###########################



make_SG_tag_database <- function(sqlite_dbs, out_sqlite = "SG_tag_database.sqlite") {
  out_db <- RSQLite::dbConnect(RSQLite::SQLite(), out_sqlite)
  for (i in sqlite_dbs) {
    message("Processing ", i)
    con <- RSQLite::dbConnect(RSQLite::SQLite(), i)
    df <- RSQLite::dbGetQuery(con, "SELECT * FROM tags")
    RSQLite::dbWriteTable(out_db, "tags", df, append = TRUE)
    RSQLite::dbDisconnect(con)
  }
  out_df <- RSQLite::dbGetQuery(out_db, "SELECT * FROM tags")
  RSQLite::dbDisconnect(out_db)
  message(length(sqlite_dbs), " tag *.sqlite files consolidated to ", out_sqlite)
  return(out_df)
}

(ex_dbs <- list.files("C:/Users/adsmith/Downloads/", pattern = ".sqlite$",
                      full.names = TRUE))
#> [1] "C:/Users/adsmith/Downloads/project_29_2017-1_tag_database.sqlite"
#> [2] "C:/Users/adsmith/Downloads/project_4_2018-4_tag_database.sqlite" 
#> [3] "C:/Users/adsmith/Downloads/project_4_2019-1_tag_database.sqlite" 
#> [4] "C:/Users/adsmith/Downloads/project_4_2019-2_tag_database.sqlite"
all_dbs <- make_SG_tag_database(ex_dbs)

#> Processing C:/Users/adsmith/Downloads/project_29_2017-1_tag_database.sqlite
#> Processing C:/Users/adsmith/Downloads/project_4_2018-4_tag_database.sqlite
#> Processing C:/Users/adsmith/Downloads/project_4_2019-1_tag_database.sqlite
#> Processing C:/Users/adsmith/Downloads/project_4_2019-2_tag_database.sqlite
#> 4 tag *.sqlite files consolidated to SG_tag_database.sqlite```

###########################
