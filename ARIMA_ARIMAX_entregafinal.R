#1. SETUP WORKING ENVIRONMENT####-----------------------------------------------

install.packages("tidyverse")
install.packages("readxl")
install.packages("forecast")



library(readxl)
library(forecast)
library(tidyverse)


setwd("C:/Users/nafa/Documents/RStudio/DataScienceProject/Dataset")



#2. LOAD DATASET####------------------------------------------------------------

#2009-2018
df <- read_excel("ONEQ_Data2009-2018_PIB.xlsx")



#2019-2023
df2 <- read_excel("ONEQ_Data2019-2023_PIB.xlsx")



#2003-2023
df3 <- read_excel("ONEQ_Data2003-2023_PIB.xlsx")






#3. DATA PRE PROCESSING####-----------------------------------------------------

#2008-2018
df$Date <- as.Date(df$Date)

oneq <- xts(df$Low, order.by = df$Date)
names(oneq) <- c("oneq.Low")
oneq$oneq.Low <- oneq$oneq.Low/1000000

pib <- xts(df$PIB, order.by = df$Date)
names(pib) <- c("pib")







#2019-2023
df2$Date <- as.Date(df2$Date)

oneq2 <- xts(df2$Low, order.by = df2$Date)
names(oneq2) <- c("oneq.Low")
oneq2$oneq.Low <- oneq2$oneq.Low/1000000

pib2 <- xts(df2$PIB, order.by = df2$Date)
names(pib2) <- c("pib")








#2003-2023
df3$Date <- as.Date(df3$Date)

oneq3 <- xts(df3$Low, order.by = df3$Date)
names(oneq3) <- c("oneq.Low")
oneq3$oneq.Low <- oneq3$oneq.Low/1000000

pib3 <- xts(df3$PIB, order.by = df3$Date)
names(pib3) <- c("pib")










#4. MODELING####----------------------------------------------------------------
#ARIMA forecasting
#2009-2018
n <- as.integer(nrow(oneq)/3)
train <- head(oneq$oneq.Low, length(oneq$oneq.Low)-n)
test <- tail(oneq$oneq.Low, n)

model <- auto.arima(train)            
fc <- forecast(model, h=n)               

autoplot(fc, title = "ARIMAX Forecast ONEQ 2009-2018 with exogenous variable USA GDP") + 
  autolayer(fc, series = "Forecast") +
  autolayer(ts(test, start= length(train)), series="Test Data") +
  xlim(0, length(oneq))



#2019-2023
n2 <- as.integer(nrow(oneq2)/3)
train2 <- head(oneq2$oneq.Low, length(oneq2$oneq.Low)-n2)
test2 <- tail(oneq2$oneq.Low, n2)

model2 <- auto.arima(train2)
fc2 <- forecast(model2, h=n2)               

autoplot(fc2, main = "ARIMAX Forecast ONEQ 2019-2023 with exogenous variable USA GDP") + 
  autolayer(ts(test2, start= length(train2)), series="Test Data")+
  xlim(0, length(oneq2)) 



#2003-2023
n3 <- as.integer(nrow(oneq3)/3)
pib.xreg3 <- head(pib3$pib, length(pib3$pib)-n3)
train3 <- head(oneq3$oneq.Low, length(oneq3$oneq.Low)-n3)
test3 <- tail(oneq3$oneq.Low, n3)

model3 <- auto.arima(train3)
fc3 <- forecast(model3, h=n3)                

autoplot(fc3, main = "ARIMAX Forecast ONEQ 2003-2023 with exogenous variable USA GDP") + 
  autolayer(ts(test3, start= length(train3)), series="Test Data")+
  xlim(0, length(oneq3)) 

fc_arima  <- fc
fc2_arima <- fc2
fc3_arima <- fc3

test_arima  <- test
test2_arima <- test2
test3_arima <- test3
#-------------------------------------------------------------------------------
#ARIMAX forecasting
  #2009-2018
n <- as.integer(nrow(oneq)/3)
pib.xreg <- head(pib$pib, length(pib$pib)-n)
train <- head(oneq$oneq.Low, length(oneq$oneq.Low)-n)
test <- tail(oneq$oneq.Low, n)


