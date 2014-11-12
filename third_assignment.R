## Firstly, we set the wd and load some useful packages

setwd("Desktop/Hertie/1st Semester/Collaborative Social Science Data Analysis/ThirdAssignment/")

library(knitr)
library(plyr)
library(ggplot2)
library(car)
library(xtable)

# Preparing packages to be cited. N.B. It could quit the present R Session for some reasons..

Packages3 <- c("knitr", "plyr", "dplyr", "ggplot2", "car", "xtable", "foreign")

repmis::LoadandCite(Packages3, file = "RPackages.bib", install = FALSE)

# We are about to prepare the dataset on which we will carry on our analysis.

## After having made our excel data about weather tidy, we have converted them in csv format.

## The next step is to import the data we have prepared before.

weather <- read.csv("TidyData_meteo.csv", header = TRUE, sep = ";", dec = ",", fill = TRUE)

## Then, we also load other data needed: the gini index calculated for the macro area considered.

gini <- read.csv("TidyData_gini.csv", header = T, sep =";", dec = ",", fill = T)

## Loading data for suicides (number of suicides per year).

suicides_rough <- read.csv("RoughData_suicides.csv", header = T, sep =";", dec = ",", fill = T)

## Loading rough data about gdp per capita (euros per person).

gdp <- read.csv("RoughData_gdp.csv", header = T, sep =";", dec = ",", fill = T)

## We remove the useless column UNIT.

gdp <- data.frame(gdp$TIME, gdp$GEO, gdp$Value)

# We rename variables and wrong named object in the table to make it comparable with others we use.

gdp$gdp.GEO <- as.character(gdp$gdp.GEO)

gdp$gdp.GEO[gdp$gdp.GEO == "Nord"] <- "north"
gdp$gdp.GEO[gdp$gdp.GEO == "Centro (IT)"] <- "centre"
gdp$gdp.GEO[gdp$gdp.GEO == "Sud"] <- "south"

gdp <- rename(gdp, replace = c("gdp.GEO" = "macro_area"))
gdp <- rename(gdp, replace = c("gdp.TIME" = "year"))
gdp <- rename(gdp, replace = c("gdp.Value" = "gdp_pc"))

# weather and gdp are tidy. We merge these two data frames.

MergedData1 <- merge(x = weather, y = gdp, union("macro_area", "year"), all = T )

# Now we merge the latter with data from the table gini.

MergedData2 <- merge(x = MergedData1, y = gini, union("macro_area", "year"), all = T )

## We rename nordwest and nordeast as "north" and south and islands as "south" to make this table comparable with the others.

suicides_rough$macro_area <- as.character(suicides_rough$macro_area)

suicides_rough$macro_area[suicides_rough$macro_area == "northeast"] <- "north"
suicides_rough$macro_area[suicides_rough$macro_area == "northwest"] <- "north"
suicides_rough$macro_area[suicides_rough$macro_area == "islands"] <- "south"

## The next step will be to sum the number of suicides in not aggregate macro areas to obtain this data for the aggregate macro area.

library(dplyr)

suicides_rough$suicides <- as.numeric(suicides_rough$suicides)

suicides_clean <- group_by(suicides_rough, macro_area, year)
suicides_clean <- summarise(suicides_clean, std_suicides_rate = mean(suicides))

# Final merge.

MergedData3 <- merge(x = MergedData2, y = suicides_clean, union("macro_area", "year"), all = T)

# MergedData 3 contains NAs, so we made this merge again not to include NA so using a complete dataframe.

MergedData4 <- merge(x = MergedData2, y = suicides_clean, union("macro_area", "year"), all = F)

# Data presentation.

library(foreign)

coplot(std_suicides_rate ~ year | macro_area, type = "b", xlab = "time", ylab = "std suicide rate per 100000 inhabitants", main = "Pattern for suicide rate over time", data = MergedData3)

scatterplot(std_suicides_rate ~ year | macro_area, boxplots = F, smooth = T, reg.line = F, xlab = "time", ylab = "std suicide rate per 100000 inhabitants", main = "Regional comparison of suicide rate over time", data = MergedData3 )

# Linear model.

M1 <- lm(std_suicides_rate ~ gdp_pc + avg_precipitations + avg_temperature + gini_index , data = MergedData4)

summary(M1)

M2 <- lm(std_suicides_rate ~ gdp_pc + avg_temperature + avg_precipitations , data = MergedData4)

summary(M2)

scatterplotMatrix(MergedData4[,3:7])

#############################################################################

# Recognized weaknesses of the previous method

# Upload tidy dataset for 2009 with data for every italian region.

Dataset2009 <- read.csv("TidyDataset2009.csv", header = TRUE, sep = ";", dec = ",", fill = TRUE)

LM1 <- lm(std_suicides_rate ~ gdp_pc + avg_precipitations + avg_temperature + gini_index , data = Dataset2009)

summary(LM1)

scatterplotMatrix(Dataset2009[,c(2,3,5,6,7)])

plot(LM1)

# Given fews observation, we drop a variable - gini_index - to gain more degrees of freedom. That is because gini index is slightly correlated with gdp per capita.

LM2 <- lm(std_suicides_rate ~ gdp_pc + avg_precipitations + avg_temperature, data = Dataset2009)

summary(LM2)

stats::confint(LM2)

