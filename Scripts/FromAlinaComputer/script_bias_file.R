# script to make bias files
# alina zeng
# Feb 16, 2023


install.packages("dismo","MASS","magrittr","maptools")
library(dismo) # interface with MaxEnt
library(raster) # spatial data manipulation
library(MASS) # for 2D kernel density function
library(magrittr) # for piping functionality, i.e., %>%
library(maptools) # reading shapefiles
library(sf)
library(terra)

install.packages("rJava")
library("rJava")

# add data
kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")
# introducing the mask here so the raster of the occurences can share the same resolution
kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")
occurence <- read.csv("input/SElephant_MGiraffe_GZebra_Kenya_Moll_Cleaned.csv", header = TRUE)

# experiment with just one species
occur_EquusGrevyi <- subset(occurence,occurence$species == "Equus grevyi")
occur_EquusGrevyi <- dplyr::select(occur_EquusGrevyi , -species)
# plot(occur_EquusGrevyi)
occurEG.ras <- rasterize(occur_EquusGrevyi, kenya_mask500, 1)

# make bias file
presences <- which(values(occurEG.ras) == 1)
pres.locs <- coordinates(occurEG.ras)[presences, ]
dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurEG.ras), ncol(occurEG.ras)), 
              lims = c(3398436,4192936,-578268.9,669231.1))
dens.ras <- raster(dens)
# extend extent (no need)
# dens.ras = extend(dens.ras, kenya_mask500,7.502362e-99)
# crop using boundary
dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)

plot(dens.ras)
writeRaster(dens.ras, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/TIFFs/bias_file_EquusGrevyi.tif", overwrite=TRUE)

# dens.ras <- aggregate(dens.ras, fact=2)  ## By default aggregates using mean, but see fun=
# writeRaster(dens.ras, "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs/bias_file_EquusGrevyi.asc", format="ascii")


# hmmm i dont have brain to run things in a loop today, so will just do the first 3 mannually

occur_LoxodontaAfricana <- subset(occurence,occurence$species == "Loxodonta africana")
occur_LoxodontaAfricana <- dplyr::select(occur_LoxodontaAfricana , -species)
plot(occur_LoxodontaAfricana)
occurEG.ras <- rasterize(occur_LoxodontaAfricana, kenya_mask500, 1)

# make bias file
presences <- which(values(occurEG.ras) == 1)
pres.locs <- coordinates(occurEG.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurEG.ras), ncol(occurEG.ras)))
dens.ras <- raster(dens)

# extend extent
dens.ras = extend(dens.ras, kenya_mask500,3.389688e-38)
# crop using boundary
dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
plot(dens.ras)
writeRaster(dens.ras, "bias_file_LoxodontaAfricana.tif")



occur_GiraffaTippelskirchi <- subset(occurence,occurence$species == "Giraffa tippelskirchi")
occur_GiraffaTippelskirchi <- dplyr::select(occur_GiraffaTippelskirchi , -species)
plot(occur_GiraffaTippelskirchi)
occurEG.ras <- rasterize(occur_GiraffaTippelskirchi, kenya_mask500, 1)

# make bias file
presences <- which(values(occurEG.ras) == 1)
pres.locs <- coordinates(occurEG.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurEG.ras), ncol(occurEG.ras)))
dens.ras <- raster(dens)

# extend extent
dens.ras = extend(dens.ras, kenya_mask500,9.367293e-32) #find min of dens.ras
# crop using boundary
dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
plot(dens.ras)
writeRaster(dens.ras, "bias_file_GiraffaTippelskirchi.tif")

