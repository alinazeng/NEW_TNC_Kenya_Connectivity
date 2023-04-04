# Prepare code for swd batch file based on season
# Vania
# Created Mar 8, 2023
# Updated Mar 27, 2023

# Set season
wetordry <- "Dry"

# Sample files ------
# Prepare template
sampledir <- paste0("C:/TNC_Connectivity_AlinaVania/SampleV/",wetordry)
ascdir <- paste0("C:/TNC_Connectivity_AlinaVania/ASC/",wetordry)
csvdir <- paste0(sampledir,"/CSV/")
swddir <- paste0(sampledir,"/SWD/") # Where to keep the samples with data (SWD) files that are generated from samples + all asc files
outputdir <- paste0(sampledir, "/SWD_TXT/") # Where to keep the text files containing the java codes
javacode <- "java -mx2048m -cp maxent.jar density.Getval"

# Get sample files
fullpath <- list.files(csvdir, full.names=TRUE)
filename <- list.files(csvdir)

# (Temp) Select species
species <- c(1,6,17,22,24,25)

# (Temp) Select fullpath and filename
fullpath <- fullpath[species]
filename <- filename[species]

# Generate code for individual batch file
for (i in 1:length(fullpath)){
  name <- strsplit(filename[i],"_")[[1]][1] # Species name 
  outname <- paste0(swddir,name,"_obs_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, fullpath[i], paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(outputdir,name,"_obs_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# Generate code for compiled batch file
for (i in 1:length(fullpath)){
  name <- strsplit(filename[i],"_")[[1]][1] # Species name 
  outname <- paste0(swddir,name,"_obs_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, fullpath[i], paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(outputdir,"/","compiled_obs_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- "" # To add space between codes for individual species
  write.table(space, file = paste0(outputdir,"compiled_obs_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  

# Background files------
# Prepare template
bgdir <- paste0("C:/TNC_Connectivity_AlinaVania/Background/",wetordry)
ascdir <- paste0("C:/TNC_Connectivity_AlinaVania/ASC/",wetordry)
bgcsvdir <- paste0(bgdir, "/CSV/")
bgswddir <- paste0(bgdir, "/SWD/")
bgoutputdir <- paste0(bgdir, "/SWD_TXT/")
javacode <- "java -mx2048m -cp maxent.jar density.Getval"

# Get background files
fullpathbg <- list.files(bgcsvdir, full.names=TRUE)
filenamebg <- list.files(bgcsvdir)

# (Temp) Select fullpath and filename
fullpathbg <- fullpathbg[species]
filenamebg <- filenamebg[species]

# Generate code for individual batch file
for (i in 1:length(fullpathbg)){
  name <- strsplit(filenamebg[i],"_")[[1]][1]
  outname <- paste0(bgswddir,name,"_bg_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, fullpathbg[i], paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(bgoutputdir,name,"_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# Generate code for compiled batch file
for (i in 1:length(fullpathbg)){
  name <- strsplit(filenamebg[i],"_")[[1]][1]
  outname <- paste0(bgswddir,name,"_bg_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, fullpathbg[i], paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(bgoutputdir,"compiled_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- ""
  write.table(space, file = paste0(bgoutputdir,"compiled_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  
