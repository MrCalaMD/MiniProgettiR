library(tidyverse)

mappa <- readOGR(dsn = getwd()) 
library(broom)
library(maptools)
library(rgdal)

mappa <- readOGR(dsn = paste0(getwd(), 
                              "/Limiti01012022_g/Reg01012022_g")) 

df<-broom::tidy(mappa)

regioni <- data.frame(mappa@data$DEN_REG)
names(regioni) <- c("Regioni")
regioni$id <- seq(0,nrow(regioni)-1)
df$id <- as.numeric(df$id)
mappa_df <- right_join(df, regioni, by = "id")

casi <- read.csv("casi_monkeypox.csv", sep = ";", row.names = NULL)

sort(unique(casi$Regioni)) == sort(unique(mappa_df$Regioni))


mappa_df <- left_join(mappa_df, casi, by = "Regioni")

ggplot() +
  geom_polygon(data = mappa_df, aes( x = long, y = lat, group=group, fill = Casi), color="black") +
  scale_fill_continuous(low = "#C2FFBC",
                        high = "#FF6E6E") +
  theme_void()+
  ggtitle("Monkey-pox cases in Italy (19/08/2022)")
