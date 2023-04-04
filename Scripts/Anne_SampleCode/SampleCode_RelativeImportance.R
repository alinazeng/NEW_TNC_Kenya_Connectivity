
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



mxtresults <- read.csv(paste0(base_dir,"1OngoingSpatialDataProduction//Biodiversity//Output//birds//Dec2022//ssp_126_585//maxentResults.csv"), header=T)
names(mxtresults)


mxtresults <- mxtresults[,c(1:29,157,189)]

names(mxtresults)

# focus on the contribution results


names(mxtresults) <-  c( "Species" ,  "Trnsamples",   "Regtraining_gain", "UnRegtraininggain" ,   "Iterations", "TrainingAUC" , "TestSamples",  "Test.gain" ,  "Test_AUC" ,  "AUCsd" , "Background_pnts" ,
                         "dHwRailw", "Elev" ,"agbiomass",  "bio10"  ,"bio11" , "bio15"  ,  "bio16",  "bio17", "dhi_ggp_min","drivermainstem"    , "drivertrib" , "dwetlands"  ,"pcrops"   , "pdecclosed"   , "pdecopen"    , "pgrasslands"  ,  "pshrublands"    , "density_pathRoads" ,  "Prevalence",  "EqualtrainingsensitivityandspecificitylogisticTrd" )



###########################################################################################
# Create table with spp and relative importance 
###########################################################################################

# 



mxtresult_clean <- read.csv(paste0(Base_fn,"//R_processed//MxtSummary_Dec22.csv"), header=FALSE)
head(mxtresult_clean)


names(mxtresult_clean) <-  c( "Spp" ,  "Trnsamples",   "Regtraining_gain", "UnRegtraininggain" ,   "Iterations", "TrainingAUC" , "TestSamples",  "Test.gain" ,  "Test_AUC" ,  "AUCsd" , "Background_pnts" ,  "Dist_Highway", "Elev" , "AboveGrndBiomass", "AvgTempWetQrt", "AvgTempColdQrt", "SeasonalPpt", "PptWetQrt", "PptDriestQrt" ,"Min_DynamicHabitatIndex","Dist_MainstemRiver" ,  "Dist_Trib", "Dist_Wetlands" , "pCrops"   , "pDecClosed"   , "pDecOpen"    , "pGrasslands"  ,  "pShrublands" ,"PathRoadDensity" ,  "Prevalence", "EqTrSen" )




mxtresult_clean_t <- mxtresult_clean[,c("Spp","Test_AUC","AUCsd"  , "Background_pnts" ,  "Dist_Highway", "Elev" , "AboveGrndBiomass", "AvgTempWetQrt", "AvgTempColdQrt", "SeasonalPpt", "PptWetQrt", "PptDriestQrt" ,"Min_DynamicHabitatIndex","Dist_MainstemRiver" ,  "Dist_Trib", "Dist_Wetlands" , "pCrops"   , "pDecClosed"   , "pDecOpen"    , "pGrasslands"  ,  "pShrublands" ,"PathRoadDensity"  ,  "Prevalence", "EqTrSen"  )]



mxtresult_clean_t2 <- mxtresult_clean_t[!rowSums(is.na(mxtresult_clean_t)),]



mxtresult_clean_RI <- mxtresult_clean_t2[,c("Spp", "Dist_Highway", "Elev" , "AboveGrndBiomass", "AvgTempWetQrt", "AvgTempColdQrt", "SeasonalPpt", "PptWetQrt", "PptDriestQrt" ,"Min_DynamicHabitatIndex","Dist_MainstemRiver" ,  "Dist_Trib", "Dist_Wetlands" , "pCrops"   , "pDecClosed"   , "pDecOpen"    , "pGrasslands"  ,  "pShrublands" ,"PathRoadDensity"   )]


mxtresult_RI_pvt <- mxtresult_clean_RI %>% 
  pivot_longer( !Spp, names_to = "Env_var", values_to = "RelImp") %>%
  mutate(Spp = str_replace_all(Spp, "(average)", ""))%>%
  mutate(Spp = factor(str_replace_all(Spp, "[()]", ""))) %>%
  mutate(Spp = trimws(Spp))%>%
  as.data.frame()

write.table(mxtresult_RI_pvt,paste0(Base_fn,"//R_processed//MxtSummary_RI_Dec22.csv"), sep="," , row.names = F, col.names = T)



lsSpp <-  list("Bucorvus_leadbeateri",
               "Rynchops_flavirostris",
               "Trigonoceps_occipitalis",
               "Polemaetus_bellicosus",
               "Falco_vespertinus",
               "Egretta_vinaceigula",
               "Gyps_africanus",
               "Aquila_nipalensis",
               "Balearica_regulorum",
               "Gyps_coprotheres",
               "Necrosyrtes_monachus",
               "Ardeotis_kori",
               "Aquila_rapax",
               "Sagittarius_serpentarius",
               "Circus_macrourus",
               "Calidris_ferruginea",
               "Glareola_nordmanni",
               "Phoeniconaias_minor",
               "Bugeranus_carunculatus",
               "Torgos_tracheliotos",
               "Terathopius_ecaudatus")

for(S in lsSpp) {
  #S <- lsSpp[1]
  sppPlot <- mxtresult_RI_pvt %>%
    filter(Spp == S); sppPlot
  
  ggplot( sppPlot,  aes(x=reorder(Env_var,RelImp), y=RelImp)) +
    geom_segment( aes(xend=Env_var, yend=0)) +
    geom_point( size=4, color="orange") +
    theme(axis.text.x=element_text(angle=45, hjust=1))+
    ggtitle(S) +
    xlab("") +
    coord_flip()
  ggsave(paste0(Base_fn,"//R_processed//plots//RI_",S,".png"))
}




mxtresult_clean_AUC <- mxtresult_clean_t2[,c("Spp","Test_AUC","Prevalence"   ,     "EqTrSen" )]


mxtresult_clean_AUC2 <- mxtresult_clean_AUC %>% 
  mutate(Spp = str_replace_all(Spp, "(average)", ""))%>%
  mutate(Spp = factor(str_replace_all(Spp, "[()]", ""))) %>%
  mutate(Spp = trimws(Spp))%>%
  as.data.frame()



write.table( mxtresult_clean_AUC2,paste0(Base_fn,"//R_processed//MxtSummary_AUC_Dec22.csv"), sep="," ,  row.names = F, col.names = T)



