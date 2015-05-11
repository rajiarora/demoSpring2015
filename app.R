source("global.R")
server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    cellLine1 <- input$cell_line1
    cellLine2 <- input$cell_line2
    selectedLines<-c(cellLine1,cellLine2)
    
    #PCA, but will have to play with it a little, not very good right now
    sexp<-exp[rownames(exp) %in% selectedLines,]
    
    psexp<-prcomp(sexp)
    #change rownames of x from names of cell lines to names of tissues 
    rownames(psexp$x)<-rownames(sexp)
    
    plotpointsx<-psexp$x[,1]
    plotpointsy<-psexp$x[,2]
    plotpointsz<-psexp$x[,3]
    
    colorsgroup=as.fumeric(selectedLines)
    plot(plotpointsx, plotpointsy,main = "PCA", xlab = "PC1", ylab = "PC2", pch=16,col=colorsgroup)
    legend("topright",selectedLines,col=colorsgroup,pch=16)
  })
  
}

ui <- shinyUI(  fluidPage(
  
  titlePanel("Interactive PCA Analysis of Sanger miRNA Data"),
  
  column(4, wellPanel(
    selectInput("cell_line1", label="Cell Line 1:",
                choices=sortedgroup,selected=sortedgroup[1],width=250),
    selectInput("cell_line2", label="Cell Line 2:",
                choices=sortedgroup,selected=sortedgroup[2],width=250),
    strong("Background"),
    br(),
    p("MicroRNAs (miRNAs) are a class of non-coding regulatory RNAs approximately 22 nucleotides in
length that play a role in a wide range of biological processes. Abnormal miRNA function has been implicated in
various human cancers including prostate cancer (PCa). Altered miRNA expression may serve as a biomarker for
cancer diagnosis and treatment. However, limited data are available on the role of cancer-specific miRNAs.
Integrative computational bioinformatics approaches are effective for the detection of potential outlier miRNAs
in cancer")
  )),
  
  column(5,
         "",
         
         # With the conditionalPanel, the condition is a JavaScript
         # expression. In these expressions, input values like
         # input$n are accessed with dots, as in input.n
         conditionalPanel("TRUE",plotOutput("scatterPlot", height = 640, width=640)
         )
  )
))

shinyApp(ui = ui, server = server)