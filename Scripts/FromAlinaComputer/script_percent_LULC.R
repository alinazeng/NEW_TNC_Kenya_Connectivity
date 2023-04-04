# reclass percent cover ESA layer

#### Library#########
library(sf)
library(terra)
library(raster) # spatial data manipulation
library(questionr)
library(parallel)
library(dplyr)
library(tidyverse)
library(corrplot)
library(geodata)
######################

kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")
kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")

# read in enviromental raster

env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]


# Landuse Land cover  -----------------------------------------------------
# LULC_2015 <- rast("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ESA/PIY_2015/ESACCI_LC_L4_LCCS)300m_P1Y_2015_v2_07_Kenya.tif")
LULC_2015 <- rast("C:/Users/alina/OneDrive - UBC/Pictures/OneDrive - UBC/ArcGIS/Projects/KenyaDigitization/Prepping Environmental Variables/PrepEV_NEW/PrepEV_NEW/ASCII/test3.asc")
# this is after I change the cell size to 300 and converted tif to asc in gis, smaller than our mask so i can resample

# resample and mask
LULC_2015 <- crop(LULC_2015, kenya_mask500)
LULC_2015_sdm.sa <- LULC_2015 %>% crop(kenya_bound) %>% mask(kenya_bound)

# calc % cover of 4 classes 
# dec open 
# 62	Tree cover, broadleaved, deciduous, open (15-40%)

DecOpen <- LULC_2015_sdm.sa
DecOpen2 <- classify(DecOpen, cbind(62, 1), others=0)

# resample the LULC to the 500m 
DecOpen_500m <- resample(DecOpen2,base_rst, method="sum")
maxVal <- minmax(DecOpen_500m)[2]
pDecOpen_500m <- DecOpen_500m/maxVal


# replacing NA's by-9999
pDecOpen_500m [is.na(pDecOpen_500m)] <- -9999 

writeRaster(  pDecOpen_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_DeciduousOpen.asc", overwrite=T)
writeRaster(  pDecOpen_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_DeciduousOpen.tif", overwrite=T)


#Dec closed
# 60	Tree cover, broadleaved, deciduous, closed to open (>15%)
# 61	Tree cover, broadleaved, deciduous, closed (>40%)

DecClosed <- LULC_2015_sdm.sa

# multiple replacements
m <- rbind(c(60, 1), c(61, 1));m
DecClosed2 <- classify(DecClosed, m, others=0)

# resample the LULC to the 900m 
DecClosed_500m <- resample(DecClosed2, base_rst, method="sum")
maxVal <- minmax(DecClosed_500m)[2]
pDecClosed_500m <- DecClosed_500m/maxVal
# replacing NA's by-9999
pDecClosed_500m [is.na(pDecClosed_500m)] <- -9999 

writeRaster(  pDecClosed_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_DeciduousClosed.asc", overwrite=T)
writeRaster(  pDecClosed_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_DeciduousClosed.tif", overwrite=T)


# shrublands	 120, 122   

Shrub <- LULC_2015_sdm.sa

# multiple replacements
m <- rbind(c(120, 1), c(122, 1));m
Shrub2 <- classify(Shrub, m, others=0)

#unique(Shrub2)
#plot(Shrub2 , col="red")

# resample the LULC to the 900m 
Shrub_500m <- resample(Shrub2, base_rst, method="sum")
maxVal <- minmax(Shrub_500m)[2]
pShrub_500m <- Shrub_500m/maxVal
# replacing NA's by-9999
pShrub_500m [is.na(pShrub_500m)] <- -9999 

writeRaster(  pShrub_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_Shrubland.asc", overwrite=T)
writeRaster(  pShrub_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_Shrubland.tif", overwrite=T)


# grasslands	 130         
Grass <- LULC_2015_sdm.sa
Grass2 <- classify(Grass, cbind(130, 1), others=0)

# resample the LULC to the 900m 
Grass_500m <- resample(Grass2, base_rst, method="sum")
maxVal <- minmax(Grass_500m)[2]
pGrass_500m <- Grass_500m/maxVal
# replacing NA's by-9999
pGrass_500m [is.na(pGrass_500m)] <- -9999 

writeRaster(  pGrass_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_Grassland.asc", overwrite=T)
writeRaster(  pGrass_500m, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_Grassland.tif", overwrite=T)



# human density...? can also do percentage i guess?
# load in human density layer, sum, and then cal

# no need... found another dataset