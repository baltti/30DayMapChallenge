
library(tidyverse)
library(sf)
library(tidygeocoder)
library(rnaturalearth)
library(extrafont)

trials<-readr::read_csv("https://raw.githubusercontent.com/JakeRuss/witch-trials/master/data/trials.csv") %>% 
  drop_na(lon, lat) %>% 
  st_as_sf(coords=c("lon", "lat"),crs=4326) %>% 
  st_transform("+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs") 

trials_geo<-readr::read_csv("https://raw.githubusercontent.com/JakeRuss/witch-trials/master/data/trials.csv") %>%
  select(-lon,-lat) %>% 
  geocode(city=gadm.adm2, method="osm") %>% 
  drop_na(long, lat) %>% 
  st_as_sf(coords=c("long", "lat"),crs=4326) %>% 
  st_transform("+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs")

countries<-ne_countries(type="countries", scale="medium",returnclass = "sf") %>% 
  st_transform("+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs")

ggplot()+
  geom_sf(data=countries, fill="black")+
  geom_sf(data=trials_geo, color="#c70525")+
  geom_sf(data=trials, color="#c70525")+
  xlim(-1056224.6,627565.9)+ylim(1270210.7,2794200.2)+
  ggtitle(label = "European witch trials")+
  labs(caption = "data: Leeson, P.T. and Russ, J.W. (2018), Witch Trials. Econ J, 128: 2066-2105. https://doi.org/10.1111/ecoj.12498")+
  facet_wrap(facets = vars(century),nrow = 2,ncol = 3)+
  theme_void()+
  theme(plot.title = element_text(hjust = 0.5,vjust=0.1,size = 30, 
                                  family = "GothicE",
                                  colour = "#c70525"),
        text = element_text(hjust = 0.5,vjust=0.8,size = 10, 
                            family = "GothicE",colour = "black"),
        plot.background = element_rect(color = NA, fill = "#8fa2bc"))+
  ggsave((paste0("day 17-upd",".png")), 
         device = "png",dpi = 500, width = 12, height = 8)
