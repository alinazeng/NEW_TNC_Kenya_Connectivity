library(raster)
library(rgdal)
library(sp)
library(sf)
library(stringr)

# Kenya boundary polygon
kenya <- st_read(dsn = "C:/Users/Vania/OneDrive - The University Of British Columbia/WL 2022 Kenya/Inputs/Kenya_Boundary_Moll",layer = "Kenya_boundary_moll")
plot(kenya)

# Kenya 500m mask
rastermask <- raster("C:/Users/Vania/OneDrive - The University Of British Columbia/WL 2022 Kenya/Inputs/Mask/Kenya_500m_raster.tif")
crs(rastermask)

# Grab all the file names
tavg_files <- list.files("C:/Users/Vania/OneDrive - The University Of British Columbia/WL 2022 Kenya/Old EV/Temperature/Worldclim/wc2.1_30s_tavg", pattern = ".tif", full.names = TRUE)
tavg_files

# Set folder for output
outputdir <- "C:/Users/Vania/OneDrive - The University Of British Columbia/WL 2022 Kenya/Old EV/Temperature/Worldclim/Projected"
setwd(outputdir)

# Project raster
for (i in 1:length(tavg_files)){
  tavg_name <- str_sub(tavg_files[i],-11)
  tavg_toproj <- raster(tavg_files[i]) # brings in the raster file into R
  projectRaster(tavg_toproj, rastermask, method="ngb", # project based on mask using nearest neighbor
                alignOnly=FALSE, over=FALSE, 
                filename=tavg_name, format = "GTiff")
}

# Grab rasters from the output folder and turn them into a stack
tavg_stack <- stack(list.files("C:/Users/Vania/OneDrive - The University Of British Columbia/WL 2022 Kenya/Old EV/Temperature/Worldclim/Projected", pattern = ".tif", full.names = TRUE))

# Crop the stack based on Kenya boundary
tavg_s_ken <- tavg_stack %>% crop(kenya) %>% mask(kenya)
plot(tavg_s_ken)

# Find the average for the stack
tavg_s_avg <- terra::mean(tavg_s_ken)
plot(tavg_s_avg)

# Export raster 
raster::writeRaster(tavg_s_avg, filename = "Kenya_tavg", bylayer = TRUE, overwrite = TRUE, format = "GTiff")
