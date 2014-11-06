# Firstly, we set the wd

setwd("Desktop/Hertie/1st Semester/Collaborative Social Science Data Analysis/ThirdAssignment/")

# We are about to prepare the dataset on which we will carry on our analysis.
# After having made our excel data about weather tidy, we have converted them in csv format.
# The next step is to import the data we have prepared before.

weather <- read.csv("TidyData_meteo.csv", header = TRUE, sep = ";", dec = ",", fill = TRUE)
