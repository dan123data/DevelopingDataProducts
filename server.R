library(devtools)
library(shiny)

shinyServer(function(input, output) {
    output$newPlot<- renderPlot({ 
    # the arrays represent time, -3 days, -2 days, yesterday, today, tomorrow, +2 days, +3 days.    
    # the first three values are known, the next four must be input
    rain<-c(0.5,   0.0,     2, input$b,input$c,input$d,input$e)
    # the first four values are known (lake levels are as of 6am)
    elev<-c( 522, 522.1, 522.4,   523.0,      0,      0,      0)
    # grnd Sat is a running, weighted, average (decreasing over last 30 days) of rain fall meant to capture how water saturated 
    # the ground is the more saturated the more run off there is  the more run-off the more the lake rise 
    GrndSat<- 0.3
    date<-c("a. -3 Days", "b. -2 Days", "c. -1 Day ", "d. Today", "e. +1 Day ", "f. +2 Days", "g. +3 Days")
    # put into a data frame
    lakeData<-data.frame(date,rain,elev)
    # calculate estimated elevation 
    # this is an initial model - hand smoothed from data - many problems have to be overcome
    # must add many more factors
    # significant issues with the data
    # do not try this at home
    # since the first four elements are known - only need to calc the last three
    for (i in 5:7){
       lakeData[i,"elev"]<- 1.336 + 
       GrndSat*0.26 +
       lakeData[i-1,"elev"]*0.997 +
       lakeData[i-1,"rain"]*0.15 +
       lakeData[i-2,"rain"]*0.08 +
       lakeData[i-3,"rain"]*0.04 + 
       GrndSat*lakeData[i-1,"rain"]*0.12 +
       GrndSat*lakeData[i-2,"rain"]*0.07 +
       GrndSat*lakeData[i-3,"rain"]*0.05 
    } 
    # to create plots with different colors for actual and estimated 
    # need to go through these gyrations with the data
    # also need to make graphs bigger than the min and max values or the 
    # elevations and rainfall amounts won't be seen for the max values 
    type<-c("")
    type2<-c("")
    max_rain<-0
    min_elev<-99999
    max_elev<-0
    for (i in 1:3) {
      type[i]<-c("Actual Rainfall")
      type2[i]<-c("Actual Elevation")
      rain[i]<-lakeData$rain[i]
      elev[i]<-lakeData$elev[i]
      if (rain[i]>max_rain) {
        max_rain<-rain[i]
      }
      if (elev[i]<min_elev) {
        min_elev<-elev[i]
      }
      if (elev[i]>max_elev) {
        max_elev<-elev[i]
      }
    }    
    for (i in 4:7) {
      type[i]<-c("Entered Forecast")
      type2[i]<-c("Est'd Elevation")
      rain[i]<-lakeData$rain[i]
      elev[i]<-lakeData$elev[i]
      if (rain[i]>max_rain) {
        max_rain<-rain[i]
      }
      if (elev[i]<min_elev) {
        min_elev<-elev[i]
      }
      if (elev[i]>max_elev) {
        max_elev<-elev[i]
      }
    }    
    type2[4]<-c("Est'd Elevation")
    type2
    lakeData1<-data.frame(date,type,type2,rain,elev)
    lakeData1
    
    setylimrain<-max(2,round(max_rain*1.2+.5,digits=0))
    setylimrain
    setylimelevmin<-round(min_elev-5,digits=0)
    setylimelevmin
    setylimelevmax<-round(max_elev+5,digits=0)
    setylimelevmax
    
    library(ggplot2)
    library(grid)
    #install.packages("grid")
    
    p1<-ggplot(lakeData1, aes(x=date,y=rain,fill=type))+ 
      geom_bar(stat="identity",width=0.3)+
      ylim(0,setylimrain)+
      #scale_color_manual(values=c("grey","light grey"))+
      scale_fill_manual(values=c("Actual Rainfall"= "grey","Entered Forecast"= "light blue"))+
      theme(aspect.ratio=.25,legend.position="right", plot.title=element_text(size=20,lineheight=4,face="bold"))+
      geom_text(size=4,label=paste(round(rain,2)),hjust=0,vjust=-0.25)+
      labs(title="Past Actual Rainfall and Input Future Estimated Rainfall",x="Days ( -3 to +3 from today)",y="Inches of Rain")
    
    p2<-ggplot(lakeData1, aes(x=date, y=elev, group=type2)) + 
      geom_line(aes(linetype=type2, color=type2, size=type2))+
      ylim(setylimelevmin,setylimelevmax)+
      geom_point(aes(color=type2),pch=18,size=3)+
      scale_linetype_manual(values=c("solid","dashed"))+
      scale_color_manual(values=c("black","blue"))+
      scale_size_manual(values=c(1, 1))+
      theme(aspect.ratio=.25,legend.position="right", plot.title=element_text(size=20,lineheight=4,face="bold"))+
      geom_text(size=4,label=paste(round(elev,1)),hjust=0,vjust=-1)+
      labs(title="Lake Elevation",x="Days ( -3 to +3 from today)",y="Elevation In Feet")
    
    
    library(gridExtra)
    
    grid.arrange(p1,p2,ncol=1,heights=c(48,48),widths=c(16))
   
      
    },height = 600, width = 800)
})
