# Preparing samples and background points based on season
# Vania
# Created Mar 8, 2023
# Updated Mar 27, 2023

# Load packages
library(tidyverse)
library(terra)

# Set output directory
out_sample <- "C:/TNC_Connectivity_AlinaVania/SampleV/"
out_bg <- "C:/TNC_Connectivity_AlinaVania/Background/"

# Import data
## Large mammal observations
largemammal <- vect("C:/TNC_Connectivity_AlinaVania/Data/Observations/AllLargeMammalsKenya_Project.shp")
## Kenya mask
rastermask <- rast("C:/TNC_Connectivity_AlinaVania/Data/Mask/Kenya_500m_raster.tif")

# Set season ("Wet" or "Dry")
wetordry <- "Dry"

# Get a list of focal species common names
focalsp_list <- largemammal %>%
  as.data.frame() %>% # Convert to dataframe
  filter(topSpecies == "Yes" & season == wetordry) %>% # Keep observations that are top species and match the season
  dplyr::select(commonName) %>% # Keep only the common name column
  distinct(commonName,.keep_all = TRUE) # Get a list of unique common names

# Prepare background points for each species ----
for (i in 1:nrow(focalsp_list)){
  # Prepare focal species observations
  focalsp <- focalsp_list[i,] # Get individual focal species
  f <- which(largemammal$commonName == focalsp & largemammal$season == wetordry) # Get the rows corresponding to foc. sp. + season
  
  focalsp_obs <- largemammal[f, ] # Get the observations of foc. sp.
  focalsp_rast <- terra::rasterize(focalsp_obs,rastermask,fun=length) # Rasterize foc. sp. observations
  focalsp_rast_poly <- as.polygons(focalsp_rast, dissolve = TRUE, na.rm = TRUE) # Convert foc.sp. raster to polygon since we can't erase with raster
  
  # Prepare background point observations 
  b <- which(largemammal$season == wetordry) # Get the rows corresponding to all large mammals in the season
  bg_obs <- largemammal[b, ] # Get all observations based on season
  s <- which(bg_obs$commonName == focalsp)
  bg_obs <- bg_obs[-s, ] # Get all other observations aside from foc. sp.
  bg_obs_erased <- terra::erase(bg_obs, focalsp_rast_poly) # Erase background points that fall in the same cells as foc. sp.
  
  # Export background points as shp
  writeVector(bg_obs_erased, paste0(out_bg,wetordry,"/SHP/",focalsp,"_bg_",wetordry,".shp"), filetype=NULL, overwrite = TRUE)
  
  # Export background points as csv
  bg_df <- as.data.frame(bg_obs_erased) # Convert to dataframe
  bg_df <- bg_df[,c("species", "x", "y")] # Keep only the species, x, and y columns
  focalsp <- str_replace_all(focalsp, " ","") # Remove all spaces in common name
  write.csv(bg_df, file = paste0(out_bg,wetordry,"/CSV/",focalsp,"_bg_",wetordry,".csv"), row.names = FALSE)
}


# Export observations (sample points) of each species based on season ----
for (i in 1:nrow(focalsp_list)){
  # Prepare focal species observations
  focalsp <- focalsp_list[i,] # Get individual focal species
  f <- which(largemammal$commonName == focalsp & largemammal$season == wetordry) # Get the rows corresponding to foc. sp. + season
  focalsp_obs <- largemammal[f, ] # Get the observations of foc. sp.
 
  # Export sample points as shp
  writeVector(focalsp_obs, paste0(out_sample,wetordry,"/SHP/",focalsp,"_obs_",wetordry,".shp"), filetype=NULL, overwrite = TRUE)

  # Export sample points as csv
  s_df <- as.data.frame(focalsp_obs) # Convert to dataframe
  s_df <- s_df[,c("species", "x", "y")] # Keep only the species, x, and y columns
  focalsp <- str_replace_all(focalsp, " ","") # Remove all spaces in common name
  write.csv(s_df, file = paste0(out_sample,wetordry,"/CSV/",focalsp,"_obs_",wetordry,".csv"), row.names = FALSE)
}
