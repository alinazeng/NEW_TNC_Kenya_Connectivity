# Batch file FactorBiasOut for Lab computer
# March 29


# Dry
sampledir_Dry <- "C:/TNC_Connectivity_AlinaVania/Sample/Dry/CSV"
ascdir_Dry <- "C:/TNC_Connectivity_AlinaVania/ASC/Dry"
outputdir_Dry <- "C:/TNC_Connectivity_AlinaVania/Results/FactorBiasOut/Dry" # Where to keep the maxent output
javabasic <- "java -mx1536m -jar maxent.jar nowarnings noprefixes" # Java code that will always be used; 1536 can be changed to other values that are multiples of 512 to allocate more RAM
javaadd <- "outputformat=logistic randomtestpoints=25 responsecurves jackknife appendtoresultsfile autorun" # Java code for settings
outputtxt_Dry <- "C:/TNC_Connectivity_AlinaVania/BatchFiles/FactorBiasOut/Dry/" # Where to keep the text files containing the java codes

# Get sample files
fullpath <- list.files(sampledir_Dry, full.names = TRUE)
filename <- list.files(sampledir_Dry)
biasfile <- list.files(path="C:/TNC_Connectivity_AlinaVania/Bias_File/Dry",pattern= ".asc$", full.names=TRUE)

# Generate code for individual batch file
for (i in 1:length(fullpath)){
  # name <- strsplit(filename[i],"_")[[1]][1] # Species name
  name <- strsplit(filename[i],"_")[[1]][1]
  code <- paste(javabasic, "-s", dQuote(fullpath[i], options(useFancyQuotes = "TeX")), "-e", ascdir_Dry,  "-o", outputdir_Dry, paste("biasfile=", biasfile[i], sep = ""), javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdir_Dryectory
  write.table(code, file = paste0(outputtxt_Dry,name,"_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# dQuote(fullpath[1], options(useFancyQuotes = "TeX"))

# Generate code for compiled batch file
for (i in 1:length(fullpath)){
  code <- paste(javabasic, "-s", dQuote(fullpath[i], options(useFancyQuotes = "TeX")), "-e", ascdir_Dry, "-o", outputdir_Dry, paste("biasfile=", biasfile[i], sep = ""), javaadd, sep = " ")
  write.table(code, file = paste0(outputtxt_Dry,"compiled_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- "" # To add space between codes for individual species
  write.table(space, file = paste0(outputtxt_Dry,"compiled_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  



# Wet
sampledir_Wet <- "C:/TNC_Connectivity_AlinaVania/Sample/Wet/CSV"
ascdir_Wet <- "C:/TNC_Connectivity_AlinaVania/ASC/Wet"
outputdir_Wet <- "C:/TNC_Connectivity_AlinaVania/Results/FactorBiasOut/Wet" # Where to keep the maxent output
javabasic <- "java -mx1536m -jar maxent.jar nowarnings noprefixes" # Java code that will always be used; 1536 can be changed to other values that are multiples of 512 to allocate more RAM
javaadd <- "outputformat=logistic randomtestpoints=25 responsecurves jackknife appendtoresultsfile autorun" # Java code for settings
outputtxt_Wet <- "C:/TNC_Connectivity_AlinaVania/BatchFiles/FactorBiasOut/Wet/" # Where to keep the text files containing the java codes

# Get sample files
fullpath <- list.files(sampledir_Wet, full.names = TRUE)
filename <- list.files(sampledir_Wet)
biasfile <- list.files(path="C:/TNC_Connectivity_AlinaVania/Bias_File/Wet",pattern= ".asc$", full.names=TRUE)

# Generate code for individual batch file
for (i in 1:length(fullpath)){
  # name <- strsplit(filename[i],"_")[[1]][1] # Species name
  name <- strsplit(filename[i],"_")[[1]][1]
  code <- paste(javabasic, "-s", dQuote(fullpath[i], options(useFancyQuotes = "TeX")), "-e", ascdir_Wet,  "-o", outputdir_Wet, paste("biasfile=", biasfile[i], sep = ""), javaadd, sep = " ") # -s = samplesfile, -e = environmentallayers, -o = outputdir_Wetectory
  write.table(code, file = paste0(outputtxt_Wet,name,"_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# dQuote(fullpath[1], options(useFancyQuotes = "TeX"))

# Generate code for compiled batch file
for (i in 1:length(fullpath)){
  code <- paste(javabasic, "-s", dQuote(fullpath[i], options(useFancyQuotes = "TeX")), "-e", ascdir_Wet, "-o", outputdir_Wet, paste("biasfile=", biasfile[i], sep = ""), javaadd, sep = " ")
  write.table(code, file = paste0(outputtxt_Wet,"compiled_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
  space <- "" # To add space between codes for individual species
  write.table(space, file = paste0(outputtxt_Wet,"compiled_FactorBiasOut.txt"), row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
}  

