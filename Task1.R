library(ggplot2)
library(dplyr)
library(tidyverse)

# EXPLORE
## task1_1
data <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/01_dat.csv", header = TRUE) 
data %>% 
        select(Time_h, RawOD, uM) %>%
        ggplot(aes(y= RawOD, x = Time_h)) +
        geom_line() +
        labs(x = "Time (h)", y = "Raw OD", title = "Growth curves of S.flexneri M90T with Azithromycin") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_1.pdf")

## task1_2
data2 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/02_dat.csv", header = TRUE)
data2 %>%
        select(Date, Time_h, RawOD, uM) %>%
        mutate(Date = as.factor(Date)) %>%
        ggplot(aes(y= RawOD, x = Time_h, color = Date)) +
        geom_line() + 
        labs(x = "Time (h)", y = "RawOD") +
        # transform to logarithmic scale using trans = "log2"
        scale_y_continuous(trans = "log2") + 
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_2.pdf")

## task1_3
data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE)
data3 %>%
        select(Date, Plt, Time_h, RawOD, uM) %>%
        mutate(Date = as.factor(Date)) %>%
        # day 3 has to biological replicates so we need to group the data by Plate (Plt) using group = Plt
        ggplot(aes(y= RawOD, x = Time_h, color = Date, group = Plt)) + 
        geom_line() + 
        labs(x = "Time (h)", y = "RawOD") +
        scale_y_continuous(trans = "log2") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_3.pdf")


# TRANSFORM

## task1_4: substract background OD
data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE) %>% 
        group_by(Date, Time_h, Plt) %>% 
        mutate(  
                background = RawOD[uM ==-1],
                OD = RawOD - background)  
        # this creates two new variables: (1) background OD (OD for uM = -1 for each Date, Time and plate) 
        # (2 )the final OD, calculated by substracting the background from the RawOD readout
data3 %>%
        select(Date, Plt, Time_h, OD, uM) %>%
        mutate(Date = as.factor(Date)) %>% 
        filter(!str_detect(uM, "-1")) %>% # drops background plot
        ggplot(aes(y= OD, x = Time_h, color = Date, group = Plt)) + 
        geom_line() + 
        labs(x = "Time (h)", y = "OD") +
        scale_y_continuous(trans = "log2") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_4.pdf")

# Another way of grouping the background OD for each date, plate and time
#data3 <- filter(data3, uM == -1) %>%
        #rename(bg= RawOD) %>% 
        #select(Date, Plt, Time_h, bg) %>% 
        #right_join(data3) %>% # it matches back based on date, plt and time_h
        #mutate(OD = RawOD - bg)

#task1_5: constrain OD to limit of detection (LOD)
data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE) %>% 
        group_by(Date, Time_h, Plt) %>% 
        mutate(  
                background = RawOD[uM ==-1],
                OD = RawOD - background)  

# constrain OD variable to LOD of 0.03
data3$OD <- ifelse(data3$OD < 0.03, 0.03, data3$OD)
data3 %>% 
        select(Date, Plt, Time_h, OD, uM) %>%
        mutate(Date = as.factor(Date)) %>% 
        filter(!str_detect(uM, "-1")) %>% # drops background plot
        ggplot(aes(y= OD, x = Time_h, color = Date, group = Plt)) + 
        geom_line() + 
        labs(x = "Time (h)", y = "OD") +
        scale_y_continuous(trans = "log2") +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_5.pdf")

#task1_6: fitness

data3 <- read.csv("/Users/carlota/Desktop/EMBL/Vallo_R/03_dat.csv", header = TRUE) %>% 
        group_by(Date, Time_h, Plt) %>% 
        mutate(  
                background = RawOD[uM ==-1],
                OD = RawOD - background)  

# constrain OD variable to LOD of 0.03
data3$OD <- ifelse(data3$OD < 0.03, 0.03, data3$OD)

data3 <- group_by(data3, Date, Time_h, Plt) %>% 
        mutate(fit_ref = OD[uM == 0],
               fit = OD/OD[uM == 0])

# constrain fitness to value of 1.1
data3$fit <- ifelse(data3$fit > 1.1, 1.1, data3$fit)

data3 %>% 
        select(Date, Time_h, Plt, OD, fit, uM) %>%
        mutate(Date = as.factor(Date)) %>% 
        filter(!str_detect(uM, "-1")) %>% # drops background plot
        ggplot(aes(y= fit, x = Time_h, color = Date, group = Plt)) + 
        geom_line() + 
        labs(x = "Time (h)", y = "Fitness") +
        scale_y_continuous(breaks = c(0.3, 0.6, 0.9, 1.2), limits = c(0.0, 1.1)) +
        facet_wrap(~ uM, labeller = label_both)
ggsave(filename = "/Users/carlota/Desktop/EMBL/Vallo_R/plot1_6.pdf")



        


