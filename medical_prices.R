# This data is from the California Department of Managed Health Care (DMHC).
# It contains all decisions from Independent Medical Reviews (IMR)
# administered by the DMHC since January 1, 2001.
# An IMR is an independent review of a denied, delayed,
# or modified health care service 
# that the health plan has determined to be not medically necessary,
# experimental/investigational or non-emergent/urgent.
# If the IMR is decided in an enrollee's favor,
# the health plan must authorize the service or treatment requested.

install.packages("sqldf")

# Libraries

library("readxl")
library("readr")

#Tidyverse
library("dplyr")
library("tidyr")

#for creating paths
library("sys")

#for graphing
library("ggplot2")

#for sql
library("sqldf")

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

str(concept_data)
str(hospital_data)
str(price_data)

concept_data$concept_id <- as.character(concept_data$concept_id)
price_data$concept_id <- as.character(price_data$concept_id)
price_data$hospital_id <- as.character(price_data$hospital_id)
hospital_data$hospital_id <- as.character(hospital_data$hospital_id)




## The are more unique concepts in price data set than in  concept data
## explanation from online
## EULA to acquire missing concepts, may not be allowed to share them publicly 

print(paste("From price dataset: ",length(unique(price_data$concept_id))))
print(paste("From concept dataset:",length(unique(concept_data$concept_id))))

## Leftjoin datasets on unique IDs, with price on left--------------------------
# Using dplyr - left join multiple columns
#df2 <- emp_df %>% left_join( dept_df, 
 #                            by=c('dept_id','dept_branch_id'))
medical_data <- left_join(price_data, concept_data, by = "concept_id")


medical_data <- left_join(medical_data, hospital_data, by = "hospital_id")

## Alot of the most expensive procedures are "max" price type 
describe(price_data$amount)





