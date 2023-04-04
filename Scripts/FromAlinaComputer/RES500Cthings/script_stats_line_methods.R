# script_stats_plots
# alinazengziyun@yahoo.com
# March 25, 2022

# Libraries needed for formatting and tidying data ----
library(dplyr)
library(tidyr)
library(Cairo)
library(ggplot2)
packages <- c(
    'emmeans',   #least square means - compare the statuss
    'Rmisc'  #function summarySE
)
if(sum(as.numeric(!packages %in% installed.packages())) != 0){
    instalador <- packages[!packages %in% installed.packages()]
    for(i in 1:length(instalador)) {
        install.packages(instalador, dependencies = T)
        break()}
    sapply(packages, require, character = T) 
} else {
    sapply(packages, require, character = T) 
}

# import raw data ----
og_routes_global <- read.csv("input/updated/original_routes_global.csv", header = TRUE)
og_routes_national <- read.csv("input/updated/original_routes_national.csv", header = TRUE)
random_lines_global <- read.csv("input/updated/random_lines_global.csv", header = TRUE)
random_lines_national <- read.csv("input/updated/random_lines_national.csv", header = TRUE)

# isolate mean values and merge tables
og_routes_global_mean <- dplyr::select(og_routes_global, c(mean, identifier,status))
og_routes_national_mean <- dplyr::select(og_routes_national, c(mean, identifier,status))
random_lines_global_mean <- dplyr::select(random_lines_global, c(mean, identifier,status))
random_lines_national_mean <- dplyr::select(random_lines_national, c(mean, identifier,status))

mean_global_lines <- full_join(og_routes_global_mean, random_lines_global_mean)
mean_national_lines <- full_join(og_routes_national_mean, random_lines_national_mean)


#variable called "identifier" - it is named with numbers but actually it is a categorical
#variable, so you can tell R that by using this code: 
mean_global_lines$identifier=factor(mean_global_lines$identifier)
mean_national_lines$identifier=factor(mean_national_lines$identifier)

#linear model
m_mean_global_lines <- lm(mean ~ status*identifier, data = mean_global_lines, na.action=na.omit)
m_mean_national_lines <- lm(mean ~ status*identifier, data = mean_national_lines, na.action=na.omit)

# posterior <- as.matrix(m_mean_global_lines)
# mcmc_areas(posterior,
#          pars = c("status", "status:identifieroriginal route"),
#          prob = 0.8)


#here you use the emmeans from emmeans package to compare all the groups in pairs. 
#it does compare the average of the groups. To know if the samples are significant
#different or not you can check the pvalue in the output
#if you want to know more how the function emmeans work you can check the package 
#documentation by typing the code "?emmeans"
emmeans(m_mean_global_lines, ~ status)
lm_line_method_global<- as.data.frame(pairs(emmeans(m_mean_global_lines, ~ status|identifier))) # most of them have very big p values (not statistically sig)
lm_line_method_global$statistically_sig <- ifelse(lm_line_method_global$p.value < 0.05, "YES","NO") 
table(lm_line_method_global$statistically_sig)
# NO YES 
# 172  10 
    
emmeans(m_mean_national_lines, ~ status)
lm_line_method_national <- as.data.frame(pairs(emmeans(m_mean_national_lines, ~ status|identifier))) # most of them have very tiny p values (not statistically sig)
lm_line_method_national$statistically_sig <- ifelse(lm_line_method_national$p.value < 0.05, "YES","NO") 
table(lm_line_method_national$statistically_sig)
# NO YES 
# 175  7

# export this
write.csv(lm_line_method_national,"output/lm_line_method_national.csv", row.names = FALSE)
write.csv(lm_line_method_global,"output/lm_line_method_global.csv", row.names = FALSE)


ggplot(lm_line_method_national, aes(x = p.value)) + 
    geom_histogram(fill = "goldenrod1", col = "black", 
                   binwidth = 0.2, boundary = 0, bins = 30) +
    labs(x = "P value", y = "Frequency") + 
   # facet_wrap(~zone, ncol = 1, scales = "free_y", strip.position = "right") +
    theme_classic()

#code for plotting the means, you can plot with SD or SE

#First, summarize the data. It will show a warning when you run this code, it is because
#the status "actual" only have one value so it does not have SD or SE
#you can remove the na.rm from the code if you don't have any NA in the data. I
#leave because it does not change anything.
df_global <- summarySE(mean_global_lines, measurevar="mean", groupvars=c("status", "identifier"),na.rm =TRUE)
df_global
df_national <- summarySE(mean_national_lines, measurevar="mean", groupvars=c("status", "identifier"),na.rm =TRUE)
df_national

