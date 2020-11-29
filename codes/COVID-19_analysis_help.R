
##############################
## Analysis of              ##
##                          ##
##  COVID-19 Deaths/capita  ##
##         and              ##
##      GPD/capita          ##
##                          ##
##      NO. 3               ##
##                          ##
##  Analysing the data      ##
##                          ##
##############################


# Clear memory
rm(list=ls())

# Packages to use
library(tidyverse)
# For scaling ggplots
require(scales)
# Estimate piecewise linear splines
#install.packages("lspline")
library(lspline)
# Estimate robust SE
#install.packages("estimatr")
library(estimatr)
# Compare models with robust SE
#install.packages("texreg")
library(texreg)
# For different themes
#install.packages(ggthemes)
library(ggthemes)
library(ggplot2)
library(flextable)
library(magrittr)


# Import  and Inspect data ------------------------------------------------

data_path <- 'https://raw.githubusercontent.com/Julianna-szabo/DA2_Assignment_1/main/data/clean/covid_pop_09_11_2020_clean.csv'
df <- read_csv(data_path)

# My question for this analysis is:
# What is the correlation between registered cases and deaths per capita?
# My y variable will be Deaths per Capita and my x  will be Registered Cases per Capita
# The original data comes in absolute numbers instead of per capita so that transformation
# may cause some inaccuracies since population numbers are from last year.
# My population is all the cases and all the deaths by COVID throughout the world.
# My sample is therefore very relevant since it has that data, although some countries
# may not be as accurate when recording these, overall it is a relatively good representation
# of the population.

# First let's see what the data looks like
glimpse(df)

# Let's take a look at the data

df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") +
  geom_histogram(bins= 20)+
  theme_bw() + 
  scale_fill_wsj()

# It looks like both confirmed cases and deaths are skewed with a right tail
# This may be lessed in the per capita numbers calculated later
# Otherwise the analysis may benefit from a log tranformation later
# There seem to be some extreme values in both confirmed and deaths

summary(df)

# While with the summary one can see that the range is huge, I have decided to keep
# all the observations, since most of the extreme values will most likely be resolved
# once we do a per Capita transformation

df <- df %>% mutate( deaths_ppc = death/population,
                     cases_ppc = confirmed/population)

# Scaling

df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") +
  geom_histogram(bins= 20)+
  theme_bw() + 
  scale_fill_wsj()

# Looking at the graphs from a scaling perspective, I have decided to transform
# the PPC numbers into per 10000 people instead of per one person that way 
# they are easier to interpret because the numbers on the scale are easier to
# understand and compare.

df <- df %>% mutate( deaths_ppc = (death/population)*10000,
                     cases_ppc = (confirmed/population)*10000)


# Distribution of variables -----------------------------------------------

# Distribution of x
df %>%
  ggplot(aes(x = cases_ppc)) +
  geom_histogram(bins= 20)+
  labs(x = "Cases per 10'000 people", y = "Count")

df %>% 
  summarise(
    mean = mean(cases_ppc),
    median = median(cases_ppc),
    min = min(cases_ppc),
    max = max(cases_ppc),
    sd = sd(cases_ppc)
  )

# Distribution of y
df %>%
  ggplot(aes(x = deaths_ppc)) +
  geom_histogram() +
  labs(x = "Deaths per 10'000 people", y = "Count")

df %>% 
  summarise(
    mean = mean(deaths_ppc),
    median = median(deaths_ppc),
    min = min(deaths_ppc),
    max = max(deaths_ppc),
    sd = sd(deaths_ppc)
  )

# Overall both x and y have many observations around zero and have a long right tail.
# While x has higher number overall the distribution is very similar in shape.
# 



# Ln Transformations ------------------------------------------------------

# Checking different transformations using scatter plots

# First I will add variables with the ln transformation
df <- df %>% mutate( ln_cases_ppc = log( cases_ppc ),
                     ln_deaths_ppc= log( deaths_ppc) )

# Different types of models

# 1, Level - level regression

df %>% 
  ggplot(aes(x = cases_ppc, y = deaths_ppc)) +
  geom_point() +
  geom_smooth(method="loess")+
  labs(x = "Cases per 10'000 people",y = "Deaths per 10'000 people")

# 2, Log - level regression

df %>% 
  ggplot(aes(x = ln_cases_ppc, y = deaths_ppc)) +
  geom_point() +
  geom_smooth(method="loess")+
  labs(x = "ln (Cases per 10'000 people)",y = "Deaths per 10'000 people")

# 3, Level - log regression

df %>% 
  ggplot(aes(x = cases_ppc, y = ln_deaths_ppc)) +
  geom_point() +
  geom_smooth(method="loess")+
  labs(x = "Cases per 10'000 people",y = "ln (Deaths per 10'000 people)")

# 4, Log - log regression

df %>% 
  ggplot(aes(x = ln_cases_ppc, y = ln_deaths_ppc)) +
  geom_point() +
  geom_smooth(method="loess")+
  labs(x = "ln (Cases per 10'000 people)",y = "ln (Deaths per 10'000 people)")


