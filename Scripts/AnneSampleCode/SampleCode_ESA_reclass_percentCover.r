


#### Library#########
library(sf)
library(terra)
library(questionr)
library(parallel)
library(dplyr)
library(tidyverse)
library(corrplot)
library(geodata)
######################


# Read in Mask for the 4 countries
# remote Desktop Base
base_dir <- "E://Terrestrial_Initiative//"
setwd(base_dir)

sdm.sp <- read_sf(paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//Mask//Okavango_SDM_ProvBoundary.shp"))


OkvSDM_msk_900m <- rast( paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//Mask//OkvSDM_msk_900m.tif"))

OkvSDM_msk_900m_utm <- project(OkvSDM_msk_900m,"epsg:32737")





# Landuse Land cover  -----------------------------------------------------
  
  #https://maps.elie.ucl.ac.be/CCI/viewer/download.php
  
  LULC_2015 <- rast("C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7//product//ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif")
  
  
  r<- crop(LULC_2015, OkvSDM_msk_900m)
  LULC_2015_sdm.sa <- mask(r, sdm.sp)
  
  writeRaster(  LULC_2015_sdm.sa, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7//product//ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7_SDMsa.tif", overwrite=T)
  
  
  # calc % cover of 4 classes 
  # dec open 
  # 62	Tree cover, broadleaved, deciduous, open (15-40%)
  
  DecOpen <- LULC_2015_sdm.sa
  DecOpen2 <- classify(DecOpen, cbind(62, 1), others=0)
  
  # resample the LULC to the 900m 
  DecOpen_t300mcell.900m <- resample(DecOpen2, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(DecOpen_t300mcell.900m)[2]
  pDecOpen_900m <- DecOpen_t300mcell.900m/maxVal
  
  writeRaster(  pDecOpen_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pDecOpen_900m.tif", overwrite=T)
  
  pDecOpen_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pDecOpen_900m.tif")
  
  
  writeRaster(pDecOpen_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//pDecOpen.asc")
  #Dec closed
  # 60	Tree cover, broadleaved, deciduous, closed to open (>15%)
  # 61	Tree cover, broadleaved, deciduous, closed (>40%)
  
  decCls <- LULC_2015_sdm.sa
  
  # multiple replacements
  m <- rbind(c(60, 1), c(61, 1));m
  decCls2 <- classify(decCls, m, others=0)
  
  # resample the LULC to the 900m 
  decCls_t300mcell.900m <- resample(decCls2, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(decCls_t300mcell.900m)[2]
  pDecClosed_900m <- decCls_t300mcell.900m/maxVal
  
  writeRaster( pDecClosed_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pDecClosed_900m.tif", overwrite=T)
  
  
  pDecClosed_900m  <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pDecClosed_900m.tif")
  
  
  writeRaster(pDecClosed_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//pDecClosed.asc")
  
  
  # shrublands	 120, 122   
  
  shb <- LULC_2015_sdm.sa
  
  # multiple replacements
  m <- rbind(c(120, 1), c(122, 1));m
  shb2 <- classify(shb, m, others=0)
  
  #unique(shb2)
  #plot(shb2 , col="red")
  
  # resample the LULC to the 900m 
  shb_t300mcell.900m <- resample(shb2, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(shb_t300mcell.900m)[2]
  pshb_900m <- shb_t300mcell.900m/maxVal
  
  writeRaster(  pshb_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pshrublands_900m.tif", overwrite=T)
  
  
  pshb_900m  <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pshrublands_900m.tif")
  
  
  writeRaster( pshb_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//pshb.asc")
  
  
  # grasslands	 130         
  gsld <- LULC_2015_sdm.sa
  gsld2 <- classify(gsld, cbind(130, 1), others=0)
  
  # resample the LULC to the 900m 
  gslands_t300mcell.900m <- resample(gsld2, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(gslands_t300mcell.900m)[2]
  pgslands_900m <- gslands_t300mcell.900m/maxVal
  
  writeRaster(  pgslands_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pGrasslands_900m.tif", overwrite=T)
  
  pgslands_900m  <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pGrasslands_900m.tif")
  
  
  writeRaster(pgslands_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//pgslands.asc")
  
  