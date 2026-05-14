library(here)       #relative path for files
library(readr)      #file reading tool
library(dplyr)      #data analysis 
library(ggplot2)    #visualization 
library(car)        #VIF test 
library(olsrr)      #linear regression tools

#establish root directory
here::i_am("02_analysis.R")

#load in data
dataset_complete <- read_csv(here("dataset_complete.csv"))

#setting up data matrix
dataset_complete <- dataset_complete %>%
  select (audit_rate, AsianPercent, BlackPercent, HispanicPercent, NativeAmPercent, Hawaiian_PIPercent, LowerIncome, Agri_MiningPerc, ConstructionPerc,
          ManufacturingPerc, WholesalePerc, RetailPerc, TransportationPerc, Finance_RealEstatePerc, Science_WastePerc,
          Education_HealthPerc, Arts_Rec_FoodPerc, PARTISAN_INDEX_REP) %>%

#Linear Regression Modeling
##model containing all variables
model <- lm(audit_rate ~ ., data = dataset_complete)

#Step-Wise regression 
##Both Directions
all_variables_both <- ols_step_both_r2(model)
all_variables_both

##Building table for plotting
step_data <- data.frame(
  step = 0:18,
  AIC = c(8640.127, 7718.049, 7206.312, 7011.875, 6878.024, 6834.857,
          6790.556, 6766.591, 6733.921, 6714.832, 6704.435, 6701.435,
          6689.995, 6680.046, 6676.161, 6671.177, 6670.781, 6672.150,
          6673.736)
)

##plotting the results of the step-wise regression
ggplot(step_data, aes(x = step, y = AIC)) +
  geom_line() +
  geom_point(size = 3) +
  labs(
    title = "Model Selection via AIC",
    x = "Step (Variables Added)",
    y = "AIC"
  ) +
  theme_minimal()

#Removing Variables 

dataset_filtered <- dataset_complete %>%
  select (audit_rate, AsianPercent, BlackPercent, HispanicPercent, NativeAmPercent, LowerIncome, Agri_MiningPerc,
          ManufacturingPerc, RetailPerc, Arts_Rec_FoodPerc, PARTISAN_INDEX_REP) %>%
  na.omit()

##creating new linear regression model
final_model <- lm(audit_rate ~ ., data = dataset_filtered)

##checking assumptions for a linear regression model
vif(final_model) #collinearity
hist(resid(final_model)) #normal distribution of errors
plot(cooks.distance(final_model)) #checking outliers
plot(fitted(final_model), resid(final_model)) #homoscedasticity of errors

#results of linear regression analysis
summary(final_model)

