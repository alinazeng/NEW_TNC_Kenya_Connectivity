# Random sampling of pixel values
# alinazengziyun@yahoo.com
# March 7 2022


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
# zone1sample <- read.csv("Input/zone1_samplearea.csv", header = TRUE)
# zone1routes <- read.csv("Input/zone1_routes.csv", header = TRUE)
zone2sample_global <- read.csv("Input/Updated/zone2_samplearea_kenya_global.csv", header = TRUE)
zone2routes_global <- read.csv("Input/Updated/zone2_routes_kenya_global.csv", header = TRUE)
zone2sample_national <- read.csv("Input/Updated/zone2_samplearea_kenya_national.csv", header = TRUE)
zone2routes_national <- read.csv("Input/Updated/zone2_routes_kenya_national.csv", header = TRUE)
zone3sample_global <- read.csv("Input/Updated/zone3_samplearea_kenya_global.csv", header = TRUE)
zone3routes_global <- read.csv("Input/Updated/zone3_routes_kenya_global.csv", header = TRUE)
zone3sample_national <- read.csv("Input/Updated/zone3_samplearea_kenya_national.csv", header = TRUE)
zone3routes_national <- read.csv("Input/Updated/zone3_routes_kenya_national.csv", header = TRUE)


mean_zone2sample_global <- mean(zone2sample_global$Value)
# [1] 1380.317
mean_zone2routes_global <- mean(zone2routes_global$Value)
# [1] 1318.702
mean_zone2sample_national <- mean(zone2sample_national$Value)
# 76140801
mean_zone2routes_national <- mean(zone2routes_national$Value)
# 75920115
mean_zone3sample_global <- mean(zone3sample_global$Value)
# [1] 1375.105
mean_zone3routes_global <- mean(zone3routes_global$Value)
# [1] 1317.864
mean_zone3sample_national <- mean(zone3sample_national$Value)
# 73267158
mean_zone3routes_national <- mean(zone3routes_national$Value)
# 74075499

# store in a vector
zone2sample_global <- zone2sample_global[,2]
zone2sample_national <- zone2sample_national[,2]
zone3sample_global <- zone3sample_global[,2]
zone3sample_national <- zone3sample_national[,2]

# randomly draw values from this, repeat for x times

test_zone2_global <- replicate(100, zone2sample_global %>% sample(233), simplify=F) # can 
test_zone2_national <- replicate(100, zone2sample_national %>% sample(2258), simplify=F)
test_zone3_global <- replicate(100, zone3sample_global %>% sample(577), simplify=F) # can 
test_zone3_national <- replicate(100, zone3sample_national %>% sample(5289), simplify=F)


# zone 2 national ----
# need an empty df first
stats_zone2_national <- data.frame(mean = numeric(), max= numeric(), min = numeric(), 
                                   ninety_pct = numeric(), sd = numeric(), 
                                   mean_route = numeric(), max_route = numeric(),
                                   min_route = numeric(),  ninety_pct_route  = numeric(),
                                   sd_route  = numeric(), zone = character())
for( i in 1:length(test_zone2_national) ){
  mean <- mean(test_zone2_national[[i]])
  min <- min(test_zone2_national[[i]])
  max <- max(test_zone2_national[[i]])
  ninety_pct <- quantile(test_zone2_national[[i]], probs = 0.9)
  sd = sd(test_zone2_national[[i]])
  mean_route <- mean(zone2sample_national)
  min_route <- min(zone2sample_national)
  max_route <- max(zone2sample_national)
  ninety_pct_route <- quantile(zone2sample_national, probs = 0.9)
  sd_route = sd(zone2sample_national)
  
  zone <- "zone2_national"
  stats_zone2_national_add <- data.frame(mean = mean, max= max, min = min, 
                                         ninety_pct = ninety_pct, sd = sd, mean_route = mean_route, 
                                         min_route = min_route, max_route = max_route, 
                                         ninety_pct_route = ninety_pct_route, sd_route = sd_route, zone = zone)
  stats_zone2_national <- rbind(stats_zone2_national, stats_zone2_national_add)
}


# zone 3 national ----
stats_zone3_national <- data.frame(mean = numeric(), max= numeric(), min = numeric(), 
                                   ninety_pct = numeric(), sd = numeric(), 
                                   mean_route = numeric(), max_route = numeric(),
                                   min_route = numeric(),  ninety_pct_route  = numeric(),
                                   sd_route  = numeric(), zone = character())
for( i in 1:length(test_zone3_national) ){
  mean <- mean(test_zone3_national[[i]])
  min <- min(test_zone3_national[[i]])
  max <- max(test_zone3_national[[i]])
  ninety_pct <- quantile(test_zone3_national[[i]], probs = 0.9)
  sd = sd(test_zone3_national[[i]])
  mean_route <- mean(zone3sample_national)
  min_route <- min(zone3sample_national)
  max_route <- max(zone3sample_national)
  ninety_pct_route <- quantile(zone3sample_national, probs = 0.9)
  sd_route = sd(zone3sample_national)
  
  zone <- "zone3_national"
  stats_zone3_national_add <- data.frame(mean = mean, max= max, min = min, 
                                         ninety_pct = ninety_pct, sd = sd, mean_route = mean_route, 
                                         min_route = min_route, max_route = max_route, 
                                         ninety_pct_route = ninety_pct_route, sd_route = sd_route, zone = zone)
  stats_zone3_national <- rbind(stats_zone3_national, stats_zone3_national_add)
}

