library(here)       #relative path for files  
library(readr)      #file reading and writing
library(dplyr)      #data analysis 
library(ggplot2)    #visualization 
library(tidycensus) #census data 
library(tidyverse)  #census data tools
library(haven)      #SPSS file functions

#Setting root directory
here::i_am("01_clean_data.R")

#set api for census data
census_api_key("3896982a905b29d14cc97b457fe5269e11bee60c", install = TRUE, overwrite = TRUE)

#pull in sav file with voting data
voter_data <- read_sav(here("VoterAndPartisanIndexData.sav"))

#data contains calculated audit rate from 2012 through 2015
audit_data <- read_csv(here("AuditRateData_2016.csv"))

#locate variable codes for matching ACS dataset
variablelist <- load_variables(2015, "acs5", cache = TRUE)

#generating variables vector to get and rename specific variables for census data
variables <- c(
  TotalPopulation = "B02001_001E", 
  Asian = "B02001_005E",
  Black = "B02001_003E",
  NativeAm = "B02001_004E",
  Hawaiian_PI = "B02001_006E",
  Hispanic = "B03001_003E",
  Total_Income_Reported = "B19001_001E",
  Income_LessThan_10K = "B19001_002E",
  Income_10K_15K = "B19001_003E",
  Income_15K_20K = "B19001_004E",
  Income_20K_25K = "B19001_005E",
  Income_25K_30K = "B19001_006E",
  Income_30K_35K = "B19001_007E",
  Income_35K_40K = "B19001_008E",
  Income_40K_45K = "B19001_009E",
  Income_45K_50K = "B19001_010E",
  Income_50K_60K = "B19001_011E",
  Income_60K_75K = "B19001_012E",
  Income_75K_100K = "B19001_013E",
  Income_100K_125K = "B19001_014E",
  Income_125K_150K = "B19001_015E",
  Income_150K_200K = "B19001_016E",
  Income_200K_up = "B19001_017E",
  Agri_Mining = "C24050_002E",
  Construction = "C24050_003E",
  Manufacturing = "C24050_004E",
  Wholesale = "C24050_005E",
  Retail = "C24050_006E",
  Transportation = "C24050_007E",
  Information = "C24050_008E",
  Finance_RealEstate = "C24050_009E",
  Science_Waste = "C24050_010E",
  Education_Health = "C24050_011E",
  Arts_Rec_Food = "C24050_012E",
  Other = "C24050_013E",
  Public_Admin = "C24050_014E",
  Employed = "C24050_001E"
)

#retrieving census data for analysis
census_data <- get_acs(geography = "county",
                       variables = variables,
                       survey = "acs5",
                       year = 2015,
                       output = "wide"
                    )

#standardizing variables to allow for comparison/testing
demographic_data <- census_data %>%
  mutate ( 
    AsianPercent = (Asian / TotalPopulation) * 100,
    BlackPercent = (Black / TotalPopulation) * 100,
    HispanicPercent = (Hispanic / TotalPopulation) * 100, 
    NativeAmPercent = (NativeAm / TotalPopulation) * 100,
    Hawaiian_PIPercent = (Hawaiian_PI / TotalPopulation) * 100,
    LowerIncome = ((Income_10K_15K + Income_15K_20K + Income_20K_25K + Income_25K_30K + 
                      Income_30K_35K + Income_35K_40K + Income_40K_45K + Income_45K_50K) / Total_Income_Reported), 
    MiddleIncome = ((Income_50K_60K + Income_60K_75K + Income_75K_100K) / Total_Income_Reported),
    HighIncome = (( Income_100K_125K + Income_125K_150K + Income_150K_200K + Income_200K_up)/ Total_Income_Reported),
    Agri_MiningPerc = (Agri_Mining / Employed) * 100,
    ConstructionPerc = (Construction / Employed) * 100,
    ManufacturingPerc = (Manufacturing / Employed) * 100,
    WholesalePerc = (Wholesale / Employed) * 100,
    RetailPerc = (Retail / Employed) * 100,
    TransportationPerc = (Transportation / Employed) * 100,
    InformationPerc = (Information / Employed) * 100,
    Finance_RealEstatePerc = (Finance_RealEstate / Employed) * 100,
    Science_WastePerc = (Science_Waste / Employed) * 100,
    Education_HealthPerc = (Education_Health / Employed) * 100,
    Arts_Rec_FoodPerc = (Arts_Rec_Food / Employed) * 100,
    OtherPerc = (Other / Employed) * 100,
    Public_AdminPerc = (Public_Admin / Employed) * 100
  ) %>%
  select(
    GEOID, AsianPercent, BlackPercent, HispanicPercent, NativeAmPercent, Hawaiian_PIPercent, LowerIncome, MiddleIncome, HighIncome, Agri_MiningPerc, ConstructionPerc,
    ManufacturingPerc, WholesalePerc, RetailPerc, TransportationPerc, Finance_RealEstatePerc, Science_WastePerc,
    Education_HealthPerc, Arts_Rec_FoodPerc, OtherPerc
  )

#filtering voter data to isolate date range
voter_data_2016 <- voter_data %>%
  filter(YEAR == 2016) %>%
  select(STCOFIPS10, YEAR, PARTISAN_INDEX_DEM, PARTISAN_INDEX_REP) %>%
  rename( 
    GEOID = "STCOFIPS10")

#setting up data to merge into one dataset
audit_data <- audit_data %>%
  mutate(fips = sprintf("%05d", as.numeric(fips))) %>% #normalizing the County Identification codes 
  rename (
    GEOID = "fips"
  )

#joining all data
dataset_complete <- demographic_data %>%
  left_join(audit_data, by = "GEOID") %>%
  left_join(voter_data_2016, by = "GEOID")

#save cleaned complete dataset
write.csv(dataset_complete, here("dataset_complete.csv"), row.names = FALSE)
