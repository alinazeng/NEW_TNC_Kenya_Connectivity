# Relative importance calculation following Anne
# alina 
# March 30. 2023



#### Library#########
library(sf)
library(terra)
library(lubridate)  # Dates and Times
library(dplyr)
library(gt)   # creating tables
library(gtsummary)
library(tidyverse)

#####################

# # Input Maxent results  -----------------------


# just need to run the script several times based on what method/season we are concerned about
#1
MethodType <- "FactorBiasOut/Dry"
filename <- "Dry_FactorBiasOut" # this is for saving the cleaned maxent result summary in later steps
#2
MethodType <- "FactorBiasOut/Wet"
filename <- "Wet_FactorBiasOut"
#3
MethodType <- "Default/Dry"
filename <- "Dry_Default"
#4
MethodType <- "Default/Wet"
filename <- "Wet_Default"
#5
MethodType <- "TargetGroup_Clamping/Dry"
filename <- "Dry_TargetGroup_Clamping"
#6
MethodType <- "TargetGroup_Clamping/Wet"
filename <- "Wet_TargetGroup_Clamping"
#7
MethodType <- "TargetGroup_FadeByClamping/Dry"
filename <- "Dry_TargetGroup_FadeByClamping"
#8
MethodType <- "TargetGroup_FadeByClamping/Wet"
filename <- "Wet_TargetGroup_FadeByClamping"
#9
MethodType <- "TargetGroup_NoClamping/Dry"
filename <- "Dry_TargetGroup_NoClamping"
#10
MethodType <- "TargetGroup_NoClamping/Wet"
filename <- "Wet_TargetGroup_NoClamping"


mxtresults <- read.csv(paste0("C:/TNC_Connectivity_AlinaVania/Results/",MethodType, "/maxentResults.csv"), header=T)

names(mxtresults)

# focus on the contribution results
# mxtresults <- mxtresults[,c(1:29,157,189)] # edit the number here based on 
# what/how many EVs we have (subject to change after figuring out correlation)
mxtresults <- mxtresults[,c(1:27)]
names(mxtresults)

names(mxtresults) <-  c( "Spp" ,  "Trnsamples",   "Regtraining_gain", "UnRegtraininggain" ,   "Iterations", "TrainingAUC" , "TestSamples",  "Test.gain" ,  "Test_AUC" ,  "AUCsd" , "Background_pnts" ,
 "Percent_crop", "Elev" ,"Dist_river_lake",  "Dist_road"  ,"Dist_wetland" , "Dist_conservancy"  ,  "Dist_nationalnetwork",  "Population", "NDVI","Percent_closed_deciduous"    , "Percent_open_deciduous" , "Percent_grassland"  ,"Percent_shrubland"   , "Precipitation"   , "Temperature"    , "TerrainRudgednessIndex" )


mxtresult_clean_t <- mxtresults[,c("Spp","Test_AUC","AUCsd"  , "Background_pnts" , "Percent_crop", "Elev" ,"Dist_river_lake",  "Dist_road"  ,"Dist_wetland" , "Dist_conservancy"  ,  "Dist_nationalnetwork",  "Population", "NDVI","Percent_closed_deciduous"    , "Percent_open_deciduous" , "Percent_grassland"  ,"Percent_shrubland"   , "Precipitation"   , "Temperature"    , "TerrainRudgednessIndex" ) ]
mxtresult_clean_t2 <- mxtresult_clean_t[!rowSums(is.na(mxtresult_clean_t)),]
mxtresult_clean_RI <- mxtresult_clean_t2[,c("Spp", "Percent_crop", "Elev" ,"Dist_river_lake",  "Dist_road"  ,"Dist_wetland" , "Dist_conservancy"  ,  "Dist_nationalnetwork",  "Population", "NDVI","Percent_closed_deciduous"    , "Percent_open_deciduous" , "Percent_grassland"  ,"Percent_shrubland"   , "Precipitation"   , "Temperature"    , "TerrainRudgednessIndex" )]

# library(dplyr)
mxtresult_RI_pvt <- mxtresult_clean_RI %>% 
  pivot_longer( !Spp, names_to = "Env_var", values_to = "Relative_Importance") %>%
  mutate(Spp = str_replace_all(Spp, "(average)", ""))%>%
  mutate(Spp = factor(str_replace_all(Spp, "[()]", ""))) %>%
  mutate(Spp = trimws(Spp))%>%
  as.data.frame()

write.table(mxtresult_RI_pvt,paste0("C:/TNC_Connectivity_AlinaVania/R_Processed/MxtSummary_RI_", filename, ".csv"), sep="," , row.names = F, col.names = T)



lsSpp <-  list("Syncerus_caffer", "Hippopotamus_amphibius", "Panthera_leo" ,"Loxodonta_africana",
      "Crocuta_crocuta","Acinonyx_jubatus")

for(S in lsSpp) {
  #S <- lsSpp[1]
  sppPlot <- mxtresult_RI_pvt %>%
    filter(Spp == S); sppPlot
  
  ggplot( sppPlot,  aes(x=reorder(Env_var,Relative_Importance), y=Relative_Importance)) +
    geom_segment( aes(xend=Env_var, yend=0)) +
    geom_point( size=4, color="orange") +
    theme(axis.text.x=element_text(angle=45, hjust=1))+
    theme_light() +
    theme(text = element_text(size = 25))+
    ggtitle(S) +
    xlab("") +
    coord_flip()
  ggsave(width = 8, height = 6, dpi = 300, paste0("C:/TNC_Connectivity_AlinaVania/R_processed/plots/RI_",S,"_", filename, ".png"))
}




