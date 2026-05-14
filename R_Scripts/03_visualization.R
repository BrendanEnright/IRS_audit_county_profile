library(here)       # relative path for files
library(tigris)     # mapping/ county data
library(readr)      # file saving/reading
library(dplyr)      # data analysis 
library(ggplot2)    # visualization 
library(stringr)    # data management
library(sf)         # spatial analysis, for querying data
library(spdep)      # autocorrelation tests
library(spatialreg) # spatial regression

#establishing root directory
here::i_am("03_visualization.R")

#loading in dataset 
dataset_complete <- read_csv(here("dataset_complete.csv"))

#attaching shapefiles
counties_sf <- counties(cb = TRUE, year = 2016)

#merging dataset
contiguous_us <- counties_sf %>%
  left_join(dataset_complete, by = "GEOID") %>%
  filter(!str_sub(GEOID, 1, 2) %in% c("02", "15", "60", "66", "69", "72", "78"))

#Mapping the Lower Income Counties
ggplot(data = contiguous_us) +  
  geom_sf(aes(fill = LowerIncome), color = "white", size = 0.01) +  
  scale_fill_distiller(palette = "Greens", 
                       direction = 1,  
                       name = "Proportion of Lower Income Households", 
                       na.value = "gray90") + 
  labs(          
    title = "Proportion of Lower Median Income Household", 
    subtitle = "United States, 2016",
    caption = "Source: ACS 5 Year Estimates"
  ) + 
  theme_bw() 

##Mapping the Voter Data by County
ggplot(data = contiguous_us) +  
  geom_sf(aes(fill = PARTISAN_INDEX_REP), color = NA) +  
  scale_fill_continuous(low = "blue", 
                        high = "red",
                        name = "Partisanship Index",  # label the legend
                        na.value = "gray90") + # color for nulls 
  labs(          
    title = "Past Republican Voting Index by County", # add text
    subtitle = "United States, 2012-2016",
    caption = "Source: ACS 5 Year Estimates"
  ) + 
  theme_bw()

##cleaning Nulls and establishing model for testing
model_data <- contiguous_us %>%
  drop_na(
    audit_rate, LowerIncome, BlackPercent, HispanicPercent, AsianPercent, NativeAmPercent, RetailPerc, Agri_MiningPerc, ManufacturingPerc, Arts_Rec_FoodPerc
  )

neighbor_list <- poly2nb(
  pl = model_data,
  queen = TRUE
)

listweights_model <- nb2listw(
  neighbours = neighbor_list,
  style = "W",
  zero.policy = TRUE
)

#building a regression model
formula <- audit_rate ~ LowerIncome + BlackPercent + HispanicPercent + AsianPercent + NativeAmPercent + RetailPerc + Agri_MiningPerc + ManufacturingPerc + Arts_Rec_FoodPerc

## Spatial Lag model test
spatial_model <- lagsarlm(formula = formula, 
                          data = model_data, 
                          listw = listweights_model, 
                          zero.policy = TRUE, 
                          na.action = na.omit)
summary(spatial_model)

##plotting results
lag_results <- model_data %>%
  mutate(
    fitted = fitted(spatial_model),
    residual = residuals(spatial_model))

## predicted values map
ggplot(data = lag_results) +  
  geom_sf(aes(fill = fitted), color = NA) +  
  scale_fill_distiller(
    palette = "Blues",
    direction = 1,
    name = "Predicted",
    na.value = "gray90"
  ) + 
  labs(
    title = "Predicted County Audit Rates",
    subtitle = "Spatial Lag Regression Model",
    caption = "Source: Spatial lag model estimates"
  ) + 
  theme_minimal()

