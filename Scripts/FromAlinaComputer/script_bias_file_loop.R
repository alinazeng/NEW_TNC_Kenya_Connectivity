# Feb 24
# Alina
# make loop to mass produce bias files

# bias file creation (https://scottrinnan.wordpress.com/2015/08/31/how-to-construct-a-bias-file-with-r-for-use-in-maxent-modeling/)


library(dismo) # interface with MaxEnt
library(raster) # spatial data manipulation
library(MASS) # for 2D kernel density function
library(magrittr) # for piping functionality, i.e., %>%
library(maptools) # reading shapefiles
library(sf)
library(terra)

# add data
kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")
# introducing the mask here so the raster of the occurences can share the same resolution
kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")

occurenceALL <- read.csv("input/AllLargeMammalsKenya_Moll_Cleaned.csv", header = TRUE)
# retain only ones with 100+ observations
# count number of obs.
test <- as.data.frame(table(occurenceALL$species))
#join table

test <- dplyr::rename(test,species=Var1)
occurenceALL <- dplyr::full_join(occurenceALL, test)

#get rid of ones with few obs.
occurenceALL <- dplyr::filter(occurenceALL, Freq>100)



# break occurence into a list of dataframes by spp name
list <- split(occurenceALL , f = occurenceALL$species)
# load in base raster for resampling
env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]

# try resampling and exporting as asciis
for (i in 1:length(list)) {  
  occurence <- as.data.frame(list[[i]])                               # Create a dataframe for each species
  name <- unique(list[[i]]$species) 
  occurence <- dplyr::select(occurence, -species)
  occurence <- dplyr::select(occurence, -Freq)
  occurence.ras <- rasterize(occurence, kenya_mask500, 1)
  # make bias file
  presences <- which(values(occurence.ras) == 1)
  pres.locs <- coordinates(occurence.ras)[presences, ]
  dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurence.ras), ncol(occurence.ras)), 
                lims = c(3398436,4192936,-578268.9,669231.1))
  dens.ras <- raster(dens)
  # crop using boundary
  dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
  dens.ras.resample <- terra::rast(dens.ras) # resampling
  dens.ras.resample <- raster::resample(dens.ras.resample, base_rst, method="bilinear")
  dens.ras.resample[is.na(dens.ras.resample)] <- -9999 
  writeRaster(dens.ras.resample, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs_resampled/bias_file_",name,".asc"))
}



# as tifs, no longer need (can add in resampling lines later)
for (i in 1:length(list)) {  
  occurence <- as.data.frame(list[[i]])                               # Create a dataframe for each species
  name <- unique(list[[i]]$species) 
  occurence <- dplyr::select(occurence, -species)
  occurence <- dplyr::select(occurence, -Freq)
  occurence.ras <- rasterize(occurence, kenya_mask500, 1)
  # make bias file
  presences <- which(values(occurence.ras) == 1)
  pres.locs <- coordinates(occurence.ras)[presences, ]
  dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurence.ras), ncol(occurence.ras)), 
                lims = c(3398436,4192936,-578268.9,669231.1))
  dens.ras <- raster(dens)
  # crop using boundary
  dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
  # plot(dens.ras)
  writeRaster(dens.ras, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/TIFFs/bias_file_",name,".tif"), format="GTiff", overwrite=TRUE)
}



# bias files for WET seasons

# load in base raster for resampling
env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]

# here can just load in all obs files in that folder
filename <- list.files(path = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/Wet/Common_name")
Wet <- list.files(path = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/Wet/Common_name",pattern= ".csv$", full.names=TRUE)
temp_wd <- setwd ("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/Wet")

for (i in 1:length(Wet)){
  occurence <- as.data.frame(read.csv(Wet[[i]])) #each file will be read in
  name <- filename[i]
  occurence <- dplyr::select(occurence, -species)
  occurence.ras <- rasterize(occurence, kenya_mask500, 1)
  # make bias file
  presences <- which(values(occurence.ras) == 1)
  pres.locs <- coordinates(occurence.ras)[presences, ]
  dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurence.ras), ncol(occurence.ras)), 
                lims = c(3398436,4192936,-578268.9,669231.1))
  dens.ras <- raster(dens)
  # crop using boundary
  dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
  dens.ras.resample <- terra::rast(dens.ras) # resampling
  dens.ras.resample <- raster::resample(dens.ras.resample, base_rst, method="bilinear")
  dens.ras.resample[is.na(dens.ras.resample)] <- -9999 
  # this is to get rid of very small numbers like 0s
  dens.ras.resample <- dens.ras.resample*10^20 + 0.0000000000000000001*exp(-10)
  writeRaster(dens.ras.resample, paste(name, ".asc"))
}

# change names
filedir <- temp_wd
fullpath <- list.files(filedir, pattern = ".asc", full.names = TRUE)
filename <- list.files(filedir, pattern = ".asc")

for (i in 1:length(fullpath)){
  newname <- str_replace_all(filename[i],"obs_Wet.csv ","bias_Wet")
  file.rename(from=fullpath[i],to=paste0(filedir,"/",newname))
}

# bias files for DRY seasons
kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")
# introducing the mask here so the raster of the occurences can share the same resolution
kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")
# load in base raster for resampling
env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]

# here can just load in all obs files in that folder
filename <- list.files(path = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/Dry/Common_name")
Dry <- list.files(path = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/Dry/Common_name",pattern= ".csv$", full.names=TRUE)
temp_wd <- setwd ("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/Dry")

for (i in 1:length(Dry)){
  occurence <- as.data.frame(read.csv(Dry[[i]])) #each file will be read in
  name <- filename[i]
  occurence <- dplyr::select(occurence, -species)
  occurence.ras <- rasterize(occurence, kenya_mask500, 1)
  # make bias file
  presences <- which(values(occurence.ras) == 1)
  pres.locs <- coordinates(occurence.ras)[presences, ]
  dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurence.ras), ncol(occurence.ras)), 
                lims = c(3398436,4192936,-578268.9,669231.1))
  dens.ras <- raster(dens)
  # crop using boundary
  dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
  dens.ras.resample <- terra::rast(dens.ras) # resampling
  dens.ras.resample <- raster::resample(dens.ras.resample, base_rst, method="bilinear")
  dens.ras.resample[is.na(dens.ras.resample)] <- -9999 
  # this is to get rid of very small numbers like 0s.... still need to do this after manually changing things
  dens.ras.resample <- dens.ras.resample*10^20 + 0.0000000000000000001*exp(-10)
  writeRaster(dens.ras.resample, paste(name, ".asc"), overwrite = TRUE)
}

# change names
filedir <- temp_wd
fullpath <- list.files(filedir, pattern = ".asc", full.names = TRUE)
filename <- list.files(filedir, pattern = ".asc")

for (i in 1:length(fullpath)){
  newname <- str_replace_all(filename[i],"obs_Dry.csv ","bias_Dry")
  file.rename(from=fullpath[i],to=paste0(filedir,"/",newname))
}
