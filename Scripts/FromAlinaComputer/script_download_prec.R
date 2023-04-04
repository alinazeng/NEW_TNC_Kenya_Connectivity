# download precipitation data and plot
# alina & vania
# Nov-10-2022


# download data
year<-seq(from = 1981, to = 2021)

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
install.packages("R.utils")
library(R.utils)
file_list<- list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz", pattern = "*.gz", full.names = TRUE)

for (i in 1:length(file_list)){
 gunzip(file_list[i])}
  
# stacking tif files
install.packages("raster")
library(raster)

# month <- c("01","02","03","04","05","06","07","08","09","10","11","12")

s_jan <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".01.tif", full.names = TRUE))
s_feb <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".02.tif", full.names = TRUE))
s_mar <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".03.tif", full.names = TRUE))
s_apr <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".04.tif", full.names = TRUE))
s_may <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".05.tif", full.names = TRUE))
s_jun <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".06.tif", full.names = TRUE))
s_jul <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".07.tif", full.names = TRUE))
s_aug <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".08.tif", full.names = TRUE))
s_sep <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".09.tif", full.names = TRUE))
s_oct <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".10.tif", full.names = TRUE))
s_nov <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".11.tif", full.names = TRUE))
s_dec <- stack(list.files("C:/Users/azzeng.stu/Desktop/Precipitation/Input/prec_1981_2021_gz/", pattern = ".12.tif", full.names = TRUE))

                        
                     
# average
install.packages("terra")
install.packages("rgdal")
install.packages("RColorBrewer")
library(terra)
library(rgdal)

mean_jan <- terra::mean(s_jan)
mean_feb <- terra::mean(s_feb)
mean_mar <- terra::mean(s_mar)
mean_apr <- terra::mean(s_apr)
mean_may <- terra::mean(s_may)
mean_jun <- terra::mean(s_jun)
mean_jul <- terra::mean(s_jul)
mean_aug <- terra::mean(s_aug)
mean_sep <- terra::mean(s_sep)
mean_oct <- terra::mean(s_oct)
mean_nov <- terra::mean(s_nov)
mean_dec <- terra::mean(s_dec)

# crop, mask, convert to df
install.packages("sp")
install.packages("sf")
library(sp)
library(sf)
library(ggplot2)

kenya<-st_read(dsn = "C:/Users/azzeng.stu/Desktop/Precipitation/Input/kenya_shapefiles",layer = "gadm41_KEN_0")

# function: convert raster to a datafram 
rasterdf <- function(x, aggregate = 1) {
  resampleFactor <- aggregate        
  inputRaster <- x    
  inCols <- ncol(inputRaster)
  inRows <- nrow(inputRaster)
  # Compute numbers of columns and rows in the new raster for mapping
  resampledRaster <- raster(ncol=(inCols / resampleFactor), 
                            nrow=(inRows / resampleFactor))
  # Match to the extent of the original raster
  extent(resampledRaster) <- extent(inputRaster)
  # Resample data on the new raster
  y <- resample(inputRaster,resampledRaster,method='ngb')
  
  # Extract cell coordinates into a data frame
  coords <- xyFromCell(y, seq_len(ncell(y)))
  # Extract layer names
  dat <- stack(as.data.frame(getValues(y)))
  # Add names - 'value' for data, 'variable' to indicate different raster layers
  # in a stack
  names(dat) <- c('value', 'variable')
  dat <- cbind(coords, dat)
  dat
}

# Call the rasterdf funciton to convert raster into dataframe for ggplot
mean_jan_kenya <- s_jan %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf() 
mean_feb_kenya <- s_feb %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_mar_kenya <- s_mar %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_apr_kenya <- s_apr %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_may_kenya <- s_may %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_jun_kenya <- s_jun %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_jul_kenya <- s_jul %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_aug_kenya <- s_aug %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_sep_kenya <- s_sep %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_oct_kenya <- s_oct %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_nov_kenya <- s_nov %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()
mean_dec_kenya <- s_dec %>% terra::mean() %>% crop(kenya) %>% mask(kenya) %>% rasterdf()

# add column
mean_jan_kenya$month <- "January"
mean_feb_kenya$month <- "February"
mean_mar_kenya$month <- "March"
mean_apr_kenya$month <- "April"
mean_may_kenya$month <- "May"
mean_jun_kenya$month <- "June"
mean_jul_kenya$month <- "July"
mean_aug_kenya$month <- "August"
mean_sep_kenya$month <- "September"
mean_oct_kenya$month <- "October"
mean_nov_kenya$month <- "November"
mean_dec_kenya$month <- "December"

# combine dataframe
install.packages("dplyr")
all_month <- rbind(mean_jan_kenya[,c(1,2,3,5)], mean_feb_kenya[,c(1,2,3,5)],
                       mean_mar_kenya[,c(1,2,3,5)],
                       mean_apr_kenya[,c(1,2,3,5)],
                       mean_may_kenya[,c(1,2,3,5)] ,
                       mean_jun_kenya[,c(1,2,3,5)],
                       mean_jul_kenya[,c(1,2,3,5)] ,
                       mean_aug_kenya[,c(1,2,3,5)] ,
                       mean_sep_kenya[,c(1,2,3,5)] ,
                       mean_oct_kenya[,c(1,2,3,5)] ,
                       mean_nov_kenya[,c(1,2,3,5)],
                       mean_dec_kenya[,c(1,2,3,5)])


# plot
order <- c("January","February","March"
           ,"April"
           , "May"
           ,"June"
           ,"July"
           ,"August"
           , "September"
           , "October"
           ,"November"
           , "December"
)

all_month$month <- factor(all_month$month, level = order   )

# export
write.csv(all_month,"all_month_19812021.csv")


# plot
install.packages("Cairo")
library(Cairo)


  png(filename = "prec_mean_19812021.png",
      type ="cairo",
      units = "in",
      width = 12,
      height = 10,
      res = 300)

  ggplot() +
  geom_raster(data =  all_month, aes(x = x, y = y, fill = value)) +
 geom_sf(data=kenya, fill=NA,color="grey50", size=0.25) +
  #  https://tmieno2.github.io/R-as-GIS-for-Economists/color-scale.html
  #scale_fill_viridis_c(option="D",direction = -1,na.value="white",name = "Total Prec (mm)")+ 
  scale_fill_viridis_c(option="D",direction = -1,na.value="white",name = "Precipitation (mm)")+ 
  coord_sf(expand = F) +
  facet_wrap(~ month,nrow=3, ncol = 4, labeller = labeller(variable = label_wrap_gen(10)))+ 
  labs(title = "Historical Precipitation Mean (1981 - 2021)") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank())

dev.off()

ggsave(all_month_plot, "prec_mean_19812021.png")




values(jan_mean)
max(values(test))
mean_jan[mean_jan<0]<--0.00001


[1] 967.5994
test[test<0]<--100

cuts <- c(0,  10 , 20,  30,  40 , 50 , 60,  70 , 80 , 90 ,100, 200, 300, 400,500,600,700,800,900,1000)

cuts <- c(0,  10 , 20,  30,  40 , 50 , 60,  70 , 80 , 90 ,100)

cuts <- seq(0,400,20)

pal <- colorRampPalette(c("green","orange", "red"))
pal <- colorRampPalette("Blue Sequential")

plot(jan_mean, breaks=cuts, col = pal(11))


seq(from=100,to=200, by=10)


max(values(test))
