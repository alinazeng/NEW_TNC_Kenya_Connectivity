# script_stats_pixel_methods

# Libraries needed for formatting and tidying data ----
library(dplyr)
library(tidyr)
library(Cairo)
library(ggplot2)
packages <- c(
  'emmeans',   #least square means - compare the statuss
  'Rmisc'  #function summarySE
)
if(sum(as.numeric(!packages %in% installed.packages())) != 0){
  instalador <- packages[!packages %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(packages, require, character = T) 
} else {
  sapply(packages, require, character = T) 
}

# import raw data ----
zone2_global <- read.csv("output/stats_zone2_global.csv", header = TRUE)
zone2_national <- read.csv("output/stats_zone2_national.csv", header = TRUE)
zone3_global <- read.csv("output/stats_zone3_global.csv", header = TRUE)
zone3_national <- read.csv("output/stats_zone3_national.csv", header = TRUE)

# change format
og_routes_zone2_global <- dplyr::select(zone2_global, mean_route)
random_pixel_zone2_global <- dplyr::select(zone2_global, mean)
og_routes_zone2_global$identifier <- (1:100)
random_pixel_zone2_global$identifier <- (1:length(random_pixel_zone2_global$mean))
og_routes_zone2_global$status <- "original route"
random_pixel_zone2_global$status <- "random pixel"
og_routes_zone2_national <- dplyr::select(zone2_national, mean_route)
random_pixel_zone2_national <- dplyr::select(zone2_national, mean)
og_routes_zone2_national$identifier <- (1:100)
random_pixel_zone2_national$identifier <- (1:length(random_pixel_zone2_national$mean))
og_routes_zone2_national$status <- "original route"
random_pixel_zone2_national$status <- "random pixel"


#need to change column name before join
og_routes_zone2_global$mean <- og_routes_zone2_global$mean_route
og_routes_zone2_global <- dplyr::select(og_routes_zone2_global, -mean_route)
og_routes_zone2_national$mean <- og_routes_zone2_national$mean_route
og_routes_zone2_national <- dplyr::select(og_routes_zone2_national, -mean_route)

#join
mean_global_pixel_zone2 <- full_join(og_routes_zone2_global, random_pixel_zone2_global)
#mean_global_pixel_zone2 <- full_join(mean_global_pixel_zone2, random_pixel_zone2_global)
#mean_global_pixel_zone2 <- full_join(mean_global_pixel_zone2, random_pixel_zone2_global)
#mean_global_pixel_zone2 <- full_join(mean_global_pixel_zone2, random_pixel_zone2_global)
#mean_global_pixel_zone2 <- full_join(mean_global_pixel_zone2, random_pixel_zone2_global)\

mean_national_pixel_zone2 <- full_join(og_routes_zone2_national, random_pixel_zone2_national)


# linear model
# m_mean_global_pixels_zone2 <- lm(mean ~ mean_route, data = zone2_global, na.action=na.omit)
# m_mean_national_pixels_zone2 <- lm(mean ~ mean_route, data = zone2_national, na.action=na.omit)

m_mean_global_pixel_zone2  <- lm(mean ~ status*identifier, data = mean_global_pixel_zone2, na.action=na.omit)
m_mean_national_pixel_zone2 <- lm(mean ~ status*identifier, data = mean_national_pixel_zone2, na.action=na.omit)

emmeans(m_mean_global_pixel_zone2, ~ status)
# status         emmean    SE  df lower.CL upper.CL
# original route   1380 2.357 196     1376     1385
# random pixel     1374 2.357 196     1369     1378

lm_pixel_method_global_zone2 <- as.data.frame(pairs(emmeans(m_mean_global_pixel_zone2, ~ status|identifier))) #
lm_pixel_method_global_zone2 $statistically_sig <- ifelse(lm_pixel_method_global_zone2$p.value < 0.05, "YES","NO") 
table(lm_pixel_method_global_zone2$statistically_sig)

lm_pixel_method_global_zone2 <- as.data.frame(pairs(m_mean_global_pixel_zone2, ~ status|identifier))
