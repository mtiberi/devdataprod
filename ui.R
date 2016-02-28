shinyUI(pageWithSidebar(
  headerPanel('Central limit theorem'),
  sidebarPanel(
    a("Click here to watch a presentation for this application",
      href="http://rpubs.com/mtiberi/devdataprod",
      target="_blank"),
  
    selectInput('dist', 'Distribution', c("uniform", "exponential")),
    numericInput('count', 'number of samples', 10000,
                 min = 1)
  ),
  mainPanel(
    plotOutput('plot1')
    #textOutput('res')
  )
))