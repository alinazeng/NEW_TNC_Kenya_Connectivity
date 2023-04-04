# script_remove_space_in_filenames

library(stringr)

# Rename bias files files
filedir <- "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Bias_File/ASCs_resampled"

fullpath <- list.files(filedir, pattern = ".asc", full.names = TRUE)
filename <- list.files(filedir, pattern = ".asc")

for (i in 1:length(fullpath)){
  newname <- str_replace_all(filename[i]," ","_")
  file.rename(from=fullpath[i],to=paste0(filedir,"/",newname))
}



# Rename batch files
filedir <- "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/BatchFiles/FactorBiasOut"

fullpath <- list.files(filedir, pattern = ".txt", full.names = TRUE)
filename <- list.files(filedir, pattern = ".txt")

for (i in 1:length(fullpath)){
  newname <- str_replace_all(filename[i],"obs.csv_","")
  file.rename(from=fullpath[i],to=paste0(filedir,"/",newname))
}

#rename obs
filedir <- "C:/Users/alina/Documents/git/TNC_Kenya_Connectivity/Input/MaxentTemp/Sample/Wet/Common_name"

fullpath <- list.files(filedir, pattern = ".csv", full.names = TRUE)
filename <- list.files(filedir, pattern = ".csv")

for (i in 1:length(fullpath)){
  newname <- str_replace_all(filename[i]," ","_")
  file.rename(from=fullpath[i],to=paste0(filedir,"/",newname))
}