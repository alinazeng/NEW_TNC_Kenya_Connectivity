# resample
# alina zeng
# Feb 16, 2023

#### Library#########
library(sf)
library(terra)
library(raster) # spatial data manipulation
######################

kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")


# read in enviromental raster
env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]

s@ptr[["names"]]
# [1] "crop"                           "eucdist_conservancies"         
# [3] "eucdist_nationalnetwork"        "eucdist_roads"                 
# [5] "kenya_dem_90m"                  "kenya_ndvi_dry_mean"           
# [7] "kenya_ndvi_dry_median"          "kenya_ndvi_gen_mean"           
# [9] "kenya_ndvi_gen_median"          "kenya_ndvi_wet_mean"           
# [11] "kenya_ndvi_wet_median"          "kenya_tavg"                    
# [13] "kenya_tavg_dry"                 "kenya_tri"                     
# [15] "population_density"             "precipitation_dry_20102020"    
# [17] "precipitation_general_20102020" "precipitation_wet_20102020"    
# [19] "x_bias_file_loxodontaafricana" 
# [20] "x_kenya_tavg_wet.asc"  
# [21] "xx_eucdist_lakes"               "xx_eucdist_roads_primary"      
# [23] "xxx_eucdist_riverlake_combined" "xxx_eucdist_roadsALL_new"      
# [25] "xxx_eucdist_wetlands" "xxxx_eucdist_roads_notertiary" 
# [27] "y_lulc_esa_2015"  "y_percent_deciduous_open" 
# [29] "yy_human_density"


base_rst <- s[[2]]


