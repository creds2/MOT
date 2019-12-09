# National fleet makup summary
library(dplyr)
library(ggplot2)
library(tidyr)

emissions <- readRDS("E:/OneDrive - University of Leeds/CREDS Data/github-secure-data/lsoa_emissions_hisorical_long.Rds")
emissions2 <- emissions
emissions2$LSOA = NULL
emissions2$fuel = NULL
emissions2$AvgCO2 = NULL
emissions2$AvgAge = NULL
emissions2$AllCars = NULL

emissions2 <- emissions2 %>%
  group_by(year) %>%
  summarize_all(sum)


emissions3 <- pivot_longer(emissions2, names(emissions2)[2:15])



ggplot(emissions3, aes(fill=name, y=value, x=year)) + 
  geom_bar(position="stack", stat="identity") +
  ylab("Number of Cars")
