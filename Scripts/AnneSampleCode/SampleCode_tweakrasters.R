
#### Library#########
library(sf)
library(terra)
######################



Kn_msk_900m <- rast( "C://Users//anne.trainor.TNC//Box//Kenya PFP Feasibility Assessment//Conservation Planning WT//KenyaConnectivity_UBC//SpatialData//Mask//Ken_msk_500m_NEW//Kenya_500m_raster.tif")


# read in enviromental raster

env.ls = list.files( path="C://Users//anne.trainor.TNC//Box//Kenya PFP Feasibility Assessment//Conservation Planning WT//KenyaConnectivity_UBC//SpatialData//Enviro4Maxent\\ASC\\ACS_Resampled\\",pattern= "\\.asc$", full.names=TRUE);env.ls


s <- rast(env.ls)

base_rst <- s[[2]]

# croplands
crops <- resample(s[[1]],base_rst, method="bilinear")
# replacing NA's by-9999
crops [is.na(crops)] <- -9999 
# writeRaster
writeRaster(crops,"C://Users//anne.trainor.TNC//Box//Kenya PFP Feasibility Assessment//Conservation Planning WT//KenyaConnectivity_UBC//SpatialData//Enviro4Maxent\\ASC\\testRun\\crops.asc", overwrite=TRUE)


# kenya_tavg
kenya_tavg<- resample(s[[7]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_tavg [is.na(kenya_tavg)] <- -9999 
# writeRaster
writeRaster(kenya_tavg,"C://Users//anne.trainor.TNC//Box//Kenya PFP Feasibility Assessment//Conservation Planning WT//KenyaConnectivity_UBC//SpatialData//Enviro4Maxent\\ASC\\testRun\\kenya_tavg.asc", overwrite=TRUE)

# map_2010_2020
map_2010_2020<- resample(s[[9]],base_rst, method="bilinear")
# replacing NA's by-9999
map_2010_2020 [is.na(map_2010_2020)] <- -9999 
# writeRaster
writeRaster(map_2010_2020,"C://Users//anne.trainor.TNC//Box//Kenya PFP Feasibility Assessment//Conservation Planning WT//KenyaConnectivity_UBC//SpatialData//Enviro4Maxent\\ASC\\testRun\\map_2010_2020.asc", overwrite=TRUE)




# 
# 
  cor <- layerCor(s, "pearson", na.rm=T)
  