# human_density
human_density<- resample(s[[29]],base_rst, method="bilinear")
# replacing NA's by-9999
human_density [is.na(human_density)] <- -9999 
# writeRaster
writeRaster(human_density,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/human_density.asc", overwrite=TRUE)

# # percent_deciduous_open
# percent_deciduous_open<- resample(s[[28]],base_rst, method="bilinear")
# # replacing NA's by-9999
# percent_deciduous_open [is.na(percent_deciduous_open)] <- -9999 
# # writeRaster
# writeRaster(percent_deciduous_open,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/percent_deciduous_open.asc", overwrite=TRUE)

# lulc_esa_2015
lulc_esa_2015<- resample(s[[27]],base_rst, method="bilinear")
# replacing NA's by-9999
lulc_esa_2015 [is.na(lulc_esa_2015)] <- -9999 
# writeRaster
writeRaster(lulc_esa_2015,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/lulc_esa_2015.asc", overwrite=TRUE)


# lulc_esa_2015
lulc_esa_2015<- resample(s[[27]],base_rst, method="sum") # using method "sum" to calculate percentage
# replacing NA's by-9999
lulc_esa_2015 [is.na(lulc_esa_2015)] <- -9999 
# writeRaster
writeRaster(lulc_esa_2015,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/lulc_esa_2015_2.0.asc", overwrite=TRUE)



# xxx_eucdist_riverlake_combined
eucdist_riverlake_combined<- resample(s[[23]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_riverlake_combined [is.na(eucdist_riverlake_combined)] <- -9999 
# writeRaster
writeRaster(eucdist_riverlake_combined,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_riverlake_combined.asc", overwrite=TRUE)

# xxx_eucdist_roadsALL_new
eucdist_roadsALL_new<- resample(s[[24]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_roadsALL_new [is.na(eucdist_roadsALL_new)] <- -9999 
# writeRaster
writeRaster(eucdist_roadsALL_new,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_roadsALL_new.asc", overwrite=TRUE)


# xxx_eucdist_wetlands
eucdist_wetlands<- resample(s[[25]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_wetlands [is.na(eucdist_wetlands)] <- -9999 
# writeRaster
writeRaster(eucdist_wetlands,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_wetlands.asc", overwrite=TRUE)


# eucdist_roads_notertiary
eucdist_roads_notertiary<- resample(s[[26]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_roads_notertiary [is.na(eucdist_roads_notertiary)] <- -9999 
# writeRaster
writeRaster(eucdist_roads_notertiary,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_roads_notertiary.asc", overwrite=TRUE)

# eucdist_lakes
eucdist_lakes<- resample(s[[21]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_lakes [is.na(eucdist_lakes)] <- -9999 
# writeRaster
writeRaster(eucdist_lakes,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_lakes.asc", overwrite=TRUE)

# xx_eucdist_roads_primary
eucdist_roads_primary<- resample(s[[22]],base_rst, method="bilinear")
# replacing NA's by-9999
eucdist_roads_primary [is.na(eucdist_roads_primary)] <- -9999 
# writeRaster
writeRaster(eucdist_roads_primary,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/eucdist_roads_primary.asc", overwrite=TRUE)
# dry precipitation
precipitation_dry_20102020<- resample(s[[16]],base_rst, method="bilinear")
# replacing NA's by-9999
precipitation_dry_20102020 [is.na(precipitation_dry_20102020)] <- -9999 
# writeRaster
writeRaster(precipitation_dry_20102020,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/precipitation_dry_20102020.asc", overwrite=TRUE)
writeRaster(crops,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/crops22.asc", overwrite=TRUE)

# wet precipitation
precipitation_wet_20102020<- resample(s[[18]],base_rst, method="bilinear")
# replacing NA's by-9999
precipitation_wet_20102020 [is.na(precipitation_wet_20102020)] <- -9999 
# writeRaster
writeRaster(precipitation_wet_20102020,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/precipitation_wet_20102020.asc", overwrite=TRUE)

# ndvi
# kenya_ndvi_dry_mean
kenya_ndvi_dry_mean<- resample(s[[6]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_dry_mean [is.na(kenya_ndvi_dry_mean)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_dry_mean,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_dry_mean.asc", overwrite=TRUE)


# kenya_ndvi_wet_mean
kenya_ndvi_wet_mean<- resample(s[[10]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_wet_mean [is.na(kenya_ndvi_wet_mean)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_wet_mean,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_wet_mean.asc", overwrite=TRUE)


# kenya_ndvi_dry_median
kenya_ndvi_dry_median<- resample(s[[7]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_dry_median [is.na(kenya_ndvi_dry_median)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_dry_median,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_dry_median.asc", overwrite=TRUE)

# kenya_ndvi_wet_median
kenya_ndvi_wet_median<- resample(s[[11]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_wet_median [is.na(kenya_ndvi_wet_median)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_wet_median,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_wet_median.asc", overwrite=TRUE)

# kenya_ndvi_gen_median
kenya_ndvi_gen_median<- resample(s[[9]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_gen_median [is.na(kenya_ndvi_gen_median)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_gen_median,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_gen_median.asc", overwrite=TRUE)

# kenya_ndvi_gen_mean
kenya_ndvi_gen_mean<- resample(s[[8]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_ndvi_gen_mean [is.na(kenya_ndvi_gen_mean)] <- -9999 
# writeRaster
writeRaster(kenya_ndvi_gen_mean,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/ndvi_gen_mean.asc", overwrite=TRUE)

# kenya_tavg_dry
kenya_tavg_dry<- resample(s[[13]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_tavg_dry [is.na(kenya_tavg_dry)] <- -9999 
# writeRaster
writeRaster(kenya_tavg_dry,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/ASC_Resampled/tavg_dry.asc", overwrite=TRUE)



# kenya_tavg_wet
kenya_tavg_wet<- resample(s[[20]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_tavg_wet [is.na(kenya_tavg_wet)] <- -9999 
# writeRaster
writeRaster(kenya_tavg_wet,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC_Resampled/tavg_wet.asc", overwrite=TRUE)


# bias files
# bias_file_loxodontaafricana
bias_file_loxodontaafricana<- resample(s[[19]],base_rst, method="bilinear")
# replacing NA's by-9999
bias_file_loxodontaafricana [is.na(bias_file_loxodontaafricana)] <- -9999 
# writeRaster
writeRaster(bias_file_loxodontaafricana,"C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Output/Bias File/resampled/bias_file_loxodontaafricana.asc", overwrite=TRUE)



