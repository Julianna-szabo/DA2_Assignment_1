# Files used for this analysis

In this folder you will find all the data I have used for this analysis.

## Raw Folder

This folder contains the two original files.

The first file is from the World Bank and contains the population data for each country
The second file is from the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University containing COVID-19 data.

### World Bank data

| Variable | Description |
| --- | --- |
| iso2c | Indicator for countries |
| country | Country for this given observation  |
| SP.POP.TOTL | Population for a given country |
| year | Year of the observation |


### COVID-19 data

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
| Incident_rate | Cases per 100,000 persons  |
| Case_Fatality_Ratio (%) | Number recorded deaths / Number cases |

## Clean Folder

In this folder you can find the final data table created through the cleaning process.
This is a combination of the above two tables. The table can be recreated using the COVID-19_cleaning.R file in the coding folder.

| Variable | Description |
| --- | --- |
| country | Country for this given observation  |
| confirmed | Confirmed number of COVID-19 cases |
| deaths | Number of deaths due to COVID-19 |
| recovered | Number of people who have recovered from COVID-19 |
| active | Number of people who are currently infected with COVID-19 |
| population | Population for a given country |
