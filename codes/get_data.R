##############################
## Analysis of              ##
##                          ##
##  COVID-19 Deaths/capita  ##
##         and              ##
##      GPD/capita          ##
##                          ##
##      NO. 1               ##
##                          ##
##  Getting the data        ##
##                          ##
##############################

# Libraries to use
#install.packages('WDI')
library(WDI)

# Importing the data
# COVID-19 Data

covid_csv <- 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/10-01-2020.csv'
covid_data <- read.csv(covid_csv)

# WDI population data 2019

gdp_data = WDI(indicator='NY.GDP.PCAP.PP.KD', country="all", start=2019, end=2019)

# Save data into raw
my_path <- "/Users/Terez/OneDrive - Central European University/Data_Analysis_02/Assignment_1/data/"
write_csv(gdp_data, paste0(my_path,'raw/WDI_lifeexp_raw.csv'))



