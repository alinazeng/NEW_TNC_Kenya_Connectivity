# script_conservancy_boxplots
# alinazengziyun@yahoo.com
# April 4, 2022

# Libraries needed for formatting and tidying data ----
library(dplyr)
library(tidyr)
library(Cairo)
library(ggplot2)

# import raw data ----
#conservancy_global <- read.csv("input/updated/conservancy_global.csv", header = TRUE)
conservancy_national <- read.csv("input/updated/conservancy_national_raw.csv", header = TRUE)
iucn <- read.csv("input/updated/iucncat_kenya.csv", header = TRUE)



# remove 4889077248 -> too big
conservancy_national <- subset(conservancy_national, conservancy_national$value !="4889077248")
iucn <- subset(iucn, iucn$cellvalue !="6272564736")

# take the median
conservancy_national <- dplyr::group_by(conservancy_national, conservancy)
median <- dplyr::summarise(conservancy_national, median(value))

median <- rename(median, NAME=conservancy, connectivity_median="median(value)")
# export to csv
write.csv(median,"output/connectivity_median_per_conservancy.csv", row.names = FALSE)



# top10 <- read.csv("input/updated/conservancy_national.csv", header = TRUE)



library(ggplot2)
# Basic box plot for connectivity values per conservancy

png(filename="Connectivity value per conservancy - National Model.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)   
ggplot(conservancy_national, aes(x=reorder(conservancy,value), y=value)) + 
  geom_boxplot(outlier.shape = NA)+
  theme_bw() +
  ylab("Connectivity Value") +                             
  xlab("Conservancy")  +
 coord_cartesian(ylim = c(0, 3*10^8))+
  theme(axis.text.x = element_text(size = 8, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  labs(title = "Connectivity value per conservancy - National Model")

dev.off()


# reorder rows			
order <- c("All Conservancy","II","IV","VI", 			
           "Not Applicable","Not Reported")		
iucn$iucn_cat <- factor(iucn$iucn_cat ,                                    # Change ordering manually			
                        levels = order)   # works here			
iucn <- iucn %>% arrange(factor("iucn_cat", levels = order))
iucn$iucn_cat <- factor(iucn$iucn_cat ,                                    # Change ordering manually			
                                  levels = order)   # works here			


# IUCN graph

png(filename="Connectivity value and IUCN information - National Model.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)

ggplot(iucn, aes(x=iucn_cat, y=cellvalue)) + 
  geom_boxplot (outlier.shape = NA)+
  theme_bw() +
  ylab("Connectivity Value") +                             
  xlab("IUCN")  +
  coord_cartesian(ylim = c(0, 2*10^8))+
  theme(axis.text.x = element_text(size = 25, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  labs(title = "Connectivity value and IUCN information - National Model")
dev.off()



# order by mean

png(filename="Connectivity value and IUCN information - National Model - ordered by mean.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)

ggplot(iucn, aes(x=reorder(iucn_cat,cellvalue), y=cellvalue)) + 
  geom_boxplot (outlier.shape = NA)+
  theme_bw() +
  ylab("Connectivity Value") +                             
  xlab("IUCN")  +
  coord_cartesian(ylim = c(0, 2*10^8))+
  theme(axis.text.x = element_text(size = 25, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  labs(title = "Connectivity value and IUCN information - National Model")
dev.off()

# all conservancies tgt


# add a column so i can graph

conservancy_national$all <- "All conservancy"
conservancy_national$iucn_cat <- "All Conservancy"
#merge this and iucn df so i can plot them tgt
test <- conservancy_national
test <- dplyr::select(test, -all)
test <- rename(test, name=conservancy, cellvalue=value)
iucn <- full_join(iucn,test)

png(filename="Connectivity value ALL conservancy - National Model.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)
ggplot(conservancy_national, aes(x=all, y=value)) + 
  geom_boxplot (outlier.shape = NA)+
  theme_bw() +
  ylab("Connectivity Value") +                             
  xlab("All Conservancy")  +
  coord_cartesian(ylim = c(0, 1.5*10^8))+
  theme(axis.text.x = element_text(size = 5, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  theme(axis.text.x=element_blank())+
  labs(title = "Connectivity value ALL conservancy - National Model")

dev.off()
