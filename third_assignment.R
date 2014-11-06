## Firstly, we set the wd

setwd("Desktop/Hertie/1st Semester/Collaborative Social Science Data Analysis/ThirdAssignment/")

# We are about to prepare the dataset on which we will carry on our analysis.

## After having made our excel data about weather tidy, we have converted them in csv format.

## The next step is to import the data we have prepared before.

weather <- read.csv("TidyData_meteo.csv", header = TRUE, sep = ";", dec = ",", fill = TRUE)

## Then, we also load other data needed: the gini index calculated for the macro area considered.

gini <- read.csv("TidyData_gini.csv", header = T, sep =";", dec = ",", fill = T)

## Loading data for suicides (number of suicides per year).

suicides <- read.csv("RoughData_suicides.csv", header = T, sep =";", dec = ",", fill = T)

## Loading rough data about gdp per capita.

gdp <- read.csv("", header = T, sep =";", dec = ",", fill = T)