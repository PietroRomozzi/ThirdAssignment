## Firstly, we set the wd and load some useful packages

setwd("Desktop/Hertie/1st Semester/Collaborative Social Science Data Analysis/ThirdAssignment/")

library(plyr)

# We are about to prepare the dataset on which we will carry on our analysis.

## After having made our excel data about weather tidy, we have converted them in csv format.

## The next step is to import the data we have prepared before.

weather <- read.csv("TidyData_meteo.csv", header = TRUE, sep = ";", dec = ",", fill = TRUE)

## Then, we also load other data needed: the gini index calculated for the macro area considered.

gini <- read.csv("TidyData_gini.csv", header = T, sep =";", dec = ",", fill = T)

## Loading data for suicides (number of suicides per year).

suicides_rough <- read.csv("RoughData_suicides.csv", header = T, sep =";", dec = ",", fill = T)

## Loading rough data about gdp per capita.

gdp <- read.csv("RoughData_gdp.csv", header = T, sep =";", dec = ",", fill = T)

## We remove the useless column UNIT

gdp <- data.frame(gdp$TIME, gdp$GEO, gdp$Value)

# We rename variables and wrong named object in the table to make it comparable with others we use.

gdp$gdp.GEO <- as.character(gdp$gdp.GEO)

gdp$gdp.GEO[gdp$gdp.GEO == "Nord"] <- "north"
gdp$gdp.GEO[gdp$gdp.GEO == "Centro (IT)"] <- "centre"
gdp$gdp.GEO[gdp$gdp.GEO == "Sud"] <- "south"

gdp <- rename(gdp, replace = c("gdp.GEO" = "macro_area"))
gdp <- rename(gdp, replace = c("gdp.TIME" = "year"))
gdp <- rename(gdp, replace = c("gdp.Value" = "gdp_pc"))

## We rename nordwest and nordeast as "north" and south and islands as "south" to make this table comparable with the others.

suicides_rough$macro_area <- as.character(suicides_rough$macro_area)

suicides_rough$macro_area[suicides_rough$macro_area == "nordeast"] <- "north"
suicides_rough$macro_area[suicides_rough$macro_area == "nordwest"] <- "north"
suicides_rough$macro_area[suicides_rough$macro_area == "islands"] <- "south"

## The next step will be to sum the number of suicides in not aggregate macro areas to obtain this data for the aggregate macro area.
