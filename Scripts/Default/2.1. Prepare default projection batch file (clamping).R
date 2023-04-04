# Prepare code for default batch file based on season + do clamping during projection
# Vania
# Created Mar 31, 2023

# Set season
wetordry <- "Dry"

# Prepare template
sampledir <- paste0("C:/TNC_Connectivity_AlinaVania/SampleV/",wetordry,"/SWD/")
bgdir <- paste0("C:/TNC_Connectivity_AlinaVania/Background/Default/",wetordry,"/SWD/")
projdir <- paste0("C:/TNC_Connectivity_AlinaVania/Projection/",wetordry)
outputdir <- paste0("C:/TNC_Connectivity_AlinaVania/Results/Default_Clamping/",wetordry) # Where to keep the maxent output
javabasic <- "java -mx2048m -jar maxent.jar nowarnings noprefixes" # Java code that will always be used
javaadd <- "outputformat=logistic randomtestpoints=25 responsecurves jackknife appendtoresultsfile autorun" # Java code for settings
outputtxt <- paste0("C:/TNC_Connectivity_AlinaVania/BatchFiles/Default_Clamping/",wetordry) # Where to keep the text files containing the java codes

# Select species 
species <- 5

# Get sample and background files
fullpath <- list.files(sampledir, full.names = TRUE)[species]
filename <- list.files(sampledir)[species]
fullpathbg <- list.files(bgdir, full.names = TRUE)

# Generate code for individual batch file
for (i in 1:length(fullpath)){
  name <- strsplit(filename[i],"_")[[1]][1] # Species name
  code <- paste(javabasic, "-s", fullpath[i], "-e", fullpathbg, "-j", projdir, "-o", outputdir, javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdirectory, -j = projectionlayers
  write.table(code, file = paste0(outputtxt,"/",name,"_defclamp_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# Generate code for compiled batch file
for (i in 1:length(fullpath)){
  code <- paste(javabasic, "-s", fullpath[i], "-e", fullpathbg, "-j", projdir, "-o", outputdir, javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdirectory, -j = projectionlayers
  write.table(code, file = paste0(outputtxt,"/compiled_defclamp_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- "" # To add space between codes for individual species
  write.table(space, file = paste0(outputtxt,"/compiled_defclamp_",wetordry,".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  
