# Otso Perakyla, 7.3.2017: IODS final project
# Data wragling part

# set working directory
setwd("D:/Documents/Courses/IODS/IODS-final/data_monthly")


# clear all variables possibly left over from previous sessions
rm(list = ls())

library(dplyr) # for data wrangling


# load data: data available at https://www.esrl.noaa.gov/gmd/dv/data/index.php?parameter_name=Carbon%2BDioxide&type=Insitu
CO2_MLO <- read.table("./co2_mlo_surface-insitu_1_ccgg_MonthlyData.txt",sep=" ",header=F)
CO2_BRW <- read.table("./co2_brw_surface-insitu_1_ccgg_MonthlyData.txt",sep=" ",header=F)
CO2_SMO <- read.table("./co2_smo_surface-insitu_1_ccgg_MonthlyData.txt",sep=" ",header=F)
CO2_SPO <- read.table("./co2_spo_surface-insitu_1_ccgg_MonthlyData.txt",sep=" ",header=F)

# manually enter col names 
colnames(CO2_MLO) <- c("site_code", "year","month","day","hour","minute","second","value","value_unc","nvalue","latitude","longitude","altitude","elevation","intake_height","instrument","qcflag")
colnames(CO2_BRW) <- c("site_code", "year","month","day","hour","minute","second","value","value_unc","nvalue","latitude","longitude","altitude","elevation","intake_height","instrument","qcflag")
colnames(CO2_SMO) <- c("site_code", "year","month","day","hour","minute","second","value","value_unc","nvalue","latitude","longitude","altitude","elevation","intake_height","instrument","qcflag")
colnames(CO2_SPO) <- c("site_code", "year","month","day","hour","minute","second","value","value_unc","nvalue","latitude","longitude","altitude","elevation","intake_height","instrument","qcflag")



# columns to keep
# keep the year and month of the measurement, the measurement value, its uncertainty, and the number of measurements that went into calculating the value
keep <- c("year","month","day","value","value_unc","nvalue")

# select the 'keep' columns
CO2_MLO <- select(CO2_MLO, one_of(keep))
CO2_BRW <- select(CO2_BRW, one_of(keep))
CO2_SMO <- select(CO2_SMO, one_of(keep))
CO2_SPO <- select(CO2_SPO, one_of(keep))






# define missing value symbols and convert to NAs
unc_missing <- -99.990
value_missing <- -999.990


CO2_MLO$value[CO2_MLO$value == value_missing] <- NA;
CO2_MLO$value_unc[CO2_MLO$value_unc == unc_missing] <- NA;

CO2_BRW$value[CO2_BRW$value == value_missing] <- NA;
CO2_BRW$value_unc[CO2_BRW$value_unc == unc_missing] <- NA;

CO2_SMO$value[CO2_SMO$value == value_missing] <- NA;
CO2_SMO$value_unc[CO2_SMO$value_unc == unc_missing] <- NA;

CO2_SPO$value[CO2_SPO$value == value_missing] <- NA;
CO2_SPO$value_unc[CO2_SPO$value_unc == unc_missing] <- NA;





# join all four datasets together
# join in two batches as the merge function only joins two at a time

join_by <- c("year","month")
MLO_BRW <- merge(CO2_MLO,CO2_BRW,by=join_by,suffix = c('_MLO','_BRW'),all = TRUE)
SMO_SPO <- merge(CO2_SMO,CO2_SPO,by=join_by,suffix = c('_SMO','_SPO'),all = TRUE)

CO2_all <- merge(MLO_BRW,SMO_SPO,by=join_by,suffix = c('SMO','SPO'),all = TRUE)







# convert the year,month,day date format to more sensible
CO2_all$date_time <- as.Date(ISOdate(CO2_all$year,CO2_all$month,CO2_all$day_BRW))


# delete the old time variables
CO2_all$day_MLO <- NULL
CO2_all$day_BRW <- NULL
CO2_all$day_SMO <- NULL
CO2_all$day_SPO <- NULL
CO2_all$year <- NULL
CO2_all$month <- NULL





print(nrow(CO2_all)) # 516 observations

str(CO2_all) # 13 variables



# glimpse at the new combined data
glimpse(CO2_all)






write.table(CO2_all, file = "CO2_4_sites.txt", row.names = F)

head(read.table("CO2_4_sites.txt"))
# seems to work

