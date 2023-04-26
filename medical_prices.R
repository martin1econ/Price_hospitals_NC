# This data is from the California Department of Managed Health Care (DMHC).
# It contains all decisions from Independent Medical Reviews (IMR)
# administered by the DMHC since January 1, 2001.
# An IMR is an independent review of a denied, delayed,
# or modified health care service 
# that the health plan has determined to be not medically necessary,
# experimental/investigational or non-emergent/urgent.
# If the IMR is decided in an enrollee's favor,
# the health plan must authorize the service or treatment requested.


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

#for model
library("psych")

path_desktop <- file.path("C:", "Users", "Martin", "Desktop")
path_project <- file.path(path_desktop, "R_projects", "projects")

path_concept <- file.path(path_project,  "medical_prices", "raw_dataset",  "concept.csv")
path_hospital <- file.path(path_project, "medical_prices", "raw_dataset",  "hospital.csv")
path_price <- file.path(path_project,    "medical_prices", "raw_dataset",  "price.csv")


concept_data <- read_csv(path_concept)
hospital_data <- read_csv(path_hospital)
price_data <- read_csv(path_price)

View(concept_data)
View(hospital_data)
View(price_data)

#1 Look into your data: 

View(concept_data)
View(hospital_data)
View(price_data)

#only quantitative column descriptive statistics 
## Data heavily skewed right (mean= 41k, median= 900)
## Max seems excessive, seems to be in the billions - same with standard deviation 

## Alot of the most expensive procedures are "max" price type 
describe(price_data$amount)

# (amounts) 118 above 1mill, 52 above 10mill, 12 above 100mill 
price_100mill <- price_data %>%
  filter(amount > 100000000)

## Alot of the most expensive procedures are "max" price type
## see data instructions:
# gross: this is often the top line item that the hospital never actually charges
# cash: this is the self-pay discounted price you would pay without insurance
# max: this is the maximum negotiated rate by an insurance company in the hospital network.
# min: this is the minimum negotiated rate by an insurance company in the hospital network

## how many procedures are above 1mill, 10mill, 100mill
# what are these procedures that cost that much, build df with amount/concept
expensive_procedures <- left_join(price_1mill, concept_data, by='concept_id')
#make amounts more readable, create column in millions
expensive_procedures <- expensive_procedures %>% 
  mutate(amount_in_mills = amount/1000000)
#only relevant columns
expensive_procedures <- expensive_procedures %>%
  select(hospital_id, price, amount_in_mills, concept_name)
#round up millions
expensive_procedures$amount_in_mills <- round(expensive_procedures$amount_in_mills)

## how many data amounts do we have for max vs min vs gross vs cash
count_price <- price_data %>%
  group_by(price) %>%
  count()
print(count_price)

## The are more unique concepts in price data set than in  concept data
## explanation from online
## EULA to acquire missing concepts, may not be allowed to share them publicly 

print(length(unique(price_data$concept_id)))
print(length(unique(concept_data$concept_id)))

#2 Check the data type of each column

str(price_data)
str(concept_data)
str(hospital_data)


#3 Look at the proportion of missing data

sum(is.na(price_data))
sum(is.na(concept_data))
sum(is.na(hospital_data))

#hospital data has 30 missing values 

for (i in 1:length(colnames(hospital_data))) {
  print(paste(colnames(hospital_data)[i],": ", sum(is.na(hospital_data[,i]))))
}
#disclosure is not important for the purposes of our analysis 


#4 If you have columns of strings, check for trailing white spaces

#5 Dealing with Missing Values (NaN Values)

##drop column with missing values

#6 Extracting more information from your dataset to get more variables

#7 Check the unique values of columns

#8 join datasets