# zone 2 global ----
# need an empty df first
stats_zone2_global <- data.frame(mean = numeric(), max= numeric(), min = numeric(), 
                                 ninety_pct = numeric(), sd = numeric(), 
                                 mean_route = numeric(), max_route = numeric(),
                                 min_route = numeric(),  ninety_pct_route  = numeric(),
                                 sd_route  = numeric(), zone = character())
for( i in 1:length(test_zone2_global) ){
  mean <- mean(test_zone2_global[[i]])
  min <- min(test_zone2_global[[i]])
  max <- max(test_zone2_global[[i]])
  ninety_pct <- quantile(test_zone2_global[[i]], probs = 0.9)
  sd = sd(test_zone2_global[[i]])
  mean_route <- mean(zone2sample_global)
  min_route <- min(zone2sample_global)
  max_route <- max(zone2sample_global)
  ninety_pct_route <- quantile(zone2sample_global, probs = 0.9)
  sd_route = sd(zone2sample_global)
  
  zone <- "zone2_global"
  stats_zone2_global_add <- data.frame(mean = mean, max= max, min = min, 
                                       ninety_pct = ninety_pct, sd = sd, mean_route = mean_route, 
                                       min_route = min_route, max_route = max_route, 
                                       ninety_pct_route = ninety_pct_route, sd_route = sd_route, zone = zone)
  stats_zone2_global <- rbind(stats_zone2_global, stats_zone2_global_add)
}


# zone 3 global ----
stats_zone3_global <- data.frame(mean = numeric(), max= numeric(), min = numeric(), 
                                 ninety_pct = numeric(), sd = numeric(), 
                                 mean_route = numeric(), max_route = numeric(),
                                 min_route = numeric(),  ninety_pct_route  = numeric(),
                                 sd_route  = numeric(), zone = character())
for( i in 1:length(test_zone3_global) ){
  mean <- mean(test_zone3_global[[i]])
  min <- min(test_zone3_global[[i]])
  max <- max(test_zone3_global[[i]])
  ninety_pct <- quantile(test_zone3_global[[i]], probs = 0.9)
  sd = sd(test_zone3_global[[i]])
  mean_route <- mean(zone3sample_global)
  min_route <- min(zone3sample_global)
  max_route <- max(zone3sample_global)
  ninety_pct_route <- quantile(zone3sample_global, probs = 0.9)
  sd_route = sd(zone3sample_global)
  
  zone <- "zone3_global"
  stats_zone3_global_add <- data.frame(mean = mean, max= max, min = min, 
                                       ninety_pct = ninety_pct, sd = sd, mean_route = mean_route, 
                                       min_route = min_route, max_route = max_route, 
                                       ninety_pct_route = ninety_pct_route, sd_route = sd_route, zone = zone)
  stats_zone3_global <- rbind(stats_zone3_global, stats_zone3_global_add)
}



# export to csvs
name<-paste("Output/stats_zone3_global.csv",sep="")
write.csv(stats_zone3_global,name, row.names = FALSE)
name<-paste("Output/stats_zone2_global.csv",sep="")
write.csv(stats_zone2_global,name, row.names = FALSE)
name<-paste("Output/stats_zone3_national.csv",sep="")
write.csv(stats_zone3_national,name, row.names = FALSE)
name<-paste("Output/stats_zone2_national.csv",sep="")
write.csv(stats_zone2_national,name, row.names = FALSE)





# strip plot and see where mean is
ggplot(stats_all_zones, aes(x=zone, y=mean)) +
  geom_jitter(color = "firebrick", size = 1, width = 0.15) +
  labs(x = "Zone", y = "Mean connectivity value") + 
  theme_classic()+
  theme(axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust = 1))  # Angled labels, so text doesn't overlap						

# add three lines showing route mean

ggplot(stats_all_zones, aes(x=zone, y=mean)) + 
  geom_boxplot(fill = "goldenrod1", notch = FALSE) + 
  labs(x = "Zone", y = "Mean connectivity value") +
  theme(axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust = 1))  # Angled labels, so text doesn't overlap						


# Multiple histograms
ggplot(stats_all_zones, aes(x = mean)) + 
  geom_histogram(fill = "goldenrod1", col = "black", 
                 binwidth = 0.2, boundary = 0, bins = 15) +
  labs(x = "Mean connectivity value", y = "Frequency") + 
  facet_wrap(~zone, ncol = 1, scales = "free_y", strip.position = "right") +
  theme_classic()


facet by zone
x = status (sample VS routes)

colunn = mean, max, min, sd, 90 percentile, status, routes

# reorganize data and plot side by side


# t-test, non-parametric 
# compare overlap -> so we know how many times we need to run the sampling for
# the less overlap the better