model <- auto.arima(train, xreg = pib.xreg$pib)            
fc <- forecast(model, xreg = pib.xreg$pib, h=n)               



autoplot(fc, title = "ARIMAX Forecast ONEQ 2009-2018 with exogenous variable USA GDP") + 
  autolayer(fc, series = "Forecast") +
  autolayer(ts(test, start= length(train)), series="Test Data") +
  xlim(0, length(oneq))



  #2019-2023
n2 <- as.integer(nrow(oneq2)/3)
pib.xreg2 <- head(pib2$pib, length(pib2$pib)-n2)
train2 <- head(oneq2$oneq.Low, length(oneq2$oneq.Low)-n2)
test2 <- tail(oneq2$oneq.Low, n2)


model2 <- auto.arima(train2, xreg = pib.xreg2$pib)
fc2 <- forecast(model2, xreg = pib.xreg2$pib, h=n2)               



autoplot(fc2, main = "ARIMAX Forecast ONEQ 2019-2023 with exogenous variable USA GDP") + 
  autolayer(ts(test2, start= length(train2)), series="Test Data")+
  xlim(0, length(oneq2)) 



  #2003-2023
n3 <- as.integer(nrow(oneq3)/3)
pib.xreg3 <- head(pib3$pib, length(pib3$pib)-n3)
train3 <- head(oneq3$oneq.Low, length(oneq3$oneq.Low)-n3)
test3 <- tail(oneq3$oneq.Low, n3)


model3 <- auto.arima(train3, xreg = pib.xreg3$pib)
fc3 <- forecast(model3, xreg = pib.xreg3$pib, h=n3)                



autoplot(fc3, main = "ARIMAX Forecast ONEQ 2003-2023 with exogenous variable USA GDP") + 
  autolayer(ts(test3, start= length(train3)), series="Test Data")+
  xlim(0, length(oneq3)) 













#5. RESULTS####-----------------------------------------------------------------

#2009-2018
me_low <- accuracy(fc_arima, test)["Test set", "ME"]
mpe_low <- accuracy(fc_arima, test)["Test set", "MPE"]
rmse_low <- accuracy(fc_arima, test)["Test set", "RMSE"]

me_low2 <- accuracy(fc, test_arima)["Test set", "ME"]
mpe_low2 <- accuracy(fc, test_arima)["Test set", "MPE"]
rmse_low2 <- accuracy(fc, test_arima)["Test set", "RMSE"]

results1 <- data.frame(Test = c("ARIMA","ARIMAX"), 
                      ME = c(me_low, me_low2), 
                      MPE = c(mpe_low, mpe_low2),
                      RMSE = c(rmse_low, rmse_low2))

results1


#2019-2023
me_low <- accuracy(fc2_arima, test2_arima)["Test set", "ME"]
mpe_low <- accuracy(fc2_arima, test2_arima)["Test set", "MPE"]
rmse_low <- accuracy(fc2_arima, test2_arima)["Test set", "RMSE"]

me_low2 <- accuracy(fc2, test2)["Test set", "ME"]
mpe_low2 <- accuracy(fc2, test2)["Test set", "MPE"]
rmse_low2 <- accuracy(fc2, test2)["Test set", "RMSE"]

results2 <- data.frame(Test = c("ARIMA","ARIMAX"), 
                       ME = c(me_low, me_low2), 
                       MPE = c(mpe_low, mpe_low2),
                       RMSE = c(rmse_low, rmse_low2))

results2




#2003-2023
me_low <- accuracy(fc3_arima, test3_arima)["Test set", "ME"]
mpe_low <- accuracy(fc3_arima, test3_arima)["Test set", "MPE"]
rmse_low <- accuracy(fc3_arima, test3_arima)["Test set", "RMSE"]

me_low2 <- accuracy(fc3, test3)["Test set", "ME"]
mpe_low2 <- accuracy(fc3, test3)["Test set", "MPE"]
rmse_low2 <- accuracy(fc3, test3)["Test set", "RMSE"]

results3 <- data.frame(Test = c("ARIMA","ARIMAX"), 
                       ME = c(me_low, me_low2), 
                       MPE = c(mpe_low, mpe_low2),
                       RMSE = c(rmse_low, rmse_low2))

results3

