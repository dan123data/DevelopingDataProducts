library(shiny)

shinyUI(pageWithSidebar(

  titlePanel("Projecting Lake Level Next 4 Days Given a Rainfall Forecast"),
  
  sidebarPanel(
    h3('Input Rainfall Forecast for Today and Next 4 Days: '),
    sliderInput('b','Your Estimate of rainfall TODAY (inches)',value=0,min=0,max=8,step=0.25),
    sliderInput('c','Your Estimate of rainfall 1 day from now (inches)',value=0,min=0,max=8,step=0.25),
    sliderInput('d','Your Estimate of rainfall 2 days from now (inches)',value=0,min=0,max=8,step=0.25),
    sliderInput('e','Your Estimate of rainfall 3 days from now (inches)',value=0,min=0,max=8,step=0.25),
    submitButton("Submit to See Effect on Lake Level Next 4 Days")
  ),
  
  mainPanel(
    h5('INSTRUCTIONS: This app will load w/ past 3 days of actual rainfall and give estmated lake level assuming no rain for next 4 days'),
    h5('STEP 1: User inputs their estimate of how much rain, in inches, will fall next 4 days using slider bars'),
    h5('STEP 2: User clicks "Submit to See Effect on Lake Level Next 4 Days" button'),
    h5('OUTPUT: App estimates lake level for next 4 days, see blue dashed line in graph below'),
    h5('LEGAL: User assumes all boating risks, app developer does not rep or warrent the accuracy of results in any way'),
    plotOutput("newPlot")
    
    )
  )
)
