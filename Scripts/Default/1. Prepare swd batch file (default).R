# Prepare code for swd batch file (default) based on season
# Vania
# Created Mar 31, 2023

# Set season
wetordry <- "Wet"

# Background files------
# Prepare template
bgdir_tg <- paste0("C:/TNC_Connectivity_AlinaVania/Background/TargetGroup/",wetordry)
bgdir_d <- paste0("C:/TNC_Connectivity_AlinaVania/Background/Default/",wetordry)
ascdir <- paste0("C:/TNC_Connectivity_AlinaVania/ASC/",wetordry)
bgcsvdir <- paste0(bgdir_tg, "/CSV/")
bgswddir <- paste0(bgdir_d, "/SWD/")
bgoutputdir <- paste0(bgdir_d, "/SWD_TXT/")
javacode <- "java -mx1024m -cp maxent.jar density.tools.RandomSample 10000"

# Select species
species <- 24

# Get file names (to get species names)
filenamebg <- list.files(bgcsvdir)[species]

# Generate code for individual batch file
for (i in 1:length(filenamebg)){
  name <- strsplit(filenamebg[i],"_")[[1]][1]
  outname <- paste0(bgswddir,name,"_bg_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(bgoutputdir,name,"_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# Generate code for compiled batch file
for (i in 1:length(filenamebg)){
  name <- strsplit(filenamebg[i],"_")[[1]][1]
  outname <- paste0(bgswddir,name,"_bg_swd_",wetordry,".csv") # Name of SWD file
  code <- paste(javacode, paste0(ascdir,"/*.asc"), ">", outname, sep = " ") # Java code
  write.table(code, file = paste0(bgoutputdir,"compiled_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- ""
  write.table(space, file = paste0(bgoutputdir,"compiled_bg_swd_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  
