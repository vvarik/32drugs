library(ggplot2)
library(dplyr)
library(tidyverse)

# EXPLORE
## task1_1
data <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/01_dat.csv", header = TRUE) 
data %>% 
        select(Well, Time_h, RawOD, uM) %>%
        ggplot(aes(y= RawOD, x = Time_h)) +
        geom_line() +
        labs(x = "Time (h)", y = "Raw OD", title = "Growth curves of S.flexneri M90T with Azithromycin") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_1.pdf")

## task1_2
data2 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/02_dat.csv", header = TRUE)
data2 %>%
        select(Date, Well, Time_h, RawOD, uM) %>%
        mutate(Date = as.factor(Date)) %>%
        ggplot(aes(y= RawOD, x = Time_h, color = Date)) +
        geom_line() + 
        labs(x = "Time (h)", y = "RawOD") +
        scale_y_continuous(trans = "log2") + # transforms to logarithmic scale
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_2.pdf")

## task1_3
data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE)
data3 %>%
        select(Date, Plt, Well, Time_h, RawOD, uM) %>%
        mutate(Date = as.factor(Date)) %>%
        ggplot(aes(y= RawOD, x = Time_h, color = Date, group = Plt)) + # groups according to Plt
        geom_line() + 
        labs(x = "Time (h)", y = "RawOD") +
        scale_y_continuous(trans = "log2") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_3.pdf")


# TRANSFORM

## task1_4
data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE) %>% 
        group_by(Date, Time_h, Plt) %>% 
        #now assign new variables
        mutate(  
                background = RawOD[uM ==-1],
                OD = RawOD - background)  
        #filter(Time_h == 1.08) 

#data3$OD <- data3$RawOD - filter(data3, uM == -1)$RawOD
data3 %>%
        select(Date, Plt, Well, Time_h, OD, RawOD, uM) %>%
        mutate(Date = as.factor(Date)) %>% # is it RawOD or OD?
        filter(!str_detect(uM, "-1")) %>%
        ggplot(aes(y= OD, x = Time_h, color = Date, group = Plt)) + # groups according to Plt
        geom_line() + 
        labs(x = "Time (h)", y = "RawOD") +
        scale_y_continuous(trans = "log2") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_4.pdf")

data3 <- filter(data3, uM == -1) %>%
        rename(bg= RawOD) %>% 
        select(Date, Plt, Time_h, bg) %>% 
        right_join(data3) # it matches back based on date, plt and time_h

        
        


