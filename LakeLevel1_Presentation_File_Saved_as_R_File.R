Rainfall Effect on Changes in Lake Level Elevation
========================================================
author: dan123data
date: `r format(Sys.Date(),"%b-%d-%Y")`

Background
========================================================
  
  - Lake Lewisville is a 50 square mile recreational and water supply lake 30 miles north of Dallas, Texas

- Lake level is a function of many factors including recent rainfall and ground water saturation

- The lake level can vary from 508' to 537' above sea level 

***
  
  
  Lake Lewisville
![alt text](map.png)


Changes in Lake Levels Can Create Safety Issues
========================================================
  
  - Rising water levels
- Reduce clearance under bridges crossing the lake
- Sailboat masts have been damaged hitting bridges
- Lower water levels
- Expose shallow areas, boat have been damaged running aground
- There is a large area of under water trees, once water levels drops below 520' boating is not safe in this area

- In addition, the water level dictates what parts of the lake are open to boating activities    


Statistical Modeling
========================================================

- Preliminary modeling of lake levels so far indicate that lake levels fluctuate with 

- The last three days of rainfall
- A ground saturation factor
- Interaction of ground saturation and rainfall

- Note: There are many other factors but for this excersize we are keeping it simple!!!

***

- Quick analysis shows there is relationship between rain and lake level change

```{r, echo=FALSE, cache=TRUE}
setwd("C://Users//Dan_Wolf//Documents//0_DataScience//JHU9_DDP//Proj1//")

lake<- read.csv(file="LakeLewisClean1.csv",head=TRUE,sep=",")
lake<-lake[,-c(1,2,3,5,7,8,10,11)]
for (k in 1:5788) {
lake[k+5,"DiffElev"]<-as.numeric(12*(lake[k+5,"Elev"]-lake[k+2,"Elev"]))
lake[k+5,"SumRain"]<-as.numeric(lake[k+2,"Precip"]+lake[k+3,"Precip"]+lake[k+4,"Precip"])
}
mod1<-lm(lake$DiffElev~lake$SumRain)
#summary(mod1)
plot(lake$SumRain,lake$DiffElev,xlab="Sum 3 Day Rainfall in Inches", ylab="4 Day Lake Elev Change in Inches",main="Rainfall Effect on Lake Level", cex.lab=1.5, cex.axis=1.5, cex.main=1.5,)
abline(mod1)

```


Goal
========================================================

- Provide an app to estimate lake level for next three days 

- Current and past lake levels are known

- Ground saturation factors are known

- User must enter his/her forecast for rainfall for the next three days 

- The app outputs a graph of estimated lake level so they can plan thier boating activities
