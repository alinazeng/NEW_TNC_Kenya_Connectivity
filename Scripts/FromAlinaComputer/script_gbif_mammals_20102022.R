# Gbif data 
# Oct 31 2022
# alinazengziyun@yahoo.com


# Housekeeping ----
rm(list=ls()) 
options(stringsAsFactors = FALSE)

library(dplyr)
library(tidyr)
library(ggplot2)
library(Cairo)


dt<- read.csv("input/GbifKenyaMammals20102022.csv",header = TRUE)



head(table(dt$CommonName))
count <- as.data.frame(table(dt$CommonName))
#descend
count <- arrange(count, desc(Freq))
count$CommonName <- count$Var1
count$individualCount<- count$Freq
count <- dplyr::select(count, -c(Var1, Freq))

dt <- dplyr::select(dt, -individualCount)
dt <- full_join(count, dt)

top10count <- count[1:10,]

row_to_keep = c("Golden-rumped Sengi", "Plains Zebra","Eastern Black Rhinoceros",
                "Giraffe","Impala", "Grant's Gazelle","Savannah Elephant", "Lion", "Spotted Hyena","Maasai Giraffe")



top10dt <- subset(dt,dt$CommonName %in% c("Golden-rumped Sengi", "Plains Zebra","Eastern Black Rhinoceros",
                  "Giraffe","Impala", "Grant's Gazelle","Savannah Elephant", "Lion", "Spotted Hyena","Maasai Giraffe"))


plot occurences
facet by month


# count by month
lala <- top10dt %>% group_by(month) %>% count(CommonName)
lala$individualCount_byMonth <- lala$n
lala <- dplyr::select(lala, -n)

top10dt <- full_join(top10dt,lala)

png(filename="top10_occurences_by_month_fixed.png", 
    type="cairo", 
    units="in", 
    width=14, 
    height=10, 
    res=300)
ggplot(top10dt, aes(x = CommonName, y = individualCount_byMonth, color = CommonName, fill = CommonName)) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_hline(aes(yintercept = mean(individualCount_byMonth)),       # Adding a line for mean observation
             colour = "#9A32CD", linetype = "dashed", size=0.5, show.legend = F) +
  theme_classic() +
  ylab("Number of observations\n") +                             
  xlab("\n Species")  +
  facet_wrap(~ month, scales = "fixed") +   
  theme(axis.text.x = element_text(size = 7, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 10),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  guides(col=guide_legend("Species"))  # Set legend title and labels with a scale function
 # labs(title = "Number of Observations for Each Phenophase on Each Species",
   #    caption = "Species as x-axis",
  #   subtitle = "Mean number of observations in dash purple line")
dev.off()




row_to_keep = c("Golden-rumped Sengi", "Plains Zebra","Eastern Black Rhinoceros",
                "Giraffe","Impala", "Grant's Gazelle","Savannah Elephant", "Lion", "Spotted Hyena","Maasai Giraffe")



top10dt <- subset(dt,dt$CommonName %in% c("Golden-rumped Sengi", "Plains Zebra","Eastern Black Rhinoceros",
                                          "Giraffe","Impala", "Grant's Gazelle","Savannah Elephant", "Lion", "Spotted Hyena","Maasai Giraffe"))


plot occurences
facet by month


# count by month
lala <- top10dt %>% group_by(month) %>% count(CommonName)
lala$individualCount_byMonth <- lala$n
lala <- dplyr::select(lala, -n)

top10dt <- full_join(top10dt,lala)


png(filename="top10_occurences_by_month_fixed.png", 
    type="cairo", 
    units="in", 
    width=14, 
    height=10, 
    res=300)
ggplot(top10dt, aes(x = CommonName, y = individualCount_byMonth, fill = CommonName)) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_hline(aes(yintercept = mean(individualCount_byMonth)),       # Adding a line for mean observation
             colour = "#9A32CD", linetype = "dashed", size=0.5, show.legend = F) +
  theme_classic() +
  ylab("Number of observations\n") +                             
  xlab("\n Species")  +
  facet_wrap(~ month, scales = "fixed") +   
  theme(axis.text.x = element_text(size = 7, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 10),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  guides(col=guide_legend("Species"))  # Set legend title and labels with a scale function
# labs(title = "Number of Observations for Each Phenophase on Each Species",
#    caption = "Species as x-axis",
#   subtitle = "Mean number of observations in dash purple line")
dev.off()




png(filename="top10_occurences_by_month_free.png", 
    type="cairo", 
    units="in", 
    width=14, 
    height=10, 
    res=300)
ggplot(top10dt, aes(x = CommonName, y = individualCount_byMonth, fill = CommonName)) +
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_hline(aes(yintercept = mean(individualCount_byMonth)),       # Adding a line for mean observation
             colour = "#9A32CD", linetype = "dashed", size=0.5, show.legend = F) +
  theme_classic() +
  ylab("Number of observations\n") +                             
  xlab("\n Species")  +
  facet_wrap(~ month, scales = "free_y") +   
  theme(axis.text.x = element_text(size = 7, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
        axis.text.y = element_text(size = 10),
        axis.title = element_text(size = 14, face = "plain"),                      
        panel.grid = element_blank(),                                          
        plot.margin = unit(c(1,1,1,1), units = , "cm"))+
  guides(col=guide_legend("Species"))  # Set legend title and labels with a scale function
# labs(title = "Number of Observations for Each Phenophase on Each Species",
#    caption = "Species as x-axis",
#   subtitle = "Mean number of observations in dash purple line")
dev.off()



