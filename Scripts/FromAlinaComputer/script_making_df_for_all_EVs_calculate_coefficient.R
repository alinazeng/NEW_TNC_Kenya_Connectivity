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

# read in enviromental raster
env.ls = list.files( path= paste0("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/ASC/", wetordry),pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)

df <- as.data.frame(s, xy =T)
