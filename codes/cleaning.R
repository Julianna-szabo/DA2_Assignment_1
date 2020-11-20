##############################
## Analysis of              ##
##                          ##
##  COVID-19 Deaths/capita  ##
##         and              ##
##      GPD/capita          ##
##                          ##
##      NO. 2               ##
##                          ##
##  Cleaning the data       ##
##                          ##
##############################

# Libraries
library(tidyverse)

# Import data from github

# First I will clean the COVID data

  # Dropping the columns I do not need

covid_data[ ,c("FIPS","Admin2","Last_Update","Lat","Long_","Combined_Key","Incidence_Rate","Case.Fatality_Ratio")] <- list(NULL)

covid_data <- covid_data %>% 
  group_by(Country_Region) %>% 
  aggre


covid_data <- aggregate(x = covid_data,
                by = list(covid_data$Country_Region), FUN = sum)









