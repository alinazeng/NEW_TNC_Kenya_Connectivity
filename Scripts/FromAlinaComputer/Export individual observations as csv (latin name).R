# Exporting individual species into separate files based on latin names
# Vania
# Feb 28, 2023

library(tidyverse)
library(terra)
library(stringr)

# Set output directory
outputdir_sample <- "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/CSV/ScientificNames"

# Import data
largemammal <- vect("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/All Large Mammals (Projected)/AllLargeMammals_Project.shp")

# Convert largemammal into a dataframe
largemammaldf <- as.data.frame(largemammal)

# List focal species
focalsp_list <- largemammal %>%
  as.data.frame() %>%
  filter(largemammal$topSpecies == "Yes") %>%
  dplyr::select(species) %>%
  dplyr::distinct(species,.keep_all = TRUE)

# Export observations of each species
for (i in 1:nrow(focalsp_list)){
  focalsp <- focalsp_list[i,] # Get individual focal species
  f <- which(largemammaldf$species == focalsp) # Get the rows corresponding to foc. sp.
  focalsp <- str_replace_all(focalsp, " ", "") # Remove space between genus and species
  
  focalspdf <- largemammaldf[f, ] # Get the observations of foc. sp.
  focalspdf <- focalspdf[,c("species", "x", "y")] # Keep only the species, x, and y columns
  write.csv(focalspdf, file = paste0(outputdir_sample,focalsp,"_obs.csv"), row.names = FALSE)
}
