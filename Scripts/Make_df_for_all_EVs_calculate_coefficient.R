# script to make a dataframe of all EVs 
# April 4, 2023
# Alina


#### Library#########
library(sf)
library(terra)
library(raster) # spatial data manipulation
######################


# wetordry
wetordry <- "Dry" 
filename <- "_dry"

wetordry <- "Wet" 
filename <- "_wet"

# read in environmental raster
env.ls = list.files( path= paste0("C:/TNC_Connectivity_AlinaVania/ASC/", wetordry),pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
df <- as.data.frame(s, xy =T)

# save df
write.table(df,paste0("C:/TNC_Connectivity_AlinaVania/R_Processed/EV_dataframe", filename, ".csv"), sep="," , row.names = F, col.names = T)


# load in one lambdas file and experiment

