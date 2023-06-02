# Code bij R voor beginners

# Hands on programming with R
# Basics als je helemaal geen programmeerervaring hebt
# https://rstudio-education.github.io/hopr/

# R for Data Science
# Begint ook vanaf de basics maar gaat er sneller door heen
# https://r4ds.hadley.nz/

install.packages("tidyverse")
install.packages("twn")
library(tidyverse)
library(twn)

dir.create("data")

download.file(url = "https://www.schielandendekrimpenerwaard.nl/kaart/waterkwaliteit/alle_wkl_metingen/Biologische_meetgegevens_HHSK.zip",
              destfile = "data/data_hhsk.zip")


unzip("data/data_hhsk.zip", exdir = "data")

my_data <- read_csv2("data/Biologische_meetgegevens_HHSK.csv")

View(my_data)

mafa_2022 <-
  my_data %>% 
  filter(year(datum) == 2022,
         taxatype == "MACEV",
         methodecode == "MAFA") 

View(mafa_2022)

mafa_2022 %>% 
  ggplot(aes(meetpunt)) + geom_bar()

mafa_locaties <- mafa_2022 %>% 
  select(meetpunt, X, Y) %>% 
  distinct()

install.packages("sf")
install.packages("leaflet")

library(leaflet)
library(sf)

mafa_locaties %>% 
  st_as_sf(coords = c(x = "X", y = "Y"), crs = 28992) %>% 
  st_transform(crs = 4326) %>% 
  leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(label = ~meetpunt) %>% 
  htmlwidgets::saveWidget("kaartje.html")