# The log - log transformation seems to be the best fit. Substantively it is easy
# to interpret and works with percentages which is great for comparison,
# It is also more pleasant to look at since the extreme values have been fixed
# by the log transformation.
# Statistically it seems to be the most collective and the CI seems the least
# spread out around most of it.

# To be able to use this in the future I need to remove some values that give
# Infinity when doing the transformation.

df <- df[!is.infinite(df$ln_deaths_ppc),]


# Regression Models -------------------------------------------------------
# Different models:
#     reg1: ln_deaths_ppc = alpha + beta * ln_cases_ppc
#     reg2: ln_deaths_ppc = alpha + beta_1 * ln_cases_ppc + beta_2 * ln_cases_ppc^2
#     reg3: ln_deaths_ppc = alpha + beta_1 * ln_cases_ppc * 1(ln_cases_ppc < 50) + beta_2 * ln_cases_ppc * 1(ln_cases_ppc >= 50)
#     reg4: ln_deaths_ppc = alpha + beta * ln_cases_ppc, weights: population

# First I will add the square and cube of the x variable to df

df <- df %>% mutate( ln_cases_ppc_sq = ln_cases_ppc^2)

# Regression 1 - Simple linear regression

reg1 <- lm_robust( ln_deaths_ppc ~ ln_cases_ppc , data = df,  se_type = "HC2" )
reg1
# Summary statistics
summary( reg1 )
# Visual inspection:
ggplot( data = df, aes( x = ln_cases_ppc, y = ln_deaths_ppc ) ) + 
  geom_point( color='blue') +
  geom_smooth( method = lm , color = 'red' ) +
  labs(x = "ln (Cases per 10'000 people)",y = "ln (Deaths per 10'000 people)")

# Regression 2 - Quadratic (linear) regression

reg2 <- lm_robust( ln_deaths_ppc ~ ln_cases_ppc + ln_cases_ppc_sq , data = df )
summary( reg2 )
ggplot( data = df, aes( x = ln_cases_ppc, y = ln_deaths_ppc ) ) + 
  geom_point( color='blue') +
  geom_smooth( formula = y ~ poly(x,2) , method = lm , color = 'red' ) +
  labs(x = "ln (Cases per 10'000 people)",y = "ln (Deaths per 10'000 people)")

# Regressipn 3 - Piecewise linear spline regression

# 1st define the cutoff for gdp per capita
cutoff <- 50
# 2nd we use a log transformation -> cutoff needs to be transformed as well
cutoff_ln<- log( cutoff )
# Use simple regression with the lspline function
reg3 <- lm_robust(ln_deaths_ppc ~ lspline( ln_cases_ppc , cutoff_ln ), data = df )
summary( reg3 )
ggplot( data = df, aes( x = ln_cases_ppc, y = ln_deaths_ppc ) ) + 
  geom_point( color='blue') +
  geom_smooth( formula = y ~ lspline(x,cutoff_ln) , method = lm , color = 'red' ) +
  labs(x = "ln (Cases per 10'000 people)",y = "ln (Deaths per 10'000 people)")

# Regression 4 - Weighted linear regression, using population as weights

reg4 <- lm_robust(ln_deaths_ppc ~ ln_cases_ppc, data = df , weights = population)
summary( reg4 )

ggplot(data = df, aes(x = ln_cases_ppc, y = ln_deaths_ppc)) +
  geom_point(data = df, aes(size=population),  color = 'blue', shape = 16, alpha = 0.6,  show.legend=F) +
  geom_smooth(aes(weight = population), method = "lm", color='red')+
  labs(x = "ln (Cases per 10'000 people)",y = "ln (Deaths per 10'000 people)")



# Comparing models --------------------------------------------------------

# Creating model summary with texreg
data_out <- "/Users/Terez/OneDrive - Central European University/Data_Analysis_02/DA2_Assignment_1/out/"
htmlreg( list(reg1 , reg2 , reg3 , reg4 ),
         type = 'html',
         custom.model.names = c("ln(Cases per 10'000) - linear","ln(Cases per 10'000) - quadratic",
                                "ln(Cases per 10'000) - PLS",
                                "ln(Cases per 10'000) - weighted linear"),
         caption = "Modelling registered cases and registered deaths of COVID-19 in different countries",
         file = paste0( data_out ,'model_comparison.html'), include.ci = FALSE)

# Pick Weighted OLS



# Testing hypothesis ------------------------------------------------------

# 1) Coefficient is equal to 0:
# Implemented by default...
summary( reg4 )

# 2) Checking it using the unique formula
library(car)
# Let test: H0: ln_cases_ppc = 0, HA: ln_cases_ppc neq 0
linearHypothesis( reg4 , "ln_cases_ppc = 0")



# Residual Analysis -------------------------------------------------------

# Get the predicted y values from the model
df$reg4_y_pred <- reg4$fitted.values
# Calculate the errors of the model
df$reg4_res <- df$ln_deaths_ppc - df$reg4_y_pred 

# Countries who lost the most people to COVID
df %>% top_n( -5 , reg4_res ) %>% 
  select( country , ln_deaths_ppc , reg4_y_pred , reg4_res )

# Countries who saved the most people in COVID
df %>% top_n( 5 , reg4_res ) %>% 
  select( country , ln_deaths_ppc , reg4_y_pred , reg4_res )









