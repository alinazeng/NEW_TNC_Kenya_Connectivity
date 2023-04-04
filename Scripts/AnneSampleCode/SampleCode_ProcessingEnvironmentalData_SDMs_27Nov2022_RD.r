# create Environmental data for the 4 countries 



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


# Calculate the number of cores
no_cores <- detectCores() - 1

# Initiate cluster
cl <- makeCluster(no_cores); cl



# Read in Mask for the 4 countries
# remote Desktop Base
base_dir <- "E://Terrestrial_Initiative//"
setwd(base_dir)

sdm.sp <- read_sf(paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//Mask//Okavango_SDM_ProvBoundary.shp"))


OkvSDM_msk_900m <- rast( paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//Mask//OkvSDM_msk_900m.tif"))

OkvSDM_msk_900m_utm <- project(OkvSDM_msk_900m,"epsg:32737")


# # Create Mask for Study Region --------------------------------------------

# OkvSDM_msk_900m <- elev_sa
# 
# OkvSDM_msk_900m[OkvSDM_msk_900m <0 ] <- NA
# OkvSDM_msk_900m[OkvSDM_msk_900m >= 0 ] <- 1

# write raster
# 
# writeRaster(OkvSDM_msk_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//Mask//OkvSDM_msk_900m.tif")

#OkvSDM_msk_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//Mask//OkvSDM_msk_900m.tif")
#OkvSDM_msk_900m_utm <- project(OkvSDM_msk_900m,"epsg:32737")


# Elevation ---------------------------------------------------------------
# keep with worldclim data to match resolution etc 
#https://www.worldclim.org/data/worldclim21.html#google_vignette
# Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.

tmp_elev <- elevation_global(0.5, path=getwd())


tmp_elev <- crop(tmp_elev,OkvSDM_msk_900m )
elev_sdm.sa <- mask(tmp_elev,OkvSDM_msk_900m )

writeRaster(elev_sdm.sa, paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//Elev_sa.tif"), overwrite=T)

# Write Ascii
# replacing NA's by-9999
elev_sdm.sa [is.na(elev_sdm.sa)] <- -9999 
writeRaster(elev_sdm.sa, paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//ascii//Elev_sa.asc"), overwrite=T)
  

# Current Climate data ------------------------------------------------------------

# clim_temp <- worldclim_global(var="bio",res=0.5, path=paste0(getwd()), version="2.1")
# failed to download via code therefore download directly 
file_pattern <- paste0("^wc2.1_30s_bio_.*",".tif$")
# list all the files that match the pattern above 
f_list <- list.files( "E://Terrestrial_Initiative//wc2.1_30s//current//", pattern =  file_pattern, full.names = T ); f_list
# 
# [1] "E://Terrestrial_Initiative//wc2.1_30s//current//wc2.1_30s_bio_10.tif"
# [2] "E://Terrestrial_Initiative//wc2.1_30s//current//wc2.1_30s_bio_11.tif"
# [3] "E://Terrestrial_Initiative//wc2.1_30s//current//wc2.1_30s_bio_15.tif"
# [4] "E://Terrestrial_Initiative//wc2.1_30s//current//wc2.1_30s_bio_16.tif"
# [5] "E://Terrestrial_Initiative//wc2.1_30s//current//wc2.1_30s_bio_17.tif"



#Select out variables that I want to use
# # BIO10 = Mean Temperature of Warmest Quarter
# # BIO11 = Mean Temperature of Coldest Quarter
#   BIO15 = Precipitation Seasonality (Coefficient of Variation)
# # BIO16 = Precipitation of Wettest Quarter
# # BIO17 = Precipitation of Driest Quarter
# 
# stack all rasters together
s_clim <- rast(f_list) 

clim_temp <- crop(s_clim,OkvSDM_msk_900m )
bioclim_sdm.sa <- mask(clim_temp,OkvSDM_msk_900m )

names(bioclim_sdm.sa) <- c("cntBio_10", "cntBio_11", "cntBio_15", "cntBio_16", "cntBio17")


#Loop through stack to write tif and ascii rasters
for(i in seq(1, nlyr(bioclim_sdm.sa), by=1)){

  writeRaster(bioclim_sdm.sa[[i]], paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//",names(bioclim_sdm.sa[[i]]),".tif"), overwrite=T)
  # replacing NA's by-9999
  bioclim_sdm.sa[[i]] [is.na(bioclim_sdm.sa[[i]])] <- -9999 
  
  writeRaster(bioclim_sdm.sa[[i]], paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//ascii//",names(bioclim_sdm.sa[[i]]),".asc"), overwrite=T)
}



########################################################################################
#         Setup the resolution and future climate scenario(s)
########################################################################################

#*******************************************************
# select resolution for analysis
res.lb <- "0.5m"
res <- 0.5
# All options are 
# "2.5m"    2.5 minute resolution (~4.65 km at equator)
#  "5m"     5 minute resolution (~9.3 km at equator)
#  "10m"	  10 minute (~18.6 km at equator)
#*******************************************************

# Shared Socioeconomic Pathways  Scenarios 
#*******************************************************
#*Select the scenario
scen <-   "126"
scen.lb <- "ssp126"
Plottitle <-   "low-end scenario (126)"

# scen <-   "585"   
# scen.lb <- "ssp585"      
# Plottitle <-  "worst-case scenario (585)"  
###################
# options for climate scenarios include
#"ssp126"        1-2.6 - This is a low-end scenario that results in less than 2° C warming by 2100. A notable feature of this     
#scenario is the increased global forest cover. 
# "ssp246"       # 2-4.5 - This is a moderate scenario with intermediate level forcings and 
#intermediate societal vulnerability.
# "ssp370"       3-7.0 - This is a new scenario and considered to be "middle of the road" but still have                                       #  relatively high climate forcings and land use change. 
#"ssp585"       5-8.5 - This is considered the worst-case future scenario.

#Yr_list <- c( "2021-2040", "2041-2060", "2061-2080", "2081-2100")
Yr_list <- c( "2041-2060", "2061-2080")


# create a list of the scenarios
mdl.list <- c( "ACCESS-CM2", "ACCESS-ESM1-5", "AWI-CM-1-1-MR", "BCC-CSM2-MR", "CanESM5", "CanESM5-CanOE", "CMCC-ESM2","CNRM-CM6-1",  "CNRM-CM6-1-HR", "CNRM-ESM2-1", "EC-Earth3-Veg", "EC-Earth3-Veg-LR", "FIO-ESM-2-0",  "GISS-E2-1-G", "GISS-E2-1-H", "HadGEM3-GC31-LL", "INM-CM4-8", "INM-CM5-0", "IPSL-CM6A-LR", "MIROC-ES2L", "MIROC6", "MPI-ESM1-2-HR", "MPI-ESM1-2-LR", "MRI-ESM2-0", "UKESM1-0-LL")

# Not available across all years
#"GFDL-ESM4"



# Download and Mask rasters -----------------------------------------------

# create directory for rasters outputs if it doesn't exist
ifelse(!dir.exists(file.path("E://Terrestrial_Initiative//wc2.1_30s//", "future")), dir.create(file.path("E://Terrestrial_Initiative//wc2.1_30s//", "future")), FALSE)

for(Year in 1:length(Yr_list)){
 # yr <- "2061-2080"
  yr <- Yr_list[Year]
  print(yr)
  for(m in 1:length(mdl.list)){
    
    #mdl <- "BCC-CSM2-MR"
    mdl <- mdl.list[m]
    print(mdl)
    
    r1 <- cmip6_world(mdl, ssp= scen, time=yr, "bioc", res, path=getwd())
    rast()
    r1 <- crop(r1,OkvSDM_msk_900m )
    r.sdm.sa<- mask(r1,OkvSDM_msk_900m)
   
   s.bio.sa <- r.sdm.sa[[c(10,11,15:17)]]
     #c(r.sdm.sa$wc2_10, r.sdm.sa$wc2_11,r.sdm.sa$wc2_15,r.sdm.sa$wc2_16,r.sdm.sa$wc2_17)
  names(s.bio.sa) <- c("wc2_10","wc2_11","wc2_15","wc2_16","wc2_17")
    
    # write Raster 
   #Loop through stack to write tif and ascii rasters
   for(i in seq(1, nlyr(s.bio.sa ), by=1)){
     
     writeRaster(s.bio.sa [[i]], paste0("E://Terrestrial_Initiative//wc2.1_30s//future//",names(s.bio.sa[[i]]),"_",res.lb,"_",scen.lb,"_",mdl,"_",yr,".tif"), overwrite=T)
    
        } # end of stack loop
  file.remove(paste0("E://Terrestrial_Initiative//wc2.1_30s//wc2.1_30s_bioc_",mdl,"_",scen.lb,"_",yr,".tif"))
   } # end of models
 
} # end of year


# average by model for each Bio variable -----------------------------------------
# create directory for rasters outputs if it doesn't exist

ifelse(!dir.exists(file.path("E://Terrestrial_Initiative//wc2.1_30s//future//", "mdlAvg")), dir.create(file.path("E://Terrestrial_Initiative//wc2.1_30s//future", "mdlAvg")), FALSE)

  # create a name of the files you want to pull out
  Climate_folder <-"E://Terrestrial_Initiative//wc2.1_30s//future//"
  # add this name to a pattern to search for in the folder
  
  #wc2_17_0.5m_ssp126_ACCESS-CM2_2021-2040.tif
  
# need to loop through each bio clim varible   
        # # BIO10 = Mean Temperature of Warmest Quarter
        # # BIO11 = Mean Temperature of Coldest Quarter
        #   BIO15 = Precipitation Seasonality (Coefficient of Variation)
        # # BIO16 = Precipitation of Wettest Quarter
        # # BIO17 = Precipitation of Driest Quarter
       
  bio_list <- c("10", "11","15", "16","17")
  Yr_list <- c( "2041-2060", "2061-2080")

    #wc2_17_0.5m_ssp126_ACCESS-CM2_2021-2040.tif
 
  
   for(b in 1:length(bio_list)){
     bio<- bio_list[b]
  for(Year in 1:length(Yr_list)){
       # yr <- "2041-2060"
       yr <- Yr_list[Year]
       print(yr) 
     
  file_pattern <- paste0("^wc2_",bio,"_",res.lb,"_",scen.lb,"_.*",yr,".tif$")
  # list all the files that match the pattern above 
  f_list <- list.files( Climate_folder, pattern =  file_pattern, full.names = T ); f_list
  # stack all rasters together
  s_clim.bio <- rast(f_list) 
  
  avg.b  <- mean(s_clim.bio, na.rm=TRUE)
  names(avg.b) <- paste0("Bio_",bio,"_",scen.lb,"_",yr)
  writeRaster(avg.b, paste0(Climate_folder,"mdlAvg//wc2_MdlAve_Bio_",bio,"_",scen.lb,"_",yr,".tif"),overwrite=TRUE)
  
  # replacing NA's by-9999
  avg.b[is.na(avg.b)] <- -9999 
  
  writeRaster(avg.b, paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//ascii_",scen.lb,"_",yr,"//cntBio_",bio,".asc"), overwrite=T)
  
  

    }
  }
  
  
  







  
  
  
  

  
  
  
  # Croplands ---------------------------------------------------------------
  #Global cropland expansion in the 21st century
  #https://glad.umd.edu/dataset/croplands
  
  # Map data provided in the geographic coordinates using the WGS84 reference system.
  # Data format:  8-bit unsigned LZW-compressed GeoTiff. Pixel size is 0.00025 × 0.00025 degree (~30 m × 30 m at Equator). Data aggregated into quadrant mosaics.
  # Pixel values: 0 - no croplands or no data; 1 - croplands.
  
  # P. Potapov, S. Turubanova, M.C. Hansen, A. Tyukavina, V. Zalles, A. Khan, X.-P. Song, A. Pickens, Q. Shen, J. Cortez. (2021) Global maps of cropland extent and change show accelerated cropland expansion in the twenty-first century. Nature Food. https://doi.org/10.1038/s43016-021-00429-z
  
  se_af_crops <- rast("C://Users//anne.trainor.TNC//Box//GIS_Africa//Africa_Global//LULC//Croplands//Global_cropland_SE_2019.tif")
  
  
  r<- crop(se_af_crops, OkvSDM_msk_900m)
  crop_sdm.sa <- mask(r, sdm.sp)
  
  # resample the LULC to the 900m 
  crop_t30mcell.900m <- resample(crop_sdm.sa, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(crop_t30mcell.900m)[2]
  pCrops_900m <- crop_t30mcell.900m/maxVal
  
  pCrops_900mNoZ <- pCrops_900m
  pCrops_900mNoZ[ pCrops_900mNoZ==0] <- NA
  global (pCrops_900mNoZ, quantile, na.rm=T)
  #                       X0.   X25.   X50.   X75. X100.
  # Global_cropland_SE_2019 3.055902e-14 0.0207 0.0765 0.2361     1
  
  
  writeRaster(  pCrops_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pCrops_900m.tif", overwrite=T)
  
  
  pCrops_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//pCrops_900m.tif")
  
  
  writeRaster(pCrops_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//pCrops.asc")
  
  
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
  
  
  
  # &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  #         Luis suggests a different wetland dataset 
  #https://zenodo.org/record/4280923#.Y2F0q3bML_i
  #           GLC_FCS30-2020:Global Land Cover with Fine Classification System at 30m in 2020
  #         #Lui et al 
  ## &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  
  
  # downloaded tiles for the SDM study region
  # C:\Users\anne.trainor.TNC\Box\AO - Okavango-Zambezi PA Conservation Planning\BaseDatasets\SpatialData\Landscapes\Lui_LULC\SDMs
  
  #mosaic in Arcpro
  # with arcpy.EnvManager(extent='11.6684732437135 -28.9694499969482 33.7057037353516 -4.37259101867677 GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]'):
  #arcpy.management.MosaicToNewRaster(r"LuiLULC\GLC_FCS30_2020_E15S15.tif;LuiLULC\GLC_FCS30_2020_E10N0.tif;LuiLULC\GLC_FCS30_2020_E30S15.tif;LuiLULC\GLC_FCS30_2020_E30S10.tif;LuiLULC\GLC_FCS30_2020_E30S5.tif;LuiLULC\GLC_FCS30_2020_E25S25.tif;LuiLULC\GLC_FCS30_2020_E25S20.tif;LuiLULC\GLC_FCS30_2020_E25S15.tif;LuiLULC\GLC_FCS30_2020_E25S10.tif;LuiLULC\GLC_FCS30_2020_E25S5.tif;LuiLULC\GLC_FCS30_2020_E20S25.tif;LuiLULC\GLC_FCS30_2020_E20S20.tif;LuiLULC\GLC_FCS30_2020_E20S15.tif;LuiLULC\GLC_FCS30_2020_E20S10.tif;LuiLULC\GLC_FCS30_2020_E20S5.tif;LuiLULC\GLC_FCS30_2020_E15S25.tif;LuiLULC\GLC_FCS30_2020_E15S20.tif;LuiLULC\GLC_FCS30_2020_E15S15.tif;LuiLULC\GLC_FCS30_2020_E15S10.tif;LuiLULC\GLC_FCS30_2020_E15S5.tif;LuiLULC\GLC_FCS30_2020_E10S25.tif;LuiLULC\GLC_FCS30_2020_E10S20.tif;LuiLULC\GLC_FCS30_2020_E10S15.tif;LuiLULC\GLC_FCS30_2020_E10S10.tif;LuiLULC\GLC_FCS30_2020_E10S5.tif", r"C:\Users\anne.trainor.TNC\Box\AO - Okavango-Zambezi PA Conservation Planning\BaseDatasets\SpatialData\Landscapes\Lui_LULC\SDMs", "GLC_FCS30_SDMExtent2.tif", None, "8_BIT_UNSIGNED", None, 1, "MAXIMUM", "FIRST")
  
  # read 
  LuiLULC <- rast("C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//Lui_LULC//SDMs//GLC_FCS30_SDMExtent2.tif")
  
  # Crop and mask by SDM SA
  LuiLULC.sa <- mask(LuiLULC, sdm.sp)
  
  
  writeRaster( LuiLULC.sa, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//Lui_LULC//SDMs//GLC_FCS30_SDMExtentmsk.tif", overwrite=T)
  
  # reclassify
  # only want to keep 180 : wetalds
  Lui_wetlands.sa <- classify(LuiLULC.sa, cbind(180, 1), others=0)
  
  writeRaster( Lui_wetlands.sa, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//Lui_LULC//SDMs//GLCFCS30_wetlands.tif", overwrite=T)
  
  # Calc % wetlands
  sum_wetlands_sdm.sa.900m <- resample(Lui_wetlands.sa, OkvSDM_msk_900m, method="sum")
  maxVal <- minmax(sum_wetlands_sdm.sa.900m)[2]
  pwetlands_900m <- sum_wetlands_sdm.sa.900m/maxVal
  
  
  writeRaster( pwetlands_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//Lui_LULC//SDMs//GLCFCS30_pwetlands_900m.tif", overwrite=T)
  
  
  
  pwetlands_900m2 <- pwetlands_900m
  pwetlands_900m2[pwetlands_900m2<0.05]  <- 0
  pwetlands_900m2[pwetlands_900m2>=0.05] <- 1
  
  
  pwetlands_900m2_utm <- project(pwetlands_900m2,"epsg:32737")
  terra::freq(pwetlands_900m2_utm)
  # layer value   count
  # 1     1     0 4118246
  # 2     1     1   83831
  pwetlands_900m2_utm2 <- mask(pwetlands_900m2_utm,OkvSDM_msk_900m_utm )
  
  dwetlands_900m2_utm <- gridDistance(pwetlands_900m2_utm2, target=1)
  
  
  # Reproject to WGS
  dwetlands_900m2_wgs <- project(dwetlands_900m2_utm, "EPSG:4326")
  dwetlands_900m2_wgs2<- resample(dwetlands_900m2_wgs,OkvSDM_msk_900m, method="bilinear")
  
  writeRaster( dwetlands_900m2_wgs2, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//Lui_LULC//SDMs//GLCFCS30_dwetlands_900m.tif", overwrite=T)
  
  dwetlands_900m2_wgs2 <- rast(  "E://Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//GLCFCS30_dwetlands_900m.tif")
  
  # replacing NA's by-9999
  dwetlands_900m2_wgs2 [is.na(dwetlands_900m2_wgs2)] <- -9999 
  
  writeRaster(dwetlands_900m2_wgs2 , "E://Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//ascii//dwetlands.asc")
  
  # Aboveground Biomass ------------------------------------------------------
  #https://climate.esa.int/en/odp/#/project/biomass 
  
  # This dataset comprises estimates of forest above-ground biomass for the years 2010, 2017 and 2018. They are derived from a combination of Earth observation data, depending on the year, from the Copernicus Sentinel-1 mission, Envisat's ASAR instrument and JAXA's Advanced Land Observing Satellite (ALOS-1 and ALOS-2), along with additional information from Earth observation sources. The data has been produced as part of the European Space Agency's (ESA's) Climate Change Initiative (CCI) programme by the Biomass CCI team. This release of the data is version 3. Compared to version 2, this is a consolidated version of the Above Ground Biomass (AGB) maps. This version also includes a preliminary estimate of AGB changes for two epochs. The data products consist of two (2) global layers that include estimates of: 1) above ground biomass (AGB, unit: tons/ha i.e., Mg/ha) (raster dataset). This is defined as the mass, expressed as oven-dry weight of the woody parts (stem, bark, branches and twigs) of all living trees excluding stump and roots 2) per-pixel estimates of above-ground biomass uncertainty expressed as the standard deviation in Mg/ha (raster dataset) In addition, files describing the AGB change between 2018 and the other two years are provided (labelled as 2018_2010 and 2018_2017). These consist of two sets of maps: the standard deviation of the AGB change and a quality flag of the AGB change. Note that the change itself can be simply computed as the difference between two AGB maps, so is not provided directly. Data are provided in both netcdf and geotiff format.
  
  #Citable as:  Santoro, M.; Cartus, O. (2021): ESA Biomass Climate Change Initiative (Biomass_cci): Global datasets of forest above-ground biomass for the years 2010, 2017 and 2018, v3. NERC EDS Centre for Environmental Data Analysis, 26 November 2021. doi:10.5285/5f331c418e9f4935b8eb1b836f8a91b8. http://dx.doi.org/10.5285/5f331c418e9f4935b8eb1b836f8a91b8
  
  AGBiomass <- rast("C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//BaseDatasets//SpatialData//Landscapes//AboveGroundBiomass//ESACCI_biomass_L4_AGB_100m_2018_fv3_Okv_SDM_SA.tif")
  
  
  cellSize(AGBiomass, unit="m")
  
  AGBiomass_avg900m <- resample(AGBiomass, OkvSDM_msk_900m, method="average")
  
  
  writeRaster( AGBiomass_avg900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//AGBiomass_avg900m.tif", overwrite=T)
  
  AGBiomass_avg900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//AGBiomass_avg900m.tif")
  
  
  writeRaster(AGBiomass_avg900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//AGBiomass.asc")
  
  
  # Dynamic Habitat Vegetation  ---------------------------------------------
  #http://silvis.forest.wisc.edu/data/dhis/
  
  #this is a test run with 4 different veg indices 
  # each indice has 3 bands 
  # Band 1 - cumulative
  # Band 2 - minimum
  # Band 3 - seasonality
  #All DHIs datasets are single composite RGB images stored in GeoTIFF format at 1 kilometer spatial resolution. Map projection is WGS84 (EPSG:4326).
  
  # NDVI 
  # most basic  b/c uses 2 bands
  #Saturates at high biomass and is therefore insensitive in these areas. Poor delineation of transition periods between low and high productivity.
  
  # EVI 
  # Vegetation index based on three bands (469 nm, 645 nm & 858 nm)
  #  greater sensitivity to high biomass than NDVI, allowing for improved characterization of vegetation productivity through a canopy background adjustment. 
  # EVI is less sensitive to soil and atmospheric influences than NDVI, because it incorporates the blue spectral wavelengths and an aerosol reflectance coefficient in its calculation (Waring et al., 2006).
  # Improvements over NDVI include reduced sensitivity to soil and atmospheric effects. Lower levels of biomass are more clearly discriminated. Better lower phenological curve delineation.
  
  # FPAR and LAI 
  # data are based on reflectance values of up to seven MODIS spectral bands using a three-dimensional description of the vegetation land cover surface (Knyazikhin et al., 1998; Myneni et al., 2002), and incorporate land cover data (Friedl et al., 2010)intheir calculation. 
  #provide a closer proxy for vegetation productivity than NDVI and EVI, because the vegetation indices are only based on two or three spectral bands. 
  
  #FPAR 
  #Index based on up to 7 bands (645 nm, 858 nm, 469 nm, 555 nm, 1240 nm, 1640 nm & 2130 nm). Requires land cover classification.
  
  #is a measure of the proportion of available solar radiation in photosynthetically active wavelengths that is absorbed by vegetation and varies from 0 on barren land to 100 in dense vegetation (Myneni et al., 2002). 
  
  #LAI 
  # Index based on up to 7 bands (645 nm, 858 nm, 469 nm, 555 nm, 1240 nm, 1640 nm & 2130 nm). Requires land cover classification.
  #defines an important structural property of a plant canopy, i.e., the one-sided leaf area per unit ground area, but LAI also saturates (Shabanov et al., 2005).
  
  
  # GPP
  # The most computationally and data intensive MODIS vegetation product is GPP, which is the total amount of light energy that primary producers convert into biomass in a given length of time (Heinsch et al., 2003). GPP is calculated using FPAR and land cover data, combined with daily meteorological data, and requires several modeling assumptions (Running et al., 2004; Turner et al., 2006), making it the most refined of all vegetation productivity data sets of MODIS.
  
  
  # Test run with GPP 
  gpp <- rast("C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//ArcPro//Okav_SDM_Mapping_31Aug2022//dhi_gppqa_f_SDM_Okv.tif")
  
  plot(gpp)
  cellSize(gpp, unit="km")
  
  
  
  gpp_900m <- resample(gpp, OkvSDM_msk_900m, method="cubic")
  
  names(gpp_900m) <- c("dhi_ggp_culm","dhi_ggp_min","dhi_ggp_var")
  
  writeRaster( gpp_900m, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//gpp_3bnds_900m.tif", overwrite=T)
  
  
  gpp_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//gpp_3bnds_900m.tif")
  
  # not using culm b/c highly correlated with biomass
  writeRaster(gpp_900m[[2]] , "C://Users//anne.trainor.TNC//Box//ascii//dhi_ggp_min.asc")
  
  
  #AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//dhi_ggp_min.asc")
  #C:\Users\anne.trainor.TNC\Box\ascii
  
  writeRaster(gpp_900m[[3]] , "C://Users//anne.trainor.TNC//Box//ascii//dhi_ggp_var.asc")
  
  #AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//dhi_ggp_var.asc")
  
  

# Rivers  -----------------------------------------------------------------

  # first used Free flowing rivers from McGill. Luis suggested a different data set
  # looked at DIGITAL CHART OF THE WORLD HYDRO but strong counry bias. for now I will leave with orginial dataset 
  
  # DWC_Rivers <- read_sf("E://Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//DIGITAL CHART OF THE WORLD HYDRO//DCW_Water_Lines_ANZB_shp.shp")
  #   # subset rivers by HYC_DESCRI
  #     # Non-Perennial/Intermittent/Fluctuating
  #   # Perennial/Permanent
  #   PerPermRivers <- DWC_Rivers %>%
  #   filter(HYC_DESCRI == "Perennial/Permanent")
  # dim(PerPermRivers)
  # #[1] 11246     7
  # 
  # 
  # # transform the streams to utm
  # PerPermRivers_utm  <- st_transform(PerPermRivers,  crs=32737)
  # 
  # # Rasterize 
  # PerPermRivers_utm$target <- 1
  # rPerPermRivers_utm <- rasterize(vect(PerPermRivers_utm),OkvSDM_msk_900m_utm, field="target")
  # 
  # # convert NA to 0 
  # rPerPermRivers_utm[is.na(rPerPermRivers_utm)] <- 0
  # rPerPermRivers_utm <- mask(rPerPermRivers_utm, OkvSDM_msk_900m_utm)
  # # generate distance raster
  # dPerPermRivers_utm <- gridDistance(rPerPermRivers_utm, target=1)*0.001 
  # 
  # 
  # 
  # # Reproject to WGS
  # dPerPermRivers_wgs <- project( dPerPermRivers_utm, "EPSG:4326")
  # dPerPermRivers_wgs2<- resample(dPerPermRivers_wgs,OkvSDM_msk_900m, method="bilinear")
  # 
  # 
  # 
  # writeRaster( dPerPermRivers_wgs2, "E://Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//Nov2022//dPerPermRivers_km_900m.tif", overwrite=T)
  
  
  # used Free flowing rivers dataset (McGill et al)  To create 2 different distance from rivers
  # 1) Tributaries
  #2) mainstem rivers
  
  # FF river dataset clipped to 4 country area
  
  #  
  
  FFR_v4_SDMsa <- read_sf("C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//ArcPro//Okav_SDM_Mapping_31Aug2022//FFR_v4_SDMsa.shp")
  
  # focuse on river orders (RIV_ORD) HydroATLAS; Linke et al. (2018)
  #River Order based on field DIS_AV_CMS (Discharge / Flow)
  
  #   Larger the order smaller the river
  # River order is based on the long-term average discharge using logarithmic progression:
  #None in the region
  #   1 = > 100000 
  # only a small trace 
  # 2 = 10000 - 100000
  # main stem rivers 
  # 3 = 1000 - 10000 
  # 4 = 100 - 1000 
  # 5 = 10 - 100 
  # these are tribs in the study region 
  # 6 = 1 - 10
  # 7
  # 
  # anything >7 remove because small drainages 
  unique(FFR_v4_SDMsa$RIV_ORD)
  
  
  
  Mainstream <- FFR_v4_SDMsa %>%
    filter(RIV_ORD < 6 )
  dim(Mainstream)
  #[1] 13346    35
  
  
  # transform the streams to utm
  Mainstream_utm  <- st_transform(Mainstream,  crs=32737)
  
  # Rasterize 
  Mainstream_utm$target <- 1
  rMainStemRivers_utm <- rasterize(vect(Mainstream_utm),OkvSDM_msk_900m_utm, field="target")
  
  # convert NA to 0 
  rMainStemRivers_utm[is.na(rMainStemRivers_utm)] <- 0
  rMainStemRivers_utm <- mask(rMainStemRivers_utm, OkvSDM_msk_900m_utm)
  # generate distance raster
  dMainStemRivers_utm <- gridDistance(rMainStemRivers_utm, target=1)
  
  
  
  # Reproject to WGS
  dMainStemRivers_wgs <- project(dMainStemRivers_utm, "EPSG:4326")
  dMainStemRivers_wgs2<- resample(dMainStemRivers_wgs,OkvSDM_msk_900m, method="bilinear")
  
  
  
  writeRaster( dMainStemRivers_wgs2, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//dRivermainstem_900m.tif", overwrite=T)
  
  
  dRivermainstem_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//dRivermainstem_900m.tif")
  
  
  writeRaster(dRivermainstem_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//dRivermainstem.asc")
  
  
  
  # %%%%%%%%  Tributaries %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  Trib <- FFR_v4_SDMsa %>%
    filter(RIV_ORD %in% c(6,7)) 
  
  dim(Trib)
  #[1] 73296    35
  
  
  # transform the streams to utm
  Trib_utm  <- st_transform(Trib,  crs=32737)
  
  # Rasterize 
  Trib_utm$target <- 1
  rTribRivers_utm <- rasterize(vect(Trib_utm),OkvSDM_msk_900m_utm, field="target")
  
  # convert NA to 0 
  rTribRivers_utm[is.na(rTribRivers_utm)] <- 0
  rTribRivers_utm <- mask(rTribRivers_utm, OkvSDM_msk_900m_utm)
  # generate distance raster
  dTribRivers_utm <- gridDistance(rTribRivers_utm, target=1)
  
  
  
  # Reproject to WGS
  dTribRivers_wgs <- project(dTribRivers_utm, "EPSG:4326")
  dTribRivers_wgs2<- resample(dTribRivers_wgs,OkvSDM_msk_900m, method="bilinear")
  
  
  
  writeRaster( dTribRivers_wgs2, "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//dRiverTrib_900m.tif", overwrite=T)
  
  
  dRiverTrib_900m <- rast( "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//dRiverTrib_900m.tif")
  
  
  writeRaster(dRiverTrib_900m , "C://Users//anne.trainor.TNC//Box//AO - Okavango-Zambezi PA Conservation Planning//Terrestrial_Initiative//1OngoingSpatialDataProduction//Biodiversity//EnvironData//ascii//dRiverTrib.asc")
  
  