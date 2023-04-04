# split observations according to scientific names
# Alina
# Feb 28, 2023


# load in data

occurenceALL <- read.csv("input/AllLargeMammalsKenya_Moll_Cleaned.csv", header = TRUE)
# retain only ones with 100+ observations
# count number of obs.
test <- as.data.frame(table(occurenceALL$species))
#join table

test <- dplyr::rename(test,species=Var1)
occurenceALL <- dplyr::full_join(occurenceALL, test)

#get rid of ones with few obs.
occurenceALL <- dplyr::filter(occurenceALL, Freq>100)

data_list <- split(occurenceALL, f = occurenceALL$species)                     # Split data
head(data_list)


for (i in 1:length(data_list)) {  
  occurence <- as.data.frame(data_list[[i]])                               # Create a dataframe for each species
  name <- unique(data_list[[i]]$species) 
  occurence <- dplyr::select(occurence, -Freq)
write.csv(occurence, file = paste0("C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/CSV/",name, "_obs.csv"), row.names = FALSE)
}