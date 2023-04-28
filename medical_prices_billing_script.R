# This data is from the California Department of Managed Health Care (DMHC).
# It contains all decisions from Independent Medical Reviews (IMR)
# administered by the DMHC since January 1, 2001.
# An IMR is an independent review of a denied, delayed,
# or modified health care service 
# that the health plan has determined to be not medically necessary,
# experimental/investigational or non-emergent/urgent.
# If the IMR is decided in an enrollee's favor,
# the health plan must authorize the service or treatment requested.


 ## CREATE PRICE REFERENCE CHECKER AND STORAGE
 ## PROVIDE REFERENCE PRICING FOR PROCEDURES AND STORE NEW TRANSSACTIONS
 ## WITH GUI

install.packages("sqldf")

########################### Libraries  ######################

library("readxl")
library("readr")

#analysis
library("psych")

#Tidyverse
library("dplyr")
library("tidyr")

#for creating paths
library("sys")

#for graphing
library("ggplot2")

#for sql
library("sqldf")

#GUI
library("shiny")

########################### Paths, load data ############################

path_desktop <- file.path("C:", "Users", "Martin", "Desktop")
path_project <- file.path(path_desktop, "R_projects", "projects")

path_concept <- file.path(path_project,  "medical_prices", "raw_dataset",  "concept.csv")
path_hospital <- file.path(path_project, "medical_prices", "raw_dataset",  "hospital.csv")
path_price <- file.path(path_project,    "medical_prices", "raw_dataset",  "price.csv")


concept_data <- read_csv(path_concept)
hospital_data <- read_csv(path_hospital)
price_data <- read_csv(path_price)


#1 Look into your data: 

View(concept_data)
View(hospital_data)
View(price_data)

sapply(concept_data,class)
sapply(hospital_data,class)
sapply(price_data,class)

# All ID columns must be character 

concept_data$concept_id <- as.character(concept_data$concept_id)

price_data$concept_id <- as.character(price_data$concept_id)
price_data$hospital_id <- as.character(price_data$hospital_id)

hospital_data$hospital_id <- as.character(hospital_data$hospital_id)
hospital_data$hospital_npi <- as.character(hospital_data$hospital_npi)

# Drop some unnecessary column IDs that will not be used for this project

concept_data <-  concept_data[- c(2,3)]
hospital_data <- hospital_data[- c(3,6,8)]


## The are more unique concepts in price data set than in concept data
## explanation from online
## Hospitals may not be allowed to share some concept names publicly 

## We can add "Undisclosed" for concepts not specified 

print(paste("From price dataset: ",length(unique(price_data$concept_id))))
print(paste("From concept dataset:",length(unique(concept_data$concept_id))))



## Leftjoin datasets on unique IDs, with price on left--------------------------

#medical_data <- left_join(price_data, concept_data, by = "concept_id")


# The data is heavily skewed right, and there are seemingly excessive large
# prices, but there are different types of prices

describe(price_data$amount)

# Analyze amounts by price type 
# Max type of price has by far the biggest right skew, with some concepts
# having 10's of billions in amount 
# Also some mins are under a penny 

x <- price_data %>%
  group_by(price) %>%
  summarize(describe(amount))
print(x)

y <- price_data %>%
  filter(amount > 100000000)

z <- price_data %>%
  filter(amount < .02)

# and then we can add concept name so that we can understand what type 
# of procedures have these type of extreme prices

subset_expensive <- left_join(y, concept_data, by = "concept_id")
subset_cheap <- left_join(z, concept_data, by = "concept_id")
View(subset_expensive)
View(subset_cheap)