#the greater the number here, more spaces between the groups in each status group
pd<-position_dodge(0.6)
pd<-position_dodge(0.3)

plot1<-ggplot(df_global, aes(x=status, y=mean, color=status)) + 
    geom_point(position=pd, size=6, aes(shape = status),na.rm=TRUE) + 
    geom_errorbar(aes(x=status, ymin=mean-sd, ymax=mean+sd), na.rm=TRUE,
                  size=1, width=.3, position=pd) + #you can change SD for SE if you want to plot the standard error 
    facet_grid(~identifier) +
    xlab('status')+ylab('value') + 
    #scale_y_continuous(limits = c(20000, 6500), breaks = seq(20000, 65000, by = 10000)) + #this line is to change the y axis if you want
    theme_bw()+
    theme(axis.line = element_line(colour = "black"),
          text = element_text(size=15),
          axis.text.x=element_text(colour="black"),
          axis.text.y=element_text(colour="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank())

plot1

#a third option is to have a overall mean for each "sample" and plot those without 
#considering the groups. 

#plot the average for each "sample"
df_global <- summarySE(mean_global_lines, measurevar="mean", groupvars=c("status"),na.rm =TRUE)
df_global
df_national <- summarySE(mean_national_lines, measurevar="mean", groupvars=c("status"),na.rm =TRUE)
df_national

png(filename="overall_mean_wo_considering_individual_lines.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=14, 
    height=12, 
    res=300)

ggplot(df_global, aes(x=status, y=mean, color=status)) + 
    geom_point(position=pd, size=6) + 
    geom_errorbar(aes(x=status, ymin=mean-sd, ymax=mean+sd))+ 
    xlab('')+ylab('Connectivity value') + 
    #scale_y_continuous(limits = c(20000, 6500), breaks = seq(20000, 65000, by = 10000)) + #this line is to change the y axis if you want
    theme_bw()+
    ggtitle("Overall mean values w/o considering individual lines - Global Model")+
    guides(color = "none")+
    theme(axis.line = element_line(colour = "black"),
          text = element_text(size=25),
          axis.text.x=element_text(colour="black"),
          axis.text.y=element_text(colour="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank())
dev.off()





# national

png(filename="overall_mean_wo_considering_individual_lines_national.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=14, 
    height=12, 
    res=300)

ggplot(df_national, aes(x=status, y=mean, color=status)) + 
    geom_point(position=pd, size=6) + 
    geom_errorbar(aes(x=status, ymin=mean-sd, ymax=mean+sd))+ 
    xlab('')+ylab('Connectivity value') + 
    #scale_y_continuous(limits = c(20000, 6500), breaks = seq(20000, 65000, by = 10000)) + #this line is to change the y axis if you want
    theme_bw()+
    ggtitle("Overall mean values w/o considering individual lines - National Model")+
    guides(color = "none")+
    theme(axis.line = element_line(colour = "black"),
          text = element_text(size=25),
          axis.text.x=element_text(colour="black"),
          axis.text.y=element_text(colour="black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank())
dev.off()












# obsolete ----



#join
random_lines <- full_join(random_lines, og_routes_mean)

random_lines$difference <- random_lines$mean - random_lines$mean_og

# take difference for pixel too
random_pixels$difference <- random_pixels$mean - random_pixels$mean_route
# difference way smaller +- 150

# plot some distributions

hist(random_lines$difference, col = 'skyblue3', breaks = 100, 
     xlab = "Mean difference between original routes and randomly generated lines",
    main = "Line method")


hist(random_pixels$difference, col = 'skyblue3', breaks = 100, 
     xlab = "Mean difference between original routes and randomly generated pixels",
     main = "Pixel method")

png(filename="histogram_mean_difference_pixel_method_15bins.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=14, 
    height=12, 
    res=300)

dev.off


# making a few barplots for presentation
global <- read.csv("output/lm_line_method_global.csv", header = TRUE)
national<- read.csv("output/lm_line_method_national.csv", header = TRUE)


# global
png(filename="histogram_pvalue_global.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=18, 
    height=12, 
    res=300)

hist(global$p.value, col = '611', breaks = 10, 
     xlab = "P value", cex.axis = 2,cex.lab =2,
     main = "Global model")

dev.off()

#national

png(filename="histogram_pvalue_national.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=18, 
    height=12, 
    res=300)

hist(national$p.value, col = '611', breaks = 10, 
     xlab = "P value", cex.axis = 2,cex.lab =2,
     main = "National model")

dev.off()

png(filename="histogram_mean_difference_line_methodpng", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=14, 
    height=12, 
    res=300)

hist(random_lines$difference, col = 'skyblue3', breaks = 100, 
     xlab = "Mean difference between original routes and randomly generated lines",
     main = "Line method")

dev.off()



# see what the statistically different ones are like in comparison to the original routes

# global
global_yes <- subset(global, global$statistically_sig != "NO")
# get identifier
# 38  41  49 161 166 168 169 170 171 178 
mean_global_lines_yes <- subset(mean_global_lines, mean_global_lines$identifier == 38 |
                                    mean_global_lines$identifier == 41 |
                                mean_global_lines$identifier ==4|
                                    mean_global_lines$identifier ==16|
                                    mean_global_lines$identifier ==166|
                                    mean_global_lines$identifier ==168|
                                    mean_global_lines$identifier ==169|
                                    mean_global_lines$identifier ==170|
                                    mean_global_lines$identifier ==171|
                                    mean_global_lines$identifier ==178)

mean_global_lines_yes <- mean_global_lines_yes %>% dplyr::group_by(identifier,status)
test_global <- mean_global_lines_yes %>%  dplyr::group_by (identifier, status) %>% dplyr::summarize(mean = mean(mean))

write.csv(test_global,"output/stats_sig_comparison_global.csv", row.names = FALSE)



#national
national_yes <- subset(national, national$statistically_sig != "NO")
# get identifier
national_yes$identifier
# 39  41  49 126 169 170 171
mean_national_lines_yes <- subset(mean_national_lines, mean_national_lines$identifier == 39 |
                                      mean_national_lines$identifier == 41 |
                                      mean_national_lines$identifier ==49|
                                      mean_national_lines$identifier ==126|
                                      mean_national_lines$identifier ==169|
                                      mean_national_lines$identifier ==170|
                                      mean_national_lines$identifier ==171)



test_national <- mean_national_lines_yes %>%  dplyr::group_by (identifier, status) %>% dplyr::summarize(mean = mean(mean))

write.csv(test_national,"output/stats_sig_comparison_national.csv", row.names = FALSE)




# graph conservancy vs non-conservancy values
conservancies <- read.csv("input/updated/allcc_kenya.csv", header = TRUE)
elsewhere <- read.csv("input/updated/nocc_kenya.csv", header = TRUE)

#get rid of first row
conservancies <- dplyr::select(conservancies, -1)
elsewhere <- dplyr::select(elsewhere, -1)

plotting <- rbind(conservancies,elsewhere)

#plot



png(filename="Connectivity value - National Model.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)

ggplot(plotting, aes(x=Status, y=Value)) + 
    geom_boxplot(outlier.shape = NA)+
    theme_bw() +
    ylab("Connectivity Value") +                             
    xlab(" ")  +
    coord_cartesian(ylim = c(0, 1.4*10^8))+
    theme(axis.text.x = element_text(size = 25, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
          axis.text.y = element_text(size = 23),
          axis.title = element_text(size = 14, face = "plain"),                      
          panel.grid = element_blank(),                                          
          plot.margin = unit(c(1,1,1,1), units = , "cm"))+
    labs(title = "Connectivity value - National Model")
dev.off()




png(filename="Connectivity value - National Model - violin.png", 
    type="cairo",    ### this helps with resolution A LOT 
    units="in", 
    width=20, 
    height=14, 
    res=300)
ggplot(plotting, aes(x=Status, y=Value)) + 
    geom_violin(fill = "goldenrod1")+
    theme_bw() +
    ylab("Connectivity Value") +                             
    xlab(" ")  +
    stat_summary(fun = mean,  geom = "point", color = "black") +
    coord_cartesian(ylim = c(0, 5*10^8))+
    theme(axis.text.x = element_text(size = 25, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
          axis.text.y = element_text(size = 23),
          axis.title = element_text(size = 14, face = "plain"),                      
          panel.grid = element_blank(),                                          
          plot.margin = unit(c(1,1,1,1), units = , "cm"))+
    labs(title = "Connectivity value - National Model")
dev.off()
