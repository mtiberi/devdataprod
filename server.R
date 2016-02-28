library("shiny")
library("ggplot2")

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

distributions<- function(name, count) {
  
  nsamples<- 100;
  lambda<- 0.2

  if (name=="uniform")
  {
    gen.mean <- 0.5
    gen.sd <- 1/sqrt(12)
    gen<- runif
  } 
  else if (name=="exponential") {
    gen.mean<- 1/lambda
    gen.sd<- (1/lambda)
    gen<- function(n) rexp(n, rate = .2)
  }
  
  function() {
    m<- matrix(gen(nsamples*count), nrow = count, ncol=nsamples)
    list(
      data=apply(m, 1, mean),
      mean=gen.mean,
      sd=gen.sd,
      ns=nsamples
      )
  }
}

shinyServer(function(input, output, session) {

  gensample <- reactive({
    distributions(input$dist, input$count)()
  })
  

  output$plot1 <- renderPlot({
    sample<- gensample();
    s.data<- sample$data;
    s.mean<- sample$mean;
    s.sd<- sample$sd;
    s.ns<- sample$ns

    title<-"compare distribution of the averages (red) with normal distribution (green)"
    
    p<- ggplot(data.frame(s.data), aes (x = s.data)) +
      ggtitle(title) +
      geom_histogram(aes(y = ..density..), colour="black", fill="white", binwidth=1/40) +
      geom_density(colour = "red", size = 1) +
      stat_function(
        fun = dnorm,
        arg = list(mean = s.mean, sd = s.sd/sqrt(s.ns)),
        colour = "darkgreen",
        size = 1,
        linetype="solid")
    print(p)
  })
})
