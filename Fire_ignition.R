#Set working directory
setwd("C:/Users/hpp/OneDrive - University of Eastern Finland/Desktop/Files/IIASA_2024/File/data/ba")

# Load required libraries
library(terra)
library(raster)
library(sf)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(dplyr)

# Load the burned area data
fire <- read.csv("fire-ba.csv", header = TRUE, sep = ",", dec = ".") 

ba <- fire %>% 
  group_by(YEAR) %>% 
  summarise(
    area = sum(Area_ha, na.rm = TRUE)
  ) %>%
  filter(YEAR >= 2017 & YEAR <= 2021)

nf <- fire %>% 
  filter(!is.na(Area_ha)) %>%
  mutate(YEAR = as.numeric(substr(YEAR, 1, 4))) %>%
  group_by(YEAR) %>%
  summarise(
    number_of_fires = n()
  ) %>%
  filter(YEAR >= 2017 & YEAR <= 2021)

ggplot()+
  geom_bar(data = ba, aes(x = YEAR, y = area, fill = "Burned Area (ha) "), stat = "identity")+
  geom_line(data = nf, aes(x = YEAR, y = number_of_fires*500, color = "Number of fires"), lwd = 0.55)+
  geom_point(data = nf, aes(x = YEAR, y = number_of_fires*500, color = "Number of fires"), size = 1.2)+
  scale_y_continuous("Burned Area (ha)", sec.axis = sec_axis(~./500, "Number of Fires")) +
  scale_fill_manual(values = "#ff0800")+
  scale_color_manual(values = "#2e67f8")+
  scale_x_continuous(breaks = seq(2017, 2021, by = 1)) +
  theme_minimal() +
  theme_bw() +
  labs(
    fill = "",
    colour = ""
  )+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),  
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12, face = "bold"),
    axis.title = element_text(size = 12, face = "bold"),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold"),
    axis.title.y.right = element_text(angle = 90),
    legend.direction = "horizontal",
    legend.position = "bottom",
    legend.spacing = unit(0.1, "cm"),
    legend.key.spacing = unit(0.05, "cm")
  )

#Save the figure
ggsave("figures/plot-ba.png", last_plot(), width = 6, height = 6)
  