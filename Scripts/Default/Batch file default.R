# Prepare code for default batch file
# Vania
# Created: Feb 27, 2023
# Last updated: March 29, 2023

# Set season
wetordry <- "Dry"

# Prepare template
sampledir <- paste0("C:/TNC_Connectivity_AlinaVania/Sample/",wetordry,"/CSV/") 
ascdir <- paste0("C:/TNC_Connectivity_AlinaVania/ASC/",wetordry)
outputdir <- paste0("C:/TNC_Connectivity_AlinaVania/Results/Default/",wetordry) # Where to keep the maxent output
javabasic <- "java -mx2048m -jar maxent.jar nowarnings noprefixes" # Java code that will always be used; 1536 can be changed to other values that are multiples of 512 to allocate more RAM
javaadd <- "outputformat=logistic randomtestpoints=25 responsecurves jackknife appendtoresultsfile autorun" # Java code for settings
outputtxt <- paste0("C:/TNC_Connectivity_AlinaVania/BatchFiles/Default/",wetordry) # Where to keep the text files containing the java codes

# Get sample files
fullpath <- list.files(sampledir, full.names = TRUE)
filename <- list.files(sampledir)

# Select species
species <- c(1,6,17,22,24,25)

# Select sample files
fullpath <- fullpath[species]
filename <- filename[species]

# Generate code for individual batch file
for (i in 1:length(fullpath)){
  name <- strsplit(filename[i],"_")[[1]][1] # Species name
  code <- paste(javabasic, "-s", fullpath[i], "-e", ascdir, "-o", outputdir, javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdirectory
  write.table(code, file = paste0(outputtxt,"/",name,"_def.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# Generate code for compiled batch file
for (i in 1:length(fullpath)){
  code <- paste(javabasic, "-s", fullpath[i], "-e", ascdir, "-o", outputdir, javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdirectory
  write.table(code, file = paste0(outputtxt,"/","compiled_def.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- "" # To add space between codes for individual species
  write.table(space, file = paste0(outputtxt,"/","compiled_def.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
} 
