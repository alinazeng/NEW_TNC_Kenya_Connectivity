# script to make average annual precipitation raster
# alina zeng
# January 17, 2023


library(R.utils)
library(sp)
library(sf)
library(raster)
library(terra)
library(rgdal)


# download data
year<-seq(from = 2010, to = 2020)

for (i in 1:length(year)){
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".01.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".02.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".03.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".04.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".05.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".06.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".07.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".08.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".09.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".10.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".11.tif.gz"))
  browseURL(paste0("https://data.chc.ucsb.edu/products/CHIRPS-2.0/africa_monthly/tifs/chirps-v2.0.",year[i],".12.tif.gz"))}


# unzip everything
file_list<- list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "*.gz", full.names = TRUE)

for (i in 1:length(file_list)){
  gunzip(file_list[i])}

# stacking tif files
# since we are now only concerned about annual average... 
# group by year first? then take average?


s_2010 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2010", full.names = TRUE))
s_2011 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2011", full.names = TRUE))
s_2012 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2012", full.names = TRUE))
s_2013 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2013", full.names = TRUE))
s_2014 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2014", full.names = TRUE))
s_2015 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2015", full.names = TRUE))
s_2016 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2016", full.names = TRUE))
s_2017 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2017", full.names = TRUE))
s_2018 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2018", full.names = TRUE))
s_2019 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2019", full.names = TRUE))
s_2020 <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = "2020", full.names = TRUE))


# take average to get the MAP of each year

# average
mean_2010 <- terra::mean(s_2010)
mean_2011 <- terra::mean(s_2011)
mean_2012 <- terra::mean(s_2012)
mean_2013 <- terra::mean(s_2013)
mean_2014 <- terra::mean(s_2014)
mean_2015 <- terra::mean(s_2015)
mean_2016 <- terra::mean(s_2016)
mean_2017 <- terra::mean(s_2017)
mean_2018 <- terra::mean(s_2018)
mean_2019 <- terra::mean(s_2019)
mean_2020 <- terra::mean(s_2020)

# take average of all years from 2010-2020
# stack first, and then take average

files = c(mean_2010, mean_2011, mean_2012, mean_2013, mean_2014, mean_2015, mean_2016,
         mean_2017, mean_2018, mean_2019, mean_2020)

all_year <- stack(files)


kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")
kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")


# Project raster
all_year <- projectRaster(all_year, kenya_mask500, method="ngb", # project based on mask using nearest neighbor
                          alignOnly=FALSE, over=FALSE, format = "GTiff")

mean_2010_2020 <- terra::mean(all_year)

# use shapefile to delineate boundary
MeanAnnualPrecipitation_20102020_Clipped <-  mean_2010_2020 %>% crop(kenya_bound) %>% mask(kenya_bound)

writeRaster(MeanAnnualPrecipitation_20102020_Clipped, "MAP_2010_2020_500m.tif")

# hmmmm aiya dry/wet code didn't get saved
# basically I stacked jan, feb, jun, sept into dry, and mar, may, oct, dec into wet, took average, resampled those, cropped. 




# need to redo this....

jan <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".01.tif", full.names = TRUE))
feb <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".02.tif", full.names = TRUE))
mar <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".03.tif", full.names = TRUE))
apr <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".04.tif", full.names = TRUE))
may <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".05.tif", full.names = TRUE))
jun <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".06.tif", full.names = TRUE))
jul <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".07.tif", full.names = TRUE))
aug <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".08.tif", full.names = TRUE))
sep <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".09.tif", full.names = TRUE))
oct <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".10.tif", full.names = TRUE))
nov <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".11.tif", full.names = TRUE))
dec <- stack(list.files("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/prec_2010_2020_gz", pattern = ".12.tif", full.names = TRUE))

# jan-feb, jun-sept
# mar-may, oct-dec
dry <- stack(jan, feb, jun, jul, aug, sep)
wet <- stack(mar, apr, may, oct, nov, dec)

kenya_bound <-st_read(dsn = "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_shapefiles",layer = "Kenya_Boundary_fromRaster")
kenya_mask500 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/kenya_mask/Kenya_500m_raster.tif")


# Project raster
l