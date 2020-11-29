# DA2 Assigment 1
This repository contains my work for the first assignment for the ECBS5142 - Data Analysis 2 course at CEU.

# Goal
My goal was to understand the correlation between COVID-19 cases per capita and COVID-19 deaths per capita for different countries.

# Data
My data comes from two original sources.
I have population data from the World Bank (through World Development Indivators) and COVID-19 data for October 1st 2020 from Center for Systems Science and Engineering (CSSE) at Johns Hopkins University.
Link to the COVID-19 data: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports

Throughout the analysis I created some additional variables for per capita calculations since the original numbers were in totals.

# Outcome

I have found that they have a linear correlation best explained by a Weighted linear model using population as weights.
The model shows that usually mode cases lead to more deaths, but population in the country play a role since countries with higher population doing a good or a bad job dealing with the pandemic have an affect on the curve.
The strength of my results are the great fit of the model to the data, but the weakness is that there might be some misreposrting in the data, that could lead to skewed results.
