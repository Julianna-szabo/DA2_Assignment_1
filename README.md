# DA2 Assigment 1
This repository contains my work for the first assignment for the ECBS5142 - Data Analysis 2 course at CEU.

# Goal
My goal was to understand the correlation between COVID-19 cases per capita and COVID-19 deaths per capita for different countries.

# Data
My data comes from two original sources.
I have population data from the World Bank (through World Development Indivators) and COVID-19 data for October 1st 2020 from Center for Systems Science and Engineering (CSSE) at Johns Hopkins University.
Link to the COVID-19 data: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports

Throughout the analysis I created some additional variables for per capita calculations since the original numbers were in totals.

# Variables
| Variable | Description |
| --- | --- |
| FIPS | Unique number used to identify US states |
| Admin2 | Cities (only available for USA)  |
| Provice_State | State or Provice of a given country |
| Country_Region | The country or Region of a given observation|
| Last_update | The date and time the numbers were last updated |
| lat | Latitudinal coordinate of the place where the observations originated |
| long | Longitudinal coordinate of the place where the observations originated |
| confirmed | Confirmed number of COVID-19 cases |
| deaths | Number of deaths due to COVID-19 |
| recovered | Number of people who have recovered from COVID-19 |
| active | Number of people who are currently infected with COVID-19 |
| Combined_Key | A combined field of City, State, and Country |
| Incident_date | Cases per 100,000 persons  |
| Case_Fatality_Ratio (%) | Number recorded deaths / Number cases |
