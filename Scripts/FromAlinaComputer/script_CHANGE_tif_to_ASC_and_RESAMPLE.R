env.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/EV_ASC",pattern= ".asc$", full.names=TRUE)
s <- rast(env.ls)
base_rst <- s[[2]]

# try resampling and exporting as asciis
# hmmm this "list" was after splitting species observations into lists based on spp
# refer to script_bias_file_loop

for (i in 1:length(list)) {  
  occurence <- as.data.frame(list[[i]])                               # Create a dataframe for each species
  name <- unique(list[[i]]$species) 
  occurence <- dplyr::select(occurence, -species)
  occurence <- dplyr::select(occurence, -Freq)
  occurence.ras <- rasterize(occurence, kenya_mask500, 1)
  # make bias file
  presences <- which(values(occurence.ras) == 1)
  pres.locs <- coordinates(occurence.ras)[presences, ]
  dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occurence.ras), ncol(occurence.ras)), 
                lims = c(3398436,4192936,-578268.9,669231.1))
  dens.ras <- raster(dens)
  # crop using boundary
  dens.ras <-  dens.ras %>% crop(kenya_bound) %>% mask(kenya_bound)
  dens.ras.resample <- terra::rast(dens.ras)
  dens.ras.resample <- raster::resample(dens.ras.resample, base_rst, method="bilinear")
  dens.ras.resample[is.na(dens.ras.resample)] <- -9999 
  writeRaster(dens.ras.resample, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs/bias_file_",name,".asc"))
}


test2 <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/precipitation_wet_2010_2020_500m.tif")

test2 <- terra::rast(test2)
  test2 <- raster::resample(test2, base_rst, method="bilinear")

  writeRaster(test2, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs/bias_file_",name,".asc"), format="ascii")
  }



kenya_tavg<- resample(s[[7]],base_rst, method="bilinear")
# replacing NA's by-9999
kenya_tavg [is.na(kenya_tavg)] <- -9999 




# March 7 2023
# values are too close to zero so I am doing multiplication so see if maxent can read them

# load in one bias file


bias_zebra <- raster("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/Dry/Grevy_sZebra_bias_Dry.asc")

bias_zebra2 <- bias_zebra*10^20
bias_zebra4 <- bias_zebra2 + 0.0000000000000000001*exp(-10)

                          

# save
writeRaster(bias_zebra4, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/bias_file__Equus_grevyi_4444.asc"), format="ascii")

writeRaster(bias_zebra4, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/ASCs_resampled/bias_file__Equus_grevyi_4444.tif"))


# okay now i know what's going on I can do all
# list files
bias.ls = list.files( path="C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/ASCs_resampled_removed0s",pattern= ".asc$", full.names=TRUE)
bias_rasters <- rast(bias.ls)
# modify...it worked
test3 <- bias_rasters*10^20 + 0.0000000000000000001*exp(-10)
# make list
bias.list <- as.list(test3)
for (i in 1:length(bias.list)) {
  #name2 <- bias.ls[i]
  writeRaster(bias.list[i], paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs/ASCs_resampled_removed0s/",name2,".asc"))
}



name.bias <- bias.ls
bias.list <- as.list(bias_rasters)


  
for (i in 1:length(bias.list)) {  
   bias.list<- bias.list[i]*10^20 + 0.0000000000000000001*exp(-10)
   name2 <- bias.ls[i]
   writeRaster(bias.list, paste("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/Bias_File/ASCs/ASCs_resampled_removed0s/",name2,".asc"))
}